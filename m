Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab2K3LoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:44:23 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53110 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932642Ab2K3LoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:44:21 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v4 2/3] davinci: vpss: dm365: set vpss clk ctrl
Date: Fri, 30 Nov 2012 17:13:40 +0530
Message-Id: <1354275821-25235-3-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354275821-25235-1-git-send-email-prabhakar.lad@ti.com>
References: <1354275821-25235-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

request_mem_region for VPSS_CLK_CTRL register and ioremap.
and enable clocks appropriately.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/platform/davinci/vpss.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
index 1c96ce8..e4ad63d 100644
--- a/drivers/media/platform/davinci/vpss.c
+++ b/drivers/media/platform/davinci/vpss.c
@@ -69,6 +69,11 @@ MODULE_AUTHOR("Texas Instruments");
 #define DM365_ISP5_CCDCMUX 		0x20
 #define DM365_ISP5_PG_FRAME_SIZE 	0x28
 #define DM365_VPBE_CLK_CTRL 		0x00
+
+#define VPSS_CLK_CTRL			0x01c40044
+#define VPSS_CLK_CTRL_VENCCLKEN		BIT(3)
+#define VPSS_CLK_CTRL_DACCLKEN		BIT(4)
+
 /*
  * vpss interrupts. VDINT0 - vpss_int0, VDINT1 - vpss_int1,
  * AF - vpss_int3
@@ -112,6 +117,7 @@ struct vpss_hw_ops {
 struct vpss_oper_config {
 	__iomem void *vpss_regs_base0;
 	__iomem void *vpss_regs_base1;
+	resource_size_t *vpss_regs_base2;
 	enum vpss_platform_type platform;
 	spinlock_t vpss_lock;
 	struct vpss_hw_ops hw_ops;
@@ -492,11 +498,20 @@ static struct platform_driver vpss_driver = {
 
 static void vpss_exit(void)
 {
+	iounmap(oper_cfg.vpss_regs_base2);
+	release_mem_region(VPSS_CLK_CTRL, 4);
 	platform_driver_unregister(&vpss_driver);
 }
 
 static int __init vpss_init(void)
 {
+	if (!request_mem_region(VPSS_CLK_CTRL, 4, "vpss_clock_control"))
+		return -EBUSY;
+
+	oper_cfg.vpss_regs_base2 = ioremap(VPSS_CLK_CTRL, 4);
+	writel(VPSS_CLK_CTRL_VENCCLKEN |
+		     VPSS_CLK_CTRL_DACCLKEN, oper_cfg.vpss_regs_base2);
+
 	return platform_driver_register(&vpss_driver);
 }
 subsys_initcall(vpss_init);
-- 
1.7.4.1

