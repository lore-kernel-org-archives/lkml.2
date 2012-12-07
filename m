Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423654Ab2LGSA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 13:00:56 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:26353 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423611Ab2LGSAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 13:00:54 -0500
X-IronPort-AV: E=Sophos;i="4.84,239,1355097600"; 
   d="scan'208";a="2163"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xen.org>
CC: Roger Pau Monne <roger.pau@citrix.com>, <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen-blkfront: handle bvecs with partial data
Date: Fri, 7 Dec 2012 19:00:31 +0100
Message-ID: <1354903231-1808-1-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently blkfront fails to handle cases in blkif_completion like the
following:

1st loop in rq_for_each_segment
 * bv_offset: 3584
 * bv_len: 512
 * offset += bv_len
 * i: 0

2nd loop:
 * bv_offset: 0
 * bv_len: 512
 * i: 0

In the second loop i should be 1, since we assume we only wanted to
read a part of the previous page. This patches fixes this cases where
only a part of the shared page is read, and blkif_completion assumes
that if the bv_offset of a bvec is less than the previous bv_offset
plus the bv_size we have to switch to the next shared page.

Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkfront.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index df21b05..860f76d 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -843,7 +843,7 @@ static void blkif_free(struct blkfront_info *info, int suspend)
 static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
 			     struct blkif_response *bret)
 {
-	int i;
+	int i = 0;
 	struct bio_vec *bvec;
 	struct req_iterator iter;
 	unsigned long flags;
@@ -860,7 +860,8 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
 		 */
 		rq_for_each_segment(bvec, s->request, iter) {
 			BUG_ON((bvec->bv_offset + bvec->bv_len) > PAGE_SIZE);
-			i = offset >> PAGE_SHIFT;
+			if (bvec->bv_offset < offset)
+				i++;
 			BUG_ON(i >= s->req.u.rw.nr_segments);
 			shared_data = kmap_atomic(
 				pfn_to_page(s->grants_used[i]->pfn));
@@ -869,7 +870,7 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
 				bvec->bv_len);
 			bvec_kunmap_irq(bvec_data, &flags);
 			kunmap_atomic(shared_data);
-			offset += bvec->bv_len;
+			offset = bvec->bv_offset + bvec->bv_len;
 		}
 	}
 	/* Add the persistent grant into the list of free grants */
-- 
1.7.7.5 (Apple Git-26)

