Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757679Ab2DXVDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 17:03:14 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:55127 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631Ab2DXVDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 17:03:13 -0400
Date: Tue, 24 Apr 2012 17:57:17 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Subject: [PATCH] TPM: chip disabled state erronously being reported as error
Message-ID: <20120424205717.GA3755@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042421-2362-0000-0000-000006F77712
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Can you test it?

Thanks,
Rajiv

---
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

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index ad7c732..9511abd 100644
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
@@ -845,7 +845,16 @@ int tpm_do_selftest(struct tpm_chip *chip)
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
+		else
+			rc = be32_to_cpu(cmd.header.out.return_code);
+
 		if (rc == TPM_ERR_DISABLED || rc == TPM_ERR_DEACTIVATED) {
 			dev_info(chip->dev,
 				 "TPM is disabled/deactivated (0x%X)\n", rc);
-- 
1.7.3.4

