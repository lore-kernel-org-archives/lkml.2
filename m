Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab0GTUmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:42:53 -0400
Received: from claw.goop.org ([74.207.240.146]:50916 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758636Ab0GTUms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:42:48 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Xen-devel <xen-devel@lists.xensource.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 01/16] xen: use less generic names in blkfront driver.
Date: Tue, 20 Jul 2010 13:42:08 -0700
Message-Id: <355e718c3f164de385d165eb8a0594895f034ebd.1279658433.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

All Xen frontend drivers have a couple of identically named functions which
makes figuring out which device went wrong from a stacktrace harder than it
needs to be. Rename them to something specificto the device type.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/block/xen-blkfront.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 82ed403..6839947 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -651,7 +651,7 @@ fail:
 
 
 /* Common code used when first setting up, and when resuming. */
-static int talk_to_backend(struct xenbus_device *dev,
+static int talk_to_blkback(struct xenbus_device *dev,
 			   struct blkfront_info *info)
 {
 	const char *message = NULL;
@@ -756,7 +756,7 @@ static int blkfront_probe(struct xenbus_device *dev,
 	info->handle = simple_strtoul(strrchr(dev->nodename, '/')+1, NULL, 0);
 	dev_set_drvdata(&dev->dev, info);
 
-	err = talk_to_backend(dev, info);
+	err = talk_to_blkback(dev, info);
 	if (err) {
 		kfree(info);
 		dev_set_drvdata(&dev->dev, NULL);
@@ -851,7 +851,7 @@ static int blkfront_resume(struct xenbus_device *dev)
 
 	blkif_free(info, info->connected == BLKIF_STATE_CONNECTED);
 
-	err = talk_to_backend(dev, info);
+	err = talk_to_blkback(dev, info);
 	if (info->connected == BLKIF_STATE_SUSPENDED && !err)
 		err = blkif_recover(info);
 
@@ -955,13 +955,13 @@ static void blkfront_closing(struct xenbus_device *dev)
 /**
  * Callback received when the backend's state changes.
  */
-static void backend_changed(struct xenbus_device *dev,
+static void blkback_changed(struct xenbus_device *dev,
 			    enum xenbus_state backend_state)
 {
 	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
 	struct block_device *bd;
 
-	dev_dbg(&dev->dev, "blkfront:backend_changed.\n");
+	dev_dbg(&dev->dev, "blkfront:blkback_changed to state %d.\n", backend_state);
 
 	switch (backend_state) {
 	case XenbusStateInitialising:
@@ -1062,7 +1062,7 @@ static struct xenbus_driver blkfront = {
 	.probe = blkfront_probe,
 	.remove = blkfront_remove,
 	.resume = blkfront_resume,
-	.otherend_changed = backend_changed,
+	.otherend_changed = blkback_changed,
 	.is_ready = blkfront_is_ready,
 };
 
-- 
1.7.1.1

