Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab2JaH1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:27:38 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38178 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab2JaH1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:27:33 -0400
From: Xiaotian Feng <xtfeng@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <xtfeng@gmail.com>, Xiaotian Feng <dannyfeng@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 1/2] tasklet: remove tasklet_kill_immediate()
Date: Wed, 31 Oct 2012 15:28:06 +0800
Message-Id: <1351668487-26635-1-git-send-email-xtfeng@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tasklet_kill_immediate() is no longer used, just remove it.

Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Triplett <josh@joshtriplett.org>
---
 kernel/softirq.c |   32 --------------------------------
 1 file changed, 32 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index cc96bdc..61abd86 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -762,38 +762,6 @@ static void run_ksoftirqd(unsigned int cpu)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-/*
- * tasklet_kill_immediate is called to remove a tasklet which can already be
- * scheduled for execution on @cpu.
- *
- * Unlike tasklet_kill, this function removes the tasklet
- * _immediately_, even if the tasklet is in TASKLET_STATE_SCHED state.
- *
- * When this function is called, @cpu must be in the CPU_DEAD state.
- */
-void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu)
-{
-	struct tasklet_struct **i;
-
-	BUG_ON(cpu_online(cpu));
-	BUG_ON(test_bit(TASKLET_STATE_RUN, &t->state));
-
-	if (!test_bit(TASKLET_STATE_SCHED, &t->state))
-		return;
-
-	/* CPU is dead, so no lock needed. */
-	for (i = &per_cpu(tasklet_vec, cpu).head; *i; i = &(*i)->next) {
-		if (*i == t) {
-			*i = t->next;
-			/* If this was the tail element, move the tail ptr */
-			if (*i == NULL)
-				per_cpu(tasklet_vec, cpu).tail = i;
-			return;
-		}
-	}
-	BUG();
-}
-
 static void takeover_tasklets(unsigned int cpu)
 {
 	/* CPU is dead, so no lock needed. */
-- 
1.7.9.5

