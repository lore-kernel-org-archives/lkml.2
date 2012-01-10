Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab2AJIQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 03:16:19 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44160 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab2AJIQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 03:16:15 -0500
Message-ID: <1326183371.6638.6.camel@edumazet-laptop>
Subject: Re: [BUG] kernel freezes with latest tree
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 10 Jan 2012 09:16:11 +0100
In-Reply-To: <1326171798.6638.4.camel@edumazet-laptop>
References: <1326171444.6638.3.camel@edumazet-laptop>
	 <1326171798.6638.4.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 10 janvier 2012 à 06:03 +0100, Eric Dumazet a écrit :
> Le mardi 10 janvier 2012 à 05:57 +0100, Eric Dumazet a écrit :
> > Hi Linus
> > 
> > I got some freezes on two different machines, using latest kernel.
> > 
> > while :; do hackbench 10 thread 4000; done
> > 
> > Not sure I'll have time today to find the problem.
> > 
> > It might be related to "perf top" also being run at least once.
> > 
> 
> Hmm, I can trigger the bug without ever using "perf".
> 
> 

OK I managed to bisect it, but I have to run now.

$ git bisect log
git bisect start
# bad: [31ae26ae7ba5ff6209b9ec5d1e1ba9442d6b87e6] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
git bisect bad 31ae26ae7ba5ff6209b9ec5d1e1ba9442d6b87e6
# good: [805a6af8dba5dfdd35ec35dc52ec0122400b2610] Linux 3.2
git bisect good 805a6af8dba5dfdd35ec35dc52ec0122400b2610
# bad: [e4e88f31bcb5f05f24b9ae518d4ecb44e1a7774d] Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc
git bisect bad e4e88f31bcb5f05f24b9ae518d4ecb44e1a7774d
# good: [ab9c17a009ee8eb8c667f22dc0be0709effceab9] mlx4_core: Modify driver initialization flow to accommodate SRIOV for Ethernet
git bisect good ab9c17a009ee8eb8c667f22dc0be0709effceab9
# good: [117ff42fd43e92d24c6aa6f3e4f0f1e1edada140] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect good 117ff42fd43e92d24c6aa6f3e4f0f1e1edada140
# bad: [67b0243131150391125d8d0beb5359d7aec78b55] Merge branch 'x86-apic-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad 67b0243131150391125d8d0beb5359d7aec78b55
# good: [423d091dfe58d3109d84c408810a7cfa82f6f184] Merge branch 'core-rcu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 423d091dfe58d3109d84c408810a7cfa82f6f184
# good: [f1ac18af219835fd5b8e19c14d2dd75c55f78737] perf: Add support for PERF_HW_COUNT_REF_CPU_CYCLES
git bisect good f1ac18af219835fd5b8e19c14d2dd75c55f78737
# good: [1ac9bc6943edf7d181b4b1cc734981350d4f6bae] sched/tracing: Add a new tracepoint for sleeptime
git bisect good 1ac9bc6943edf7d181b4b1cc734981350d4f6bae
# bad: [0db49b72bce26341274b74fd968501489a361ae3] Merge branch 'sched-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad 0db49b72bce26341274b74fd968501489a361ae3
# good: [1b5495043d5bc058def21f9b66fd8feaa794eb44] perf tools: Moving code in some files
git bisect good 1b5495043d5bc058def21f9b66fd8feaa794eb44
# good: [29c9862f1b818bf4caa4c48a30dbe5f25c84ee08] perf session: Remove impossible condition check
git bisect good 29c9862f1b818bf4caa4c48a30dbe5f25c84ee08
# good: [466e2876bcb9ddc9b92502c46689679bee7d72a0] perf script: Kill script_spec__delete
git bisect good 466e2876bcb9ddc9b92502c46689679bee7d72a0
# good: [35b740e4662ef386f0c60e1b60aaf5b44db9914c] Merge branch 'perf-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 35b740e4662ef386f0c60e1b60aaf5b44db9914c


Could it be a merge error ?

