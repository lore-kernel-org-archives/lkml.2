Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998Ab2HGXOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:14:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47761 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932951Ab2HGWhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:37:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: [ 032/109] TPM: chip disabled state erronously being reported as error
Date: Tue,  7 Aug 2012 15:34:51 -0700
Message-Id: <20120807222045.919552904@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

commit 24ebe6670de3d1f0dca11c9eb372134c7ab05503 upstream.

tpm_do_selftest() attempts to read a PCR in order to
decide if one can rely on the TPM being used or not.
The function that's used by __tpm_pcr_read() does not
expect the TPM to be disabled or deactivated, and if so,
reports an error.

It's fine if the TPM returns this error when trying to
use it for the first time after a power cycle, but it's
definitely not if it already returned success for a
previous attempt to read one of its PCRs.

The tpm_do_selftest() was modified so that the driver only
reports this return code as an error when it really is.

Reported-and-tested-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/tpm.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -827,10 +827,10 @@ EXPORT_SYMBOL_GPL(tpm_pcr_extend);
 int tpm_do_selftest(struct tpm_chip *chip)
 {
 	int rc;
-	u8 digest[TPM_DIGEST_SIZE];
 	unsigned int loops;
 	unsigned int delay_msec = 1000;
 	unsigned long duration;
+	struct tpm_cmd_t cmd;
 
 	duration = tpm_calc_ordinal_duration(chip,
 	                                     TPM_ORD_CONTINUE_SELFTEST);
@@ -845,7 +845,15 @@ int tpm_do_selftest(struct tpm_chip *chi
 		return rc;
 
 	do {
-		rc = __tpm_pcr_read(chip, 0, digest);
+		/* Attempt to read a PCR value */
+		cmd.header.in = pcrread_header;
+		cmd.params.pcrread_in.pcr_idx = cpu_to_be32(0);
+		rc = tpm_transmit(chip, (u8 *) &cmd, READ_PCR_RESULT_SIZE);
+
+		if (rc < TPM_HEADER_SIZE)
+			return -EFAULT;
+
+		rc = be32_to_cpu(cmd.header.out.return_code);
 		if (rc == TPM_ERR_DISABLED || rc == TPM_ERR_DEACTIVATED) {
 			dev_info(chip->dev,
 				 "TPM is disabled/deactivated (0x%X)\n", rc);


