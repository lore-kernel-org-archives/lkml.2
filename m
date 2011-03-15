Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab1COLOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 07:14:47 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:42269 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259Ab1COLOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 07:14:34 -0400
Message-Id: <20110315111427.833354300@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 15 Mar 2011 07:13:14 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, preining@logic.at,
        Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [patch 7/8] tpm_tis: Probing function for Intel iTPM bug
References: <20110315111307.895085413@linux.vnet.ibm.com>
Content-Disposition: inline; filename=tis_probe_itpm.v2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a function for automatic probing for the Intel iTPM
STS_DATA_EXPECT flaw.

I split the current tpm_tis_send function into 2 parts where the 1st part is
now called tpm_tis_send_data() and merely sends the data to the TPM. I am using
that function for probing. The new tpm_tis_send function now first calls
tpm_tis_send_data and if that succeeds has the TPM process the command and
waits until the response is there.

The probing for the Intel iTPM is only invoked if the user has not passed
itpm=1 as parameter for the module *or* if such a TPM was detected via ACPI.
Previously it was necessary to pass itpm=1 when also passing force=1 to the
module when doing a 'modprobe'. This function is more general than the ACPI
test function and the function relying on ACPI could probably be removed.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

---
 drivers/char/tpm/tpm_tis.c |   77 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 73 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/char/tpm/tpm_tis.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm_tis.c
+++ linux-2.6/drivers/char/tpm/tpm_tis.c
@@ -306,11 +306,10 @@ MODULE_PARM_DESC(itpm, "Force iTPM worka
  * tpm.c can skip polling for the data to be available as the interrupt is
  * waited for here
  */
-static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
+static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 {
 	int rc, status, burstcnt;
 	size_t count = 0;
-	u32 ordinal;
 
 	if (request_locality(chip, 0) < 0)
 		return -EBUSY;
@@ -345,8 +344,7 @@ static int tpm_tis_send(struct tpm_chip 
 
 	/* write last byte */
 	iowrite8(buf[count],
-		 chip->vendor.iobase +
-		 TPM_DATA_FIFO(chip->vendor.locality));
+		 chip->vendor.iobase + TPM_DATA_FIFO(chip->vendor.locality));
 	wait_for_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c,
 		      &chip->vendor.int_queue);
 	status = tpm_tis_status(chip);
@@ -355,6 +353,28 @@ static int tpm_tis_send(struct tpm_chip 
 		goto out_err;
 	}
 
+	return 0;
+
+out_err:
+	tpm_tis_ready(chip);
+	release_locality(chip, chip->vendor.locality, 0);
+	return rc;
+}
+
+/*
+ * If interrupts are used (signaled by an irq set in the vendor structure)
+ * tpm.c can skip polling for the data to be available as the interrupt is
+ * waited for here
+ */
+static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
+{
+	int rc;
+	u32 ordinal;
+
+	rc = tpm_tis_send_data(chip, buf, len);
+	if (rc < 0)
+		return rc;
+
 	/* go and do it */
 	iowrite8(TPM_STS_GO,
 		 chip->vendor.iobase + TPM_STS(chip->vendor.locality));
@@ -376,6 +396,47 @@ out_err:
 	return rc;
 }
 
+/*
+ * Early probing for iTPM with STS_DATA_EXPECT flaw.
+ * Try sending command without itpm flag set and if that
+ * fails, repeat with itpm flag set.
+ */
+static int probe_itpm(struct tpm_chip *chip)
+{
+	int rc = 0;
+	u8 cmd_getticks[] = {
+		0x00, 0xc1, 0x00, 0x00, 0x00, 0x0a,
+		0x00, 0x00, 0x00, 0xf1
+	};
+	size_t len = sizeof(cmd_getticks);
+	int rem_itpm = itpm;
+
+	itpm = 0;
+
+	rc = tpm_tis_send_data(chip, cmd_getticks, len);
+	if (rc == 0)
+		goto out;
+
+	tpm_tis_ready(chip);
+	release_locality(chip, chip->vendor.locality, 0);
+
+	itpm = 1;
+
+	rc = tpm_tis_send_data(chip, cmd_getticks, len);
+	if (rc == 0) {
+		dev_info(chip->dev, "Detected an iTPM.\n");
+		rc = 1;
+	} else
+		rc = -EFAULT;
+
+out:
+	itpm = rem_itpm;
+	tpm_tis_ready(chip);
+	release_locality(chip, chip->vendor.locality, 0);
+
+	return rc;
+}
+
 static const struct file_operations tis_ops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
@@ -515,6 +576,14 @@ static int tpm_tis_init(struct device *d
 		 "1.2 TPM (device-id 0x%X, rev-id %d)\n",
 		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
 
+	if (!itpm) {
+		itpm = probe_itpm(chip);
+		if (itpm < 0) {
+			rc = -ENODEV;
+			goto out_err;
+		}
+	}
+
 	if (itpm)
 		dev_info(dev, "Intel iTPM workaround enabled\n");
 

