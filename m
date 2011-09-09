Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759769Ab1IIScP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 14:32:15 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:38866 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759754Ab1IIScK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 14:32:10 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, JBeulich@novell.com,
        jeremy.fitzhardinge@citrix.com, axboe@kernel.dk,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, stable@kernel.org
Subject: [PATCH 3/3] xen-blkfront: If no barrier or flush is supported, use invalid operation.
Date: Fri,  9 Sep 2011 14:31:00 -0400
Message-Id: <1315593060-20031-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315593060-20031-1-git-send-email-konrad.wilk@oracle.com>
References: <1315593060-20031-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4E6A5B80.006A:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By default we would set the info->flush_op=0, and zero maps
to BLKIF_OP_READ request code. So if the backend did not support
either barrier ('feature-barrier') or flush ('feature-flush-cache')
we would end up using that opcode for the flush/barrier request, meaning
we actually do a READ request. Fortunatly for us, __generic_make_request
checks q->flush_flags and realizes that we don't do FLUSH and removes
the REQ_FLUSH | REQ_FUA so we never end up issuing a READ request
for a flush request. However, other third party implementations of
__make_request might not be so smart, so lets fix this up.

CC: stable@kernel.org
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkfront.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index e205d91..c4aa9da 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -97,7 +97,7 @@ struct blkfront_info
 	struct blk_shadow shadow[BLK_RING_SIZE];
 	unsigned long shadow_free;
 	unsigned int feature_flush;
-	unsigned int flush_op;
+	int flush_op;
 	unsigned int feature_discard;
 	unsigned int discard_granularity;
 	unsigned int discard_alignment;
@@ -774,7 +774,7 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 				if (error == -EOPNOTSUPP)
 					error = 0;
 				info->feature_flush = 0;
-				info->flush_op = 0;
+				info->flush_op = -1; /* 0 is BLKIF_OP_READ */
 				xlvbd_flush(info);
 			}
 			/* fall through */
@@ -1207,7 +1207,7 @@ static void blkfront_connect(struct blkfront_info *info)
 	}
 
 	info->feature_flush = 0;
-	info->flush_op = 0;
+	info->flush_op = -1; /* 0 is BLKIF_OP_READ */
 
 	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
 			    "feature-barrier", "%d", &barrier,
@@ -1234,7 +1234,7 @@ static void blkfront_connect(struct blkfront_info *info)
 	if (!err && flush)
 		info->flush_op = BLKIF_OP_FLUSH_DISKCACHE;
 
-	if (info->flush_op)
+	if (info->flush_op > 0)
 		info->feature_flush = REQ_FLUSH | REQ_FUA;
 
 	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
-- 
1.7.4.1

