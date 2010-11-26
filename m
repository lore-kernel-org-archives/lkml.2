Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab0KZKvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 05:51:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:42321 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899Ab0KZKu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 05:50:26 -0500
From: Tejun Heo <tj@kernel.org>
To: roland@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        "rjw@sisk.plpavel"@ucw.cz
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/14] signal: don't notify parent if not stopping after tracehook_notify_jctl() in do_signal_stop()
Date: Fri, 26 Nov 2010 11:49:19 +0100
Message-Id: <1290768569-16224-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290768569-16224-1-git-send-email-tj@kernel.org>
References: <1290768569-16224-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 10:49:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_signal_stop() tests sig->group_stop_count one more time after
calling tracehook_notify_jctl() as it's allowed release siglock.  If
group_stop_count has changed to zero, it no longer stops but still
notifies the parent.  For both SIGCONT and KILL which could cause the
condition, this notification is unnecessary.

SIGCONT will be notified to the parent when the task calls
get_signal_to_deliver() right after returning from do_signal_stop()
which will handle the collapsed notification correctly by itself.  The
notification from do_signal_stop() in this case would only cause
duplication.  For SIGKILL, the imminent death of the task will be
notified to parent and it's completely superflous to report the
skipped stop.

Also, tracehook_notify_jctl() doesn't release siglock, so, currently,
none of these matters at all.

This patch updates do_signal_stop() such that it jumps out of the
function if group_stop_count has dropped during
tracehook_notify_jctl().

This doesn't cause any behavior difference as the condition never
triggers in the current code.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---
 kernel/signal.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 0a6816a..6f7407d 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1763,15 +1763,20 @@ static int do_signal_stop(int signr)
 	notify = tracehook_notify_jctl(notify, CLD_STOPPED);
 	/*
 	 * tracehook_notify_jctl() can drop and reacquire siglock, so
-	 * we keep ->group_stop_count != 0 before the call. If SIGCONT
-	 * or SIGKILL comes in between ->group_stop_count == 0.
+	 * we test ->group_stop_count again.  If SIGCONT or SIGKILL
+	 * comes in between, ->group_stop_count == 0.
 	 */
-	if (sig->group_stop_count) {
-		if (!--sig->group_stop_count)
-			sig->flags = SIGNAL_STOP_STOPPED;
-		current->exit_code = sig->group_exit_code;
-		__set_current_state(TASK_STOPPED);
+	if (!sig->group_stop_count) {
+		spin_unlock_irq(&current->sighand->siglock);
+		goto out;
 	}
+
+	if (!--sig->group_stop_count)
+		sig->flags = SIGNAL_STOP_STOPPED;
+
+	current->exit_code = sig->group_exit_code;
+	__set_current_state(TASK_STOPPED);
+
 	spin_unlock_irq(&current->sighand->siglock);
 
 	if (notify) {
@@ -1782,7 +1787,7 @@ static int do_signal_stop(int signr)
 
 	/* Now we don't run again until woken by SIGCONT or SIGKILL */
 	schedule();
-
+out:
 	tracehook_finish_jctl();
 	current->exit_code = 0;
 
-- 
1.7.1

