Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219Ab2KOXXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 18:23:20 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:55755 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750911Ab2KOXXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 18:23:19 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX196r/ooSCh6965UR35PUnvrudFH+Swe6ooAhs/g+L
	IMYpBtfpSHm3Re
From: Peter Huewe <peterhuewe@gmx.de>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH v2] char/tpm: simplify duration calculation and eliminate smatch warning.
Date: Fri, 16 Nov 2012 00:31:29 +0100
Message-Id: <1353022289-20597-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <20121115215307.GA12000@ennui.austin.ibm.com>
References: <20121115215307.GA12000@ennui.austin.ibm.com>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the semantics of the duration calculation for an
ordinal, by masking out the higher bits of a tpm command, which specify
whether it's an TPM_PROTECTED_COMMAND, TPM_UNPROTECTED_COMMAND,
TPM_CONNECTION_COMMAND, TPM_CONNECTION_COMMAND, TPM_VENDOR_COMMAND.
(See TPM Main Spec Part 2 Section 17 for details).

For all TPM_PROTECTED and TPM_CONNECTION commands the results are
unchanged.
The TPM_UNPROTECTED commands are TSS commands and thus irrelevant as
they are not sent to the tpm.
For vendor commands the semantics change for ordinals 10 and 11 but
they were probably wrong anyway.

For everything else which has the ordinal set to 10 or 11 the semantics
change as it now uses TPM_UNDEFINED instead of TPM_SHORT which was
probably wrong anyway (but irrelevant as not defined by the standard).

This patch also gets rid of the (false positive) smatch warning:
 drivers/char/tpm/tpm.c:360 tpm_calc_ordinal_duration() error: buffer
 overflow 'tpm_protected_ordinal_duration' 12 <= 243

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
v2: Smatch not sparse and TSC instead of TCS ;)


 drivers/char/tpm/tpm.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 9e3c529..0a08af0 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -40,8 +40,9 @@ enum tpm_duration {
 };
 
 #define TPM_MAX_ORDINAL 243
-#define TPM_MAX_PROTECTED_ORDINAL 12
-#define TPM_PROTECTED_ORDINAL_MASK 0xFF
+#define TSC_MAX_ORDINAL 12
+#define TPM_PROTECTED_COMMAND 0x00
+#define TPM_CONNECTION_COMMAND 0x40
 
 /*
  * Bug workaround - some TPM's don't flush the most
@@ -336,13 +337,11 @@ unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip,
 {
 	int duration_idx = TPM_UNDEFINED;
 	int duration = 0;
+	u8 category = (ordinal >> 24) & 0xFF;
 
-	if (ordinal < TPM_MAX_ORDINAL)
+	if ((category == TPM_PROTECTED_COMMAND && ordinal < TPM_MAX_ORDINAL) ||
+	    (category == TPM_CONNECTION_COMMAND && ordinal < TSC_MAX_ORDINAL))
 		duration_idx = tpm_ordinal_duration[ordinal];
-	else if ((ordinal & TPM_PROTECTED_ORDINAL_MASK) <
-		 TPM_MAX_PROTECTED_ORDINAL)
-		duration_idx =
-		    tpm_ordinal_duration[ordinal & TPM_PROTECTED_ORDINAL_MASK];
 
 	if (duration_idx != TPM_UNDEFINED)
 		duration = chip->vendor.duration[duration_idx];
-- 
1.7.8.6

