Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760808Ab0KRWnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 17:43:13 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:54000 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760793Ab0KRWnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 17:43:08 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v1.4 2/5] tpm: add module_put wrapper
Date: Thu, 18 Nov 2010 17:42:43 -0500
Message-Id: <1290120166-3132-3-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1290120166-3132-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1290120166-3132-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For readability, define a tpm_chip_put() wrapper to call module_put().
Replace existing module_put() calls with the wrapper.

(Change based on trusted/encrypted patchset review by David Howells.)

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: David Safford <safford@watson.ibm.com>
---
 drivers/char/tpm/tpm.c |    4 ++--
 drivers/char/tpm/tpm.h |    5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 7c41335..26c09f3 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -736,7 +736,7 @@ int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf)
 	if (chip == NULL)
 		return -ENODEV;
 	rc = __tpm_pcr_read(chip, pcr_idx, res_buf);
-	module_put(chip->dev->driver->owner);
+	tpm_chip_put(chip);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_pcr_read);
@@ -775,7 +775,7 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 	rc = transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
 			  "attempting extend a PCR value");
 
-	module_put(chip->dev->driver->owner);
+	tpm_chip_put(chip);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_pcr_extend);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 792868d..72ddb03 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -113,6 +113,11 @@ struct tpm_chip {
 
 #define to_tpm_chip(n) container_of(n, struct tpm_chip, vendor)
 
+static inline void tpm_chip_put(struct tpm_chip *chip)
+{
+	module_put(chip->dev->driver->owner);
+}
+
 static inline int tpm_read_index(int base, int index)
 {
 	outb(index, base);
-- 
1.7.2.2

