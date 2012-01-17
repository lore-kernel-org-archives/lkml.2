Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab2AQJGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 04:06:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41152 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab2AQJG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 04:06:27 -0500
Date: Tue, 17 Jan 2012 10:06:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yasunori Goto <y-goto@jp.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special condition
Message-ID: <20120117090605.GD7612@elte.hu>
References: <20120116205140.6120.E1E9C6FF@jp.fujitsu.com>
 <1326721082.2442.234.camel@twins>
 <20120117174031.3118.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120117174031.3118.E1E9C6FF@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yasunori Goto <y-goto@jp.fujitsu.com> wrote:

> --- linux-3.2.orig/kernel/exit.c
> +++ linux-3.2/kernel/exit.c
> @@ -1038,6 +1038,22 @@ NORET_TYPE void do_exit(long code)
>  
>  	preempt_disable();
>  	exit_rcu();
> +
> +	/*
> +	 * The setting of TASK_RUNNING by try_to_wake_up() may be delayed
> +	 * when the following two conditions become true.
> +	 *   - There is race condition of mmap_sem (It is acquired by
> +	 *     exit_mm()), and
> +	 *   - SMI occurs before setting TASK_RUNINNG.
> +	 *     (or hypervisor of virtual machine switches to other guest)
> +	 *  As a result, we may become TASK_RUNNING after becoming TASK_DEAD
> +	 *
> +	 * To avoid it, we have to wait for releasing tsk->pi_lock which
> +	 * is held by try_to_wake_up()
> +	 */
> +	smp_mb();
> +	raw_spin_unlock_wait(&tsk->pi_lock);

Hm, unlock_wait() is really nasty. Wouldnt the adoption of the 
-rt kernel's delayed task put logic solve most of these races? 
It's the patch below - we could get rid of the 
CONFIG_PREEMPT_RT_BASE and make it unconditional.

[ The -rt kernel is facing similar "sudden outbreak of large 
  delays" constraints as hypervisors or SMI victims do, so even 
  if the delayed-task-put patch does not solve the race, some 
  other -rt patch might :-) ]

Thanks,

	Ingo

-------------------->
Subject: sched-delay-put-task.patch
From: Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 31 May 2011 16:59:16 +0200

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/sched.h |   13 +++++++++++++
 kernel/fork.c         |   11 +++++++++++
 2 files changed, 24 insertions(+)

Index: linux-3.2/include/linux/sched.h
===================================================================
--- linux-3.2.orig/include/linux/sched.h
+++ linux-3.2/include/linux/sched.h
@@ -1588,6 +1588,9 @@ struct task_struct {
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 	atomic_t ptrace_bp_refcnt;
 #endif
+#ifdef CONFIG_PREEMPT_RT_BASE
+	struct rcu_head put_rcu;
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
@@ -1772,6 +1775,15 @@ extern struct pid *cad_pid;
 extern void free_task(struct task_struct *tsk);
 #define get_task_struct(tsk) do { atomic_inc(&(tsk)->usage); } while(0)
 
+#ifdef CONFIG_PREEMPT_RT_BASE
+extern void __put_task_struct_cb(struct rcu_head *rhp);
+
+static inline void put_task_struct(struct task_struct *t)
+{
+	if (atomic_dec_and_test(&t->usage))
+		call_rcu(&t->put_rcu, __put_task_struct_cb);
+}
+#else
 extern void __put_task_struct(struct task_struct *t);
 
 static inline void put_task_struct(struct task_struct *t)
@@ -1779,6 +1791,7 @@ static inline void put_task_struct(struc
 	if (atomic_dec_and_test(&t->usage))
 		__put_task_struct(t);
 }
+#endif
 
 extern void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st);
 extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st);
Index: linux-3.2/kernel/fork.c
===================================================================
--- linux-3.2.orig/kernel/fork.c
+++ linux-3.2/kernel/fork.c
@@ -197,7 +197,18 @@ void __put_task_struct(struct task_struc
 	if (!profile_handoff_task(tsk))
 		free_task(tsk);
 }
+#ifndef CONFIG_PREEMPT_RT_BASE
 EXPORT_SYMBOL_GPL(__put_task_struct);
+#else
+void __put_task_struct_cb(struct rcu_head *rhp)
+{
+	struct task_struct *tsk = container_of(rhp, struct task_struct, rcu);
+
+	__put_task_struct(tsk);
+
+}
+EXPORT_SYMBOL_GPL(__put_task_struct_cb);
+#endif
 
 /*
  * macro override instead of weak attribute alias, to workaround
