Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab0JKABJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 20:01:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60956 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab0JKABH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 20:01:07 -0400
From: monstr@monstr.eu
To: michal.simek@petalogix.com
Cc: Michal Simek <monstr@monstr.eu>,
        Andrei Konovalov <akonovalov@ru.mvista.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] fbdev/xilinxfb: Microblaze driver support
Date: Mon, 11 Oct 2010 10:00:55 +1000
Message-Id: <4cb253c1.5c0edf0a.47dd.790c@mx.google.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

DCR bus is natively used for PowerPC. Microblaze has
no infrastructure for compile DCR that's why is necessary
to exclude it.

Signed-off-by: Michal Simek <monstr@monstr.eu>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
CC: Andrei Konovalov <akonovalov@ru.mvista.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org
---
 drivers/video/xilinxfb.c |   25 ++++++++++++++++++-------
 1 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index 0c9ce88..3c22dbb 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -32,10 +32,14 @@
 #include <linux/dma-mapping.h>
 #include <linux/of_device.h>
 #include <linux/of_platform.h>
+#include <linux/of_address.h>
 #include <linux/io.h>
 #include <linux/xilinxfb.h>
 #include <linux/slab.h>
+
+#ifdef CONFIG_PPC_DCR
 #include <asm/dcr.h>
+#endif
 
 #define DRIVER_NAME		"xilinxfb"
 
@@ -123,10 +127,10 @@ struct xilinxfb_drvdata {
 						registers */
 	void __iomem	*regs;		/* virt. address of the control
 						registers */
-
+#ifdef CONFIG_PPC_DCR
 	dcr_host_t      dcr_host;
 	unsigned int    dcr_len;
-
+#endif
 	void		*fb_virt;	/* virt. address of the frame buffer */
 	dma_addr_t	fb_phys;	/* phys. address of the frame buffer */
 	int		fb_alloced;	/* Flag, was the fb memory alloced? */
@@ -152,9 +156,10 @@ static void xilinx_fb_out_be32(struct xilinxfb_drvdata *drvdata, u32 offset,
 {
 	if (drvdata->flags & PLB_ACCESS_FLAG)
 		out_be32(drvdata->regs + (offset << 2), val);
+#ifdef CONFIG_PPC_DCR
 	else
 		dcr_write(drvdata->dcr_host, offset, val);
-
+#endif
 }
 
 static int
@@ -383,8 +388,11 @@ static int xilinxfb_release(struct device *dev)
 	if (drvdata->flags & PLB_ACCESS_FLAG) {
 		iounmap(drvdata->regs);
 		release_mem_region(drvdata->regs_phys, 8);
-	} else
+	}
+#ifdef CONFIG_PPC_DCR
+	else
 		dcr_unmap(drvdata->dcr_host, drvdata->dcr_len);
+#endif
 
 	kfree(drvdata);
 	dev_set_drvdata(dev, NULL);
@@ -404,7 +412,7 @@ xilinxfb_of_probe(struct platform_device *op, const struct of_device_id *match)
 	u32 tft_access;
 	struct xilinxfb_platform_data pdata;
 	struct resource res;
-	int size, rc, start;
+	int size, rc;
 	struct xilinxfb_drvdata *drvdata;
 
 	/* Copy with the default pdata (not a ptr reference!) */
@@ -437,9 +445,11 @@ xilinxfb_of_probe(struct platform_device *op, const struct of_device_id *match)
 			dev_err(&op->dev, "invalid address\n");
 			goto err;
 		}
-	} else {
+	}
+#ifdef CONFIG_PPC_DCR
+	else {
 		res.start = 0;
-		start = dcr_resource_start(op->dev.of_node, 0);
+		int start = dcr_resource_start(op->dev.of_node, 0);
 		drvdata->dcr_len = dcr_resource_len(op->dev.of_node, 0);
 		drvdata->dcr_host = dcr_map(op->dev.of_node, start, drvdata->dcr_len);
 		if (!DCR_MAP_OK(drvdata->dcr_host)) {
@@ -447,6 +457,7 @@ xilinxfb_of_probe(struct platform_device *op, const struct of_device_id *match)
 			goto err;
 		}
 	}
+#endif
 
 	prop = of_get_property(op->dev.of_node, "phys-size", &size);
 	if ((prop) && (size >= sizeof(u32)*2)) {
-- 
1.5.5.1

