Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415Ab0ICKmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 06:42:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:35607 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756809Ab0ICKbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 06:31:04 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, hch@lst.de, konishi.ryusuke@lab.ntt.co.jp,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        snitzer@redhat.com, k-ueda@ct.jp.nec.com, mpatocka@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 22/41] block: make __blk_rq_prep_clone() copy most command flags
Date: Fri,  3 Sep 2010 12:29:37 +0200
Message-Id: <1283509796-1510-23-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 10:30:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently __blk_rq_prep_clone() copies only REQ_WRITE and REQ_DISCARD.
There's no reason to omit other command flags and REQ_FUA needs to be
copied to implement FUA support in request-based dm.

REQ_COMMON_MASK which specifies flags to be copied from bio to request
already identifies all the command flags.  Define REQ_CLONE_MASK to be
the same as REQ_COMMON_MASK for clarity and make __blk_rq_prep_clone()
copy all flags in the mask.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c          |    4 +---
 include/linux/blk_types.h |    1 +
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 495bdc4..2a5b192 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2505,9 +2505,7 @@ EXPORT_SYMBOL_GPL(blk_rq_unprep_clone);
 static void __blk_rq_prep_clone(struct request *dst, struct request *src)
 {
 	dst->cpu = src->cpu;
-	dst->cmd_flags = (rq_data_dir(src) | REQ_NOMERGE);
-	if (src->cmd_flags & REQ_DISCARD)
-		dst->cmd_flags |= REQ_DISCARD;
+	dst->cmd_flags = (src->cmd_flags & REQ_CLONE_MASK) | REQ_NOMERGE;
 	dst->cmd_type = src->cmd_type;
 	dst->__sector = blk_rq_pos(src);
 	dst->__data_len = blk_rq_bytes(src);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 1797994..36edadf 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -168,6 +168,7 @@ enum rq_flag_bits {
 #define REQ_COMMON_MASK \
 	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_HARDBARRIER | REQ_SYNC | \
 	 REQ_META | REQ_DISCARD | REQ_NOIDLE | REQ_FLUSH | REQ_FUA)
+#define REQ_CLONE_MASK		REQ_COMMON_MASK
 
 #define REQ_UNPLUG		(1 << __REQ_UNPLUG)
 #define REQ_RAHEAD		(1 << __REQ_RAHEAD)
-- 
1.7.1

