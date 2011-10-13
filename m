Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab1JMKec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 06:34:32 -0400
Received: from mail09.linbit.com ([212.69.161.110]:58084 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab1JMKcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 06:32:19 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 03/10] drbd: Fixes from the 8.3 development branch
Date: Thu, 13 Oct 2011 12:32:09 +0200
Message-Id: <1318501936-11689-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318501936-11689-1-git-send-email-philipp.reisner@linbit.com>
References: <1318501936-11689-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 * commit 'ae57a0a':
   drbd: Only print sanitize state's warnings, if the state change happens
   drbd: we should write meta data updates with FLUSH FUA
   drbd: fix limit define, we support 1 PiByte now
   drbd: fix log message argument order
   drbd: Typo in user-visible message.
   drbd: Make "(rcv|snd)buf-size" and "ping-timeout" available for the proxy, too.
   drbd: Allow keywords to be used in multiple config sections.
   drbd: fix typos in comments.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h   |   10 +++---
 drivers/block/drbd/drbd_state.c |   56 ++++++++++++++++++++++++++++----------
 include/linux/drbd_limits.h     |    2 +-
 3 files changed, 47 insertions(+), 21 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index de42c7c..1d71b3a 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -372,11 +372,11 @@ struct p_connection_features {
 	u32 protocol_max;
 
 	/* should be more than enough for future enhancements
-	 * for now, feature_flags and the reserverd array shall be zero.
+	 * for now, feature_flags and the reserved array shall be zero.
 	 */
 
 	u32 _pad;
-	u64 reserverd[7];
+	u64 reserved[7];
 } __packed;
 
 struct p_barrier {
@@ -914,7 +914,7 @@ struct drbd_conf {
 	atomic_t ap_bio_cnt;	 /* Requests we need to complete */
 	atomic_t ap_pending_cnt; /* AP data packets on the wire, ack expected */
 	atomic_t rs_pending_cnt; /* RS request/data packets on the wire */
-	atomic_t unacked_cnt;	 /* Need to send replys for */
+	atomic_t unacked_cnt;	 /* Need to send replies for */
 	atomic_t local_cnt;	 /* Waiting for local completion */
 
 	/* Interval tree of pending local requests */
@@ -2153,7 +2153,7 @@ static inline int drbd_state_is_stable(struct drbd_conf *mdev)
 		/* disk state is stable as well. */
 		break;
 
-	/* no new io accepted during tansitional states */
+	/* no new io accepted during transitional states */
 	case D_ATTACHING:
 	case D_FAILED:
 	case D_NEGOTIATING:
@@ -2217,7 +2217,7 @@ static inline void inc_ap_bio(struct drbd_conf *mdev)
 	/* we wait here
 	 *    as long as the device is suspended
 	 *    until the bitmap is no longer on the fly during connection
-	 *    handshake as long as we would exeed the max_buffer limit.
+	 *    handshake as long as we would exceed the max_buffer limit.
 	 *
 	 * to avoid races with the reconnect code,
 	 * we need to atomic_inc within the spinlock. */
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 1be92e5..3221743 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -37,6 +37,15 @@ struct after_state_chg_work {
 	struct completion *done;
 };
 
+enum sanitize_state_warnings {
+	NO_WARNING,
+	ABORTED_ONLINE_VERIFY,
+	ABORTED_RESYNC,
+	CONNECTION_LOST_NEGOTIATING,
+	IMPLICITLY_UPGRADED_DISK,
+	IMPLICITLY_UPGRADED_PDSK,
+};
+
 static int w_after_state_ch(struct drbd_work *w, int unused);
 static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 			   union drbd_state ns, enum chg_state_flags flags);
@@ -44,7 +53,7 @@ static enum drbd_state_rv is_valid_state(struct drbd_conf *, union drbd_state);
 static enum drbd_state_rv is_valid_soft_transition(union drbd_state, union drbd_state);
 static enum drbd_state_rv is_valid_transition(union drbd_state os, union drbd_state ns);
 static union drbd_state sanitize_state(struct drbd_conf *mdev, union drbd_state ns,
-				       const char **warn_sync_abort);
+				       enum sanitize_state_warnings *warn);
 
 static inline bool is_susp(union drbd_state s)
 {
@@ -656,6 +665,21 @@ is_valid_transition(union drbd_state os, union drbd_state ns)
 	return rv;
 }
 
