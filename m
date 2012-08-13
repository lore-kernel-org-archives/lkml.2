Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab2HMRFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 13:05:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33697 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab2HMRFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 13:05:41 -0400
Date: Mon, 13 Aug 2012 10:05:27 -0700
From: tip-bot for Pekka Enberg <penberg@kernel.org>
Message-ID: <tip-edde96eafc91a510f404e7b82cfc0ecb608505ee@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, rdunlap@xenotime.net,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, tglx@linutronix.de,
        rdunlap@xenotime.net
In-Reply-To: <1344070187-2420-1-git-send-email-penberg@kernel.org>
References: <1344070187-2420-1-git-send-email-penberg@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Document schedule() entry points
Git-Commit-ID: edde96eafc91a510f404e7b82cfc0ecb608505ee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 13 Aug 2012 10:05:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  edde96eafc91a510f404e7b82cfc0ecb608505ee
Gitweb:     http://git.kernel.org/tip/edde96eafc91a510f404e7b82cfc0ecb608505ee
Author:     Pekka Enberg <penberg@kernel.org>
AuthorDate: Sat, 4 Aug 2012 11:49:47 +0300
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 13 Aug 2012 18:58:15 +0200

sched: Document schedule() entry points

This patch adds a comment on top of the schedule() function to explain
to scheduler newbies how the main scheduler function is entered.

Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Explained-by: Ingo Molnar <mingo@kernel.org>
Explained-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1344070187-2420-1-git-send-email-penberg@kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/core.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fbf1fd0..c9a3655 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3367,6 +3367,40 @@ pick_next_task(struct rq *rq)
 
 /*
  * __schedule() is the main scheduler function.
+ *
+ * The main means of driving the scheduler and thus entering this function are:
+ *
+ *   1. Explicit blocking: mutex, semaphore, waitqueue, etc.
+ *
+ *   2. TIF_NEED_RESCHED flag is checked on interrupt and userspace return
+ *      paths. For example, see arch/x86/entry_64.S.
+ *
+ *      To drive preemption between tasks, the scheduler sets the flag in timer
+ *      interrupt handler scheduler_tick().
+ *
+ *   3. Wakeups don't really cause entry into schedule(). They add a
+ *      task to the run-queue and that's it.
+ *
+ *      Now, if the new task added to the run-queue preempts the current
+ *      task, then the wakeup sets TIF_NEED_RESCHED and schedule() gets
+ *      called on the nearest possible occasion:
+ *
+ *       - If the kernel is preemptible (CONFIG_PREEMPT=y):
+ *
+ *         - in syscall or exception context, at the next outmost
+ *           preempt_enable(). (this might be as soon as the wake_up()'s
+ *           spin_unlock()!)
+ *
+ *         - in IRQ context, return from interrupt-handler to
+ *           preemptible context
+ *
+ *       - If the kernel is not preemptible (CONFIG_PREEMPT is not set)
+ *         then at the next:
+ *
+ *          - cond_resched() call
+ *          - explicit schedule() call
+ *          - return from syscall or exception to user-space
+ *          - return from interrupt-handler to user-space
  */
 static void __sched __schedule(void)
 {
