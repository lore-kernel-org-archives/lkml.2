Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab0EGQok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 12:44:40 -0400
Received: from www.tglx.de ([62.245.132.106]:36057 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab0EGQoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 12:44:39 -0400
Date: Fri, 7 May 2010 18:43:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Darren Hart <dvhltc@us.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>, Ulrich Drepper <drepper@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 4/4] futex: Add FUTEX_LOCK with optional adaptive
 spinning
In-Reply-To: <1273250143.1642.361.camel@laptop>
Message-ID: <alpine.LFD.2.00.1005071839140.3401@localhost.localdomain>
References: <1273127060-30375-1-git-send-email-dvhltc@us.ibm.com>  <1273127060-30375-5-git-send-email-dvhltc@us.ibm.com>  <alpine.LFD.2.00.1005071818380.3401@localhost.localdomain>  <1273249491.1642.360.camel@laptop>  <alpine.LFD.2.00.1005071829470.3401@localhost.localdomain>
 <1273250143.1642.361.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 7 May 2010, Peter Zijlstra wrote:

> On Fri, 2010-05-07 at 18:30 +0200, Thomas Gleixner wrote:
> > > Please keep the code as near mutex_spin_on_owner() as possible.
> > 
> > There is no reason why we can't make that unconditional.
> > 
> Sure, but lets do that in a separate series.

Sure. I'm not touching mutex_spin_on_owner() now. It's just for
testing now.

Thanks,

	tglx
---
Index: linux-2.6-tip/kernel/sched.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched.c
+++ linux-2.6-tip/kernel/sched.c
@@ -841,6 +841,10 @@ static inline int task_running(struct rq
 
 static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
 {
+#ifdef CONFIG_SMP
+	next->oncpu = 1;
+	prev->oncpu = 0;
+#endif
 }
 
 static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
@@ -2628,7 +2632,7 @@ void sched_fork(struct task_struct *p, i
 	if (likely(sched_info_on()))
 		memset(&p->sched_info, 0, sizeof(p->sched_info));
 #endif
-#if defined(CONFIG_SMP) && defined(__ARCH_WANT_UNLOCKED_CTXSW)
+#if defined(CONFIG_SMP)
 	p->oncpu = 0;
 #endif
 #ifdef CONFIG_PREEMPT
@@ -5250,7 +5254,7 @@ void __cpuinit init_idle(struct task_str
 	__set_task_cpu(idle, cpu);
 
 	rq->curr = rq->idle = idle;
-#if defined(CONFIG_SMP) && defined(__ARCH_WANT_UNLOCKED_CTXSW)
+#if defined(CONFIG_SMP)
 	idle->oncpu = 1;
 #endif
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
Index: linux-2.6-tip/include/linux/sched.h
===================================================================
--- linux-2.6-tip.orig/include/linux/sched.h
+++ linux-2.6-tip/include/linux/sched.h
@@ -1178,10 +1178,8 @@ struct task_struct {
 	int lock_depth;		/* BKL lock depth */
 
 #ifdef CONFIG_SMP
-#ifdef __ARCH_WANT_UNLOCKED_CTXSW
 	int oncpu;
 #endif
-#endif
 
 	int prio, static_prio, normal_prio;
 	unsigned int rt_priority;