+static void print_sanitize_warnings(struct drbd_conf *mdev, enum sanitize_state_warnings warn)
+{
+	static const char *msg_table[] = {
+		[NO_WARNING] = "",
+		[ABORTED_ONLINE_VERIFY] = "Online-verify aborted.",
+		[ABORTED_RESYNC] = "Resync aborted.",
+		[CONNECTION_LOST_NEGOTIATING] = "Connection lost while negotiating, no data!",
+		[IMPLICITLY_UPGRADED_DISK] = "Implicitly upgraded disk",
+		[IMPLICITLY_UPGRADED_PDSK] = "Implicitly upgraded pdsk",
+	};
+
+	if (warn != NO_WARNING)
+		dev_warn(DEV, "%s\n", msg_table[warn]);
+}
+
 /**
  * sanitize_state() - Resolves implicitly necessary additional changes to a state transition
  * @mdev:	DRBD device.
@@ -667,11 +691,14 @@ is_valid_transition(union drbd_state os, union drbd_state ns)
  * to D_UNKNOWN. This rule and many more along those lines are in this function.
  */
 static union drbd_state sanitize_state(struct drbd_conf *mdev, union drbd_state ns,
-				       const char **warn_sync_abort)
+				       enum sanitize_state_warnings *warn)
 {
 	enum drbd_fencing_p fp;
 	enum drbd_disk_state disk_min, disk_max, pdsk_min, pdsk_max;
 
+	if (warn)
+		*warn = NO_WARNING;
+
 	fp = FP_DONT_CARE;
 	if (get_ldev(mdev)) {
 		rcu_read_lock();
@@ -695,10 +722,9 @@ static union drbd_state sanitize_state(struct drbd_conf *mdev, union drbd_state
 	/* An implication of the disk states onto the connection state */
 	/* Abort resync if a disk fails/detaches */
 	if (ns.conn > C_CONNECTED && (ns.disk <= D_FAILED || ns.pdsk <= D_FAILED)) {
-		if (warn_sync_abort)
-			*warn_sync_abort =
-				ns.conn == C_VERIFY_S || ns.conn == C_VERIFY_T ?
-				"Online-verify" : "Resync";
+		if (warn)
+			*warn = ns.conn == C_VERIFY_S || ns.conn == C_VERIFY_T ?
+				ABORTED_ONLINE_VERIFY : ABORTED_RESYNC;
 		ns.conn = C_CONNECTED;
 	}
 
@@ -709,7 +735,8 @@ static union drbd_state sanitize_state(struct drbd_conf *mdev, union drbd_state
 			ns.disk = mdev->new_state_tmp.disk;
 			ns.pdsk = mdev->new_state_tmp.pdsk;
 		} else {
-			dev_alert(DEV, "Connection lost while negotiating, no data!\n");
+			if (warn)
+				*warn = CONNECTION_LOST_NEGOTIATING;
 			ns.disk = D_DISKLESS;
 			ns.pdsk = D_UNKNOWN;
 		}
@@ -791,16 +818,16 @@ static union drbd_state sanitize_state(struct drbd_conf *mdev, union drbd_state
 		ns.disk = disk_max;
 
 	if (ns.disk < disk_min) {
-		dev_warn(DEV, "Implicitly set disk from %s to %s\n",
-			 drbd_disk_str(ns.disk), drbd_disk_str(disk_min));
+		if (warn)
+			*warn = IMPLICITLY_UPGRADED_DISK;
 		ns.disk = disk_min;
 	}
 	if (ns.pdsk > pdsk_max)
 		ns.pdsk = pdsk_max;
 
 	if (ns.pdsk < pdsk_min) {
-		dev_warn(DEV, "Implicitly set pdsk from %s to %s\n",
-			 drbd_disk_str(ns.pdsk), drbd_disk_str(pdsk_min));
+		if (warn)
+			*warn = IMPLICITLY_UPGRADED_PDSK;
 		ns.pdsk = pdsk_min;
 	}
 
@@ -875,12 +902,12 @@ __drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
 {
 	union drbd_state os;
 	enum drbd_state_rv rv = SS_SUCCESS;
-	const char *warn_sync_abort = NULL;
+	enum sanitize_state_warnings ssw;
 	struct after_state_chg_work *ascw;
 
 	os = drbd_read_state(mdev);
 
-	ns = sanitize_state(mdev, ns, &warn_sync_abort);
+	ns = sanitize_state(mdev, ns, &ssw);
 	if (ns.i == os.i)
 		return SS_NOTHING_TO_DO;
 
@@ -909,8 +936,7 @@ __drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
 		return rv;
 	}
 
-	if (warn_sync_abort)
-		dev_warn(DEV, "%s aborted.\n", warn_sync_abort);
+	print_sanitize_warnings(mdev, ssw);
 
 	drbd_pr_state_change(mdev, os, ns, flags);
 
diff --git a/include/linux/drbd_limits.h b/include/linux/drbd_limits.h
index f74334d..cd51207 100644
--- a/include/linux/drbd_limits.h
+++ b/include/linux/drbd_limits.h
@@ -126,7 +126,7 @@
  * is 1 PiB, currently. */
 /* DRBD_MAX_SECTORS */
 #define DRBD_DISK_SIZE_MIN  0
-#define DRBD_DISK_SIZE_MAX  (16 * (2LLU << 30))
+#define DRBD_DISK_SIZE_MAX  (1 * (2LLU << 40))
 #define DRBD_DISK_SIZE_DEF  0 /* = disabled = no user size... */
 #define DRBD_DISK_SIZE_SCALE 's'  /* sectors */
 
-- 
1.7.4.1

