Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab2GKJ6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 05:58:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51374 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab2GKJ6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 05:58:19 -0400
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH] misc/pch_phub: Enable UART clock setting by module parameter
Date: Wed, 11 Jul 2012 18:57:50 +0900
Message-Id: <1342000670-1005-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, when a user wants to change UART clock,
needs to modify this source code by hand.
This patch enables changing UART clock by specifying UART clock
as module parameter.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/misc/pch_phub.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index 9fbcacd..2e7b0b0 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -93,6 +93,18 @@
 
 #define PCH_PHUB_OROM_SIZE 15360
 
+#define CLKCFG_BAUDDIV2				(2 << 20)
+#define CLKCFG_BAUDDIV6				(6 << 20)
+#define CLKCFG_PLL2VCO8				(8 << 9)
+
+#define PCH_PHUB_REFCLK_48MHZ	CLKCFG_UART_48MHZ
+
+#define PCH_PHUB_REFCLK_64MHZ	(CLKCFG_UART_48MHZ | CLKCFG_BAUDDIV6 |\
+				CLKCFG_PLL2VCO8 | CLKCFG_UARTCLKSEL)
+
+#define PCH_PHUB_REFCLK_192MHZ	(CLKCFG_UART_48MHZ | CLKCFG_BAUDDIV2 |\
+				CLKCFG_PLL2VCO8 | CLKCFG_UARTCLKSEL)
+
 /**
  * struct pch_phub_reg - PHUB register structure
  * @phub_id_reg:			PHUB_ID register val
@@ -142,6 +154,8 @@ struct pch_phub_reg {
 /* SROM SPEC for MAC address assignment offset */
 static const int pch_phub_mac_offset[ETH_ALEN] = {0x3, 0x2, 0x1, 0x0, 0xb, 0xa};
 
+static unsigned int select_uart_clk;
+
 static DEFINE_MUTEX(pch_phub_mutex);
 
 /**
@@ -710,6 +724,34 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 
 	chip->pdev = pdev; /* Save pci device struct */
 
+	/* Reference clock setting. ML7223 bus-m doesn't have clock register. */
+	if (select_uart_clk && id->driver_data != 3) {
+		unsigned int clk_val;
+		switch (select_uart_clk) {
+		case 48000000:
+		case 48:
+			clk_val = PCH_PHUB_REFCLK_48MHZ;
+			break;
+		case 64000000:
+		case 64:
+			clk_val = PCH_PHUB_REFCLK_64MHZ;
+			break;
+		case 192000000:
+		case 192:
+			clk_val = PCH_PHUB_REFCLK_192MHZ;
+			break;
+		default:
+			dev_err(&pdev->dev,
+				"%s : Invalid clock(Only 48/64/192MHz).\n",
+				__func__);
+			goto err_sysfs_create;
+		}
+		pch_phub_read_modify_write_reg(chip,
+					      (unsigned int)CLKCFG_REG_OFFSET,
+					       clk_val, CLKCFG_UART_MASK);
+	}
+
+
 	if (id->driver_data == 1) { /* EG20T PCH */
 		const char *board_name;
 
@@ -908,3 +950,6 @@ module_exit(pch_phub_pci_exit);
 
 MODULE_DESCRIPTION("Intel EG20T PCH/LAPIS Semiconductor IOH(ML7213/ML7223) PHUB");
 MODULE_LICENSE("GPL");
+module_param(select_uart_clk, uint, S_IRUGO);
+MODULE_PARM_DESC(select_uart_clk,
+		 "Select clock for UART (48/64/192MHz). default is 1.8342MHz");
-- 
1.7.4.4

