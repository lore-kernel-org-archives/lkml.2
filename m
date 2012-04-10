Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab2DJQVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 12:21:55 -0400
Received: from smtp.citrix.com ([66.165.176.89]:58845 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab2DJQVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 12:21:54 -0400
X-IronPort-AV: E=Sophos;i="4.75,399,1330923600"; 
   d="scan'208";a="24030591"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: konrad.wilk@oracle.com
CC: Stefano.Stabellini@eu.citrix.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v3] xen-blkfront: set pages are FOREIGN_FRAME when sharing them
Date: Tue, 10 Apr 2012 17:25:19 +0100
Message-ID: <1334075119-25102-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set pages as FOREIGN_FRAME whenever blkfront shares them with another
domain. Then when blkfront un-share them, also removes the
FOREIGN_FRAME_BIT from the p2m.

We do it so that when the source and the destination domain are the same
(blkfront connected to blkback in the same domain) we can more easily
recognize which ones are the source pfns and which ones are the
destination pfns (both are going to be pointing to the same mfns).

Without this patch enstablishing a connection between blkfront and QEMU
qdisk in the same domain causes QEMU to hang and never return.


Changes in v3:
- only set_phys_to_machine if xen_pv_domain.


Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/block/xen-blkfront.c |   33 ++++++++++++++++++++++++++++-----
 1 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 2f22874..cabfbbb 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -262,7 +262,7 @@ static int blkif_ioctl(struct block_device *bdev, fmode_t mode,
 static int blkif_queue_request(struct request *req)
 {
 	struct blkfront_info *info = req->rq_disk->private_data;
-	unsigned long buffer_mfn;
+	unsigned long buffer_mfn, buffer_pfn;
 	struct blkif_request *ring_req;
 	unsigned long id;
 	unsigned int fsect, lsect;
@@ -321,7 +321,8 @@ static int blkif_queue_request(struct request *req)
 		       BLKIF_MAX_SEGMENTS_PER_REQUEST);
 
 		for_each_sg(info->sg, sg, ring_req->u.rw.nr_segments, i) {
-			buffer_mfn = pfn_to_mfn(page_to_pfn(sg_page(sg)));
+			buffer_pfn = page_to_pfn(sg_page(sg));
+			buffer_mfn = pfn_to_mfn(buffer_pfn);
 			fsect = sg->offset >> 9;
 			lsect = fsect + (sg->length >> 9) - 1;
 			/* install a grant reference. */
@@ -340,6 +341,17 @@ static int blkif_queue_request(struct request *req)
 						.gref       = ref,
 						.first_sect = fsect,
 						.last_sect  = lsect };
+			/* 
+			 * Set the page as foreign, considering that we are giving
+			 * it to a foreign domain.
+			 * This is important in case the destination domain is
+			 * ourselves, so that we can more easily recognize the
+			 * source pfn from destination pfn, both mapping to the same
+			 * mfn.
+			 */
+			if (xen_pv_domain())
+				set_phys_to_machine(buffer_pfn,
+						FOREIGN_FRAME(buffer_mfn));
 		}
 	}
 
@@ -715,8 +727,12 @@ static void blkif_completion(struct blk_shadow *s)
 	int i;
 	/* Do not let BLKIF_OP_DISCARD as nr_segment is in the same place
 	 * flag. */
-	for (i = 0; i < s->req.u.rw.nr_segments; i++)
+	for (i = 0; i < s->req.u.rw.nr_segments; i++) {
 		gnttab_end_foreign_access(s->req.u.rw.seg[i].gref, 0, 0UL);
+		if (xen_pv_domain())
+			set_phys_to_machine(s->frame[i],
+					get_phys_to_machine(s->frame[i]) & ~FOREIGN_FRAME_BIT);
+	}
 }
 
 static irqreturn_t blkif_interrupt(int irq, void *dev_id)
@@ -1051,13 +1067,20 @@ static int blkif_recover(struct blkfront_info *info)
 		memcpy(&info->shadow[req->u.rw.id], &copy[i], sizeof(copy[i]));
 
 		if (req->operation != BLKIF_OP_DISCARD) {
+			unsigned long buffer_pfn;
+			unsigned long buffer_mfn;
 		/* Rewrite any grant references invalidated by susp/resume. */
-			for (j = 0; j < req->u.rw.nr_segments; j++)
+			for (j = 0; j < req->u.rw.nr_segments; j++) {
+				buffer_pfn = info->shadow[req->u.rw.id].frame[j];
+				buffer_mfn = pfn_to_mfn(buffer_pfn);
 				gnttab_grant_foreign_access_ref(
 					req->u.rw.seg[j].gref,
 					info->xbdev->otherend_id,
-					pfn_to_mfn(info->shadow[req->u.rw.id].frame[j]),
+					buffer_mfn,
 					rq_data_dir(info->shadow[req->u.rw.id].request));
+				if (xen_pv_domain())
+					set_phys_to_machine(buffer_pfn, FOREIGN_FRAME(buffer_mfn));
+			}
 		}
 		info->shadow[req->u.rw.id].req = *req;
 
-- 
1.7.2.5

