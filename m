Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab1LSLED (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 06:04:03 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:44459 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab1LSLEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 06:04:00 -0500
Message-ID: <4EEF1A13.4000801@linux.vnet.ibm.com>
Date: Mon, 19 Dec 2011 16:33:47 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: mc@linux.vnet.ibm.com, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, david@fromorbit.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
References: <1324265775.25089.20.camel@mengcong> <4EEEE866.2000203@linux.vnet.ibm.com> <4EEF0003.3010800@codeaurora.org>
In-Reply-To: <4EEF0003.3010800@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11121911-8878-0000-0000-0000009FE597
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 02:42 PM, Stephen Boyd wrote:

> On 12/18/2011 11:31 PM, Srivatsa S. Bhat wrote:
>> Hi,
>>
>> I feel the following patch is a better fix for 2 reasons:
>>
>> 1. As Al Viro pointed out, if we do for_each_possible_cpus() then we
>> might
>> encounter unnecessary performance hit in some scenarios. So working with
>> only online cpus, safely(a.k.a race-free), if possible, would be a good
>> solution (which this patch implements).
>>
>> 2. *_global_lock_online() and *_global_unlock_online() needs fixing as
>> well
>> because, the names suggest that they lock/unlock per-CPU locks of only
>> the
>> currently online CPUs, but unfortunately they do not have any
>> synchronization
>> to prevent offlining those CPUs in between, if it happens to race with
>> a CPU
>> hotplug operation.
>>
>> And if we solve issue 2 above "carefully" (as mentioned in the
>> changelog below),
>> it solves this whole thing!
> 
> We started seeing this same problem last week. I've come up with almost
> the same solution but you beat me to the list!
> 


Oh :-)

>> diff --git a/include/linux/lglock.h b/include/linux/lglock.h
>> index f549056..583d1a8 100644
>> --- a/include/linux/lglock.h
>> +++ b/include/linux/lglock.h
>> @@ -126,6 +127,7 @@
>>       int i;                                \
>>       preempt_disable();                        \
>>       rwlock_acquire(&name##_lock_dep_map, 0, 0, _RET_IP_);        \
>> +    get_online_cpus();                        \
>>       for_each_online_cpu(i) {                    \
>>           arch_spinlock_t *lock;                    \
>>           lock =&per_cpu(name##_lock, i);            \
>> @@ -142,6 +144,7 @@
>>           lock =&per_cpu(name##_lock, i);            \
>>           arch_spin_unlock(lock);                    \
>>       }                                \
>> +    put_online_cpus();                        \
>>       preempt_enable();                        \
>>    }                                    \
>>    EXPORT_SYMBOL(name##_global_unlock_online);                \
> 
> Don't you want to call {get,put}_online_cpus() outside the
> preempt_{disable,enable}()? Otherwise you are scheduling while atomic?
>


Oh right, thanks for spotting this! (and thanks for your Ack too!)


> With that fixed
> 
> Acked-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> but I wonder if taking the hotplug mutex even for a short time reduces
> the effectiveness of these locks? Or is it more about fast readers and
> slow writers?
> 


IMHO, we don't need to be concerned here because, {get,put}_online_cpus()
implement a refcounting solution, and they don't really serialize stuff
unnecessarily. The readers (those who prevent cpu hotplug, such as this lock-
unlock code) are fast and can be concurrent, while the writers (the task that
is doing the cpu hotplug) waits till all existing readers are gone/done with
their work.

So, since we are readers here, IMO, we don't have to worry about performance.
(I know that we get serialized just for a moment while incrementing the
refcount, but that should not be worrisome right?)

Moreover, using for_each_online_cpu() without using {get,put}_online_cpus()
around that, is plain wrong, because of the unhandled race with cpu hotplug.
IOW, our primary concern here is functionality, isn't it?

To summarize, in the current design of these VFS locks, using
{get,put}_online_cpus() is *essential* to fix a functionality-related bug,
(and not so bad performance-wise as well).

The following patch (v2) incorporates your comments:

---
From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2] VFS: Fix race between CPU hotplug and *_global_[un]lock_online()

The *_global_[un]lock_online() macros defined in include/linux/lglock.h
can race with CPU hotplug operations. Fix this race by using the pair
get_online_cpus() and put_online_cpus() around them, so as to prevent CPU
hotplug happening at the same time.

But be careful to note the semantics here: if we enable CPU hotplug in-between
a lock_online() and the corresponding unlock_online(), the lock states can
get messed up, since we might end up for example, in a situation such as taking
a lock on an online CPU but not releasing it because that CPU was offline when
unlock_online() was invoked (thanks to Cong Meng for debugging this issue).
[Soft-lockups detected as a consequence of this issue was reported earlier in
https://lkml.org/lkml/2011/8/24/185.]

So, we are careful to allow CPU hotplug only after the lock-unlock sequence
is complete.

v2: Moved {get,put}_online_cpus() outside of preempt_{disable,enable} to avoid
scheduling while atomic.

Debugged-by: Cong Meng <mc@linux.vnet.ibm.com>
Acked-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/lglock.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/lglock.h b/include/linux/lglock.h
index f549056..7ef257d 100644
--- a/include/linux/lglock.h
+++ b/include/linux/lglock.h
@@ -22,6 +22,7 @@
 #include <linux/spinlock.h>
 #include <linux/lockdep.h>
 #include <linux/percpu.h>
+#include <linux/cpu.h>
 
 /* can make br locks by using local lock for read side, global lock for write */
 #define br_lock_init(name)	name##_lock_init()
@@ -124,6 +125,7 @@
 									\
  void name##_global_lock_online(void) {					\
 	int i;								\
+	get_online_cpus();						\
 	preempt_disable();						\
 	rwlock_acquire(&name##_lock_dep_map, 0, 0, _RET_IP_);		\
 	for_each_online_cpu(i) {					\
@@ -143,6 +145,7 @@
 		arch_spin_unlock(lock);					\
 	}								\
 	preempt_enable();						\
+	put_online_cpus();						\
  }									\
  EXPORT_SYMBOL(name##_global_unlock_online);				\
 									\


