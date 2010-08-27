Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab0H0RRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 13:17:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:41796 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817Ab0H0RRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 13:17:25 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, snitzer@redhat.com,
        j-nomura@ce.jp.nec.com, jamie@shareable.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-raid@vger.kernel.org, hch@lst.de
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] block: make __blk_rq_prep_clone() copy most command flags
Date: Fri, 27 Aug 2010 19:10:57 +0200
Message-Id: <1282929060-23663-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1282929060-23663-1-git-send-email-tj@kernel.org>
References: <1282929060-23663-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 27 Aug 2010 17:16:58 +0000 (UTC)
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

