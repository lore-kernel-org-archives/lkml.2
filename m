Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab0D3VkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 17:40:24 -0400
Received: from tex.lwn.net ([70.33.254.29]:36264 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759697Ab0D3VkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 17:40:09 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       =?UTF-8?q?Bruno=20Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 3/3] viafb: Don't build in camera-specific code without the camera
Date: Fri, 30 Apr 2010 15:39:49 -0600
Message-Id: <1272663589-4950-4-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1272663589-4950-1-git-send-email-corbet@lwn.net>
References: <1272663589-4950-1-git-send-email-corbet@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bruno noted that the camera subdev was being created even in the absence of
the camera module; stop that.  While I was at it, I also put an #ifdef
guard around the DMA code.  Viafb users have gotten along just fine without
that functionality so far, and only the camera uses it, so there is no
point in bloating the driver if the camera is not being built.

Reported-by: Bruno Prémont <bonbons@linux-vserver.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/via-core.c |   12 ++++++++++--
 drivers/video/via/via-core.h |    3 ++-
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/video/via/via-core.c b/drivers/video/via/via-core.c
index 1c6835e..a084363 100644
--- a/drivers/video/via/via-core.c
+++ b/drivers/video/via/via-core.c
@@ -34,7 +34,6 @@ static struct via_port_cfg adap_configs[] = {
  */
 static struct viafb_dev global_dev;
 
-
 /*
  * Basic register access; spinlock required.
  */
@@ -95,6 +94,13 @@ EXPORT_SYMBOL_GPL(viafb_irq_disable);
 
 /* ---------------------------------------------------------------------- */
 /*
+ * Currently, the camera driver is the only user of the DMA code, so we
+ * only compile it in if the camera driver is being built.  Chances are,
+ * most viafb systems will not need to have this extra code for a while.
+ * As soon as another user comes long, the ifdef can be removed.
+ */
+#if defined(CONFIG_FB_VIA_CAMERA) || defined(CONFIG_FB_VIA_CAMERA_MODULE)
+/*
  * Access to the DMA engine.  This currently provides what the camera
  * driver needs (i.e. outgoing only) but is easily expandable if need
  * be.
@@ -322,7 +328,7 @@ int viafb_dma_copy_out_sg(unsigned int offset, struct scatterlist *sg, int nsg)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(viafb_dma_copy_out_sg);
-
+#endif /* CONFIG_FB_VIA_CAMERA */
 
 /* ---------------------------------------------------------------------- */
 /*
@@ -508,9 +514,11 @@ static struct viafb_subdev_info {
 	{
 		.name = "viafb-i2c",
 	},
+#if defined(CONFIG_FB_VIA_CAMERA) || defined(CONFIG_FB_VIA_CAMERA_MODULE)
 	{
 		.name = "viafb-camera",
 	},
+#endif
 };
 #define N_SUBDEVS ARRAY_SIZE(viafb_subdevs)
 
diff --git a/drivers/video/via/via-core.h b/drivers/video/via/via-core.h
index 087c562..ca52dfe 100644
--- a/drivers/video/via/via-core.h
+++ b/drivers/video/via/via-core.h
@@ -94,7 +94,6 @@ struct viafb_dev {
 /*
  * Interrupt management.
  */
-
 void viafb_irq_enable(u32 mask);
 void viafb_irq_disable(u32 mask);
 
@@ -135,6 +134,7 @@ void viafb_irq_disable(u32 mask);
 #define   VDE_I_LVDSSIEN  0x40000000  /* LVDS Sense enable */
 #define   VDE_I_ENABLE	  0x80000000  /* Global interrupt enable */
 
+#if defined(CONFIG_FB_VIA_CAMERA) || defined(CONFIG_FB_VIA_CAMERA_MODULE)
 /*
  * DMA management.
  */
@@ -169,5 +169,6 @@ int viafb_dma_copy_out_sg(unsigned int offset, struct scatterlist *sg, int nsg);
  */
 #define VGA_WIDTH	640
 #define VGA_HEIGHT	480
+#endif /* CONFIG_FB_VIA_CAMERA */
 
 #endif /* __VIA_CORE_H__ */
-- 
1.7.0.1

