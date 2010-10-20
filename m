Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab0JTWt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 18:49:27 -0400
Received: from smtp-out.google.com ([216.239.44.51]:32127 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab0JTWt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 18:49:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GLtdTO8WOHc/JBsiSNCf3B4qZiEVCoOw1EEiTPW7haWP92ObQmbjnfIZ4pC/jwyexy
         e/etvJvK6BM4TctxCvAQ==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 1/6] Free up pf flag PF_KSOFTIRQD
Date: Wed, 20 Oct 2010 15:48:57 -0700
Message-Id: <1287614941-32325-2-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287614941-32325-1-git-send-email-venki@google.com>
References: <1287614941-32325-1-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup patch, freeing up PF_KSOFTIRQD and
using (current == __get_cpu_var(ksoftirqd)) instead, as suggested
by Eric Dumazet.

Unrelated one line cleanup of changing hardirq_count() to in_irq() in
account_system_vtime.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
---
 include/linux/sched.h |    3 ++-
 kernel/sched.c        |    4 ++--
 kernel/softirq.c      |    6 +++++-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0383601..6dd4894 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1691,7 +1691,6 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 /*
  * Per process flags
  */
-#define PF_KSOFTIRQD	0x00000001	/* I am ksoftirqd */
 #define PF_STARTING	0x00000002	/* being created */
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
@@ -1749,6 +1748,8 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define tsk_used_math(p) ((p)->flags & PF_USED_MATH)
 #define used_math() tsk_used_math(current)
 
+int is_ksoftirqd_context(void);
+
 #ifdef CONFIG_PREEMPT_RCU
 
 #define RCU_READ_UNLOCK_BLOCKED (1 << 0) /* blocked while in RCU read-side. */
diff --git a/kernel/sched.c b/kernel/sched.c
index abf8440..5d4afe9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1984,9 +1984,9 @@ void account_system_vtime(struct task_struct *curr)
 	 * in that case, so as not to confuse scheduler with a special task
 	 * that do not consume any time, but still wants to run.
 	 */
-	if (hardirq_count())
+	if (in_irq())
 		per_cpu(cpu_hardirq_time, cpu) += delta;
-	else if (in_serving_softirq() && !(curr->flags & PF_KSOFTIRQD))
+	else if (in_serving_softirq() && !(is_ksoftirqd_context()))
 		per_cpu(cpu_softirq_time, cpu) += delta;
 
 	local_irq_restore(flags);
diff --git a/kernel/softirq.c b/kernel/softirq.c
index f02a9df..3ceb560 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -56,6 +56,11 @@ static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp
 
 static DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
 
+int is_ksoftirqd_context(void)
+{
+	return (current == __get_cpu_var(ksoftirqd));
+}
+
 char *softirq_to_name[NR_SOFTIRQS] = {
 	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK", "BLOCK_IOPOLL",
 	"TASKLET", "SCHED", "HRTIMER",	"RCU"
@@ -719,7 +724,6 @@ static int run_ksoftirqd(void * __bind_cpu)
 {
 	set_current_state(TASK_INTERRUPTIBLE);
 
-	current->flags |= PF_KSOFTIRQD;
 	while (!kthread_should_stop()) {
 		preempt_disable();
 		if (!local_softirq_pending()) {
-- 
1.7.1

