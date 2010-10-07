Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab0JGUwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:52:31 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59823 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756102Ab0JGUw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:52:28 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: [PATCH v1 2/4] key: add tpm_send command
Date: Thu,  7 Oct 2010 16:52:12 -0400
Message-Id: <1286484734-3119-3-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1286484734-3119-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1286484734-3119-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add internal kernel tpm_send() command used to seal/unseal keys.

Signed-off-by: David Safford <safford@watson.ibm.com>
Reviewd-by: Mimi Zohar <zohar@watson.ibm.com>
Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm.c |   17 +++++++++++++++++
 include/linux/tpm.h    |    3 +++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 7c41335..5987d9c 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -780,6 +780,23 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 }
 EXPORT_SYMBOL_GPL(tpm_pcr_extend);
 
+int tpm_send(u32 chip_num, char *cmd, int buflen)
+{
+	struct tpm_chip *chip;
+	int rc;
+
+	chip = tpm_chip_find_get(chip_num);
+	if (chip == NULL)
+		return -ENODEV;
+
+	rc = transmit_cmd(chip, (struct tpm_cmd_t *)cmd, buflen,
+			  "attempting tpm_cmd");
+
+	module_put(chip->dev->driver->owner);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tpm_send);
+
 ssize_t tpm_show_pcrs(struct device *dev, struct device_attribute *attr,
 		      char *buf)
 {
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index ac5d1c1..a0ecaa9 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -31,6 +31,7 @@
 
 extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
 extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash);
+extern int tpm_send(u32 chip_num, char *cmd, int buflen);
 #else
 static inline int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf) {
 	return -ENODEV;
@@ -38,5 +39,7 @@ static inline int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf) {
 static inline int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash) {
 	return -ENODEV;
 }
+static inline int tpm_send(u32 chip_num, char *cmd, int buflen) {
+	return -ENODEV;
 #endif
 #endif
-- 
1.7.2.2

