Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab1LTMvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 07:51:39 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:34708 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab1LTMv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 07:51:29 -0500
Message-ID: <4EF084A4.3000106@linux.vnet.ibm.com>
Date: Tue, 20 Dec 2011 18:20:44 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: mc@linux.vnet.ibm.com
CC: Al Viro <viro@ZenIV.linux.org.uk>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, david@fromorbit.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
References: <1324265775.25089.20.camel@mengcong> <4EEEE866.2000203@linux.vnet.ibm.com> <4EEF0003.3010800@codeaurora.org> <4EEF1A13.4000801@linux.vnet.ibm.com> <20111219121100.GI2203@ZenIV.linux.org.uk> <4EEF9D4E.1000008@linux.vnet.ibm.com> <20111219205251.GK2203@ZenIV.linux.org.uk> <4EF01565.2000700@linux.vnet.ibm.com> <20111220062710.GC23916@ZenIV.linux.org.uk> <4EF03915.60902@linux.vnet.ibm.com> <1324373854.21588.16.camel@mengcong> <4EF0654B.4060904@linux.vnet.ibm.com> <4EF06C9B.4010703@linux.vnet.ibm.com>
In-Reply-To: <4EF06C9B.4010703@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11122002-9264-0000-0000-0000007026D7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2011 04:38 PM, Srivatsa S. Bhat wrote:

> On 12/20/2011 04:06 PM, Srivatsa S. Bhat wrote:
> 
>> On 12/20/2011 03:07 PM, mengcong wrote:
>>
>>> On Tue, 2011-12-20 at 12:58 +0530, Srivatsa S. Bhat wrote:
>>>> On 12/20/2011 11:57 AM, Al Viro wrote:
>>>>
>>>>> On Tue, Dec 20, 2011 at 10:26:05AM +0530, Srivatsa S. Bhat wrote:
>>>>>> Oh, right, that has to be handled as well...
>>>>>>
>>>>>> Hmmm... How about registering a CPU hotplug notifier callback during lock init
>>>>>> time, and then for every cpu that gets onlined (after we took a copy of the
>>>>>> cpu_online_mask to work with), we see if that cpu is different from the ones
>>>>>> we have already locked, and if it is, we lock it in the callback handler and
>>>>>> update the locked_cpu_mask appropriately (so that we release the locks properly
>>>>>> during the unlock operation).
>>>>>>
>>>>>> Handling the newly introduced race between the callback handler and lock-unlock
>>>>>> code must not be difficult, I believe..
>>>>>>
>>>>>> Any loopholes in this approach? Or is the additional complexity just not worth
>>>>>> it here?
>>>>>
>>>>> To summarize the modified variant of that approach hashed out on IRC:
>>>>>
>>>>> 	* lglock grows three extra things: spinlock, cpu bitmap and cpu hotplug
>>>>> notifier.
>>>>> 	* foo_global_lock_online starts with grabbing that spinlock and
>>>>> loops over the cpus in that bitmap.
>>>>> 	* foo_global_unlock_online loops over the same bitmap and then drops
>>>>> that spinlock
>>>>> 	* callback of the notifier is going to do all bitmap updates.  Under
>>>>> that spinlock.  Events that need handling definitely include the things like
>>>>> "was going up but failed", since we need the bitmap to contain all online CPUs
>>>>> at all time, preferably without too much junk beyond that.  IOW, we need to add
>>>>> it there _before_ low-level __cpu_up() calls set_cpu_online().  Which means
>>>>> that we want to clean up on failed attempt to up it.  Taking a CPU down is
>>>>> probably less PITA; just clear bit on the final "the sucker's dead" event.
>>>>> 	* bitmap is initialized once, at the same time we set the notifier
>>>>> up.  Just grab the spinlock and do
>>>>> 	for_each_online_cpu(N)
>>>>> 		add N to bitmap
>>>>> then release the spinlock and let the callbacks handle all updates.
>>>>>
>>>>> I think that'll work with relatively little pain, but I'm not familiar enough
>>>>> with the cpuhotplug notifiers, so I'd rather have the folks familiar with those
>>>>> to supply the set of events to watch for...
>>>>>
>>>>
>>>>
>>>> We need not watch out for "up failed" events. It is enough if we handle
>>>> CPU_ONLINE and CPU_DEAD events. Because, these 2 events are triggered only
>>>> upon successful online or offline operation, and these notifications are
>>>> more than enough for our purpose (to update our bitmaps). Also, those cpus
>>>> which came online wont start running until these "success notifications"
>>>> are all done, which is where we do our stuff in the callback (ie., try
>>>> grabbing the spinlock..).
>>>>
>>>> Of course, by doing this (only looking out for CPU_ONLINE and CPU_DEAD
>>>> events), our bitmap will probably be one step behind cpu_online_mask
>>>> (which means, we'll still have to take the snapshot of cpu_online_mask and
>>>> work with it instead of using for_each_online_cpu()).
>>>> But that doesn't matter, as long as:
>>>>   * we don't allow the newly onlined CPU to start executing code (this
>>>>     is achieved by taking the spinlock in the callback)
>>>
>>> I think cpu notifier callback doesn't always run on the UPing cpu.
>>> Actually, it rarely runs on the UPing cpu.
>>> If I was wrong about the above thought, there is still a chance that lg-lock
>>> operations are scheduled on the UPing cpu before calling the callback.
>>>
>>
>>
>> I wasn't actually banking on that, but you have raised a very good point.
>> The scheduler uses its own set of cpu hotplug callback handlers to start
>> using the newly added cpu (see the set of callbacks in kernel/sched.c)
>>
>> So, now we have a race between our callback and the scheduler's callbacks.
>> ("Placing" our callback appropriately in a safe position using priority
>> for notifiers doesn't appeal to me that much, since it looks like too much
>> hackery. It should probably be our last resort).
>>
> 
> 
> Hey, actually there is a simple solution: just nip it (or rather delay it)
> in the bud ;) That is, we watch out for CPU_UP_PREPARE event and lock it
> up there itself using our spinlock.. that way, that cpu will not come up
> until we are done executing br_write_unlock(). In fact, we can even fail
> the onlining of that cpu by returning appropriate value from our callback,
> but that would be too harsh.. so we can settle for delaying the cpu online
> operation :)
> 
> And we do the same thing for CPU_DOWN_PREPARE event. And we can forget about
> taking snapshot of cpu_online_mask, since cpu_online_mask is guaranteed to
> be unmodified until we are done with br_write_unlock().
> 


