Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab1BJM2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:28:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756174Ab1BJMZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:25:08 -0500
From: stable-bot for Venkatesh Pallipadi <venki@google.com>
Date: Thu, 10 Feb 2011 10:23:27 +0100
Subject: [PATCH 16/28] sched: Add a PF flag for ksoftirqd identification
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Message-ID: <1297340644.5512.16.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit: 6cdd5199daf0cb7b0fcc8dca941af08492612887 upstream
Author: Venkatesh Pallipadi <venki@google.com>
AuthorDate: Mon Oct 4 17:03:18 2010 -0700

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
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    1 +
 kernel/softirq.c      |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 32bf471..63d5aea 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1728,6 +1728,7 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 /*
  * Per process flags
  */
+#define PF_KSOFTIRQD	0x00000001	/* I am ksoftirqd */
 #define PF_STARTING	0x00000002	/* being created */
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 0ed8343..0a617de 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -718,6 +718,7 @@ static int ksoftirqd(void * __bind_cpu)
 {
 	set_current_state(TASK_INTERRUPTIBLE);
 
+	current->flags |= PF_KSOFTIRQD;
 	while (!kthread_should_stop()) {
 		preempt_disable();
 		if (!local_softirq_pending()) {
-- 
1.7.4


