Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab1AZMMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 07:12:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:39747 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab1AZMM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 07:12:29 -0500
Date: Wed, 26 Jan 2011 12:11:54 GMT
From: tip-bot for Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, sruffell@digium.com, tglx@linutronix.de,
        venki@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, sruffell@digium.com, tglx@linutronix.de,
        venki@google.com, mingo@elte.hu
In-Reply-To: <1292980144-28796-2-git-send-email-venki@google.com>
References: <1292980144-28796-2-git-send-email-venki@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] softirqs: Free up pf flag PF_KSOFTIRQD
Message-ID: <tip-4dd53d891ca46dcc1fde0376a33540d3fd83cb9a@git.kernel.org>
Git-Commit-ID: 4dd53d891ca46dcc1fde0376a33540d3fd83cb9a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 12:11:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4dd53d891ca46dcc1fde0376a33540d3fd83cb9a
Gitweb:     http://git.kernel.org/tip/4dd53d891ca46dcc1fde0376a33540d3fd83cb9a
Author:     Venkatesh Pallipadi <venki@google.com>
AuthorDate: Tue, 21 Dec 2010 17:09:00 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Jan 2011 12:33:20 +0100

softirqs: Free up pf flag PF_KSOFTIRQD

Cleanup patch, freeing up PF_KSOFTIRQD and use per_cpu ksoftirqd pointer
instead, as suggested by Eric Dumazet.

Tested-by: Shaun Ruffell <sruffell@digium.com>
Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1292980144-28796-2-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/interrupt.h |    7 +++++++
 include/linux/sched.h     |    1 -
 kernel/sched.c            |    2 +-
 kernel/softirq.c          |    3 +--
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 55e0d42..a1382b9 100644
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
index d747f94..af6e15f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1715,7 +1715,6 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 /*
  * Per process flags
  */
-#define PF_KSOFTIRQD	0x00000001	/* I am ksoftirqd */
 #define PF_STARTING	0x00000002	/* being created */
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
diff --git a/kernel/sched.c b/kernel/sched.c
index 6820b5b..8b89b3b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1880,7 +1880,7 @@ void account_system_vtime(struct task_struct *curr)
 	 */
 	if (hardirq_count())
 		__this_cpu_add(cpu_hardirq_time, delta);
-	else if (in_serving_softirq() && !(curr->flags & PF_KSOFTIRQD))
+	else if (in_serving_softirq() && curr != this_cpu_ksoftirqd())
 		__this_cpu_add(cpu_softirq_time, delta);
 
 	irq_time_write_end();
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 68eb5ef..0cee504 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -54,7 +54,7 @@ EXPORT_SYMBOL(irq_stat);
 
 static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp;
 
-static DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
+DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
 
 char *softirq_to_name[NR_SOFTIRQS] = {
 	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK", "BLOCK_IOPOLL",
@@ -721,7 +721,6 @@ static int run_ksoftirqd(void * __bind_cpu)
 {
 	set_current_state(TASK_INTERRUPTIBLE);
 
-	current->flags |= PF_KSOFTIRQD;
 	while (!kthread_should_stop()) {
 		preempt_disable();
 		if (!local_softirq_pending()) {
