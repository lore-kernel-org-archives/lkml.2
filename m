Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab1EXVYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:24:13 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32426 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab1EXVYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:24:12 -0400
Message-ID: <4DDC21E1.1070502@kernel.org>
Date: Tue, 24 May 2011 14:23:45 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:core/rcu] Revert "rcu: Decrease memory-barrier usage based
 on semi-formal proof"
References: <4DD70120.9090801@kernel.org> <20110521131844.GE2271@linux.vnet.ibm.com> <20110521140845.GA12157@linux.vnet.ibm.com> <4DDAC01E.7050602@kernel.org> <20110523212530.GF7428@linux.vnet.ibm.com> <4DDAD934.9010603@kernel.org> <4DDAE5FA.2030303@kernel.org> <4DDAE6A5.6060701@kernel.org> <20110524011824.GL7428@linux.vnet.ibm.com> <4DDB093F.2060601@kernel.org> <20110524013523.GO7428@linux.vnet.ibm.com>
In-Reply-To: <20110524013523.GO7428@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090208.4DDC21E6.01C6,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2011 06:35 PM, Paul E. McKenney wrote:
> On Mon, May 23, 2011 at 06:26:23PM -0700, Yinghai Lu wrote:
>> On 05/23/2011 06:18 PM, Paul E. McKenney wrote:
>>
>>> OK, so it looks like I need to get this out of the way in order to track
>>> down the delays.  Or does reverting PeterZ's patch get you a stable
>>> system, but with the longish delays in memory_dev_init()?  If the latter,
>>> it might be more productive to handle the two problems separately.
>>>
>>> For whatever it is worth, I do see about 5% increase in grace-period
>>> duration when switching to kthreads.  This is acceptable -- your
>>> 30x increase clearly is completely unacceptable and must be fixed.
>>> Other than that, the main thing that affects grace period duration is
>>> the setting of CONFIG_HZ -- the smaller the HZ value, the longer the
>>> grace-period duration.
>>
>> for my 1024g system when memory hotadd is enabled in kernel config:
>> 1. current linus tree + tip tree:  memory_dev_init will take about 100s.
>> 2. current linus tree + tip tree + your tree - Peterz patch: 
>>    a. on fedora 14 gcc: will cost about 4s: like old times
>>    b. on opensuse 11.3 gcc: will cost about 10s.
> 
> So some patch in my tree that is not yet in tip makes things better?
> 
> If so, could you please see which one?  Maybe that would give me a hint
> that could make things better on opensuse 11.3 as well.

today's tip:

[   31.795597] cpu_dev_init done
[   40.930202] memory_dev_init done


after

commit e219b351fc90c0f5304e16efbc603b3b78843ea1
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Mon May 16 02:44:06 2011 -0700

    rcu: Remove old memory barriers from rcu_process_callbacks()
    
    Second step of partitioning of commit e59fb3120b.
    
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 3731141..011bf6f 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1460,25 +1460,11 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
  */
 static void rcu_process_callbacks(void)
 {
-	/*
-	 * Memory references from any prior RCU read-side critical sections
-	 * executed by the interrupted code must be seen before any RCU
-	 * grace-period manipulations below.
-	 */
-	smp_mb(); /* See above block comment. */
-
 	__rcu_process_callbacks(&rcu_sched_state,
 				&__get_cpu_var(rcu_sched_data));
 	__rcu_process_callbacks(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
 	rcu_preempt_process_callbacks();
 
-	/*
-	 * Memory references from any later RCU read-side critical sections
-	 * executed by the interrupted code must be seen after any RCU
-	 * grace-period manipulations above.
-	 */
-	smp_mb(); /* See above block comment. */
-
 	/* If we are last CPU on way to dyntick-idle mode, accelerate it. */
 	rcu_needs_cpu_flush();
 }

cause

[   32.235103] cpu_dev_init done
[   74.897943] memory_dev_init done

then add

commit d0d642680d4cf5cc2ccf542b74a3c8b7e197306b
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Mon May 16 02:52:04 2011 -0700

    rcu: Don't do reschedule unless in irq
    
    Condition the set_need_resched() in rcu_irq_exit() on in_irq().  This
    should be a no-op, because rcu_irq_exit() should only be called from irq.
    
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 011bf6f..195b3a3 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -421,8 +421,9 @@ void rcu_irq_exit(void)
 	WARN_ON_ONCE(rdtp->dynticks & 0x1);
 
 	/* If the interrupt queued a callback, get out of dyntick mode. */
-	if (__this_cpu_read(rcu_sched_data.nxtlist) ||
-	    __this_cpu_read(rcu_bh_data.nxtlist))
+	if (in_irq() &&
+	    (__this_cpu_read(rcu_sched_data.nxtlist) ||
+	     __this_cpu_read(rcu_bh_data.nxtlist)))
 		set_need_resched();
 }
 
got:

[   34.384490] cpu_dev_init done
[   86.656322] memory_dev_init done


after

commit fcfc28801f5b3b9c70616fc57e3a2c6f52014e14
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Mon May 16 14:27:31 2011 -0700

    rcu: Make rcu_enter_nohz() pay attention to nesting
    
    The old version of rcu_enter_nohz() forced RCU into nohz mode even if
    the nesting count was non-zero.  This change causes rcu_enter_nohz()
    to hold off for non-zero nesting counts.
    
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 195b3a3..99c6038 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -324,8 +324,8 @@ void rcu_enter_nohz(void)
 	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
 	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
-	rdtp->dynticks++;
-	rdtp->dynticks_nesting--;
+	if (--rdtp->dynticks_nesting == 0)
+		rdtp->dynticks++;
 	WARN_ON_ONCE(rdtp->dynticks & 0x1);
 	local_irq_restore(flags);
 }

got: 

[   32.414049] cpu_dev_init done
[   38.237979] memory_dev_init done


after:
commit bcd6e68330f893a81b3519ab3c5fc2bebbc9988c
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Tue Sep 7 10:38:22 2010 -0700

    rcu: Decrease memory-barrier usage based on semi-formal proof
...

got:

[   32.447936] cpu_dev_init done
[  111.027066] memory_dev_init done


after 

commit fbb753fb9dd62318d27fa070c686423ced139817
Author: Paul E. McKenney <paul.mckenney@linaro.org>
Date:   Wed May 11 05:33:33 2011 -0700

    atomic: Add atomic_or()
    
    An atomic_or() function is needed by TREE_RCU to avoid deadlock, so
    add a generic version.
    
    Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/atomic.h b/include/linux/atomic.h
index 96c038e..ee456c7 100644
--- a/include/linux/atomic.h
+++ b/include/linux/atomic.h
@@ -34,4 +34,17 @@ static inline int atomic_inc_not_zero_hint(atomic_t *v, int hint)
 }
 #endif
 
+#ifndef CONFIG_ARCH_HAS_ATOMIC_OR
+static inline void atomic_or(int i, atomic_t *v)
+{
+	int old;
+	int new;
+
+	do {
+		old = atomic_read(v);
+		new = old | i;
+	} while (atomic_cmpxchg(v, old, new) != old);
+}
+#endif /* #ifndef CONFIG_ARCH_HAS_ATOMIC_OR */
+
 #endif /* _LINUX_ATOMIC_H */

got:

[   32.803704] cpu_dev_init done
[   99.171292] memory_dev_init done

