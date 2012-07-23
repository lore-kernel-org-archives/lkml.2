Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab2GWSSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 14:18:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557Ab2GWSRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 14:17:53 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] dlm: use wait_event_timeout
Date: Mon, 23 Jul 2012 13:17:45 -0500
Message-Id: <1343067467-24308-5-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use wait_event_timeout to avoid using a timer
directly.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/recover.c |   29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/fs/dlm/recover.c b/fs/dlm/recover.c
index ff6f276..12702cc 100644
--- a/fs/dlm/recover.c
+++ b/fs/dlm/recover.c
@@ -36,30 +36,23 @@
  * (LS_RECOVERY_STOP set due to failure of a node in ls_nodes).  When another
  * function thinks it could have completed the waited-on task, they should wake
  * up ls_wait_general to get an immediate response rather than waiting for the
- * timer to detect the result.  A timer wakes us up periodically while waiting
- * to see if we should abort due to a node failure.  This should only be called
- * by the dlm_recoverd thread.
+ * timeout.  This uses a timeout so it can check periodically if the wait
+ * should abort due to node failure (which doesn't cause a wake_up).
+ * This should only be called by the dlm_recoverd thread.
  */
 
-static void dlm_wait_timer_fn(unsigned long data)
-{
-	struct dlm_ls *ls = (struct dlm_ls *) data;
-	mod_timer(&ls->ls_timer, jiffies + (dlm_config.ci_recover_timer * HZ));
-	wake_up(&ls->ls_wait_general);
-}
-
 int dlm_wait_function(struct dlm_ls *ls, int (*testfn) (struct dlm_ls *ls))
 {
 	int error = 0;
+	int rv;
 
-	init_timer(&ls->ls_timer);
-	ls->ls_timer.function = dlm_wait_timer_fn;
-	ls->ls_timer.data = (long) ls;
-	ls->ls_timer.expires = jiffies + (dlm_config.ci_recover_timer * HZ);
-	add_timer(&ls->ls_timer);
-
-	wait_event(ls->ls_wait_general, testfn(ls) || dlm_recovery_stopped(ls));
-	del_timer_sync(&ls->ls_timer);
+	while (1) {
+		rv = wait_event_timeout(ls->ls_wait_general,
+					testfn(ls) || dlm_recovery_stopped(ls),
+					dlm_config.ci_recover_timer * HZ);
+		if (rv)
+			break;
+	}
 
 	if (dlm_recovery_stopped(ls)) {
 		log_debug(ls, "dlm_wait_function aborted");
-- 
1.7.10.1.362.g242cab3

