Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab1HYPVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:21:33 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33400 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab1HYPJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:44 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 072/118] drbd: Moved DISCARD_CONCURRENT to the per connection (tconn) flags
Date: Thu, 25 Aug 2011 17:08:08 +0200
Message-Id: <1314284934-17999-73-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    2 +-
 drivers/block/drbd/drbd_nl.c       |    2 +-
 drivers/block/drbd/drbd_receiver.c |   14 +++++++-------
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index b325b0a..a88bf7c 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -762,7 +762,6 @@ enum {
 	UNPLUG_QUEUED,		/* only relevant with kernel 2.4 */
 	UNPLUG_REMOTE,		/* sending a "UnplugRemote" could help */
 	MD_DIRTY,		/* current uuids and flags not yet on disk */
-	DISCARD_CONCURRENT,	/* Set on one node, cleared on the peer! */
 	USE_DEGR_WFC_T,		/* degr-wfc-timeout instead of wfc-timeout. */
 	CLUSTER_ST_CHANGE,	/* Cluster wide state change going on... */
 	CL_ST_CHG_SUCCESS,
@@ -910,6 +909,7 @@ struct fifo_buffer {
 /* flag bits per tconn */
 enum {
 	NET_CONGESTED,		/* The data socket is congested */
+	DISCARD_CONCURRENT,	/* Set on one node, cleared on the peer! */
 };
 
 struct drbd_tconn {			/* is a resource from the config file */
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index e30d52b..fda399a 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1637,7 +1637,7 @@ void resync_after_online_grow(struct drbd_conf *mdev)
 	if (mdev->state.role != mdev->state.peer)
 		iass = (mdev->state.role == R_PRIMARY);
 	else
-		iass = test_bit(DISCARD_CONCURRENT, &mdev->flags);
+		iass = test_bit(DISCARD_CONCURRENT, &mdev->tconn->flags);
 
 	if (iass)
 		drbd_start_resync(mdev, C_SYNC_SOURCE);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 83066a3..cb45a3c 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -762,7 +762,7 @@ static int drbd_connect(struct drbd_conf *mdev)
 	if (drbd_request_state(mdev, NS(conn, C_WF_CONNECTION)) < SS_SUCCESS)
 		return -2;
 
-	clear_bit(DISCARD_CONCURRENT, &mdev->flags);
+	clear_bit(DISCARD_CONCURRENT, &mdev->tconn->flags);
 	mdev->tconn->agreed_pro_version = 99;
 	/* agreed_pro_version must be smaller than 100 so we send the old
 	   header (h80) in the first packet and in the handshake packet. */
@@ -823,7 +823,7 @@ retry:
 					sock_release(msock);
 				}
 				msock = s;
-				set_bit(DISCARD_CONCURRENT, &mdev->flags);
+				set_bit(DISCARD_CONCURRENT, &mdev->tconn->flags);
 				break;
 			default:
 				dev_warn(DEV, "Error receiving initial packet\n");
@@ -1783,7 +1783,7 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 		/* don't get the req_lock yet,
 		 * we may sleep in drbd_wait_peer_seq */
 		const int size = peer_req->i.size;
-		const int discard = test_bit(DISCARD_CONCURRENT, &mdev->flags);
+		const int discard = test_bit(DISCARD_CONCURRENT, &mdev->tconn->flags);
 		DEFINE_WAIT(wait);
 		int first;
 
@@ -2243,7 +2243,7 @@ static int drbd_asb_recover_0p(struct drbd_conf *mdev) __must_hold(local)
 		     "Using discard-least-changes instead\n");
 	case ASB_DISCARD_ZERO_CHG:
 		if (ch_peer == 0 && ch_self == 0) {
-			rv = test_bit(DISCARD_CONCURRENT, &mdev->flags)
+			rv = test_bit(DISCARD_CONCURRENT, &mdev->tconn->flags)
 				? -1 : 1;
 			break;
 		} else {
@@ -2259,7 +2259,7 @@ static int drbd_asb_recover_0p(struct drbd_conf *mdev) __must_hold(local)
 			rv =  1;
 		else /* ( ch_self == ch_peer ) */
 		     /* Well, then use something else. */
-			rv = test_bit(DISCARD_CONCURRENT, &mdev->flags)
+			rv = test_bit(DISCARD_CONCURRENT, &mdev->tconn->flags)
 				? -1 : 1;
 		break;
 	case ASB_DISCARD_LOCAL:
@@ -2472,7 +2472,7 @@ static int drbd_uuid_compare(struct drbd_conf *mdev, int *rule_nr) __must_hold(l
 		case 1: /*  self_pri && !peer_pri */ return 1;
 		case 2: /* !self_pri &&  peer_pri */ return -1;
 		case 3: /*  self_pri &&  peer_pri */
-			dc = test_bit(DISCARD_CONCURRENT, &mdev->flags);
+			dc = test_bit(DISCARD_CONCURRENT, &mdev->tconn->flags);
 			return dc ? -1 : 1;
 		}
 	}
@@ -3213,7 +3213,7 @@ static int receive_req_state(struct drbd_conf *mdev, enum drbd_packet cmd,
 	mask.i = be32_to_cpu(p->mask);
 	val.i = be32_to_cpu(p->val);
 
-	if (test_bit(DISCARD_CONCURRENT, &mdev->flags) &&
+	if (test_bit(DISCARD_CONCURRENT, &mdev->tconn->flags) &&
 	    test_bit(CLUSTER_ST_CHANGE, &mdev->flags)) {
 		drbd_send_sr_reply(mdev, SS_CONCURRENT_ST_CHG);
 		return true;
-- 
1.7.4.1

