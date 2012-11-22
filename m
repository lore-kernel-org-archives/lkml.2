Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab2KVVRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:17:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:49627 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755272Ab2KVSks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Josh Durgin <josh.durgin@dreamhost.com>,
        Alex Elder <elder@dreamhost.com>,
        Yehuda Sadeh <yehuda@hq.newdream.net>
Subject: [ 090/171] rbd: store snapshot id instead of index
Date: Wed, 21 Nov 2012 16:40:36 -0800
Message-Id: <20121122004042.388435941@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Durgin <josh.durgin@dreamhost.com>

(cherry picked from commit 77dfe99fe3cb0b2b0545e19e2d57b7a9134ee3c0)

When a device was open at a snapshot, and snapshots were deleted or
added, data from the wrong snapshot could be read. Instead of
assuming the snap context is constant, store the actual snap id when
the device is initialized, and rely on the OSDs to signal an error
if we try reading from a snapshot that was deleted.

Signed-off-by: Josh Durgin <josh.durgin@dreamhost.com>
Reviewed-by: Alex Elder <elder@dreamhost.com>
Reviewed-by: Yehuda Sadeh <yehuda@hq.newdream.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |   27 +++++----------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -175,8 +175,7 @@ struct rbd_device {
 	/* protects updating the header */
 	struct rw_semaphore     header_rwsem;
 	char                    snap_name[RBD_MAX_SNAP_NAME_LEN];
-	u32 cur_snap;	/* index+1 of current snapshot within snap context
-			   0 - for the head */
+	u64                     snap_id;	/* current snapshot id */
 	int read_only;
 
 	struct list_head	node;
@@ -552,21 +551,6 @@ err_snapc:
 	return -ENOMEM;
 }
 
-static int snap_index(struct rbd_image_header *header, int snap_num)
-{
-	return header->total_snaps - snap_num;
-}
-
-static u64 cur_snap_id(struct rbd_device *rbd_dev)
-{
-	struct rbd_image_header *header = &rbd_dev->header;
-
-	if (!rbd_dev->cur_snap)
-		return 0;
-
-	return header->snapc->snaps[snap_index(header, rbd_dev->cur_snap)];
-}
-
 static int snap_by_name(struct rbd_image_header *header, const char *snap_name,
 			u64 *seq, u64 *size)
 {
@@ -605,7 +589,7 @@ static int rbd_header_set_snap(struct rb
 			snapc->seq = header->snap_seq;
 		else
 			snapc->seq = 0;
-		dev->cur_snap = 0;
+		dev->snap_id = CEPH_NOSNAP;
 		dev->read_only = 0;
 		if (size)
 			*size = header->image_size;
@@ -613,8 +597,7 @@ static int rbd_header_set_snap(struct rb
 		ret = snap_by_name(header, dev->snap_name, &snapc->seq, size);
 		if (ret < 0)
 			goto done;
-
-		dev->cur_snap = header->total_snaps - ret;
+		dev->snap_id = snapc->seq;
 		dev->read_only = 1;
 	}
 
@@ -1521,7 +1504,7 @@ static void rbd_rq_fn(struct request_que
 					      coll, cur_seg);
 			else
 				rbd_req_read(rq, rbd_dev,
-					     cur_snap_id(rbd_dev),
+					     rbd_dev->snap_id,
 					     ofs,
 					     op_size, bio,
 					     coll, cur_seg);
@@ -1656,7 +1639,7 @@ static int rbd_header_add_snap(struct rb
 	struct ceph_mon_client *monc;
 
 	/* we should create a snapshot only if we're pointing at the head */
-	if (dev->cur_snap)
+	if (dev->snap_id != CEPH_NOSNAP)
 		return -EINVAL;
 
 	monc = &dev->rbd_client->client->monc;


