Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab0KBQVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 12:21:46 -0400
Received: from claw.goop.org ([74.207.240.146]:49568 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab0KBQVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 12:21:38 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Stodden <daniel.stodden@citrix.com>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 4/4] xen/blkfront: cope with backend that fail empty BLKIF_OP_WRITE_BARRIER requests
Date: Tue,  2 Nov 2010 12:20:47 -0400
Message-Id: <a90cc3e15a94274bb22b990be16cd1f62747a0dd.1288714384.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1288714384.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288714384.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1288714384.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288714384.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Some(?) Xen block backends fail BLKIF_OP_WRITE_BARRIER requests, which
Linux uses as a cache flush operation.  In that case, disable use
of FLUSH.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Daniel Stodden <daniel.stodden@citrix.com>
---
 drivers/block/xen-blkfront.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 76b874a..5e5a622 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -656,6 +656,14 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 				printk(KERN_WARNING "blkfront: %s: write barrier op failed\n",
 				       info->gd->disk_name);
 				error = -EOPNOTSUPP;
+			}
+			if (unlikely(bret->status == BLKIF_RSP_ERROR &&
+				     info->shadow[id].req.nr_segments == 0)) {
+				printk(KERN_WARNING "blkfront: %s: empty write barrier op failed\n",
+				       info->gd->disk_name);
+				error = -EOPNOTSUPP;
+			}
+			if (unlikely(error)) {
 				info->feature_flush = 0;
 				xlvbd_flush(info);
 			}
-- 
1.7.2.3

