Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab0HYPx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 11:53:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:52822 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab0HYPx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 11:53:56 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        jeremy@goop.org, snitzer@redhat.com, k-ueda@ct.jp.nec.com
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 21/30] gfs2: replace barriers with explicit flush / FUA usage
Date: Wed, 25 Aug 2010 17:47:38 +0200
Message-Id: <1282751267-3530-22-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1282751267-3530-1-git-send-email-tj@kernel.org>
References: <1282751267-3530-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 25 Aug 2010 15:53:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

Switch to the WRITE_FLUSH_FUA flag for log writes, remove the EOPNOTSUPP
detection for barriers and stop setting the barrier flag for discards.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Steven Whitehouse <swhiteho@redhat.com>
Acked-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/gfs2/log.c  |   19 +++++--------------
 fs/gfs2/rgrp.c |    5 ++---
 2 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index cde1248..9c65170 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -592,22 +592,13 @@ static void log_write_header(struct gfs2_sbd *sdp, u32 flags, int pull)
 	lh->lh_hash = cpu_to_be32(hash);
 
 	bh->b_end_io = end_buffer_write_sync;
-	if (test_bit(SDF_NOBARRIERS, &sdp->sd_flags))
-		goto skip_barrier;
 	get_bh(bh);
-	submit_bh(WRITE_BARRIER | REQ_META, bh);
-	wait_on_buffer(bh);
-	if (buffer_eopnotsupp(bh)) {
-		clear_buffer_eopnotsupp(bh);
-		set_buffer_uptodate(bh);
-		fs_info(sdp, "barrier sync failed - disabling barriers\n");
-		set_bit(SDF_NOBARRIERS, &sdp->sd_flags);
-		lock_buffer(bh);
-skip_barrier:
-		get_bh(bh);
+	if (test_bit(SDF_NOBARRIERS, &sdp->sd_flags))
 		submit_bh(WRITE_SYNC | REQ_META, bh);
-		wait_on_buffer(bh);
-	}
+	else
+		submit_bh(WRITE_FLUSH_FUA | REQ_META, bh);
+	wait_on_buffer(bh);
+
 	if (!buffer_uptodate(bh))
 		gfs2_io_error_bh(sdp, bh);
 	brelse(bh);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 171a744..3793164 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -854,8 +854,7 @@ static void gfs2_rgrp_send_discards(struct gfs2_sbd *sdp, u64 offset,
 				if ((start + nr_sects) != blk) {
 					rv = blkdev_issue_discard(bdev, start,
 							    nr_sects, GFP_NOFS,
-							    BLKDEV_IFL_WAIT |
-							    BLKDEV_IFL_BARRIER);
+							    BLKDEV_IFL_WAIT);
 					if (rv)
 						goto fail;
 					nr_sects = 0;
@@ -870,7 +869,7 @@ start_new_extent:
 	}
 	if (nr_sects) {
 		rv = blkdev_issue_discard(bdev, start, nr_sects, GFP_NOFS,
-					 BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
+					 BLKDEV_IFL_WAIT);
 		if (rv)
 			goto fail;
 	}
-- 
1.7.1

