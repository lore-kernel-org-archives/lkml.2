Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab1COLOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 07:14:41 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:48111 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757253Ab1COLOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 07:14:34 -0400
Message-Id: <20110315111425.977309317@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 15 Mar 2011 07:13:09 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, preining@logic.at,
        Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [patch 2/8] tpm_tis: Re-enable interrupts upon (S3) resume
References: <20110315111307.895085413@linux.vnet.ibm.com>
Content-Disposition: inline; filename=tpm_irq_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:
  - the patch was adapted to also work with a machine with a Intel iTPM

This patch makes sure that if the TPM TIS interface is run in interrupt mode
(rather than polling mode) that all interrupts are enabled in the TPM's
interrupt enable register after a resume from ACPI S3 suspend. The registers
may either have been cleared by the TPM loosing its state during device sleep
or by the BIOS leaving the TPM in polling mode (after sending a command to
the TPM for starting it up again)

You may want to check if your TPM runs with interrupts by doing

cat /proc/interrupts | grep -i tpm

and see whether there is an entry or otherwise for it to use interrupts:

modprobe tpm_tis interrupts=1 [add 'itpm=1' for Intel TPM ]

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

---
 drivers/char/tpm/tpm_tis.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

Index: linux-2.6/drivers/char/tpm/tpm_tis.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm_tis.c
+++ linux-2.6/drivers/char/tpm/tpm_tis.c
@@ -647,11 +647,36 @@ static int tpm_tis_pnp_suspend(struct pn
 	return tpm_pm_suspend(&dev->dev, msg);
 }
 
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
 static int tpm_tis_pnp_resume(struct pnp_dev *dev)
 {
 	struct tpm_chip *chip = pnp_get_drvdata(dev);
 	int ret;
 
+	if (chip->vendor.irq)
+		tpm_tis_reenable_interrupts(chip);
+
 	ret = tpm_pm_resume(&dev->dev);
 	if (!ret)
 		tpm_continue_selftest(chip);
@@ -704,6 +729,11 @@ static int tpm_tis_suspend(struct platfo
 
 static int tpm_tis_resume(struct platform_device *dev)
 {
+	struct tpm_chip *chip = dev_get_drvdata(&dev->dev);
+
+	if (chip->vendor.irq)
+		tpm_tis_reenable_interrupts(chip);
+
 	return tpm_pm_resume(&dev->dev);
 }
 static struct platform_driver tis_drv = {

