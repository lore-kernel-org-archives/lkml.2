Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297Ab2EUVUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:20:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759160Ab2EUVSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:18:45 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] dlm: limit rcom debug messages
Date: Mon, 21 May 2012 16:18:35 -0500
Message-Id: <1337635120-19969-4-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unify the checking for both types of ignored
rcom messages, and replace the two log_debug
statements with a single, rate limited debug
message.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/dlm_internal.h |    8 ++++++++
 fs/dlm/rcom.c         |   48 ++++++++++++++++++++----------------------------
 2 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 3a564d1..0e74832 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -38,6 +38,7 @@
 #include <linux/miscdevice.h>
 #include <linux/mutex.h>
 #include <linux/idr.h>
+#include <linux/ratelimit.h>
 #include <asm/uaccess.h>
 
 #include <linux/dlm.h>
@@ -74,6 +75,13 @@ do { \
 		       (ls)->ls_name , ##args); \
 } while (0)
 
+#define log_limit(ls, fmt, args...) \
+do { \
+	if (dlm_config.ci_log_debug) \
+		printk_ratelimited(KERN_DEBUG "dlm: %s: " fmt "\n", \
+			(ls)->ls_name , ##args); \
+} while (0)
+
 #define DLM_ASSERT(x, do) \
 { \
   if (!(x)) \
diff --git a/fs/dlm/rcom.c b/fs/dlm/rcom.c
index ac5c616..6565fd5 100644
--- a/fs/dlm/rcom.c
+++ b/fs/dlm/rcom.c
@@ -486,47 +486,39 @@ int dlm_send_ls_not_ready(int nodeid, struct dlm_rcom *rc_in)
 	return 0;
 }
 
-static int is_old_reply(struct dlm_ls *ls, struct dlm_rcom *rc)
+/* Called by dlm_recv; corresponds to dlm_receive_message() but special
+   recovery-only comms are sent through here. */
+
+void dlm_receive_rcom(struct dlm_ls *ls, struct dlm_rcom *rc, int nodeid)
 {
+	int lock_size = sizeof(struct dlm_rcom) + sizeof(struct rcom_lock);
+	int stop, reply = 0;
 	uint64_t seq;
-	int rv = 0;
 
 	switch (rc->rc_type) {
 	case DLM_RCOM_STATUS_REPLY:
 	case DLM_RCOM_NAMES_REPLY:
 	case DLM_RCOM_LOOKUP_REPLY:
 	case DLM_RCOM_LOCK_REPLY:
-		spin_lock(&ls->ls_recover_lock);
-		seq = ls->ls_recover_seq;
-		spin_unlock(&ls->ls_recover_lock);
-		if (rc->rc_seq_reply != seq) {
-			log_debug(ls, "ignoring old reply %x from %d "
-				      "seq_reply %llx expect %llx",
-				      rc->rc_type, rc->rc_header.h_nodeid,
-				      (unsigned long long)rc->rc_seq_reply,
-				      (unsigned long long)seq);
-			rv = 1;
-		}
-	}
-	return rv;
-}
+		reply = 1;
+	};
 
-/* Called by dlm_recv; corresponds to dlm_receive_message() but special
-   recovery-only comms are sent through here. */
-
-void dlm_receive_rcom(struct dlm_ls *ls, struct dlm_rcom *rc, int nodeid)
-{
-	int lock_size = sizeof(struct dlm_rcom) + sizeof(struct rcom_lock);
+	spin_lock(&ls->ls_recover_lock);
+	stop = test_bit(LSFL_RECOVERY_STOP, &ls->ls_flags);
+	seq = ls->ls_recover_seq;
+	spin_unlock(&ls->ls_recover_lock);
 
-	if (dlm_recovery_stopped(ls) && (rc->rc_type != DLM_RCOM_STATUS)) {
-		log_debug(ls, "ignoring recovery message %x from %d",
-			  rc->rc_type, nodeid);
+	if ((stop && (rc->rc_type != DLM_RCOM_STATUS)) ||
+	    (reply && (rc->rc_seq_reply != seq))) {
+		log_limit(ls, "dlm_receive_rcom ignore msg %d "
+			  "from %d %llu %llu seq %llu",
+			   rc->rc_type, nodeid,
+			   (unsigned long long)rc->rc_seq,
+			   (unsigned long long)rc->rc_seq_reply,
+			   (unsigned long long)seq);
 		goto out;
 	}
 
-	if (is_old_reply(ls, rc))
-		goto out;
-
 	switch (rc->rc_type) {
 	case DLM_RCOM_STATUS:
 		receive_rcom_status(ls, rc);
-- 
1.7.10.1.362.g242cab3

