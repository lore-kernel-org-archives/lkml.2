Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab1LFOax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 09:30:53 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49123 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab1LFOaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 09:30:52 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] nohz: Remove ts->inidle checks before restarting the tick
Date: Tue,  6 Dec 2011 15:30:43 +0100
Message-Id: <1323181843-12144-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ts->inidle is set by tick_nohz_stop_sched_tick(1) and unset
by tick_nohz_restart_sched_tick(). These two calls are assumed
to be always paired. This means that by the time we call
tick_nohz_restart_sched_tick(), ts->inidle is supposed to
be always set to 1.

Remove the checks for ts->inidle in tick_nohz_restart_sched_tick().
This simplifies a bit the code and improves its debuggability
(ie: ensure the call is paired with a tick_nohz_stop_sched_tick() call).

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/time/tick-sched.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 4042064..0f7c5e5 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -529,20 +529,22 @@ void tick_nohz_restart_sched_tick(void)
 	ktime_t now;
 
 	local_irq_disable();
-	if (ts->idle_active || (ts->inidle && ts->tick_stopped))
+
+	WARN_ON_ONCE(!ts->inidle);
+
+	ts->inidle = 0;
+
+	if (ts->idle_active || ts->tick_stopped)
 		now = ktime_get();
 
 	if (ts->idle_active)
 		tick_nohz_stop_idle(cpu, now);
 
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

