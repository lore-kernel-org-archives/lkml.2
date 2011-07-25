Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab1GYVOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:14:30 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37736 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab1GYVO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:14:27 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/2] nohz: Drop useless ts->inidle check before rearming the tick
Date: Mon, 25 Jul 2011 23:14:20 +0200
Message-Id: <1311628460-22090-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1311274177-23891-1-git-send-email-fweisbec@gmail.com>
References: <1311274177-23891-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only need to check if we have ts->stopped to ensure the tick
was stopped and we want to re-enable it. Checking ts->inidle
there is useless.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/time/tick-sched.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index c4d7113..5934aee 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -504,16 +504,14 @@ void tick_nohz_restart_sched_tick(void)
 	if (ts->inidle) {
 		now = ktime_get();
 		tick_nohz_stop_idle(cpu, now);
+		ts->inidle = 0;
 	}
 
-	if (!ts->inidle || !ts->tick_stopped) {
-		ts->inidle = 0;
+	if (!ts->tick_stopped) {
 		local_irq_enable();
 		return;
 	}
 
-	ts->inidle = 0;
-
 	rcu_exit_nohz();
 
 	/* Update jiffies first */
-- 
1.7.5.4

