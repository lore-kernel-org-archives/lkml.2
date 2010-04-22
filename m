Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab0DVNWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 09:22:15 -0400
Received: from india.einfochips.com ([203.88.139.151]:49709 "EHLO
	ahmedabad.einfochips.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754602Ab0DVNWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 09:22:13 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Apr 2010 09:22:12 EDT
From: Tanmay Upadhyay <tanmay.upadhyay@einfochips.com>
To: dhaval.vasa@einfochips.com
Cc: linux-kernel@vger.kernel.org,
       Tanmay Upadhyay <tanmay.upadhyay@einfochips.com>
Subject: [PATCH] OpenRD: Enable SD/UART selection for serial port 1
Date: Thu, 22 Apr 2010 18:46:36 +0530
Message-Id: <1271942196-25613-1-git-send-email-tanmay.upadhyay@einfochips.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <no>
References: <no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables user to use serial port 1 of the OpenRD device for SDIO
or UART(RS232/RS485). The selection can be done through kernel parameter.

By default the port would be used for SDIO. To select RS232 or RS485 mode,
pass string "uart=232" or "uart=485" respectively in the kernel parameters.
"uart=485" is ignored on OpenRD-Base as it doesn't have RS485 port.

Signed-off-by: Tanmay Upadhyay <tanmay.upadhyay@einfochips.com>
---
 arch/arm/mach-kirkwood/openrd-setup.c |   67 ++++++++++++++++++++++++++++++++-
 1 files changed, 66 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-kirkwood/openrd-setup.c b/arch/arm/mach-kirkwood/openrd-setup.c
index ad3f1ec..fb4bfad 100644
--- a/arch/arm/mach-kirkwood/openrd-setup.c
+++ b/arch/arm/mach-kirkwood/openrd-setup.c
@@ -15,6 +15,8 @@
 #include <linux/mtd/partitions.h>
 #include <linux/ata_platform.h>
 #include <linux/mv643xx_eth.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <mach/kirkwood.h>
@@ -56,16 +58,58 @@ static struct mvsdio_platform_data openrd_mvsdio_data = {
 };
 
 static unsigned int openrd_mpp_config[] __initdata = {
+	MPP12_SD_CLK,
+	MPP13_SD_CMD,
+	MPP14_SD_D0,
+	MPP15_SD_D1,
+	MPP16_SD_D2,
+	MPP17_SD_D3,
 	MPP29_GPIO,
 	0
 };
 
+static int sd_uart_selection(void)
+{
+	/* Parse boot_command_line string uart=no/232/485 */
+	char *ptr = strstr(boot_command_line, "uart=");
+
+	/* Default is SD. Change if required, for UART */
+	if (ptr != NULL) {
+		if (!strncmp(ptr + 5, "232", 3)) {
+			/* Configure MPP for UART */
+			openrd_mpp_config[1] = MPP13_UART1_TXD;
+			openrd_mpp_config[2] = MPP14_UART1_RXD;
+
+			return 232;
+		} else if (!strncmp(ptr + 5, "485", 3)) {
+			/* OpenRD-Base doesn't have RS485. Treat is as an
+			 * unknown argument & just have default setting -
+			 * which is SD */
+			if (machine_is_openrd_base())
+				return 0;
+
+			/* Configure MPP for UART */
+			openrd_mpp_config[1] = MPP13_UART1_TXD;
+			openrd_mpp_config[2] = MPP14_UART1_RXD;
+
+			return 485;
+		}
+	}
+	return 0;
+}
+
 static void __init openrd_init(void)
 {
+	int uart1;
+
 	/*
 	 * Basic setup. Needs to be called early.
 	 */
 	kirkwood_init();
+
+	/* This function modifies MPP config according to boot argument */
+	uart1 = sd_uart_selection();
+
 	kirkwood_mpp_conf(openrd_mpp_config);
 
 	kirkwood_uart0_init();
@@ -77,9 +121,30 @@ static void __init openrd_init(void)
 	if (machine_is_openrd_client())
 		kirkwood_ge01_init(&openrd_ge01_data);
 	kirkwood_sata_init(&openrd_sata_data);
-	kirkwood_sdio_init(&openrd_mvsdio_data);
 
 	kirkwood_i2c_init();
+
+	if (!uart1) {
+		/* Select SD
+		 * Pin # 34: 0 => UART1, 1 => SD */
+		writel(readl(GPIO_OUT(34)) | 4, GPIO_OUT(34));
+
+		kirkwood_sdio_init(&openrd_mvsdio_data);
+	} else {
+		/* Select UART1
+		 * Pin # 34: 0 => UART1, 1 => SD */
+		writel(readl(GPIO_OUT(34)) & ~(4), GPIO_OUT(34));
+
+		/* Select RS232 OR RS485
+		 * Pin # 28: 0 => RS232, 1 => RS485 */
+		if (uart1 == 232)
+			writel(readl(GPIO_OUT(28)) & ~(0x10000000),
+				GPIO_OUT(28));
+		else
+			writel(readl(GPIO_OUT(28)) | 0x10000000, GPIO_OUT(28));
+
+		kirkwood_uart1_init();
+	}
 }
 
 static int __init openrd_pci_init(void)
-- 
1.6.6.1

-- 
_____________________________________________________________________
Disclaimer: This e-mail message and all attachments transmitted with it
are intended solely for the use of the addressee and may contain legally
privileged and confidential information. If the reader of this message
is not the intended recipient, or an employee or agent responsible for
delivering this message to the intended recipient, you are hereby
notified that any dissemination, distribution, copying, or other use of
this message or its attachments is strictly prohibited. If you have
received this message in error, please notify the sender immediately by
replying to this message and please delete it from your computer. Any
views expressed in this message are those of the individual sender
unless otherwise stated.Company has taken enough precautions to prevent
the spread of viruses. However the company accepts no liability for any
damage caused by any virus transmitted by this email.
_____________________________________________________________________
 
