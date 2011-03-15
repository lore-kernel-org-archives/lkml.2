Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab1COFD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 01:03:57 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63697 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab1COFBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 01:01:24 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6285"; a="79964167"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jeff Ohlstein <johlstei@codeaurora.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH 06/11] msm: dma: use a platform device for msm_dmov
Date: Mon, 14 Mar 2011 22:01:09 -0700
Message-Id: <1300165274-8544-7-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300165274-8544-1-git-send-email-johlstei@codeaurora.org>
References: <1300165274-8544-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switching to a platform device allows us to add hooks for power
management, along with providing a way to do per-SoC configuration of
the device.

Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 arch/arm/mach-msm/board-halibut.c               |    1 +
 arch/arm/mach-msm/board-mahimahi.c              |    1 +
 arch/arm/mach-msm/board-msm7x30.c               |    1 +
 arch/arm/mach-msm/board-qsd8x50.c               |    1 +
 arch/arm/mach-msm/board-trout.c                 |    1 +
 arch/arm/mach-msm/devices-msm7x00.c             |   21 ++++++-
 arch/arm/mach-msm/devices-msm7x30.c             |   21 ++++++-
 arch/arm/mach-msm/devices-qsd8x50.c             |   21 ++++++-
 arch/arm/mach-msm/devices.h                     |    2 +
 arch/arm/mach-msm/dma.c                         |   78 +++++++++++++++++------
 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h |    5 +-
 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h |    5 +-
 arch/arm/mach-msm/include/mach/msm_iomap-8x50.h |    5 +-
 arch/arm/mach-msm/io.c                          |    3 -
 14 files changed, 131 insertions(+), 35 deletions(-)

