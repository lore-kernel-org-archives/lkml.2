Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab0LPTgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 14:36:54 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49066 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab0LPTgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 14:36:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZbGtI5PkUjUTSF5cpvcayx8/vmbnd6F3ONTEc8ld5z6dOTzZWaTOqST8J4ZfGq+eXI
         jAq2+A2MjX9YmzypvcCmgNlAUsviGCBYuxlG33xkmIKHwUXabSOW1pJe63HwZkY09GBK
         QV4cIls/W7GERoejioJu7WF8P2f1Ha1uxd3C4=
Message-ID: <4D0A6A51.6090803@am.sony.com>
Date: Thu, 16 Dec 2010 11:36:49 -0800
From: Frank Rowand <frank.rowand@gmail.com>
Reply-To: frank.rowand@am.sony.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: frank.rowand@am.sony.com, frank.rowand@gmail.com
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/5] Reduce runqueue lock contention -v2
References: <20101216145602.899838254@chello.nl> <4D0A649B.9080505@am.sony.com>
In-Reply-To: <4D0A649B.9080505@am.sony.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



patch 2 of 2

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>

---
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1060,7 +1060,7 @@ struct sched_class {
 
 #ifdef CONFIG_SMP
 	int  (*select_task_rq)(struct rq *rq, struct task_struct *p,
-			       int sd_flag, int flags);
+			       int sd_flag, int flags, int waking_cpu);
 
 	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
 	void (*post_schedule) (struct rq *this_rq);
