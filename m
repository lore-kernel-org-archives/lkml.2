Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab2BUEsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 23:48:43 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61019 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab2BUEsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 23:48:42 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of tomoya.rohm@gmail.com designates 10.68.221.9 as permitted sender) smtp.mail=tomoya.rohm@gmail.com; dkim=pass header.i=tomoya.rohm@gmail.com
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, feng.tang@intel.com, dvhart@linux.intel.com,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH] misc/pch_phub: Change UART clock setting 192MHz
Date: Tue, 21 Feb 2012 13:48:09 +0900
Message-Id: <1329799689-3868-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, PCH_UART uses UART_CLK(provided by external) as default clock.
So, according to user environment, users need to care both clock
setting and baud rate.

This patch uses internal clock (USB 48MHz) as base of UART clock.
Using this clock, users don't have to care clock setting.
Additionally, the clock multiplied 4, namely the clock is 192MHz,
the clock can cover almost UART range.

This setting is the same as quirk for CM-iTC board.
So, delete the quirk.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/misc/pch_phub.c |   35 ++++++++++++++++++++++++++---------
 1 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index 10fc478..4ef9285 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -55,7 +55,7 @@
 #define CLKCFG_CANCLK_MASK 0xFF000000
 #define CLKCFG_UART_MASK			0xFFFFFF
 
-/* CM-iTC */
+/* 192MHz Clock configuration. USB_48MHz * 8 / 2 = 192 */
 #define CLKCFG_UART_48MHZ			(1 << 16)
 #define CLKCFG_BAUDDIV				(2 << 20)
 #define CLKCFG_PLL2VCO				(8 << 9)
@@ -731,14 +731,11 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 					       CLKCFG_CAN_50MHZ,
 					       CLKCFG_CANCLK_MASK);
 
-		/* quirk for CM-iTC board */
-		board_name = dmi_get_system_info(DMI_BOARD_NAME);
-		if (board_name && strstr(board_name, "CM-iTC"))
-			pch_phub_read_modify_write_reg(chip,
-						(unsigned int)CLKCFG_REG_OFFSET,
-						CLKCFG_UART_48MHZ | CLKCFG_BAUDDIV |
-						CLKCFG_PLL2VCO | CLKCFG_UARTCLKSEL,
-						CLKCFG_UART_MASK);
+		pch_phub_read_modify_write_reg(chip,
+					(unsigned int)CLKCFG_REG_OFFSET,
+					CLKCFG_UART_48MHZ | CLKCFG_BAUDDIV |
+					CLKCFG_PLL2VCO | CLKCFG_UARTCLKSEL,
+					CLKCFG_UART_MASK);
 
 		/* set the prefech value */
 		iowrite32(0x000affaa, chip->pch_phub_base_address + 0x14);
@@ -750,6 +747,13 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 		retval = sysfs_create_bin_file(&pdev->dev.kobj, &pch_bin_attr);
 		if (retval)
 			goto err_sysfs_create;
+
+		pch_phub_read_modify_write_reg(chip,
+			(unsigned int)CLKCFG_REG_OFFSET,
+			CLKCFG_UART_48MHZ | CLKCFG_BAUDDIV |
+			CLKCFG_PLL2VCO | CLKCFG_UARTCLKSEL,
+			CLKCFG_UART_MASK);
+
 		/* set the prefech value
 		 * Device2(USB OHCI #1/ USB EHCI #1/ USB Device):a
 		 * Device4(SDIO #0,1,2):f
@@ -777,6 +781,13 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 		retval = sysfs_create_bin_file(&pdev->dev.kobj, &pch_bin_attr);
 		if (retval)
 			goto exit_bin_attr;
+
+		pch_phub_read_modify_write_reg(chip,
+					(unsigned int)CLKCFG_REG_OFFSET,
+					CLKCFG_UART_48MHZ | CLKCFG_BAUDDIV |
+					CLKCFG_PLL2VCO | CLKCFG_UARTCLKSEL,
+					CLKCFG_UART_MASK);
+
 		/* set the prefech value
 		 * Device2(USB OHCI #0,1,2,3/ USB EHCI #0):a
 		 * Device4(SDIO #0,1):f
@@ -796,6 +807,12 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 		if (retval)
 			goto exit_bin_attr;
 
+		pch_phub_read_modify_write_reg(chip,
+					(unsigned int)CLKCFG_REG_OFFSET,
+					CLKCFG_UART_48MHZ | CLKCFG_BAUDDIV |
+					CLKCFG_PLL2VCO | CLKCFG_UARTCLKSEL,
+					CLKCFG_UART_MASK);
+
 		/* set the prefech value */
 		iowrite32(0x000affaa, chip->pch_phub_base_address + 0x14);
 		/* set the interrupt delay value */
-- 
1.7.7.6

