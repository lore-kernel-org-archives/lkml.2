Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab2ARDHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 22:07:41 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:41093 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab2ARDHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 22:07:39 -0500
Subject: [PATCH] tpm: fix (ACPI S3) suspend regression
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Cc: linux-pm@vger.kernel.org, Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        rjw@sisk.pl
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Jan 2012 22:07:30 -0500
Message-ID: <1326856050.32259.4.camel@d941e-10>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12011803-1780-0000-0000-0000026A576A
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000245; HX=3.00000181; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00105884; UDB=6.00026686; UTC=2012-01-18
 03:07:38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an (ACPI S3) suspend regression introduced in commit
68d6e6713fcb2ea6278661aaaf5f1c9c821b3751 and occurring with an Infineon
TPM and tpm_tis and tpm_infineon drivers active. Further, the suspend problem
occurred if the TPM was disabled and/or deactivated and therefore the
TPM_PCRRead checking the result of the (asynchronous) self test returned
an error code which then caused the tpm_tis driver to become inactive and
this then seemed to have negatively influenced the suspend support by the
tpm_infineon driver...
Besides that the tpm_tis drive may stay active even if the TPM is disabled
and/or deactivated.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
Tested-by: Rafael J. Wysocki <rjw@sisk.pl>

---
 drivers/char/tpm/tpm.c |    9 +++++++++
 drivers/char/tpm/tpm.h |    3 +++
 2 files changed, 12 insertions(+)

Index: linux-2.6/drivers/char/tpm/tpm.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm.c
+++ linux-2.6/drivers/char/tpm/tpm.c
@@ -846,6 +846,15 @@ int tpm_do_selftest(struct tpm_chip *chi
 
 	do {
 		rc = __tpm_pcr_read(chip, 0, digest);
+		if (rc == TPM_ERR_DISABLED || rc == TPM_ERR_DEACTIVATED) {
+			dev_info(chip->dev,
+				 "TPM is disabled/deactivated (0x%X)\n", rc);
+			/* TPM is disabled and/or deactivated; driver can
+			 * proceed and TPM does handle commands for
+			 * suspend/resume correctly
+			 */
+			return 0;
+		}
 		if (rc != TPM_WARN_DOING_SELFTEST)
 			return rc;
 		msleep(delay_msec);
Index: linux-2.6/drivers/char/tpm/tpm.h
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm.h
+++ linux-2.6/drivers/char/tpm/tpm.h
@@ -39,6 +39,9 @@ enum tpm_addr {
 };
 
 #define TPM_WARN_DOING_SELFTEST 0x802
+#define TPM_ERR_DEACTIVATED     0x6
+#define TPM_ERR_DISABLED        0x7
+
 #define TPM_HEADER_SIZE		10
 extern ssize_t tpm_show_pubek(struct device *, struct device_attribute *attr,
 				char *);


