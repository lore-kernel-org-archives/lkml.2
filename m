Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab0ICKew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 06:34:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:35780 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757088Ab0ICKbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 06:31:25 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, hch@lst.de, konishi.ryusuke@lab.ntt.co.jp,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        snitzer@redhat.com, k-ueda@ct.jp.nec.com, mpatocka@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 32/41] nilfs2: replace barriers with explicit flush / FUA usage
Date: Fri,  3 Sep 2010 12:29:47 +0200
Message-Id: <1283509796-1510-33-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 10:30:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

Switch to the WRITE_FLUSH_FUA flag for log writes, remove the EOPNOTSUPP
detection for barriers and stop setting the barrier flag for discards.

tj: nilfs is now fixed to wait for discard completion.  Updated this
    patch accordingly and dropped warning about it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/nilfs2/super.c     |   10 +---------
 fs/nilfs2/the_nilfs.c |    7 ++-----
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 9222633..faa5078 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -178,17 +178,9 @@ static int nilfs_sync_super(struct nilfs_sb_info *sbi, int flag)
 
  retry:
 	set_buffer_dirty(nilfs->ns_sbh[0]);
-
 	if (nilfs_test_opt(sbi, BARRIER)) {
 		err = __sync_dirty_buffer(nilfs->ns_sbh[0],
-					  WRITE_SYNC | WRITE_BARRIER);
-		if (err == -EOPNOTSUPP) {
-			nilfs_warning(sbi->s_super, __func__,
-				      "barrier-based sync failed. "
-				      "disabling barriers\n");
-			nilfs_clear_opt(sbi, BARRIER);
-			goto retry;
-		}
+					  WRITE_SYNC | WRITE_FLUSH_FUA);
 	} else {
 		err = sync_dirty_buffer(nilfs->ns_sbh[0]);
 	}
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 4317f17..400b2ca 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -774,9 +774,7 @@ int nilfs_discard_segments(struct the_nilfs *nilfs, __u64 *segnump,
 			ret = blkdev_issue_discard(nilfs->ns_bdev,
 						   start * sects_per_block,
 						   nblocks * sects_per_block,
-						   GFP_NOFS,
-						   BLKDEV_IFL_WAIT |
-						   BLKDEV_IFL_BARRIER);
+						   GFP_NOFS, BLKDEV_IFL_WAIT);
 			if (ret < 0)
 				return ret;
 			nblocks = 0;
@@ -786,8 +784,7 @@ int nilfs_discard_segments(struct the_nilfs *nilfs, __u64 *segnump,
 		ret = blkdev_issue_discard(nilfs->ns_bdev,
 					   start * sects_per_block,
 					   nblocks * sects_per_block,
-					   GFP_NOFS,
-					  BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
+					   GFP_NOFS, BLKDEV_IFL_WAIT);
 	return ret;
 }
 
-- 
1.7.1

