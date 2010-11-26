Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab0KZKug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 05:50:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:42324 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741Ab0KZKue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 05:50:34 -0500
From: Tejun Heo <tj@kernel.org>
To: roland@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        "rjw@sisk.plpavel"@ucw.cz
Cc: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 02/14] freezer: fix a race during freezing of TASK_STOPPED tasks
Date: Fri, 26 Nov 2010 11:49:17 +0100
Message-Id: <1290768569-16224-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290768569-16224-1-git-send-email-tj@kernel.org>
References: <1290768569-16224-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 10:49:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After calling freeze_task(), try_to_freeze_tasks() see whether the
task is stopped or traced and if so, considers it to be frozen;
however, nothing guarantees that either the task being frozen sees
TIF_FREEZE or the freezer sees TASK_STOPPED -> TASK_RUNNING
transition.  The task being frozen may wake up and not see TIF_FREEZE
while the freezer fails to notice the transition and believes the task
is still stopped.

This patch fixes the race by making freeze_task() always go through
fake_signal_wake_up() for applicable tasks.  The function goes through
the target task's scheduler lock and thus guarantees that either the
target sees TIF_FREEZE or try_to_freeze_task() sees TASK_RUNNING.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/freezer.c       |    9 +++++++--
 kernel/power/process.c |    6 ++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index bd1d42b..66ecd2e 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -104,8 +104,13 @@ bool freeze_task(struct task_struct *p, bool sig_only)
 	}
 
 	if (should_send_signal(p)) {
-		if (!signal_pending(p))
-			fake_signal_wake_up(p);
+		fake_signal_wake_up(p);
+		/*
+		 * fake_signal_wake_up() goes through p's scheduler
+		 * lock and guarantees that TASK_STOPPED/TRACED ->
+		 * TASK_RUNNING transition can't race with task state
+		 * testing in try_to_freeze_tasks().
+		 */
 	} else if (sig_only) {
 		return false;
 	} else {
diff --git a/kernel/power/process.c b/kernel/power/process.c
index e50b4c1..eb2c88a 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -64,6 +64,12 @@ static int try_to_freeze_tasks(bool sig_only)
 			 * perturb a task in TASK_STOPPED or TASK_TRACED.
 			 * It is "frozen enough".  If the task does wake
 			 * up, it will immediately call try_to_freeze.
+			 *
+			 * Because freeze_task() goes through p's
+			 * scheduler lock after setting TIF_FREEZE, it's
+			 * guaranteed that either we see TASK_RUNNING or
+			 * try_to_stop() after schedule() in ptrace/signal
+			 * stop sees TIF_FREEZE.
 			 */
 			if (!task_is_stopped_or_traced(p) &&
 			    !freezer_should_skip(p))
-- 
1.7.1

