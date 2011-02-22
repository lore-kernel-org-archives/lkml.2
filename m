Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab1BVTuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 14:50:07 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:46772 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab1BVTuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 14:50:06 -0500
Subject: [PATCH] tpm_tis: Re-enable interrupts upon resume
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: Jiri Slaby <jirislaby@gmail.com>, preining@logic.at,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        "debora@linux.vnet.ibm.com" <debora@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Feb 2011 14:49:59 -0500
Message-ID: <1298404199.25819.15.camel@d941e-10>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below patch applies to the tip of the git tree.

This patch makes sure that if the TPM TIS interface is run in interrupt
mode (rather than polling mode) that the interrupts are enabled in the
TPM's interrupt enable register which may either have been cleared by
the TPM's TIS loosing its state during device sleep in ACPI S3 (suspend)
or by the BIOS, which upon resume sends a TPM_Startup() command to the
TPM, and may run the TPM in polling mode and leave the TIS interrupts
disabled once it transfers control to the OS again.

Problem is, I don't currently have a machine running the TPM in
interrupt mode. I found this through a self-built TPM device model for
Qemu and SeaBIOS patches, where this does resolve a problem upon resume.

You may want to check if your TPM runs with interrupts by doing

cat /proc/interrupts | grep -i tpm

and see whether there is an entry.


Signed-off-by: Stefan Berger <stefanb@us.ibm.com>


Index: linux-2.6/drivers/char/tpm/tpm_tis.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm_tis.c
+++ linux-2.6/drivers/char/tpm/tpm_tis.c
@@ -651,6 +651,23 @@ static int tpm_tis_pnp_resume(struct pnp
 {
 	struct tpm_chip *chip = pnp_get_drvdata(dev);
 	int ret;
+	u32 intmask;
+
+	if (chip->vendor.irq) {
+		/* reenable interrupts that device may have lost or
+		   BIOS/firmware may have disabled */
+		intmask =
+		    ioread32(chip->vendor.iobase +
+			     TPM_INT_ENABLE(chip->vendor.locality));
+
+		intmask |= TPM_INTF_CMD_READY_INT
+		    | TPM_INTF_LOCALITY_CHANGE_INT | TPM_INTF_DATA_AVAIL_INT
+		    | TPM_INTF_STS_VALID_INT | TPM_GLOBAL_INT_ENABLE;
+
+		iowrite32(intmask,
+			  chip->vendor.iobase +
+			  TPM_INT_ENABLE(chip->vendor.locality));
+	}
 
 	ret = tpm_pm_resume(&dev->dev);
 	if (!ret)

