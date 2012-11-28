Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab2K1K4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 05:56:00 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33512 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab2K1Kz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 05:55:57 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v3 2/3] davinci: vpss: dm365: set vpss clk ctrl
Date: Wed, 28 Nov 2012 16:25:33 +0530
Message-Id: <1354100134-21095-3-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354100134-21095-1-git-send-email-prabhakar.lad@ti.com>
References: <1354100134-21095-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

request_mem_region for VPSS_CLK_CTRL register and ioremap.
and enable clocks appropriately.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/platform/davinci/vpss.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
index 34ad7bd..a36d694 100644
--- a/drivers/media/platform/davinci/vpss.c
+++ b/drivers/media/platform/davinci/vpss.c
@@ -103,6 +103,7 @@ struct vpss_hw_ops {
 struct vpss_oper_config {
 	__iomem void *vpss_regs_base0;
 	__iomem void *vpss_regs_base1;
+	resource_size_t *vpss_regs_base2;
 	enum vpss_platform_type platform;
 	spinlock_t vpss_lock;
 	struct vpss_hw_ops hw_ops;
@@ -484,11 +485,24 @@ static struct platform_driver vpss_driver = {
 
 static void vpss_exit(void)
 {
+	iounmap(oper_cfg.vpss_regs_base2);
+	release_mem_region(*oper_cfg.vpss_regs_base2, 4);
 	platform_driver_unregister(&vpss_driver);
 }
 
+#define VPSS_CLK_CTRL			0x01c40044
+#define VPSS_CLK_CTRL_VENCCLKEN		BIT(3)
+#define VPSS_CLK_CTRL_DACCLKEN		BIT(4)
+
 static int __init vpss_init(void)
 {
+	if (request_mem_region(VPSS_CLK_CTRL, 4, "vpss_clock_control")) {
+		oper_cfg.vpss_regs_base2 = ioremap(VPSS_CLK_CTRL, 4);
+		__raw_writel(VPSS_CLK_CTRL_VENCCLKEN |
+			     VPSS_CLK_CTRL_DACCLKEN, oper_cfg.vpss_regs_base2);
+	} else {
+		return -EBUSY;
+	}
 	return platform_driver_register(&vpss_driver);
 }
 subsys_initcall(vpss_init);
-- 
1.7.4.1

