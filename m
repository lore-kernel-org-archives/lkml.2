Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab1LUVPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 16:15:44 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:58271 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab1LUVPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 16:15:42 -0500
Message-ID: <4EF24C71.6000609@linux.vnet.ibm.com>
Date: Thu, 22 Dec 2011 02:45:29 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: mc@linux.vnet.ibm.com, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, david@fromorbit.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
References: <20111220062710.GC23916@ZenIV.linux.org.uk> <4EF03915.60902@linux.vnet.ibm.com> <1324373854.21588.16.camel@mengcong> <4EF0654B.4060904@linux.vnet.ibm.com> <4EF06C9B.4010703@linux.vnet.ibm.com> <4EF084A4.3000106@linux.vnet.ibm.com> <20111220140628.GD23916@ZenIV.linux.org.uk> <4EF09D34.1060607@linux.vnet.ibm.com> <20111220175919.GE23916@ZenIV.linux.org.uk> <4EF0DE04.6030604@linux.vnet.ibm.com> <20111220195806.GF23916@ZenIV.linux.org.uk>
In-Reply-To: <20111220195806.GF23916@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11122111-7014-0000-0000-0000004B0EF3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2011 01:28 AM, Al Viro wrote:

> On Wed, Dec 21, 2011 at 12:42:04AM +0530, Srivatsa S. Bhat wrote:
>> register_hotcpu_notifier(...);
>> grab spinlock
>> for_each_online_cpu(N)
>>   add N to bitmap
>> release spinlock
>>
>> because the latter code is not fully race-free (because we don't handle
>> CPU_DOWN_PREPARE event in the callback and hence cpu_online_mask can get
>> updated in-between). But it would still work since cpus going down don't
>> really pose problems for us.
> 
> Um?  Sure, that loop can end up adding CPUs on their way down into the set.
> And as soon as they get their CPU_DEAD, notifier will prune them out...  Or
> is there something I'm missing here?
>


No, everything is fine overall (as I mentioned earlier - it would still work,
because even though the for_each_online_cpu() thing is racy, that race is
harmless). 

Now considering that we have come to a working solution to this whole issue
(though it looks a bit convoluted), IMHO it is worth trying to make this
whole thing look a bit more intuitive and appear "obviously race-free", at
least at places where we can afford it. IOW, I feel using
{get,put}_online_cpus() as mentioned in my previous post avoids a
"suspicious looking" usage of for_each_online_cpu() :-)

The following patch is the same as the patch you posted, but with this small
change (aimed merely at making the code a bit easier to understand) and a
commit message added. Please point out if this change seems bad for
any reason. And if it is fine, Viro, can you please sign-off on this patch?
(since this patch has code contributions from both you and me)

I tested this patch locally - the originally reported issue did not crop up
(soft-lockups in VFS callpaths).

---
From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] VFS: Fix race between CPU hotplug and lglocks

Currently, the *_global_[un]lock_online() routines are not at all synchronized
with CPU hotplug. Soft-lockups detected as a consequence of this race was
reported earlier at https://lkml.org/lkml/2011/8/24/185. (Thanks to Cong Meng
for finding out that the root-cause of this issue is the race condition
between br_write_[un]lock() and CPU hotplug, which results in the lock states
getting messed up).

Fixing this race by just adding {get,put}_online_cpus() at appropriate places
in *_global_[un]lock_online() is not a good option, because, then suddenly
br_write_[un]lock() would become blocking, whereas they have been kept as
non-blocking all this time, and we would want to keep them that way.

So, overall, we want to ensure 3 things:
1. br_write_lock() and br_write_unlock() must remain as non-blocking.
2. The corresponding lock and unlock of the per-cpu spinlocks must not happen
   for different sets of CPUs.
3. Either prevent any new CPU online operation in between this lock-unlock, or
   ensure that the newly onlined CPU does not proceed with its corresponding
   per-cpu spinlock unlocked.

To achieve all this:
(a) We introduce a new spinlock that is taken by the *_global_lock_online()
    routine and released by the *_global_unlock_online() routine.
(b) We register a callback for CPU hotplug notifications, and this callback
    takes the same spinlock as above.
(c) We maintain a bitmap which is close to the cpu_online_mask, and once it is
    initialized in the lock_init() code, all future updates to it are done in
    the callback, under the above spinlock.
(d) The above bitmap is used (instead of cpu_online_mask) while locking and
    unlocking the per-cpu locks.

The callback takes the spinlock upon the CPU_UP_PREPARE event. So, if the
br_write_lock-unlock sequence is in progress, the callback keeps spinning,
thus preventing the CPU online operation till the lock-unlock sequence is
complete. This takes care of requirement (3).

