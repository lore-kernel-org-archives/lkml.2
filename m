Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab1ILLkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 07:40:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:33287 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab1ILLkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 07:40:07 -0400
Date: Mon, 12 Sep 2011 13:40:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] watchdog: Drop FIFO policy in exit path
Message-ID: <alpine.LFD.2.02.1109121337461.2723@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the watchdog thread exits it runs through the exit path with FIFO
priority. There is no point in doing so. Switch back to SCHED_NORMAL
before exiting.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/watchdog.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/watchdog.c
===================================================================
--- linux-2.6.orig/kernel/watchdog.c
+++ linux-2.6/kernel/watchdog.c
@@ -320,7 +320,7 @@ static enum hrtimer_restart watchdog_tim
  */
 static int watchdog(void *unused)
 {
-	static struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
+	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
@@ -349,7 +349,8 @@ static int watchdog(void *unused)
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
 	__set_current_state(TASK_RUNNING);
-
+	param.sched_priority = 0;
+	sched_setscheduler(current, SCHED_NORMAL, &param);
 	return 0;
 }
 
