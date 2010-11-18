Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843Ab0KRWny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 17:43:54 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:44101 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760796Ab0KRWnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 17:43:11 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@watson.ibm.com>
Subject: [PATCH v1.4 3/5] key: add tpm_send command
Date: Thu, 18 Nov 2010 17:42:44 -0500
Message-Id: <1290120166-3132-4-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1290120166-3132-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1290120166-3132-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add internal kernel tpm_send() command used to seal/unseal keys.

Changelog:
- replaced module_put in tpm_send() with new tpm_chip_put() wrapper
  (suggested by David Howells)
- Make tpm_send() cmd argument a 'void *' (suggested by David Howells)

Signed-off-by: David Safford <safford@watson.ibm.com>
Signed-off-by: Mimi Zohar <zohar@watson.ibm.com>
---
 drivers/char/tpm/tpm.c |   16 ++++++++++++++++
 include/linux/tpm.h    |    4 ++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 26c09f3..b737cf3 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -780,6 +780,22 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 }
 EXPORT_SYMBOL_GPL(tpm_pcr_extend);
 
+int tpm_send(u32 chip_num, void *cmd, int buflen)
+{
+	struct tpm_chip *chip;
+	int rc;
+
+	chip = tpm_chip_find_get(chip_num);
+	if (chip == NULL)
+		return -ENODEV;
+
+	rc = transmit_cmd(chip, cmd, buflen, "attempting tpm_cmd");
+
+	tpm_chip_put(chip);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tpm_send);
+
 ssize_t tpm_show_pcrs(struct device *dev, struct device_attribute *attr,
 		      char *buf)
 {
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index ac5d1c1..a25ab8f 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -31,6 +31,7 @@
 
 extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
 extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash);
+extern int tpm_send(u32 chip_num, void *cmd, int buflen);
 #else
 static inline int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf) {
 	return -ENODEV;
@@ -38,5 +39,8 @@ static inline int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf) {
 static inline int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash) {
 	return -ENODEV;
 }
+static inline int tpm_send(u32 chip_num, void *cmd, int buflen) {
+	return -ENODEV;
+}
 #endif
 #endif
-- 
1.7.2.2

