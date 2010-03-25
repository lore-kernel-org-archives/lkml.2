Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750834Ab0CYECX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 00:02:23 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:46883 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702Ab0CYECW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 00:02:22 -0400
Subject: [PATCH] TPM: workaround to enforce PCR updates across suspends
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: jmorris@namei.org
Cc: safford@watson.ibm.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: IBM
Date: Thu, 25 Mar 2010 00:55:32 -0300
Message-Id: <1269489332.12676.14.camel@blackbox.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a workaround for TPM's which fail to flush last written
PCR values in a TPM_SaveState, in preparation for suspend.

Signed-off-by: David Safford <safford@watson.ibm.com>
Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

diff -u -r a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt	2010-02-24 13:52:17.000000000 -0500
+++ b/Documentation/kernel-parameters.txt	2010-03-10 15:23:29.701436428 -0500
@@ -98,6 +98,7 @@
 	SWSUSP	Software suspend (hibernation) is enabled.
 	SUSPEND	System suspend states are enabled.
 	FTRACE	Function tracing enabled.
+	TPM	TPM drivers are enabled.
 	TS	Appropriate touchscreen support is enabled.
 	UMS	USB Mass Storage support is enabled.
 	USB	USB support is enabled.
@@ -2588,6 +2589,15 @@
 
 	tp720=		[HW,PS2]
 
+	tpm_suspend_pcr=[HW,TPM]
+			Format: integer pcr id
+			Specify that at suspend time, the tpm driver
+			should extend the specified pcr with zeros,
+			as a workaround for some chips which fail to
+			flush the last written pcr on TPM_SaveState.
+			This will guarantee that all the other pcrs
+			are saved.
+
 	trace_buf_size=nn[KMG]
 			[FTRACE] will set tracing buffer size.
 
diff -u -r a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c	2010-02-24 13:52:17.000000000 -0500
+++ b/drivers/char/tpm/tpm.c	2010-03-17 09:50:36.221195050 -0400
@@ -1067,6 +1067,27 @@
 }
 EXPORT_SYMBOL_GPL(tpm_remove_hardware);
 
+#define TPM_ORD_SAVESTATE cpu_to_be32(152)
+#define SAVESTATE_RESULT_SIZE 10
+
+static struct tpm_input_header savestate_header = {
+	.tag = TPM_TAG_RQU_COMMAND,
+	.length = cpu_to_be32(10),
+	.ordinal = TPM_ORD_SAVESTATE
+};
+
+/* Bug workaround - some TPM's don't flush the most
+ * recently changed pcr on suspend, so force the flush
+ * with an extend to the selected _unused_ non-volatile pcr.
+ */
+static int tpm_suspend_pcr;
+static int __init tpm_suspend_setup(char *str)
+{
+	get_option(&str, &tpm_suspend_pcr);
+	return 1;
+}
+__setup("tpm_suspend_pcr=", tpm_suspend_setup);
+
 /*
  * We are about to suspend. Save the TPM state
  * so that it can be restored.
@@ -1074,17 +1095,29 @@
 int tpm_pm_suspend(struct device *dev, pm_message_t pm_state)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
-	u8 savestate[] = {
-		0, 193,		/* TPM_TAG_RQU_COMMAND */
-		0, 0, 0, 10,	/* blob length (in bytes) */
-		0, 0, 0, 152	/* TPM_ORD_SaveState */
-	};
+	struct tpm_cmd_t cmd;
+	int rc;
+
+	u8 dummy_hash[TPM_DIGEST_SIZE] = { 0 };
 
 	if (chip == NULL)
 		return -ENODEV;
 
-	tpm_transmit(chip, savestate, sizeof(savestate));
-	return 0;
+	/* for buggy tpm, flush pcrs with extend to selected dummy */
+	if (tpm_suspend_pcr) {
+		cmd.header.in = pcrextend_header;
+		cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(tpm_suspend_pcr);
+		memcpy(cmd.params.pcrextend_in.hash, dummy_hash,
+		       TPM_DIGEST_SIZE);
+		rc = transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
+				  "extending dummy pcr before suspend");
+	}
+
+	/* now do the actual savestate */
+	cmd.header.in = savestate_header;
+	rc = transmit_cmd(chip, &cmd, SAVESTATE_RESULT_SIZE,
+			  "sending savestate before suspend");
+	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_pm_suspend);
 



