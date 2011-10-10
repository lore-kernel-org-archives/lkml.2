Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab1JJMRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 08:17:04 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:52445 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab1JJMRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 08:17:02 -0400
Subject: [PATCH] Refuse activation of tpm_tis driver if TPM is not working
 correctly
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        James Morris <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>, m.selhorst@sirrix.com
Cc: a.miskiewicz@gmail.com
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 08:16:45 -0400
Message-ID: <1318249005.5482.5.camel@d941e-10>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refuse activation of tpm_tis driver if the TPM is found not to be
working correctly. This prevents suspend/resume problems for me on
Lenovo W500 and T61p.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

---
 drivers/char/tpm/tpm_tis.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 3f4051a..7f2761d 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -549,6 +549,7 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 	u32 vendor, intfcaps, intmask;
 	int rc, i, irq_s, irq_e;
 	struct tpm_chip *chip;
+	u8 digest[TPM_DIGEST_SIZE];
 
 	if (!(chip = tpm_register_hardware(dev, &tpm_tis)))
 		return -ENODEV;
@@ -616,6 +617,18 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 	/* get the timeouts before testing for irqs */
 	tpm_get_timeouts(chip);
 
+	/* test for correctly working TPM; refuse driver if not working 
+	   to prevent suspend/resume problems */
+	rc = tpm_pcr_read(chip->dev_num, 0, digest);
+	if (rc != 0) {
+		dev_err(dev, "Could not read PCR 0. "
+			"TPM is not working correctly.\n");
+		dev_err(dev, "Was machine previously suspended without TPM "
+			"driver present?\n");
+		rc = -ENODEV;
+		goto out_err;
+	}
+
 	/* INTERRUPT Setup */
 	init_waitqueue_head(&chip->vendor.read_queue);
 	init_waitqueue_head(&chip->vendor.int_queue);
-- 
1.7.6.4


