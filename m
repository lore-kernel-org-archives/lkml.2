Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab2AEMT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 07:19:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756638Ab2AEMQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 07:16:16 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 01/16] GFS2: Fix up REQ flags
Date: Thu,  5 Jan 2012 11:51:47 +0000
Message-Id: <1325764322-10807-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
References: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph has split up REQ_PRIO from REQ_META. That means that
we can drop REQ_PRIO from places where is it not needed. I'm
not at all sure that the combination WRITE_FLUSH_FUA | REQ_PRIO
makes any kind of sense, anyway.

In addition, I've added REQ_META to one place in the code where
it was missing. REQ_PRIO has been left for read/writes triggered
by glock acquisition and writeback only. We can adjust it again
if required, but these are the most important points from a
performance perspective.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 5986464..2731e65 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -626,7 +626,7 @@ static void log_write_header(struct gfs2_sbd *sdp, u32 flags, int pull)
 	if (test_bit(SDF_NOBARRIERS, &sdp->sd_flags))
 		submit_bh(WRITE_SYNC | REQ_META | REQ_PRIO, bh);
 	else
-		submit_bh(WRITE_FLUSH_FUA | REQ_META | REQ_PRIO, bh);
+		submit_bh(WRITE_FLUSH_FUA | REQ_META, bh);
 	wait_on_buffer(bh);
 
 	if (!buffer_uptodate(bh))
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index be29858..181586e 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -435,7 +435,7 @@ struct buffer_head *gfs2_meta_ra(struct gfs2_glock *gl, u64 dblock, u32 extlen)
 	if (buffer_uptodate(first_bh))
 		goto out;
 	if (!buffer_locked(first_bh))
-		ll_rw_block(READ_SYNC | REQ_META | REQ_PRIO, 1, &first_bh);
+		ll_rw_block(READ_SYNC | REQ_META, 1, &first_bh);
 
 	dblock++;
 	extlen--;
@@ -444,7 +444,7 @@ struct buffer_head *gfs2_meta_ra(struct gfs2_glock *gl, u64 dblock, u32 extlen)
 		bh = gfs2_getbuf(gl, dblock, CREATE);
 
 		if (!buffer_uptodate(bh) && !buffer_locked(bh))
-			ll_rw_block(READA, 1, &bh);
+			ll_rw_block(READA | REQ_META, 1, &bh);
 		brelse(bh);
 		dblock++;
 		extlen--;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index cb23c2b..fe72e79 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -224,7 +224,7 @@ static int gfs2_read_super(struct gfs2_sbd *sdp, sector_t sector, int silent)
 
 	bio->bi_end_io = end_bio_io_page;
 	bio->bi_private = page;
-	submit_bio(READ_SYNC | REQ_META | REQ_PRIO, bio);
+	submit_bio(READ_SYNC | REQ_META, bio);
 	wait_on_page_locked(page);
 	bio_put(bio);
 	if (!PageUptodate(page)) {
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 7e528dc..d1962b2 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -712,7 +712,7 @@ get_a_page:
 		set_buffer_uptodate(bh);
 
 	if (!buffer_uptodate(bh)) {
-		ll_rw_block(READ | REQ_META | REQ_PRIO, 1, &bh);
+		ll_rw_block(READ | REQ_META, 1, &bh);
 		wait_on_buffer(bh);
 		if (!buffer_uptodate(bh))
 			goto unlock_out;
-- 
1.7.4

