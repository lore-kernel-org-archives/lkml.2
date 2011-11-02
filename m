Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933682Ab1KBSjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:39:21 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18091 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933467Ab1KBShI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:37:08 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133707009"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 27/34] msm-8x60: Add serial support
Date: Wed,  2 Nov 2011 11:36:24 -0700
Message-Id: <1320258991-22325-28-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stepan Moskovchenko <stepanm@codeaurora.org>

Add the platform data to the board file.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/board-msm8x60.c |   50 +++++++++++++++++++++++++++++++++++++
 1 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index 7b8016f..f034bf5 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -73,8 +73,58 @@ static void __init msm8x60_init_irq(void)
 		writel(0x0000FFFF, MSM_QGIC_DIST_BASE + GIC_DIST_ENABLE_SET);
 }
 
+static struct resource msm_uart12_dm_resources[] = {
+	{
+		.start = 0x19C40000,
+		.end   = 0x19C40000 + PAGE_SIZE - 1,
+		.name  = "uart_resource",
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = INT_UART12DM_IRQ,
+		.end   = INT_UART12DM_IRQ,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		/* GSBI 12 is UARTDM2 */
+		.start = 0x19C00000,
+		.end   = 0x19C00000 + PAGE_SIZE - 1,
+		.name  = "gsbi_resource",
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+struct platform_device msm_device_uart_dm12 = {
+	.name = "msm_serial",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(msm_uart12_dm_resources),
+	.resource = msm_uart12_dm_resources,
+};
+
+static struct platform_device *devices[] __initdata = {
+	&msm_device_uart_dm12,
+};
+
+static void __init msm8x60_init_uart12dm(void)
+{
+	/* 0x1D000000 now belongs to EBI2:CS3 i.e. USB ISP Controller */
+	void *fpga_mem = ioremap_nocache(0x1D000000, SZ_4K);
+	/* Advanced mode */
+	writew(0xFFFF, fpga_mem + 0x15C);
+	/* FPGA_UART_SEL */
+	writew(0, fpga_mem + 0x172);
+	/* FPGA_GPIO_CONFIG_117 */
+	writew(1, fpga_mem + 0xEA);
+	/* FPGA_GPIO_CONFIG_118 */
+	writew(1, fpga_mem + 0xEC);
+	dmb();
+	iounmap(fpga_mem);
+}
+
 static void __init msm8x60_init(void)
 {
+	msm8x60_init_uart12dm();
+	platform_add_devices(devices, ARRAY_SIZE(devices));
 }
 
 MACHINE_START(MSM8X60_RUMI3, "QCT MSM8X60 RUMI3")
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

