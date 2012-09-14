Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab2INMud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:50:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63481 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab2INMu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:50:28 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH 11/14] dm365: vpss: set vpss clk ctrl
Date: Fri, 14 Sep 2012 18:16:41 +0530
Message-Id: <1347626804-5703-12-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1347626804-5703-1-git-send-email-prabhakar.lad@ti.com>
References: <1347626804-5703-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

request_mem_region for VPSS_CLK_CTRL register and ioremap.
and enable clocks appropriately.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/platform/davinci/vpss.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
index 34ad7bd..49bb045 100644
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
@@ -484,11 +485,21 @@ static struct platform_driver vpss_driver = {
 
 static void vpss_exit(void)
 {
+	iounmap(oper_cfg.vpss_regs_base2);
+	release_mem_region(*oper_cfg.vpss_regs_base2, 4);
 	platform_driver_unregister(&vpss_driver);
 }
 
+#define VPSS_CLK_CTRL		0x01c40044
+
 static int __init vpss_init(void)
 {
+	if (request_mem_region(VPSS_CLK_CTRL, 4, "vpss_clock_control")) {
+		oper_cfg.vpss_regs_base2 = ioremap(VPSS_CLK_CTRL, 4);
+		__raw_writel(0x18, oper_cfg.vpss_regs_base2);
+	} else {
+		return -EBUSY;
+	}
 	return platform_driver_register(&vpss_driver);
 }
 subsys_initcall(vpss_init);
-- 
1.7.4.1

