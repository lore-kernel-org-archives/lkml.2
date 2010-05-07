Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813Ab0EGTGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 15:06:17 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:42639 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab0EGTGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 15:06:16 -0400
Message-ID: <4BE46497.4010505@us.ibm.com>
Date: Fri, 07 May 2010 12:05:59 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>, Ulrich Drepper <drepper@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 4/4] futex: Add FUTEX_LOCK with optional adaptive spinning
References: <1273127060-30375-1-git-send-email-dvhltc@us.ibm.com> <1273127060-30375-5-git-send-email-dvhltc@us.ibm.com> <alpine.LFD.2.00.1005071818380.3401@localhost.localdomain> <1273249491.1642.360.camel@laptop> <alpine.LFD.2.00.1005071829470.3401@localhost.localdomain> <1273250143.1642.361.camel@laptop> <alpine.LFD.2.00.1005071839140.3401@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005071839140.3401@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Fri, 7 May 2010, Peter Zijlstra wrote:
> 
>> On Fri, 2010-05-07 at 18:30 +0200, Thomas Gleixner wrote:
>>>> Please keep the code as near mutex_spin_on_owner() as possible.
>>> There is no reason why we can't make that unconditional.
>>>
>> Sure, but lets do that in a separate series.
> 
> Sure. I'm not touching mutex_spin_on_owner() now. It's just for
> testing now.
> 
> Thanks,
> 
> 	tglx


One bug below, see patch below for fix.


> ---
> Index: linux-2.6-tip/kernel/sched.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/sched.c
> +++ linux-2.6-tip/kernel/sched.c
> @@ -841,6 +841,10 @@ static inline int task_running(struct rq
> 
>  static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
>  {
> +#ifdef CONFIG_SMP
> +	next->oncpu = 1;
> +	prev->oncpu = 0;

no prev in context, moved to finish_lock_switch:

How's this?

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
---
 include/linux/sched.h |    2 --
 kernel/sched.c        |   10 ++++++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 885d659..3fb8a45 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1178,10 +1178,8 @@ struct task_struct {
 	int lock_depth;		/* BKL lock depth */
 
 #ifdef CONFIG_SMP
-#ifdef __ARCH_WANT_UNLOCKED_CTXSW
 	int oncpu;
 #endif
-#endif
 
 	int prio, static_prio, normal_prio;
 	unsigned int rt_priority;
diff --git a/kernel/sched.c b/kernel/sched.c
index 20b8d99..9915bdf 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -841,10 +841,16 @@ static inline int task_running(struct rq *rq, struct task_struct *p)
 
 static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
 {
+#ifdef CONFIG_SMP
+	next->oncpu = 1;
+#endif
 }
 
 static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 {
+#ifdef CONFIG_SMP
+	prev->oncpu = 0;
+#endif
 #ifdef CONFIG_DEBUG_SPINLOCK
 	/* this is a valid case when another task releases the spinlock */
 	rq->lock.owner = current;
@@ -2628,7 +2634,7 @@ void sched_fork(struct task_struct *p, int clone_flags)
 	if (likely(sched_info_on()))
 		memset(&p->sched_info, 0, sizeof(p->sched_info));
 #endif
-#if defined(CONFIG_SMP) && defined(__ARCH_WANT_UNLOCKED_CTXSW)
+#if defined(CONFIG_SMP)
 	p->oncpu = 0;
 #endif
 #ifdef CONFIG_PREEMPT
@@ -5316,7 +5322,7 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	__set_task_cpu(idle, cpu);
 
 	rq->curr = rq->idle = idle;
-#if defined(CONFIG_SMP) && defined(__ARCH_WANT_UNLOCKED_CTXSW)
+#if defined(CONFIG_SMP)
 	idle->oncpu = 1;
 #endif
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
-- 
1.6.3.3


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