commit 0db49b72bce26341274b74fd968501489a361ae3
Merge: 35b740e 1ac9bc6
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Jan 6 08:33:28 2012 -0800

    Merge branch 'sched-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
    
    * 'sched-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip: (40 commits)
      sched/tracing: Add a new tracepoint for sleeptime
      sched: Disable scheduler warnings during oopses
      sched: Fix cgroup movement of waking process
      sched: Fix cgroup movement of newly created process
      sched: Fix cgroup movement of forking process
      sched: Remove cfs bandwidth period check in tg_set_cfs_period()
      sched: Fix load-balance lock-breaking
      sched: Replace all_pinned with a generic flags field
      sched: Only queue remote wakeups when crossing cache boundaries
      sched: Add missing rcu_dereference() around ->real_parent usage
      [S390] fix cputime overflow in uptime_proc_show
      [S390] cputime: add sparse checking and cleanup
      sched: Mark parent and real_parent as __rcu
      sched, nohz: Fix missing RCU read lock
      sched, nohz: Set the NOHZ_BALANCE_KICK flag for idle load balancer
      sched, nohz: Fix the idle cpu check in nohz_idle_balance
      sched: Use jump_labels for sched_feat
      sched/accounting: Fix parameter passing in task_group_account_field
      sched/accounting: Fix user/system tick double accounting
      sched/accounting: Re-use scheduler statistics for the root cgroup
      ...
    
    Fix up conflicts in
     - arch/ia64/include/asm/cputime.h, include/asm-generic/cputime.h
    	usecs_to_cputime64() vs the sparse cleanups
     - kernel/sched/fair.c, kernel/time/tick-sched.c
    	scheduler changes in multiple branches

diff --cc arch/ia64/include/asm/cputime.h
index 5a274af,461e52f..3deac95
--- a/arch/ia64/include/asm/cputime.h
+++ b/arch/ia64/include/asm/cputime.h
@@@ -58,9 -46,10 +46,12 @@@ typedef u64 __nocast cputime64_t
  /*
   * Convert cputime <-> microseconds
   */
- #define cputime_to_usecs(__ct)		((__ct) / NSEC_PER_USEC)
- #define usecs_to_cputime(__usecs)	((__usecs) * NSEC_PER_USEC)
- #define usecs_to_cputime64(__usecs)	usecs_to_cputime(__usecs)
+ #define cputime_to_usecs(__ct)		\
+ 	((__force u64)(__ct) / NSEC_PER_USEC)
+ #define usecs_to_cputime(__usecs)	\
+ 	(__force cputime_t)((__usecs) * NSEC_PER_USEC)
++#define usecs_to_cputime64(__usecs)	\
++	(__force cputime64_t)((__usecs) * NSEC_PER_USEC)
  
  /*
   * Convert cputime <-> seconds
diff --cc arch/powerpc/include/asm/cputime.h
index 98b7c4b,e94935c..6ec1c38
--- a/arch/powerpc/include/asm/cputime.h
+++ b/arch/powerpc/include/asm/cputime.h
@@@ -147,11 -131,9 +131,11 @@@ static inline cputime_t usecs_to_cputim
  	}
  	if (sec)
  		ct += (cputime_t) sec * tb_ticks_per_sec;
- 	return ct;
+ 	return (__force cputime_t) ct;
  }
  
 +#define usecs_to_cputime64(us)		usecs_to_cputime(us)
 +
  /*
   * Convert cputime <-> seconds
   */
diff --cc arch/s390/include/asm/cputime.h
index b9acaaa,0887a04..c23c390
--- a/arch/s390/include/asm/cputime.h
+++ b/arch/s390/include/asm/cputime.h
@@@ -75,20 -62,16 +62,18 @@@ static inline cputime64_t jiffies64_to_
  /*
   * Convert cputime to microseconds and back.
   */
- static inline unsigned int
- cputime_to_usecs(const cputime_t cputime)
+ static inline unsigned int cputime_to_usecs(const cputime_t cputime)
  {
- 	return cputime_div(cputime, 4096);
+ 	return (__force unsigned long long) cputime >> 12;
  }
  
- static inline cputime_t
- usecs_to_cputime(const unsigned int m)
+ static inline cputime_t usecs_to_cputime(const unsigned int m)
  {
- 	return (cputime_t) m * 4096;
+ 	return (__force cputime_t)(m * 4096ULL);
  }
  
 +#define usecs_to_cputime64(m)		usecs_to_cputime(m)
 +
  /*
   * Convert cputime to milliseconds and back.
   */
diff --cc fs/proc/stat.c
index 0855e6f,2527a68..d76ca6a
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@@ -29,10 -28,10 +28,10 @@@ static u64 get_idle_time(int cpu
  
  	if (idle_time == -1ULL) {
  		/* !NO_HZ so we can rely on cpustat.idle */
- 		idle = kstat_cpu(cpu).cpustat.idle;
- 		idle = cputime64_add(idle, arch_idle_time(cpu));
+ 		idle = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE];
+ 		idle += arch_idle_time(cpu);
  	} else
 -		idle = nsecs_to_jiffies64(1000 * idle_time);
 +		idle = usecs_to_cputime64(idle_time);
  
  	return idle;
  }