Had to modify this a bit, to handle a race while using cpu_online_mask.

Anyway, here is the code:

The idea here is that the notifier will grab the spinlock and not release it
until the entire cpu hotplug operation is complete. Hence the pairs
CPU_UP_PREPARE <-> CPU_UP_CANCELED, CPU_ONLINE
and
CPU_DOWN_PREPARE <-> CPU_DOWN_FAILED, CPU_DEAD

However, if the notifier couldn't acquire the spinlock, it will keep spinning
at the CPU_UP_PREPARE or CPU_DOWN_PREPARE event, thereby preventing cpu
hotplug, as well as any updates to cpu_online_mask. Hence, taking snapshot of
cpu_online_mask becomes unnecessary.

[Actually I have another approach, using CPU_STARTING and CPU_DYING events,
which addresses Cong Meng's concern in a more direct manner, but I would
rather post that patch after sometime, to avoid the risk of confusing
everyone. Moreover, that approach is not a "clear winner", so it can wait
until the below patch gets reviewed].

---

 include/linux/lglock.h |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/include/linux/lglock.h b/include/linux/lglock.h
index f549056..71079b1 100644
--- a/include/linux/lglock.h
+++ b/include/linux/lglock.h
@@ -22,6 +22,7 @@
 #include <linux/spinlock.h>
 #include <linux/lockdep.h>
 #include <linux/percpu.h>
+#include <linux/cpu.h>
 
 /* can make br locks by using local lock for read side, global lock for write */
 #define br_lock_init(name)	name##_lock_init()
@@ -75,6 +76,41 @@
  DEFINE_PER_CPU(arch_spinlock_t, name##_lock);				\
  DEFINE_LGLOCK_LOCKDEP(name);						\
 									\
+DEFINE_SPINLOCK(name##_notifier_lock);					\
+									\
+static int								\
+name##_lg_cpu_callback(struct notifier_block *nb,			\
+				unsigned long action, void *hcpu)	\
+{									\
+	switch (action & ~CPU_TASKS_FROZEN) {				\
+	case CPU_UP_PREPARE:						\
+		spin_lock(&name##_notifier_lock);			\
+		break;							\
+									\
+	case CPU_UP_CANCELED:						\
+	case CPU_ONLINE:						\
+		spin_unlock(&name##_notifier_lock);			\
+		break;							\
+									\
+	case CPU_DOWN_PREPARE:						\
+		spin_lock(&name##_notifier_lock);			\
+		break;							\
+									\
+	case CPU_DOWN_FAILED:						\
+	case CPU_DEAD:							\
+		spin_unlock(&name##_notifier_lock);			\
+		break;							\
+									\
+	default:							\
+		return NOTIFY_DONE;					\
+	}								\
+	return NOTIFY_OK;						\
+}									\
+									\
+static struct notifier_block name##_lg_cpu_notifier = {			\
+	.notifier_call = name##_lg_cpu_callback,			\
+};									\
+									\
  void name##_lock_init(void) {						\
 	int i;								\
 	LOCKDEP_INIT_MAP(&name##_lock_dep_map, #name, &name##_lock_key, 0); \
@@ -83,6 +119,7 @@
 		lock = &per_cpu(name##_lock, i);			\
 		*lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;	\
 	}								\
+	register_hotcpu_notifier(&name##_lg_cpu_notifier);		\
  }									\
  EXPORT_SYMBOL(name##_lock_init);					\
 									\
@@ -125,6 +162,7 @@
  void name##_global_lock_online(void) {					\
 	int i;								\
 	preempt_disable();						\
+	spin_lock(&name##_notifier_lock);				\
 	rwlock_acquire(&name##_lock_dep_map, 0, 0, _RET_IP_);		\
 	for_each_online_cpu(i) {					\
 		arch_spinlock_t *lock;					\
@@ -142,6 +180,7 @@
 		lock = &per_cpu(name##_lock, i);			\
 		arch_spin_unlock(lock);					\
 	}								\
+	spin_unlock(&name##_notifier_lock);				\
 	preempt_enable();						\
  }									\
  EXPORT_SYMBOL(name##_global_unlock_online);				\




Regards,
Srivatsa S. Bhat

