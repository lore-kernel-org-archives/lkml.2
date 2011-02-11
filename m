Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab1BKBuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 20:50:08 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:34868 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231Ab1BKBuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 20:50:06 -0500
Date: Thu, 10 Feb 2011 17:49:58 -0800
From: Andres Salomon <dilinger@queued.net>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, jon.nettleton@gmail.com,
        devel@driverdev.osuosl.org
Subject: [PATCH 05/10] olpc_dcon: drop XO-1.5 prototype support
Message-ID: <20110210174958.0c0f5847@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove code related to XO-1.5 prototype boards.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c |   84 +++++++-------------------
 1 files changed, 23 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c b/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c
index 4f56098..5ef0540 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c
@@ -10,19 +10,15 @@
 
 /* Hardware setup on the XO 1.5:
  * 	DCONLOAD connects to
- *		VX855_GPO12 (not nCR_PWOFF)   (rev A)
- *		VX855_GPIO1 (not SMBCK2)      (rev B)
+ *		VX855_GPIO1 (not SMBCK2)
  * 	DCONBLANK connects to VX855_GPIO8 (not SSPICLK)  unused in driver
  *	DCONSTAT0 connects to VX855_GPI10 (not SSPISDI)
  *	DCONSTAT1 connects to VX855_GPI11 (not nSSPISS)
- *	DCONIRQ connects to VX855_GPIO12 (on B3.  on B2, it goes to
- *		SMBALRT, which doesn't work.)
+ *	DCONIRQ connects to VX855_GPIO12
  *	DCONSMBDATA connects to VX855 graphics CRTSPD
  *	DCONSMBCLK connects to VX855 graphics CRTSPCLK
  */
 
-#define TEST_B2 0   // define to test B3 paths on a modded B2 board
-
 #define VX855_GENL_PURPOSE_OUTPUT 0x44c // PMIO_Rx4c-4f
 #define VX855_GPI_STATUS_CHG 0x450  // PMIO_Rx50
 #define VX855_GPI_SCI_SMI 0x452  // PMIO_Rx52
@@ -30,34 +26,21 @@
 
 #define PREFIX "OLPC DCON:"
 
-/*
-  there is no support here for DCONIRQ on 1.5 boards earlier than
-  B3.  the issue is that the DCONIRQ signal on earlier boards is
-  routed to SMBALRT, which turns out to to be a level sensitive
-  interrupt.  the DCONIRQ signal is far too short (11usec) to
-  be detected reliably in that case.  including support for
-  DCONIRQ functions no better than none at all.
-*/
-
 static struct dcon_platform_data dcon_pdata_xo_1_5;
 
 static void dcon_clear_irq(void)
 {
-	if (TEST_B2 || olpc_board_at_least(olpc_board(BOARD_XO_1_5_B3))) {
-		// irq status will appear in PMIO_Rx50[6] (RW1C) on gpio12
-		outb(BIT_GPIO12, VX855_GPI_STATUS_CHG);
-	}
+	/* irq status will appear in PMIO_Rx50[6] (RW1C) on gpio12 */
+	outb(BIT_GPIO12, VX855_GPI_STATUS_CHG);
 }
 
 static int dcon_was_irq(void)
 {
 	u_int8_t tmp;
 
-	if (TEST_B2 || olpc_board_at_least(olpc_board(BOARD_XO_1_5_B3))) {
-		// irq status will appear in PMIO_Rx50[6] on gpio12
-		tmp = inb(VX855_GPI_STATUS_CHG);
-		return !!(tmp & BIT_GPIO12);
-	}
+	/* irq status will appear in PMIO_Rx50[6] on gpio12 */
+	tmp = inb(VX855_GPI_STATUS_CHG);
+	return !!(tmp & BIT_GPIO12);
 
 	return 0;
 }
@@ -76,14 +59,8 @@ static int dcon_init_xo_1_5(void)
 		return 1;
 	}
 
