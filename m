Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946099Ab2K2Aje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 19:39:34 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:59787 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1946086Ab2K2Ajb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 19:39:31 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18+uToxCS8+NevynPa74ZVduRLvuv5EHlbL0FUiPs
	L1N2Q370bGknT3
From: Peter Huewe <peterhuewe@gmx.de>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: Rajiv Andrade <mail@srajiv.net>, Marcel Selhorst <tpmdd@selhorst.net>,
        Sirrix AG <tpmdd@sirrix.com>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH v2] char/tpm: Use true and false for bools
Date: Thu, 29 Nov 2012 01:39:38 +0100
Message-Id: <1354149578-9252-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <20121129002519.GG4939@ZenIV.linux.org.uk>
References: <20121129002519.GG4939@ZenIV.linux.org.uk>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bool initializations should use true and false.  Bool tests don't need
comparisons.  Based on contributions from Joe Perches, Rusty Russell
and Bruce W Allan.

The semantic patch that makes this output is available
in scripts/coccinelle/misc/boolinit.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
v2:
Removed/changed that silly itpm = (probe == 0) ? 0 : 1; 
since probe is here either 0 or 1 -- thanks Al for noticing.
This section and the probing of the itpm can probably be improved anyway,
but I'll wrap that in a different patch soon.

 drivers/char/tpm/tpm_tis.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 6bdf267..8b084e0 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -374,7 +374,7 @@ static int probe_itpm(struct tpm_chip *chip)
 	if (vendor != TPM_VID_INTEL)
 		return 0;
 
-	itpm = 0;
+	itpm = false;
 
 	rc = tpm_tis_send_data(chip, cmd_getticks, len);
 	if (rc == 0)
@@ -383,7 +383,7 @@ static int probe_itpm(struct tpm_chip *chip)
 	tpm_tis_ready(chip);
 	release_locality(chip, chip->vendor.locality, 0);
 
-	itpm = 1;
+	itpm = true;
 
 	rc = tpm_tis_send_data(chip, cmd_getticks, len);
 	if (rc == 0) {
@@ -502,7 +502,7 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static bool interrupts = 1;
+static bool interrupts = true;
 module_param(interrupts, bool, 0444);
 MODULE_PARM_DESC(interrupts, "Enable interrupts");
 
@@ -545,7 +545,7 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 			rc = -ENODEV;
 			goto out_err;
 		}
-		itpm = (probe == 0) ? 0 : 1;
+		itpm = probe;
 	}
 
 	if (itpm)
@@ -741,10 +741,10 @@ static int __devinit tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
 	if (pnp_irq_valid(pnp_dev, 0))
 		irq = pnp_irq(pnp_dev, 0);
 	else
-		interrupts = 0;
+		interrupts = false;
 
 	if (is_itpm(pnp_dev))
-		itpm = 1;
+		itpm = true;
 
 	return tpm_tis_init(&pnp_dev->dev, start, len, irq);
 }
-- 
1.7.8.6

