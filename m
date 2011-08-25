Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab1HYPKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:10:19 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33138 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab1HYPKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:10:16 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 105/118] drbd: Renamed is_valid_state_transition() to is_valid_soft_transition()
Date: Thu, 25 Aug 2011 17:08:41 +0200
Message-Id: <1314284934-17999-106-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And removed the unused mdev parameter, and made the order of
the state parameters: os, ns

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_state.c |   26 ++++++++++----------------
 1 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 18feba6..d577715 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -45,6 +45,10 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 			   union drbd_state ns, enum chg_state_flags flags);
 static void after_conn_state_ch(struct drbd_tconn *tconn, union drbd_state os,
 				union drbd_state ns, enum chg_state_flags flags);
+static enum drbd_state_rv is_valid_state(struct drbd_conf *, union drbd_state);
+static enum drbd_state_rv is_valid_soft_transition(union drbd_state, union drbd_state);
+static union drbd_state sanitize_state(struct drbd_conf *mdev, union drbd_state os,
+				       union drbd_state ns, const char **warn_sync_abort);
 
 /**
  * cl_wide_st_chg() - true if the state change is a cluster wide one
@@ -94,15 +98,6 @@ void drbd_force_state(struct drbd_conf *mdev,
 	drbd_change_state(mdev, CS_HARD, mask, val);
 }
 
-static enum drbd_state_rv is_valid_state(struct drbd_conf *, union drbd_state);
-static enum drbd_state_rv is_valid_state_transition(struct drbd_conf *,
-						    union drbd_state,
-						    union drbd_state);
-static union drbd_state sanitize_state(struct drbd_conf *mdev, union drbd_state os,
-				       union drbd_state ns, const char **warn_sync_abort);
-int drbd_send_state_req(struct drbd_conf *,
-			union drbd_state, union drbd_state);
-
 static enum drbd_state_rv
 _req_st_cond(struct drbd_conf *mdev, union drbd_state mask,
 	     union drbd_state val)
@@ -128,7 +123,7 @@ _req_st_cond(struct drbd_conf *mdev, union drbd_state mask,
 	if (!rv) {
 		rv = is_valid_state(mdev, ns);
 		if (rv == SS_SUCCESS) {
-			rv = is_valid_state_transition(mdev, ns, os);
+			rv = is_valid_soft_transition(os, ns);
 			if (rv == SS_SUCCESS)
 				rv = SS_UNKNOWN_ERROR; /* cont waiting, otherwise fail. */
 		}
@@ -171,7 +166,7 @@ drbd_req_state(struct drbd_conf *mdev, union drbd_state mask,
 	if (cl_wide_st_chg(mdev, os, ns)) {
 		rv = is_valid_state(mdev, ns);
 		if (rv == SS_SUCCESS)
-			rv = is_valid_state_transition(mdev, ns, os);
+			rv = is_valid_soft_transition(os, ns);
 		spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
 
 		if (rv < SS_SUCCESS) {
@@ -344,14 +339,13 @@ is_valid_state(struct drbd_conf *mdev, union drbd_state ns)
 }
 
 /**
- * is_valid_state_transition() - Returns an SS_ error code if the state transition is not possible
+ * is_valid_soft_transition() - Returns an SS_ error code if the state transition is not possible
  * @mdev:	DRBD device.
  * @ns:		new state.
  * @os:		old state.
  */
 static enum drbd_state_rv
-is_valid_state_transition(struct drbd_conf *mdev, union drbd_state ns,
-			  union drbd_state os)
+is_valid_soft_transition(union drbd_state os, union drbd_state ns)
 {
 	enum drbd_state_rv rv = SS_SUCCESS;
 
@@ -657,9 +651,9 @@ __drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
 			   this happen...*/
 
 			if (is_valid_state(mdev, os) == rv)
-				rv = is_valid_state_transition(mdev, ns, os);
+				rv = is_valid_soft_transition(os, ns);
 		} else
-			rv = is_valid_state_transition(mdev, ns, os);
+			rv = is_valid_soft_transition(os, ns);
 	}
 
 	if (rv < SS_SUCCESS) {
-- 
1.7.4.1