@@ -1196,6 +1196,7 @@ struct task_struct {
 #ifdef CONFIG_SMP
 	struct task_struct *ttwu_queue_wake_entry;
 	int ttwu_queue_wake_flags;
+	int ttwu_waking_cpu;
 #ifdef __ARCH_WANT_UNLOCKED_CTXSW
 	int oncpu;
 #endif
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2262,9 +2262,11 @@ static int select_fallback_rq(int cpu, s
  * The caller (fork, wakeup) owns TASK_WAKING, ->cpus_allowed is stable.
  */
 static inline
-int select_task_rq(struct rq *rq, struct task_struct *p, int sd_flags, int wake_flags)
+int select_task_rq(struct rq *rq, struct task_struct *p, int sd_flags,
+		   int wake_flags, int waking_cpu)
 {
-	int cpu = p->sched_class->select_task_rq(rq, p, sd_flags, wake_flags);
+	int cpu = p->sched_class->select_task_rq(rq, p, sd_flags, wake_flags,
+						 waking_cpu);
 
 	/*
 	 * In order not to call set_task_cpu() on a blocking task we need
@@ -2335,12 +2337,14 @@ static inline void ttwu_post_activation(
 }
 
 #ifdef CONFIG_SMP
-static void ttwu_queue_wake_up(struct task_struct *p, int cpu, int wake_flags)
+static void ttwu_queue_wake_up(struct task_struct *p, int this_cpu, int p_cpu,
+			       int wake_flags)
 {
 	struct task_struct *next = NULL;
-	struct rq *rq = cpu_rq(cpu);
+	struct rq *rq = cpu_rq(p_cpu);
 
 	p->ttwu_queue_wake_flags = wake_flags;
+	p->ttwu_waking_cpu = this_cpu;
 
 	for (;;) {
 		struct task_struct *old = next;
@@ -2352,7 +2356,7 @@ static void ttwu_queue_wake_up(struct ta
 	}
 
 	if (!next)
-		smp_send_reschedule(cpu);
+		smp_send_reschedule(p_cpu);
 }
 #endif
 
@@ -2377,8 +2381,6 @@ static int try_to_wake_up(struct task_st
 /*
  * xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  * todo
- *  - pass waking cpu with queued wake up, to be used in call to
- *    select_task_rq().
  *  - handle cpu being offlined
  * xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  */
@@ -2387,7 +2389,7 @@ static int try_to_wake_up(struct task_st
 	unsigned long en_flags = ENQUEUE_WAKEUP;
 	struct rq *rq;
 #ifdef CONFIG_SMP
-	int load;
+	int load, waking_cpu;
 #endif
 
 	this_cpu = get_cpu();
@@ -2405,8 +2407,12 @@ static int try_to_wake_up(struct task_st
 		load = task_contributes_to_load(p);
 
 		if (cmpxchg(&p->state, task_state, TASK_WAKING) == task_state) {
-			if (state == TASK_WAKING)
+			if (state == TASK_WAKING) {
 				load = wake_flags & WF_LOAD;
+				waking_cpu = p->ttwu_waking_cpu;
+			} else {
+				waking_cpu = this_cpu;
+			}
 			break;
 		}
 	}
@@ -2443,7 +2449,7 @@ static int try_to_wake_up(struct task_st
 	if (cpu != this_cpu) {
 		if (load)
 			wake_flags |= WF_LOAD;
-		ttwu_queue_wake_up(p, cpu, wake_flags);
+		ttwu_queue_wake_up(p, this_cpu, cpu, wake_flags);
 		success = 1;
 		goto out_nolock;
 	}
@@ -2482,7 +2488,7 @@ static int try_to_wake_up(struct task_st
 		en_flags |= ENQUEUE_WAKING;
 	}
 
-	cpu = select_task_rq(rq, p, SD_BALANCE_WAKE, wake_flags);
+	cpu = select_task_rq(rq, p, SD_BALANCE_WAKE, wake_flags, waking_cpu);
 	if (cpu != orig_cpu)
 		set_task_cpu(p, cpu);
 	/*
@@ -2728,7 +2734,7 @@ void wake_up_new_task(struct task_struct
 	 * We set TASK_WAKING so that select_task_rq() can drop rq->lock
 	 * without people poking at ->cpus_allowed.
 	 */
-	cpu = select_task_rq(rq, p, SD_BALANCE_FORK, 0);
+	cpu = select_task_rq(rq, p, SD_BALANCE_FORK, 0, cpu);
 	set_task_cpu(p, cpu);
 
 	p->state = TASK_RUNNING;
@@ -3327,7 +3333,8 @@ void sched_exec(void)
 	int dest_cpu;
 
 	rq = task_rq_lock(p, &flags);
-	dest_cpu = p->sched_class->select_task_rq(rq, p, SD_BALANCE_EXEC, 0);
+	dest_cpu = p->sched_class->select_task_rq(rq, p, SD_BALANCE_EXEC, 0,
+						  smp_processor_id());
 	if (dest_cpu == smp_processor_id())
 		goto unlock;
 
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1606,10 +1606,10 @@ static int select_idle_sibling(struct ta
  * preempt must be disabled.
  */
 static int
-select_task_rq_fair(struct rq *rq, struct task_struct *p, int sd_flag, int wake_flags)
+select_task_rq_fair(struct rq *rq, struct task_struct *p, int sd_flag,
+		    int wake_flags, int cpu)
 {
 	struct sched_domain *tmp, *affine_sd = NULL, *sd = NULL;
-	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	int new_cpu = cpu;
 	int want_affine = 0;
Index: linux-2.6/kernel/sched_idletask.c
===================================================================
--- linux-2.6.orig/kernel/sched_idletask.c
+++ linux-2.6/kernel/sched_idletask.c
@@ -7,7 +7,8 @@
 
 #ifdef CONFIG_SMP
 static int
-select_task_rq_idle(struct rq *rq, struct task_struct *p, int sd_flag, int flags)
+select_task_rq_idle(struct rq *rq, struct task_struct *p, int sd_flag,
+		    int flags, int waking_cpu)
 {
 	return task_cpu(p); /* IDLE tasks as never migrated */
 }
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -973,7 +973,8 @@ static void yield_task_rt(struct rq *rq)
 static int find_lowest_rq(struct task_struct *task);
 
 static int
-select_task_rq_rt(struct rq *rq, struct task_struct *p, int sd_flag, int flags)
+select_task_rq_rt(struct rq *rq, struct task_struct *p, int sd_flag, int flags,
+		  int waking_cpu)
 {
 	if (sd_flag != SD_BALANCE_WAKE)
 		return smp_processor_id();
Index: linux-2.6/kernel/sched_stoptask.c
===================================================================
--- linux-2.6.orig/kernel/sched_stoptask.c
+++ linux-2.6/kernel/sched_stoptask.c
@@ -10,7 +10,7 @@
 #ifdef CONFIG_SMP
 static int
 select_task_rq_stop(struct rq *rq, struct task_struct *p,
-		    int sd_flag, int flags)
+		    int sd_flag, int flags, int waking_cpu)
 {
 	return task_cpu(p); /* stop tasks as never migrate */
 }
