Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab1LSUYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 15:24:14 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:49819 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab1LSUYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 15:24:12 -0500
Message-ID: <4EEF9D4E.1000008@linux.vnet.ibm.com>
Date: Tue, 20 Dec 2011 01:53:42 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Stephen Boyd <sboyd@codeaurora.org>, mc@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, david@fromorbit.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
References: <1324265775.25089.20.camel@mengcong> <4EEEE866.2000203@linux.vnet.ibm.com> <4EEF0003.3010800@codeaurora.org> <4EEF1A13.4000801@linux.vnet.ibm.com> <20111219121100.GI2203@ZenIV.linux.org.uk>
In-Reply-To: <20111219121100.GI2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11121920-4790-0000-0000-0000007B7838
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 05:41 PM, Al Viro wrote:

> On Mon, Dec 19, 2011 at 04:33:47PM +0530, Srivatsa S. Bhat wrote:
> 
>> IMHO, we don't need to be concerned here because, {get,put}_online_cpus()
>> implement a refcounting solution, and they don't really serialize stuff
>> unnecessarily. The readers (those who prevent cpu hotplug, such as this lock-
>> unlock code) are fast and can be concurrent, while the writers (the task that
>> is doing the cpu hotplug) waits till all existing readers are gone/done with
>> their work.
>>
>> So, since we are readers here, IMO, we don't have to worry about performance.
>> (I know that we get serialized just for a moment while incrementing the
>> refcount, but that should not be worrisome right?)
>>
>> Moreover, using for_each_online_cpu() without using {get,put}_online_cpus()
>> around that, is plain wrong, because of the unhandled race with cpu hotplug.
>> IOW, our primary concern here is functionality, isn't it?
>>
>> To summarize, in the current design of these VFS locks, using
>> {get,put}_online_cpus() is *essential* to fix a functionality-related bug,
>> (and not so bad performance-wise as well).
>>
>> The following patch (v2) incorporates your comments:
> 
> I really don't like that.  Amount of contention is not a big issue, but the
> fact that now br_write_lock(vfsmount_lock) became blocking is really nasty.
> Moreover, we suddenly get cpu_hotplug.lock nested inside namespace_sem...
> BTW, it's seriously blocking - if nothing else, it waits for cpu_down()
> in progress to complete.  Which can involve any number of interesting
> locks taken by notifiers.
> 
> Dave's variant is also no good; consider this:
> CPU1: br_write_lock(); spinlocks grabbed
> CPU2: br_read_lock(); spinning on one of them
> CPU3: try to take CPU2 down.  We *can't* proceed to the end, notifiers or no
> notifiers, until CPU2 gets through the critical area.  Which can't happen
> until the spinlock is unlocked, i.e. until CPU1 does br_write_unlock().
> Notifier can't silently do spin_unlock() here or we'll get CPU2 free to go
> into the critical area when it's really not safe there.
> 
> That got one hell of a deadlock potential ;-/  So far I'm more or less
> in favor of doing get_online_cpus() explicitly in fs/namespace.c, outside
> of namespace_sem.  But I still have not convinced myself that it's
> really safe ;-/
> 


Okay, clearly you want br_write_locks to remain non-blocking. And for reasons
related to long-term code understandability/maintainability, I am not a fan of
the idea of sprinkling {get,put}_online_cpus() in fs/namespace.c, away from the
place where the race with CPU hotplug actually exists (though I understand that
that would work just fine).

So, considering the above two requirements, let me propose another approach
(though it might sound a bit hacky) :

We note that we can simplify our requirement in *global_[un]lock_online() to:

"lock and unlock must be invoked on the same set of CPUs, and that sequence
must not get missed for any CPU, even if the CPU is offline. We only care about
the correctness of lock-unlock operations, and not really about CPU Hotplug or
'working with only online CPUs' or anything of that sort."

If this new definition of our requirement is acceptable (correct me if I am
wrong), then we can do something like the following patch, while still
retaining br locks as non-blocking.

We make a copy of the current cpu_online_mask, and lock the per-cpu locks of
all those cpus. Then while unlocking, we unlock the per-cpu locks of these cpus
(by using that temporary copy of cpu_online_mask we created earlier), without
caring about the cpus actually online at that moment.
IOW, we do lock-unlock on the same set of cpus, and that too, without missing
the complete lock-unlock sequence in any of them. Guaranteed.

[I will provide the changelog later, if people are OK with this approach].

But it is to be noted that this doesn't actually synchronize with cpu hotplug,
but tries to overcome the issue nevertheless. Comments/suggestions?

---

 include/linux/lglock.h |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/lglock.h b/include/linux/lglock.h
index f549056..6351ae3 100644
--- a/include/linux/lglock.h
+++ b/include/linux/lglock.h
@@ -122,11 +122,16 @@
  }									\
  EXPORT_SYMBOL(name##_local_unlock_cpu);				\
 									\
+static DECLARE_BITMAP(name##_locked_cpu_bits, CONFIG_NR_CPUS);		\
+static struct cpumask *name##_locked_cpu_mask =				\
+				to_cpumask(name##_locked_cpu_bits);	\
+									\
  void name##_global_lock_online(void) {					\
 	int i;								\
 	preempt_disable();						\
 	rwlock_acquire(&name##_lock_dep_map, 0, 0, _RET_IP_);		\
-	for_each_online_cpu(i) {					\
+	cpumask_copy(name##_locked_cpu_mask, cpu_online_mask);		\
+	for_each_cpu(i, name##_locked_cpu_mask) {			\
 		arch_spinlock_t *lock;					\
 		lock = &per_cpu(name##_lock, i);			\
 		arch_spin_lock(lock);					\
@@ -137,7 +142,7 @@
  void name##_global_unlock_online(void) {				\
 	int i;								\
 	rwlock_release(&name##_lock_dep_map, 1, _RET_IP_);		\
-	for_each_online_cpu(i) {					\
+	for_each_cpu(i, name##_locked_cpu_mask) {			\
 		arch_spinlock_t *lock;					\
 		lock = &per_cpu(name##_lock, i);			\
 		arch_spin_unlock(lock);					\