@@@ -44,9 -42,9 +42,9 @@@ static u64 get_iowait_time(int cpu
  
  	if (iowait_time == -1ULL)
  		/* !NO_HZ so we can rely on cpustat.iowait */
- 		iowait = kstat_cpu(cpu).cpustat.iowait;
+ 		iowait = kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT];
  	else
 -		iowait = nsecs_to_jiffies64(1000 * iowait_time);
 +		iowait = usecs_to_cputime64(iowait_time);
  
  	return iowait;
  }
diff --cc include/asm-generic/cputime.h
index 12a1764,77202e2..9a62937
--- a/include/asm-generic/cputime.h
+++ b/include/asm-generic/cputime.h
@@@ -38,9 -23,10 +23,12 @@@ typedef u64 __nocast cputime64_t
  /*
   * Convert cputime to microseconds and back.
   */
- #define cputime_to_usecs(__ct)		jiffies_to_usecs(__ct)
- #define usecs_to_cputime(__msecs)	usecs_to_jiffies(__msecs)
- #define usecs_to_cputime64(__msecs)	nsecs_to_jiffies64((__msecs) * 1000)
+ #define cputime_to_usecs(__ct)		\
 -	jiffies_to_usecs(cputime_to_jiffies(__ct));
 -#define usecs_to_cputime(__msecs)	\
 -	jiffies_to_cputime(usecs_to_jiffies(__msecs));
++	jiffies_to_usecs(cputime_to_jiffies(__ct))
++#define usecs_to_cputime(__usec)	\
++	jiffies_to_cputime(usecs_to_jiffies(__usec))
++#define usecs_to_cputime64(__usec)	\
++	jiffies64_to_cputime64(nsecs_to_jiffies64((__usec) * 1000))
  
  /*
   * Convert cputime to seconds and back.
diff --cc kernel/time/tick-sched.c
index 0ec8b83,31cc061..7656642
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@@ -446,56 -481,8 +446,64 @@@ out
  	ts->next_jiffies = next_jiffies;
  	ts->last_jiffies = last_jiffies;
  	ts->sleep_length = ktime_sub(dev->next_event, now);
 -end:
 -	local_irq_restore(flags);
 +}
 +
 +/**
 + * tick_nohz_idle_enter - stop the idle tick from the idle task
 + *
 + * When the next event is more than a tick into the future, stop the idle tick
 + * Called when we start the idle loop.
 + *
 + * The arch is responsible of calling:
 + *
 + * - rcu_idle_enter() after its last use of RCU before the CPU is put
 + *  to sleep.
 + * - rcu_idle_exit() before the first use of RCU after the CPU is woken up.
 + */
 +void tick_nohz_idle_enter(void)
 +{
 +	struct tick_sched *ts;
 +
 +	WARN_ON_ONCE(irqs_disabled());
 +
++	/*
++ 	 * Update the idle state in the scheduler domain hierarchy
++ 	 * when tick_nohz_stop_sched_tick() is called from the idle loop.
++ 	 * State will be updated to busy during the first busy tick after
++ 	 * exiting idle.
++ 	 */
++	set_cpu_sd_state_idle();
++
 +	local_irq_disable();
 +
 +	ts = &__get_cpu_var(tick_cpu_sched);
 +	/*
 +	 * set ts->inidle unconditionally. even if the system did not
 +	 * switch to nohz mode the cpu frequency governers rely on the
 +	 * update of the idle time accounting in tick_nohz_start_idle().
 +	 */
 +	ts->inidle = 1;
 +	tick_nohz_stop_sched_tick(ts);
 +
 +	local_irq_enable();
 +}
 +
 +/**
 + * tick_nohz_irq_exit - update next tick event from interrupt exit
 + *
 + * When an interrupt fires while we are idle and it doesn't cause
 + * a reschedule, it may still add, modify or delete a timer, enqueue
 + * an RCU callback, etc...
 + * So we need to re-calculate and reprogram the next tick event.
 + */
 +void tick_nohz_irq_exit(void)
 +{
 +	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 +
 +	if (!ts->inidle)
 +		return;
 +
 +	tick_nohz_stop_sched_tick(ts);
  }
  
  /**