diff --git a/arch/arm/mach-msm/board-halibut.c b/arch/arm/mach-msm/board-halibut.c
index 18a3c97..4d264eb 100644
--- a/arch/arm/mach-msm/board-halibut.c
+++ b/arch/arm/mach-msm/board-halibut.c
@@ -59,6 +59,7 @@ static struct platform_device smc91x_device = {
 
 static struct platform_device *devices[] __initdata = {
 	&msm_device_uart3,
+	&msm_device_dmov,
 	&msm_device_smd,
 	&msm_device_nand,
 	&msm_device_hsusb,
diff --git a/arch/arm/mach-msm/board-mahimahi.c b/arch/arm/mach-msm/board-mahimahi.c
index 7a9a03e..db3201a 100644
--- a/arch/arm/mach-msm/board-mahimahi.c
+++ b/arch/arm/mach-msm/board-mahimahi.c
@@ -44,6 +44,7 @@ static struct platform_device *devices[] __initdata = {
 #if !defined(CONFIG_MSM_SERIAL_DEBUGGER)
 	&msm_device_uart1,
 #endif
+	&msm_device_dmov,
 	&msm_device_uart_dm1,
 	&msm_device_nand,
 };
diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-msm7x30.c
index cf15889..cfd6172 100644
--- a/arch/arm/mach-msm/board-msm7x30.c
+++ b/arch/arm/mach-msm/board-msm7x30.c
@@ -79,6 +79,7 @@ static struct platform_device *devices[] __initdata = {
 #if defined(CONFIG_SERIAL_MSM) || defined(CONFIG_MSM_SERIAL_DEBUGGER)
         &msm_device_uart2,
 #endif
+	&msm_device_dmov,
 	&msm_device_smd,
 	&msm_device_otg,
 	&msm_device_hsusb,
diff --git a/arch/arm/mach-msm/board-qsd8x50.c b/arch/arm/mach-msm/board-qsd8x50.c
index 127ee6d..50b9dd0 100644
--- a/arch/arm/mach-msm/board-qsd8x50.c
+++ b/arch/arm/mach-msm/board-qsd8x50.c
@@ -93,6 +93,7 @@ static struct msm_otg_platform_data msm_otg_pdata = {
 
 static struct platform_device *devices[] __initdata = {
 	&msm_device_uart3,
+	&msm_device_dmov,
 	&msm_device_smd,
 	&msm_device_otg,
 	&msm_device_hsusb,
diff --git a/arch/arm/mach-msm/board-trout.c b/arch/arm/mach-msm/board-trout.c
index 8143867..5831ce5 100644
--- a/arch/arm/mach-msm/board-trout.c
+++ b/arch/arm/mach-msm/board-trout.c
@@ -35,6 +35,7 @@ extern int trout_init_mmc(unsigned int);
 
 static struct platform_device *devices[] __initdata = {
 	&msm_device_uart3,
+	&msm_device_dmov,
 	&msm_device_smd,
 	&msm_device_nand,
 	&msm_device_hsusb,
diff --git a/arch/arm/mach-msm/devices-msm7x00.c b/arch/arm/mach-msm/devices-msm7x00.c
index c4f5e26..3ef38a5 100644
--- a/arch/arm/mach-msm/devices-msm7x00.c
+++ b/arch/arm/mach-msm/devices-msm7x00.c
@@ -418,8 +418,27 @@ struct platform_device msm_device_mdp = {
 	.resource = resources_mdp,
 };
 
+static struct resource resources_dmov[] = {
+	{
+		.start = MSM7X00_DMOV_PHYS,
+		.end = MSM7X00_DMOV_PHYS + MSM7X00_DMOV_SIZE - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = INT_ADM_AARM,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+struct platform_device msm_device_dmov = {
+	.name	= "msm_dmov",
+	.id	= -1,
+	.num_resources = ARRAY_SIZE(resources_dmov),
+	.resource = resources_dmov,
+};
+
 struct clk_lookup msm_clocks_7x01a[] = {
-	CLK_PCOM("adm_clk",	ADM_CLK,	NULL, 0),
+	CLK_PCOM("adm_clk",	ADM_CLK,	"msm_dmov", 0),
 	CLK_PCOM("adsp_clk",	ADSP_CLK,	NULL, 0),
 	CLK_PCOM("ebi1_clk",	EBI1_CLK,	NULL, 0),
 	CLK_PCOM("ebi2_clk",	EBI2_CLK,	NULL, 0),
diff --git a/arch/arm/mach-msm/devices-msm7x30.c b/arch/arm/mach-msm/devices-msm7x30.c
index 09b4f14..f803fcd 100644
--- a/arch/arm/mach-msm/devices-msm7x30.c
+++ b/arch/arm/mach-msm/devices-msm7x30.c
@@ -130,8 +130,27 @@ struct platform_device msm_device_hsusb_host = {
 	},
 };
 
+static struct resource resources_dmov[] = {
+	{
+		.start = MSM7X30_DMOV_PHYS,
+		.end = MSM7X30_DMOV_PHYS + MSM7X30_DMOV_SIZE - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = INT_ADM_AARM,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+struct platform_device msm_device_dmov = {
+	.name	= "msm_dmov",
+	.id	= -1,
+	.num_resources = ARRAY_SIZE(resources_dmov),
+	.resource = resources_dmov,
+};
+
 struct clk_lookup msm_clocks_7x30[] = {
-	CLK_PCOM("adm_clk",	ADM_CLK,	NULL, 0),
+	CLK_PCOM("adm_clk",	ADM_CLK,	"msm_dmov", 0),
 	CLK_PCOM("adsp_clk",	ADSP_CLK,	NULL, 0),
 	CLK_PCOM("cam_m_clk",	CAM_M_CLK,	NULL, 0),
 	CLK_PCOM("camif_pad_pclk",	CAMIF_PAD_P_CLK,	NULL, OFF),
diff --git a/arch/arm/mach-msm/devices-qsd8x50.c b/arch/arm/mach-msm/devices-qsd8x50.c
index 12d8deb..730982f 100644
--- a/arch/arm/mach-msm/devices-qsd8x50.c
+++ b/arch/arm/mach-msm/devices-qsd8x50.c
@@ -315,8 +315,27 @@ int __init msm_add_sdcc(unsigned int controller,
 	return platform_device_register(pdev);
 }
 
+static struct resource resources_dmov[] = {
+	{
+		.start = QSD8X50_DMOV_PHYS,
+		.end = QSD8X50_DMOV_PHYS + QSD8X50_DMOV_SIZE - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = INT_ADM_AARM,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+struct platform_device msm_device_dmov = {
+	.name	= "msm_dmov",
+	.id	= -1,
+	.num_resources = ARRAY_SIZE(resources_dmov),
+	.resource = resources_dmov,
+};
+
 struct clk_lookup msm_clocks_8x50[] = {
-	CLK_PCOM("adm_clk",	ADM_CLK,	NULL, 0),
+	CLK_PCOM("adm_clk",	ADM_CLK,	"msm_dmov", 0),
 	CLK_PCOM("ce_clk",	CE_CLK,		NULL, 0),
 	CLK_PCOM("ebi1_clk",	EBI1_CLK,	NULL, CLK_MIN),
 	CLK_PCOM("ebi2_clk",	EBI2_CLK,	NULL, 0),
diff --git a/arch/arm/mach-msm/devices.h b/arch/arm/mach-msm/devices.h
index e7a0cb0..54ebfee 100644
--- a/arch/arm/mach-msm/devices.h
+++ b/arch/arm/mach-msm/devices.h
@@ -40,6 +40,8 @@ extern struct platform_device msm_device_i2c;
 
 extern struct platform_device msm_device_smd;
 
+extern struct platform_device msm_device_dmov;
+
 extern struct platform_device msm_device_nand;
 
 extern struct platform_device msm_device_mddi0;
diff --git a/arch/arm/mach-msm/dma.c b/arch/arm/mach-msm/dma.c
index 3ff31f9..3bafee9 100644
--- a/arch/arm/mach-msm/dma.c
+++ b/arch/arm/mach-msm/dma.c
@@ -20,10 +20,13 @@
 #include <linux/interrupt.h>
 #include <linux/completion.h>
 #include <linux/module.h>
+#include <linux/platform_device.h>
 #include <mach/dma.h>
 
 #define MSM_DMOV_CHANNEL_COUNT 16
 
+#define MODULE_NAME "msm_dmov"
+
 enum {
 	MSM_DMOV_PRINT_ERRORS = 1,
 	MSM_DMOV_PRINT_IO = 2,
@@ -37,11 +40,13 @@ static unsigned int channel_active;
 static struct list_head ready_commands[MSM_DMOV_CHANNEL_COUNT];
 static struct list_head active_commands[MSM_DMOV_CHANNEL_COUNT];
 unsigned int msm_dmov_print_mask = MSM_DMOV_PRINT_ERRORS;
+static void __iomem *msm_dmov_base;
+static unsigned msm_dmov_irq;
 
-#define DMOV_SD0(off, ch) (MSM_DMOV_BASE + 0x0000 + (off) + ((ch) << 2))
-#define DMOV_SD1(off, ch) (MSM_DMOV_BASE + 0x0400 + (off) + ((ch) << 2))
-#define DMOV_SD2(off, ch) (MSM_DMOV_BASE + 0x0800 + (off) + ((ch) << 2))
-#define DMOV_SD3(off, ch) (MSM_DMOV_BASE + 0x0C00 + (off) + ((ch) << 2))
+#define DMOV_SD0(off, ch) (msm_dmov_base + 0x0000 + (off) + ((ch) << 2))
+#define DMOV_SD1(off, ch) (msm_dmov_base + 0x0400 + (off) + ((ch) << 2))
+#define DMOV_SD2(off, ch) (msm_dmov_base + 0x0800 + (off) + ((ch) << 2))
+#define DMOV_SD3(off, ch) (msm_dmov_base + 0x0C00 + (off) + ((ch) << 2))
 
 #if defined(CONFIG_ARCH_MSM7X30)
 #define DMOV_SD_AARM DMOV_SD2
@@ -127,7 +132,7 @@ void msm_dmov_enqueue_cmd(unsigned id, struct msm_dmov_cmd *cmd)
 		PRINT_IO("msm_dmov_enqueue_cmd(%d), start command, status %x\n", id, status);
 		list_add_tail(&cmd->list, &active_commands[id]);
 		if (!channel_active)
-			enable_irq(INT_ADM_AARM);
+			enable_irq(msm_dmov_irq);
 		channel_active |= 1U << id;
 		writel(cmd->cmdptr, DMOV_CMD_PTR(id));
 	} else {
@@ -303,7 +308,7 @@ static irqreturn_t msm_datamover_irq_handler(int irq, void *dev_id)
 	}
 
 	if (!channel_active) {
-		disable_irq_nosync(INT_ADM_AARM);
+		disable_irq_nosync(msm_dmov_irq);
 		msm_dmov_clocks_off();
 	}
 
@@ -319,46 +324,79 @@ static void __init msm_dmov_deinit_clocks(void)
 		clk_put(msm_dmov_pclk);
 }
 
-static int __init msm_dmov_init_clocks(void)
+static int __devinit msm_dmov_init_clocks(struct platform_device *pdev)
 {
 	int ret = 0;
 
-	msm_dmov_clk = clk_get(NULL, "adm_clk");
+	msm_dmov_clk = clk_get(&pdev->dev, "adm_clk");
 	if (IS_ERR(msm_dmov_clk)) {
 		PRINT_ERROR("%s: Error getting adm_clk\n", __func__);
 		ret = PTR_ERR(msm_dmov_clk);
 	}
 
-	msm_dmov_pclk = clk_get(NULL, "adm_pclk");
+	msm_dmov_pclk = clk_get(&pdev->dev, "adm_pclk");
 	/* pclk not present on all SoCs, don't return error on failure */
 
 	return ret;
 }
 
-static int __init msm_init_datamover(void)
+static int __devinit msm_dmov_probe(struct platform_device *pdev)
 {
 	int i;
 	int ret;
+	struct resource *res;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENXIO;
+
+	msm_dmov_base = ioremap_nocache(res->start, resource_size(res));
+	if (!msm_dmov_base)
+		return -ENOMEM;
 
 	for (i = 0; i < MSM_DMOV_CHANNEL_COUNT; i++) {
 		INIT_LIST_HEAD(&ready_commands[i]);
 		INIT_LIST_HEAD(&active_commands[i]);
-		writel(DMOV_CONFIG_IRQ_EN | DMOV_CONFIG_FORCE_TOP_PTR_RSLT | DMOV_CONFIG_FORCE_FLUSH_RSLT, DMOV_CONFIG(i));
+		writel(DMOV_CONFIG_IRQ_EN | DMOV_CONFIG_FORCE_TOP_PTR_RSLT |
+		       DMOV_CONFIG_FORCE_FLUSH_RSLT, DMOV_CONFIG(i));
 	}
 
-	ret = msm_dmov_init_clocks();
+	ret = msm_dmov_init_clocks(pdev);
 	if (ret)
-		return ret;
+		goto out_map;
 
-	ret = request_irq(INT_ADM_AARM, msm_datamover_irq_handler, 0,
-			  "msmdatamover", NULL);
-	if (ret) {
-		msm_dmov_deinit_clocks();
-		return ret;
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res) {
+		ret = -EINVAL;
+		goto out_clock;
 	}
-	disable_irq(INT_ADM_AARM);
+
+	msm_dmov_irq = res->start;
+	ret = request_irq(msm_dmov_irq, msm_datamover_irq_handler, 0,
+			  "msmdatamover", NULL);
+	if (ret)
+		goto out_clock;
+	disable_irq(msm_dmov_irq);
+
 	return 0;
+out_clock:
+	msm_dmov_deinit_clocks();
+out_map:
+	iounmap(msm_dmov_base);
+	return ret;
 }
 
-arch_initcall(msm_init_datamover);
+static struct platform_driver msm_dmov_driver = {
+	.probe = msm_dmov_probe,
+	.driver = {
+		.name = MODULE_NAME,
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init msm_init_datamover(void)
+{
+	return platform_driver_register(&msm_dmov_driver);
+}
 
+arch_initcall(msm_init_datamover);
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h b/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
index 8f99d97..d6540e1 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
@@ -51,9 +51,8 @@
 #define MSM7X00_CSR_PHYS      0xC0100000
 #define MSM7X00_CSR_SIZE      SZ_4K
 
-#define MSM_DMOV_BASE         IOMEM(0xE0002000)
-#define MSM_DMOV_PHYS         0xA9700000
-#define MSM_DMOV_SIZE         SZ_4K
+#define MSM7X00_DMOV_PHYS     0xA9700000
+#define MSM7X00_DMOV_SIZE     SZ_4K
 
 #define MSM_GPIO1_BASE        IOMEM(0xE0003000)
 #define MSM_GPIO1_PHYS        0xA9200000
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h b/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
index 4d84be1..23912e5 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
@@ -42,9 +42,8 @@
 #define MSM7X30_CSR_PHYS      0xC0100000
 #define MSM7X30_CSR_SIZE      SZ_4K
 
-#define MSM_DMOV_BASE         IOMEM(0xE0002000)
-#define MSM_DMOV_PHYS         0xAC400000
-#define MSM_DMOV_SIZE         SZ_4K
+#define MSM7X30_DMOV_PHYS     0xAC400000
+#define MSM7X30_DMOV_SIZE     SZ_4K
 
 #define MSM_GPIO1_BASE        IOMEM(0xE0003000)
 #define MSM_GPIO1_PHYS        0xAC001000
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h
index d414320..fc36b82 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h
@@ -42,9 +42,8 @@
 #define QSD8X50_CSR_PHYS      0xAC100000
 #define QSD8X50_CSR_SIZE      SZ_4K
 
-#define MSM_DMOV_BASE         IOMEM(0xE0002000)
-#define MSM_DMOV_PHYS         0xA9700000
-#define MSM_DMOV_SIZE         SZ_4K
+#define QSD8X50_DMOV_PHYS     0xA9700000
+#define QSD8X50_DMOV_SIZE     SZ_4K
 
 #define MSM_GPIO1_BASE        IOMEM(0xE0003000)
 #define MSM_GPIO1_PHYS        0xA9000000
diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index cec6ed1..1c86cda 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -42,7 +42,6 @@
 static struct map_desc msm_io_desc[] __initdata = {
 	MSM_DEVICE(VIC),
 	MSM_CHIP_DEVICE(CSR, MSM7X00),
-	MSM_DEVICE(DMOV),
 	MSM_DEVICE(GPIO1),
 	MSM_DEVICE(GPIO2),
 	MSM_DEVICE(CLK_CTL),
@@ -75,7 +74,6 @@ void __init msm_map_common_io(void)
 static struct map_desc qsd8x50_io_desc[] __initdata = {
 	MSM_DEVICE(VIC),
 	MSM_CHIP_DEVICE(CSR, QSD8X50),
-	MSM_DEVICE(DMOV),
 	MSM_DEVICE(GPIO1),
 	MSM_DEVICE(GPIO2),
 	MSM_DEVICE(CLK_CTL),
@@ -134,7 +132,6 @@ void __init msm_map_msm8960_io(void)
 static struct map_desc msm7x30_io_desc[] __initdata = {
 	MSM_DEVICE(VIC),
 	MSM_CHIP_DEVICE(CSR, MSM7X30),
-	MSM_DEVICE(DMOV),
 	MSM_DEVICE(GPIO1),
 	MSM_DEVICE(GPIO2),
 	MSM_DEVICE(CLK_CTL),
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