The bitmap that we maintain remains unmodified throughout the lock-unlock
sequence, since all updates to it are managed by the callback, which takes
the same spinlock as the one taken by the lock code and released only by the
unlock routine. Combining this with (d) above, satisfies requirement (2).

Overall, since we use a spinlock (mentioned in (a)) to prevent CPU hotplug
operations from racing with br_write_lock-unlock, requirement (1) is also
taken care of.

By the way, it is to be noted that a CPU offline operation can actually run
in parallel with our lock-unlock sequence, because our callback doesn't react
to notifications earlier than CPU_DEAD (in order to maintain our bitmap
properly). And this means, since we use our own bitmap (which is stale, on
purpose) during the lock-unlock sequence, we could end up unlocking the
per-cpu lock of an offline CPU (because we had locked it earlier, when the
CPU was online), in order to satisfy requirement (2). But this is harmless,
though it looks a bit awkward.

Debugged-by: Cong Meng <mc@linux.vnet.ibm.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/lglock.h |   36 ++++++++++++++++++++++++++++++++----
 1 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/include/linux/lglock.h b/include/linux/lglock.h
index f549056..87f402c 100644
--- a/include/linux/lglock.h
+++ b/include/linux/lglock.h
@@ -22,6 +22,7 @@
 #include <linux/spinlock.h>
 #include <linux/lockdep.h>
 #include <linux/percpu.h>
+#include <linux/cpu.h>
 
 /* can make br locks by using local lock for read side, global lock for write */
 #define br_lock_init(name)	name##_lock_init()
@@ -72,9 +73,31 @@
 
 #define DEFINE_LGLOCK(name)						\
 									\
+ DEFINE_SPINLOCK(name##_cpu_lock);					\
+ cpumask_t name##_cpus __read_mostly;					\
  DEFINE_PER_CPU(arch_spinlock_t, name##_lock);				\
  DEFINE_LGLOCK_LOCKDEP(name);						\
 									\
+ static int								\
+ name##_lg_cpu_callback(struct notifier_block *nb,			\
+				unsigned long action, void *hcpu)	\
+ {									\
+	switch (action & ~CPU_TASKS_FROZEN) {				\
+	case CPU_UP_PREPARE:						\
+		spin_lock(&name##_cpu_lock);				\
+		cpu_set((unsigned long)hcpu, name##_cpus);		\
+		spin_unlock(&name##_cpu_lock);				\
+		break;							\
+	case CPU_UP_CANCELED: case CPU_DEAD:				\
+		spin_lock(&name##_cpu_lock);				\
+		cpu_clear((unsigned long)hcpu, name##_cpus);		\
+		spin_unlock(&name##_cpu_lock);				\
+	}								\
+	return NOTIFY_OK;						\
+ }									\
+ static struct notifier_block name##_lg_cpu_notifier = {		\
+	.notifier_call = name##_lg_cpu_callback,			\
+ };									\
  void name##_lock_init(void) {						\
 	int i;								\
 	LOCKDEP_INIT_MAP(&name##_lock_dep_map, #name, &name##_lock_key, 0); \
@@ -83,6 +106,11 @@
 		lock = &per_cpu(name##_lock, i);			\
 		*lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;	\
 	}								\
+	register_hotcpu_notifier(&name##_lg_cpu_notifier);		\
+	get_online_cpus();						\
+	for_each_online_cpu(i)						\
+		cpu_set(i, name##_cpus);				\
+	put_online_cpus();						\
  }									\
  EXPORT_SYMBOL(name##_lock_init);					\
 									\
@@ -124,9 +152,9 @@
 									\
  void name##_global_lock_online(void) {					\
 	int i;								\
-	preempt_disable();						\
+	spin_lock(&name##_cpu_lock);					\
 	rwlock_acquire(&name##_lock_dep_map, 0, 0, _RET_IP_);		\
-	for_each_online_cpu(i) {					\
+	for_each_cpu(i, &name##_cpus) {					\
 		arch_spinlock_t *lock;					\
 		lock = &per_cpu(name##_lock, i);			\
 		arch_spin_lock(lock);					\
@@ -137,12 +165,12 @@
  void name##_global_unlock_online(void) {				\
 	int i;								\
 	rwlock_release(&name##_lock_dep_map, 1, _RET_IP_);		\
-	for_each_online_cpu(i) {					\
+	for_each_cpu(i, &name##_cpus) {					\
 		arch_spinlock_t *lock;					\
 		lock = &per_cpu(name##_lock, i);			\
 		arch_spin_unlock(lock);					\
 	}								\
-	preempt_enable();						\
+	spin_unlock(&name##_cpu_lock);					\
  }									\
  EXPORT_SYMBOL(name##_global_unlock_online);				\
 									\


