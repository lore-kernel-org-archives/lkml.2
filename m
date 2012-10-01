Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab2JAVwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 17:52:44 -0400
Received: from lunge.queued.net ([173.255.254.236]:58891 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab2JAVwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 17:52:42 -0400
X-Greylist: delayed 418 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Oct 2012 17:52:42 EDT
Date: Mon, 1 Oct 2012 14:46:11 -0700
From: Andres Salomon <dilinger@queued.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jon Nettleton <jon.nettleton@gmail.com>, Chris Ball <cjb@laptop.org>
Subject: [PATCH 4/5] staging/olpc_dcon: drop pin frobbing code for xo1.5
Message-ID: <20121001144611.735938b2@debxo>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This code looks in the PCI config space for pin addresses and sets up some
stuff.  However, Openfirmware has already done this for us, so there's no
need to ever do it in Linux.  According to Mitch Bradley, this OFW has been
doing this for us since at least B3 builds (pre-mass production).

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c |   30 --------------------------
 1 file changed, 30 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c b/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c
index 352dd3d..6a4d379 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c
@@ -10,7 +10,6 @@
 
 #include <linux/acpi.h>
 #include <linux/delay.h>
-#include <linux/pci.h>
 #include <linux/gpio.h>
 #include <asm/olpc.h>
 
@@ -62,33 +61,6 @@ static int dcon_was_irq(void)
 static int dcon_init_xo_1_5(struct dcon_priv *dcon)
 {
 	unsigned int irq;
-	u_int8_t tmp;
-	struct pci_dev *pdev;
-
-	pdev = pci_get_device(PCI_VENDOR_ID_VIA,
-			      PCI_DEVICE_ID_VIA_VX855, NULL);
-	if (!pdev) {
-		pr_err("cannot find VX855 PCI ID\n");
-		return 1;
-	}
-
-	pci_read_config_byte(pdev, 0x95, &tmp);
-	pci_write_config_byte(pdev, 0x95, tmp|0x0c);
-
-	/* Set GPIO8 to GPIO mode, not SSPICLK */
-	pci_read_config_byte(pdev, 0xe3, &tmp);
-	pci_write_config_byte(pdev, 0xe3, tmp | 0x04);
-
-	/* Set GPI10/GPI11 to GPI mode, not SSPISDI/SSPISS */
-	pci_read_config_byte(pdev, 0xe4, &tmp);
-	pci_write_config_byte(pdev, 0xe4, tmp|0x08);
-
-	/* clear PMU_RxE1[6] to select SCI on GPIO12 */
-	/* clear PMU_RxE0[6] to choose falling edge */
-	pci_read_config_byte(pdev, 0xe1, &tmp);
-	pci_write_config_byte(pdev, 0xe1, tmp & ~BIT_GPIO12);
-	pci_read_config_byte(pdev, 0xe0, &tmp);
-	pci_write_config_byte(pdev, 0xe0, tmp & ~BIT_GPIO12);
 
 	dcon_clear_irq();
 
@@ -101,8 +73,6 @@ static int dcon_init_xo_1_5(struct dcon_priv *dcon)
 			DCON_SOURCE_CPU : DCON_SOURCE_DCON;
 	dcon->pending_src = dcon->curr_src;
 
-	pci_dev_put(pdev);
-
 	/* we're sharing the IRQ with ACPI */
 	irq = acpi_gbl_FADT.sci_interrupt;
 	if (request_irq(irq, &dcon_interrupt, IRQF_SHARED, "DCON", dcon)) {
-- 
1.7.10.4

