Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab2HGJ7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:59:39 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:57102 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab2HGJ7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:59:37 -0400
X-Greylist: delayed 464 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Aug 2012 05:59:37 EDT
X-DKIM: OpenDKIM Filter v2.4.1 mail.betterlinux.com 42CB082073
From: Andrea Righi <andrea@betterlinux.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] audit: fix wrong timeout value in audit_log_start
Date: Tue,  7 Aug 2012 11:51:42 +0200
Message-Id: <1344333102-8419-1-git-send-email-andrea@betterlinux.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

audit_log_start() does not properly check timeout values when
audit_backlog_limit is exceeded, for example it is possible to use
negative timeout values with schedule_timeout() triggering error
messages like this:

  schedule_timeout: wrong timeout value ffffffffffff54e4

Be sure to never set negative values for the timeout.

Also, do a small refactoring to improve code readability.

Reported-by: Sean Jenkins <sean@bluehost.com>
Signed-off-by: Andrea Righi <andrea@betterlinux.com>
---
 kernel/audit.c |   46 ++++++++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index ea3b7b6..362d9b4 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1123,6 +1123,28 @@ static inline void audit_get_stamp(struct audit_context *ctx,
 	}
 }
 
+/* Wait for auditd to drain the queue a little */
+static void audit_log_congestion_wait(unsigned long timeout_start)
+{
+	DECLARE_WAITQUEUE(wait, current);
+
+	set_current_state(TASK_INTERRUPTIBLE);
+	add_wait_queue(&audit_backlog_wait, &wait);
+
+	if (audit_backlog_limit &&
+	    skb_queue_len(&audit_skb_queue) > audit_backlog_limit) {
+		unsigned long deadline, now = ACCESS_ONCE(jiffies);
+
+		WARN_ON(time_after(timeout_start, now));
+		deadline = timeout_start + audit_backlog_wait_time;
+		if (time_before(now, deadline))
+			schedule_timeout(deadline - now);
+	}
+
+	__set_current_state(TASK_RUNNING);
+	remove_wait_queue(&audit_backlog_wait, &wait);
+}
+
 /* Obtain an audit buffer.  This routine does locking to obtain the
  * audit buffer, but then no locking is required for calls to
  * audit_log_*format.  If the tsk is a task that is currently in a
@@ -1166,22 +1188,14 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 		reserve = 5; /* Allow atomic callers to go up to five
 				entries over the normal backlog limit */
 
-	while (audit_backlog_limit
-	       && skb_queue_len(&audit_skb_queue) > audit_backlog_limit + reserve) {
-		if (gfp_mask & __GFP_WAIT && audit_backlog_wait_time
-		    && time_before(jiffies, timeout_start + audit_backlog_wait_time)) {
-
-			/* Wait for auditd to drain the queue a little */
-			DECLARE_WAITQUEUE(wait, current);
-			set_current_state(TASK_INTERRUPTIBLE);
-			add_wait_queue(&audit_backlog_wait, &wait);
-
-			if (audit_backlog_limit &&
-			    skb_queue_len(&audit_skb_queue) > audit_backlog_limit)
-				schedule_timeout(timeout_start + audit_backlog_wait_time - jiffies);
-
-			__set_current_state(TASK_RUNNING);
-			remove_wait_queue(&audit_backlog_wait, &wait);
+	while (audit_backlog_limit &&
+	       skb_queue_len(&audit_skb_queue) >
+				audit_backlog_limit + reserve) {
+		if ((gfp_mask & __GFP_WAIT) &&
+		    audit_backlog_wait_time &&
+		    time_is_after_jiffies(timeout_start +
+					audit_backlog_wait_time)) {
+			audit_log_congestion_wait(timeout_start);
 			continue;
 		}
 		if (audit_rate_check() && printk_ratelimit())
-- 
1.7.9.5

