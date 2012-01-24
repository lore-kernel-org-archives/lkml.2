Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab2AXSAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 13:00:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65311 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab2AXSAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 13:00:01 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 2/3] nohz: Remove ts->inidle checks before restarting the tick
Date: Tue, 24 Jan 2012 18:59:43 +0100
Message-Id: <1327427984-23282-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327427984-23282-1-git-send-email-fweisbec@gmail.com>
References: <1327427984-23282-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ts->inidle is set by tick_nohz_idle_enter() and unset by
tick_nohz_idle_exit(). However These two calls are assumed
to be always paired. This means that by the time we call
tick_nohz_idle_exit(), ts->inidle is supposed to be always
set to 1.

Remove the checks for ts->inidle in tick_nohz_idle_exit().
This simplifies a bit the code and improves its debuggability
(ie: ensure the call is paired with a tick_nohz_idle_enter()
call).

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
---
 kernel/time/tick-sched.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 85a67e8..6aecf74 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -560,20 +560,21 @@ void tick_nohz_idle_exit(void)
 
 	local_irq_disable();
 
-	if (ts->idle_active || (ts->inidle && ts->tick_stopped))
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
 	/* Update jiffies first */
 	select_nohz_load_balancer(0);
 	tick_do_update_jiffies64(now);
-- 
1.7.5.4