-	if (olpc_board_at_least(olpc_board(BOARD_XO_1_5_B1))) {
-		pci_read_config_byte(pdev, 0x95, &tmp);
-		pci_write_config_byte(pdev, 0x95, tmp|0x0c);
-	} else {
-		/* Set GPO12 to GPO mode, not nCR_PWOFF */
-		pci_read_config_byte(pdev, 0x9b, &tmp);
-		pci_write_config_byte(pdev, 0x9b, tmp|0x01);
-	}
+	pci_read_config_byte(pdev, 0x95, &tmp);
+	pci_write_config_byte(pdev, 0x95, tmp|0x0c);
 
 	/* Set GPIO8 to GPIO mode, not SSPICLK */
 	pci_read_config_byte(pdev, 0xe3, &tmp);
@@ -93,31 +70,22 @@ static int dcon_init_xo_1_5(void)
 	pci_read_config_byte(pdev, 0xe4, &tmp);
 	pci_write_config_byte(pdev, 0xe4, tmp|0x08);
 
-	if (TEST_B2 || olpc_board_at_least(olpc_board(BOARD_XO_1_5_B3))) {
-		// clear PMU_RxE1[6] to select SCI on GPIO12
-		// clear PMU_RxE0[6] to choose falling edge
-		pci_read_config_byte(pdev, 0xe1, &tmp);
-		pci_write_config_byte(pdev, 0xe1, tmp & ~BIT_GPIO12);
-		pci_read_config_byte(pdev, 0xe0, &tmp);
-		pci_write_config_byte(pdev, 0xe0, tmp & ~BIT_GPIO12);
-
-		dcon_clear_irq();
+	/* clear PMU_RxE1[6] to select SCI on GPIO12 */
+	/* clear PMU_RxE0[6] to choose falling edge */
+	pci_read_config_byte(pdev, 0xe1, &tmp);
+	pci_write_config_byte(pdev, 0xe1, tmp & ~BIT_GPIO12);
+	pci_read_config_byte(pdev, 0xe0, &tmp);
+	pci_write_config_byte(pdev, 0xe0, tmp & ~BIT_GPIO12);
 
-		// set   PMIO_Rx52[6] to enable SCI/SMI on gpio12
-		outb(inb(VX855_GPI_SCI_SMI)|BIT_GPIO12, VX855_GPI_SCI_SMI);
+	dcon_clear_irq();
 
-	}
+	/* set   PMIO_Rx52[6] to enable SCI/SMI on gpio12 */
+	outb(inb(VX855_GPI_SCI_SMI)|BIT_GPIO12, VX855_GPI_SCI_SMI);
 
 	/* Determine the current state of DCONLOAD, likely set by firmware */
-	if (olpc_board_at_least(olpc_board(BOARD_XO_1_5_B1))) {
-		// GPIO1
-		dcon_source = (inl(VX855_GENL_PURPOSE_OUTPUT) & 0x1000) ?
-			DCON_SOURCE_CPU : DCON_SOURCE_DCON;
-	} else {
-		// GPO12
-		dcon_source = (inl(VX855_GENL_PURPOSE_OUTPUT) & 0x04000000) ?
+	/* GPIO1 */
+	dcon_source = (inl(VX855_GENL_PURPOSE_OUTPUT) & 0x1000) ?
 			DCON_SOURCE_CPU : DCON_SOURCE_DCON;
-	}
 	dcon_pending = dcon_source;
 
 	pci_dev_put(pdev);
@@ -180,19 +148,13 @@ static void dcon_wiggle_xo_1_5(void)
 	}
 	udelay(5);
 
-	if (TEST_B2 || olpc_board_at_least(olpc_board(BOARD_XO_1_5_B3))) {
-		// set   PMIO_Rx52[6] to enable SCI/SMI on gpio12
-		outb(inb(VX855_GPI_SCI_SMI)|BIT_GPIO12, VX855_GPI_SCI_SMI);
-	}
+	/* set   PMIO_Rx52[6] to enable SCI/SMI on gpio12 */
+	outb(inb(VX855_GPI_SCI_SMI)|BIT_GPIO12, VX855_GPI_SCI_SMI);
 }
 
 static void dcon_set_dconload_xo_1_5(int val)
 {
-	if (olpc_board_at_least(olpc_board(BOARD_XO_1_5_B1))) {
-		gpio_set_value(VX855_GPIO(1), val);
-	} else {
-		gpio_set_value(VX855_GPO(12), val);
-	}
+	gpio_set_value(VX855_GPIO(1), val);
 }
 
 static u8 dcon_read_status_xo_1_5(void)
-- 
1.7.2.3

