Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623Ab0JYWbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 18:31:00 -0400
Received: from smtp-out.google.com ([74.125.121.35]:47064 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265Ab0JYWa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 18:30:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CjBNWqrVgmQkdZwXJ2bTCtzoSP+5aUtRAv7NU/lZrP8fXZOKuz4VgUuxT3yzr+j2Z9
         Sqt9tiVaFXMiyRlEbD0A==
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
Subject: [PATCH 1/6] Free up pf flag PF_KSOFTIRQD -v1
Date: Mon, 25 Oct 2010 15:30:12 -0700
Message-Id: <1288045817-3135-2-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288045817-3135-1-git-send-email-venki@google.com>
References: <1288045817-3135-1-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup patch, freeing up PF_KSOFTIRQD and use per_cpu ksoftirqd pointer
instead, as suggested by Eric Dumazet.

Tested-by: Shaun Ruffell <sruffell@digium.com>

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 include/linux/interrupt.h |    7 +++++++
 include/linux/sched.h     |    1 -
 kernel/sched.c            |    2 +-
 kernel/softirq.c          |    3 +--
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 01b2816..0473d88 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -426,6 +426,13 @@ extern void raise_softirq(unsigned int nr);
  */
 DECLARE_PER_CPU(struct list_head [NR_SOFTIRQS], softirq_work_list);
 
+DECLARE_PER_CPU(struct task_struct *, ksoftirqd);
+
+static inline struct task_struct *this_cpu_ksoftirqd(void)
+{
+	return this_cpu_read(ksoftirqd);
+}
+
 /* Try to send a softirq to a remote cpu.  If this cannot be done, the
  * work will be queued to the local cpu.
  */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0383601..0b25c60 100644
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
diff --git a/kernel/sched.c b/kernel/sched.c
index abf8440..fae668b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1986,7 +1986,7 @@ void account_system_vtime(struct task_struct *curr)
 	 */
 	if (hardirq_count())
 		per_cpu(cpu_hardirq_time, cpu) += delta;
-	else if (in_serving_softirq() && !(curr->flags & PF_KSOFTIRQD))
+	else if (in_serving_softirq() && curr != this_cpu_ksoftirqd())
 		per_cpu(cpu_softirq_time, cpu) += delta;
 
 	local_irq_restore(flags);
diff --git a/kernel/softirq.c b/kernel/softirq.c
index f02a9df..f7a88af 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -54,7 +54,7 @@ EXPORT_SYMBOL(irq_stat);
 
 static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp;
 
-static DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
+DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
 
 char *softirq_to_name[NR_SOFTIRQS] = {
 	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK", "BLOCK_IOPOLL",
@@ -719,7 +719,6 @@ static int run_ksoftirqd(void * __bind_cpu)
 {
 	set_current_state(TASK_INTERRUPTIBLE);
 
-	current->flags |= PF_KSOFTIRQD;
 	while (!kthread_should_stop()) {
 		preempt_disable();
 		if (!local_softirq_pending()) {
-- 
1.7.1

