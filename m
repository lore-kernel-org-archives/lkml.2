Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933111Ab0JRT0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:26:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:58769 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932471Ab0JRT0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:26:02 -0400
Date: Mon, 18 Oct 2010 19:25:20 GMT
From: tip-bot for Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
        venki@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, venki@google.com,
        mingo@elte.hu
In-Reply-To: <1286237003-12406-4-git-send-email-venki@google.com>
References: <1286237003-12406-4-git-send-email-venki@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Add a PF flag for ksoftirqd identification
Message-ID: <tip-6cdd5199daf0cb7b0fcc8dca941af08492612887@git.kernel.org>
Git-Commit-ID: 6cdd5199daf0cb7b0fcc8dca941af08492612887
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Oct 2010 19:25:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6cdd5199daf0cb7b0fcc8dca941af08492612887
Gitweb:     http://git.kernel.org/tip/6cdd5199daf0cb7b0fcc8dca941af08492612887
Author:     Venkatesh Pallipadi <venki@google.com>
AuthorDate: Mon, 4 Oct 2010 17:03:18 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Oct 2010 20:52:22 +0200

sched: Add a PF flag for ksoftirqd identification

To account softirq time cleanly in scheduler, we need to identify whether
softirq is invoked in ksoftirqd context or softirq at hardirq tail context.
Add PF_KSOFTIRQD for that purpose.

As all PF flag bits are currently taken, create space by moving one of the
infrequently used bits (PF_THREAD_BOUND) down in task_struct to be along
with some other state fields.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1286237003-12406-4-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    1 +
 kernel/softirq.c      |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8744e50..aca0ce6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1682,6 +1682,7 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 /*
  * Per process flags
  */
+#define PF_KSOFTIRQD	0x00000001	/* I am ksoftirqd */
 #define PF_STARTING	0x00000002	/* being created */
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 988dfbe..267f7b7 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -713,6 +713,7 @@ static int run_ksoftirqd(void * __bind_cpu)
 {
 	set_current_state(TASK_INTERRUPTIBLE);
 
+	current->flags |= PF_KSOFTIRQD;
 	while (!kthread_should_stop()) {
 		preempt_disable();
 		if (!local_softirq_pending()) {
