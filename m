Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761682Ab0GTUnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:43:07 -0400
Received: from claw.goop.org ([74.207.240.146]:50931 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761587Ab0GTUmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:42:49 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Xen-devel <xen-devel@lists.xensource.com>,
        "K. Y. Srinivasan" <ksrinivasan@novell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 04/16] xen/front: Propagate changed size of VBDs
Date: Tue, 20 Jul 2010 13:42:12 -0700
Message-Id: <81b53eb0381af589b74b61f8390fc90239ec2f01.1279658433.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <355e718c3f164de385d165eb8a0594895f034ebd.1279658433.git.jeremy.fitzhardinge@citrix.com>
References: <355e718c3f164de385d165eb8a0594895f034ebd.1279658433.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: K. Y. Srinivasan <ksrinivasan@novell.com>

Support dynamic resizing of virtual block devices. This patch supports
both file backed block devices as well as physical devices that can be
dynamically resized on the host side.

Signed-off-by: K. Y. Srinivasan <ksrinivasan@novell.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/block/xen-blkfront.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index df2bae5..0b4091b 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -930,9 +930,24 @@ static void blkfront_connect(struct blkfront_info *info)
 	unsigned int binfo;
 	int err;
 
-	if ((info->connected == BLKIF_STATE_CONNECTED) ||
-	    (info->connected == BLKIF_STATE_SUSPENDED) )
+	switch (info->connected) {
+	case BLKIF_STATE_CONNECTED:
+		/*
+		 * Potentially, the back-end may be signalling
+		 * a capacity change; update the capacity.
+		 */
+		err = xenbus_scanf(XBT_NIL, info->xbdev->otherend,
+				   "sectors", "%Lu", &sectors);
+		if (XENBUS_EXIST_ERR(err))
+			return;
+		printk(KERN_INFO "Setting capacity to %Lu\n",
+		       sectors);
+		set_capacity(info->gd, sectors);
+
+		/* fall through */
+	case BLKIF_STATE_SUSPENDED:
 		return;
+	}
 
 	dev_dbg(&info->xbdev->dev, "%s:%s.\n",
 		__func__, info->xbdev->otherend);
-- 
1.7.1.1

