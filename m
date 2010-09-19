Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab0ISMyx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 08:54:53 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58608 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab0ISMyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 08:54:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VL1SAlbgDJusY85fSuFEP2BU51/T5/ct59cZX/Ty98RUqyml7FPWGgNhPocFHCzWKC
         rw1y8bRcd8D56ITKjv/ib/44ngmpxYhei1hqPqCex7qSJ2sS6OpvajwwAZ3ed0vqLoxv
         +n/bHvf9LrLq+eL3B6MKesSxc3a33fDH9NTvM=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/14] mca: fix device_register() error handling
Date: Sun, 19 Sep 2010 16:54:46 +0400
Message-Id: <1284900887-24327-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If device_register() fails then call put_device().
See comment to device_register.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 I cannot compile this driver, so it is not tested at all.

 drivers/mca/mca-bus.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/mca/mca-bus.c b/drivers/mca/mca-bus.c
index ada5ebb..7162f08 100644
--- a/drivers/mca/mca-bus.c
+++ b/drivers/mca/mca-bus.c
@@ -116,8 +116,10 @@ int __init mca_register_device(int bus, struct mca_device *mca_dev)
 	mca_dev->dev.coherent_dma_mask = mca_dev->dma_mask;
 
 	rc = device_register(&mca_dev->dev);
-	if (rc)
+	if (rc) {
+		put_device(&mca_dev->dev);
 		goto err_out;
+	}
 
 	rc = device_create_file(&mca_dev->dev, &dev_attr_id);
 	if (rc) goto err_out_devreg;
@@ -154,6 +156,7 @@ struct mca_bus * __devinit mca_attach_bus(int bus)
 	dev_set_name(&mca_bus->dev, "mca%d", bus);
 	sprintf(mca_bus->name,"Host %s MCA Bridge", bus ? "Secondary" : "Primary");
 	if (device_register(&mca_bus->dev)) {
+		put_device(&mca_bus->dev);
 		kfree(mca_bus);
 		return NULL;
 	}
-- 
1.7.0.4

