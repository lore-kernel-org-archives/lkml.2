Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab1GQFFA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 01:05:00 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:43992 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab1GQFE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 01:04:57 -0400
Subject: [PATCH] tpm: Move tpm_tis_reenable_interrupts out of CONFIG_PNP
 block
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: sfr@canb.auug.org.au, Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Jul 2011 01:04:24 -0400
Message-ID: <1310879064.15064.4.camel@d941e-10>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the tpm_tis_reenable_interrupts function out of the
CONFIG_PNP-surrounded #define block. This solves a compilation error in
case CONFIG_PNP is not defined.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

---
 drivers/char/tpm/tpm_tis.c |   45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

Index: linux-2.6/drivers/char/tpm/tpm_tis.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm_tis.c
+++ linux-2.6/drivers/char/tpm/tpm_tis.c
@@ -731,6 +731,29 @@ out_err:
 	tpm_remove_hardware(chip->dev);
 	return rc;
 }
+
+static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
+{
+	u32 intmask;
+
+	/* reenable interrupts that device may have lost or
+	   BIOS/firmware may have disabled */
+	iowrite8(chip->vendor.irq, chip->vendor.iobase +
+		 TPM_INT_VECTOR(chip->vendor.locality));
+
+	intmask =
+	    ioread32(chip->vendor.iobase +
+		     TPM_INT_ENABLE(chip->vendor.locality));
+
+	intmask |= TPM_INTF_CMD_READY_INT
+	    | TPM_INTF_LOCALITY_CHANGE_INT | TPM_INTF_DATA_AVAIL_INT
+	    | TPM_INTF_STS_VALID_INT | TPM_GLOBAL_INT_ENABLE;
+
+	iowrite32(intmask,
+		  chip->vendor.iobase + TPM_INT_ENABLE(chip->vendor.locality));
+}
+
+
 #ifdef CONFIG_PNP
 static int __devinit tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
 				      const struct pnp_device_id *pnp_id)
@@ -757,28 +780,6 @@ static int tpm_tis_pnp_suspend(struct pn
 	return tpm_pm_suspend(&dev->dev, msg);
 }
 
-static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
-{
-	u32 intmask;
-
-	/* reenable interrupts that device may have lost or
-	   BIOS/firmware may have disabled */
-	iowrite8(chip->vendor.irq, chip->vendor.iobase +
-		 TPM_INT_VECTOR(chip->vendor.locality));
-
-	intmask =
-	    ioread32(chip->vendor.iobase +
-		     TPM_INT_ENABLE(chip->vendor.locality));
-
-	intmask |= TPM_INTF_CMD_READY_INT
-	    | TPM_INTF_LOCALITY_CHANGE_INT | TPM_INTF_DATA_AVAIL_INT
-	    | TPM_INTF_STS_VALID_INT | TPM_GLOBAL_INT_ENABLE;
-
-	iowrite32(intmask,
-		  chip->vendor.iobase + TPM_INT_ENABLE(chip->vendor.locality));
-}
-
-
 static int tpm_tis_pnp_resume(struct pnp_dev *dev)
 {
 	struct tpm_chip *chip = pnp_get_drvdata(dev);

