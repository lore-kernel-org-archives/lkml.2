Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab1CAHp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 02:45:58 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:58007 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab1CAHp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 02:45:57 -0500
Subject: [PATCH v2] tpm_tis: Re-enable interrupts upon resume
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: preining@logic.at,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        "debora@linux.vnet.ibm.com" <debora@linux.vnet.ibm.com>
In-Reply-To: <1298404199.25819.15.camel@d941e-10>
References: <1298404199.25819.15.camel@d941e-10>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 02:45:50 -0500
Message-ID: <1298965550.20975.6.camel@d941e-10>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:
  - the patch was adapted to also work with a machine with a Intel TPM


Below patch applies to the tip of the git tree.

This patch makes sure that if the TPM TIS interface is run in interrupt
mode (rather than polling mode) that the interrupts are enabled in the
TPM's interrupt enable register which may either have been cleared by
the TPM's TIS loosing its state during device sleep in ACPI S3 (suspend)
or by the BIOS, which upon resume sends a TPM_Startup() command to the
TPM, and may run the TPM in polling mode and leave the TIS interrupts
disabled once it transfers control to the OS again.

You may want to check if your TPM runs with interrupts by doing

cat /proc/interrupts | grep -i tpm

and see whether there is an entry or otherwise for it to use interrupts:

modprobe tpm_tis interrupts=1 [add 'itpm=1' for Intel TPM ]


Signed-off-by: Stefan Berger <stefanb@us.ibm.com>

---
 drivers/char/tpm/tpm_tis.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

Index: linux-2.6/drivers/char/tpm/tpm_tis.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm_tis.c
+++ linux-2.6/drivers/char/tpm/tpm_tis.c
@@ -647,11 +647,37 @@ static int tpm_tis_pnp_suspend(struct pn
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
+		  chip->vendor.iobase +
+		  TPM_INT_ENABLE(chip->vendor.locality));
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
@@ -704,6 +730,11 @@ static int tpm_tis_suspend(struct platfo
 
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

