Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab2KLW3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 17:29:39 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:48048 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752769Ab2KLW3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 17:29:37 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+YWIxUb/iY/EVJGM1LusqS7zocJcN7zr9RgAFUDy
	Otiah4cMUWLoPy
From: Peter Huewe <peterhuewe@gmx.de>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 2/2] char/tpm: simplify duration calculation and eliminate sparse warning.
Date: Mon, 12 Nov 2012 23:37:18 +0100
Message-Id: <1352759838-27175-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1352759838-27175-1-git-send-email-peterhuewe@gmx.de>
References: <1352759838-27175-1-git-send-email-peterhuewe@gmx.de>
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

This patch also gets rid of the (false positive) sparse warning:
 drivers/char/tpm/tpm.c:360 tpm_calc_ordinal_duration() error: buffer
 overflow 'tpm_protected_ordinal_duration' 12 <= 243

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/tpm.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 9e3c529..a455d11 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -40,8 +40,9 @@ enum tpm_duration {
 };
 
 #define TPM_MAX_ORDINAL 243
-#define TPM_MAX_PROTECTED_ORDINAL 12
-#define TPM_PROTECTED_ORDINAL_MASK 0xFF
+#define TCS_MAX_ORDINAL 12
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
+	    (category == TPM_CONNECTION_COMMAND && ordinal < TCS_MAX_ORDINAL))
 		duration_idx = tpm_ordinal_duration[ordinal];
-	else if ((ordinal & TPM_PROTECTED_ORDINAL_MASK) <
-		 TPM_MAX_PROTECTED_ORDINAL)
-		duration_idx =
-		    tpm_ordinal_duration[ordinal & TPM_PROTECTED_ORDINAL_MASK];
 
 	if (duration_idx != TPM_UNDEFINED)
 		duration = chip->vendor.duration[duration_idx];
-- 
1.7.8.6

