Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab2BOTjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:39:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53086 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab2BOTjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:39:21 -0500
Date: Wed, 15 Feb 2012 11:38:29 -0800
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <tip-15f827be93928890bba965bc175caee50c4406d2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, john.stultz@linaro.org, fweisbec@gmail.com,
        tglx@linutronix.de, yong.zhang0@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, john.stultz@linaro.org, fweisbec@gmail.com,
        tglx@linutronix.de, yong.zhang0@gmail.com, mingo@elte.hu
In-Reply-To: <1327427984-23282-2-git-send-email-fweisbec@gmail.com>
References: <1327427984-23282-2-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] nohz: Remove ts->
 Einidle checks before restarting the tick
Git-Commit-ID: 15f827be93928890bba965bc175caee50c4406d2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 15 Feb 2012 11:38:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  15f827be93928890bba965bc175caee50c4406d2
Gitweb:     http://git.kernel.org/tip/15f827be93928890bba965bc175caee50c4406d2
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 24 Jan 2012 18:59:43 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 15 Feb 2012 15:23:09 +0100

nohz: Remove ts->Einidle checks before restarting the tick

ts->inidle is set by tick_nohz_idle_enter() and unset by
tick_nohz_idle_exit(). However these two calls are assumed
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
Cc: John Stultz <john.stultz@linaro.org>
Cc: Ingo Molnar <mingo@elte.hu>
Link: http://lkml.kernel.org/r/1327427984-23282-2-git-send-email-fweisbec@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-sched.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 8cfffd9..3526038 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -558,20 +558,21 @@ void tick_nohz_idle_exit(void)
 
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
