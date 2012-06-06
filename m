Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab2FFNip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 09:38:45 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35715 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab2FFNij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 09:38:39 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCH 3/7] remoteproc: Pass struct fw to load_segments and find_rsc_table.
Date: Wed,  6 Jun 2012 15:38:23 +0200
Message-Id: <1338989907-25360-4-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1338989907-25360-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1338989907-25360-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Prepare for introduction of custom firmware loaders by changing
the functions rproc_find_rcs_table() and rproc_load_segments()
to use struct firmware as parameter.

When the custom loader framework is introduced all calls into
the firmware specific function must use struct firmware as
parameter.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 9d6343d..07036e2 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -192,8 +192,7 @@ static void *rproc_da_to_va(struct rproc *rproc, u64 da, int len)
 /**
  * rproc_load_segments() - load firmware segments to memory
  * @rproc: remote processor which will be booted using these fw segments
- * @elf_data: the content of the ELF firmware image
- * @len: firmware size (in bytes)
+ * @fw: the  the ELF firmware image
  *
  * This function loads the firmware segments to memory, where the remote
  * processor expects them.
@@ -215,12 +214,13 @@ static void *rproc_da_to_va(struct rproc *rproc, u64 da, int len)
  * supported, though.
  */
 static int
-rproc_load_segments(struct rproc *rproc, const u8 *elf_data, size_t len)
+rproc_load_segments(struct rproc *rproc, const struct firmware *fw)
 {
 	struct device *dev = rproc->dev;
 	struct elf32_hdr *ehdr;
 	struct elf32_phdr *phdr;
 	int i, ret = 0;
+	const u8 *elf_data = fw->data;
 
 	ehdr = (struct elf32_hdr *)elf_data;
 	phdr = (struct elf32_phdr *)(elf_data + ehdr->e_phoff);
@@ -246,9 +246,9 @@ rproc_load_segments(struct rproc *rproc, const u8 *elf_data, size_t len)
 			break;
 		}
 
-		if (offset + filesz > len) {
+		if (offset + filesz > fw->size) {
 			dev_err(dev, "truncated fw: need 0x%x avail 0x%zx\n",
-					offset + filesz, len);
+					offset + filesz, fw->size);
 			ret = -EINVAL;
 			break;
 		}
@@ -824,8 +824,7 @@ rproc_handle_virtio_rsc(struct rproc *rproc, struct resource_table *table, int l
 /**
  * rproc_find_rsc_table() - find the resource table
  * @rproc: the rproc handle
- * @elf_data: the content of the ELF firmware image
- * @len: firmware size (in bytes)
+ * @fw: the ELF firmware image
  * @tablesz: place holder for providing back the table size
  *
  * This function finds the resource table inside the remote processor's
@@ -838,7 +837,7 @@ rproc_handle_virtio_rsc(struct rproc *rproc, struct resource_table *table, int l
  * (and @tablesz isn't set).
  */
 static struct resource_table *
-rproc_find_rsc_table(struct rproc *rproc, const u8 *elf_data, size_t len,
+rproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
 							int *tablesz)
 {
 	struct elf32_hdr *ehdr;
@@ -847,6 +846,7 @@ rproc_find_rsc_table(struct rproc *rproc, const u8 *elf_data, size_t len,
 	struct device *dev = rproc->dev;
 	struct resource_table *table = NULL;
 	int i;
+	const u8 *elf_data = fw->data;
 
 	ehdr = (struct elf32_hdr *)elf_data;
 	shdr = (struct elf32_shdr *)(elf_data + ehdr->e_shoff);
@@ -863,7 +863,7 @@ rproc_find_rsc_table(struct rproc *rproc, const u8 *elf_data, size_t len,
 		table = (struct resource_table *)(elf_data + offset);
 
 		/* make sure we have the entire table */
-		if (offset + size > len) {
+		if (offset + size > fw->size) {
 			dev_err(dev, "resource table truncated\n");
 			return NULL;
 		}
@@ -1040,7 +1040,7 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 	rproc->bootaddr = ehdr->e_entry;
 
 	/* look for the resource table */
-	table = rproc_find_rsc_table(rproc, fw->data, fw->size, &tablesz);
+	table = rproc_find_rsc_table(rproc, fw, &tablesz);
 	if (!table) {
 		ret = -EINVAL;
 		goto clean_up;
@@ -1054,7 +1054,7 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 	}
 
 	/* load the ELF segments to memory */
-	ret = rproc_load_segments(rproc, fw->data, fw->size);
+	ret = rproc_load_segments(rproc, fw);
 	if (ret) {
 		dev_err(dev, "Failed to load program segments: %d\n", ret);
 		goto clean_up;
@@ -1097,7 +1097,7 @@ static void rproc_fw_config_virtio(const struct firmware *fw, void *context)
 		goto out;
 
 	/* look for the resource table */
-	table = rproc_find_rsc_table(rproc, fw->data, fw->size, &tablesz);
+	table = rproc_find_rsc_table(rproc, fw,  &tablesz);
 	if (!table)
 		goto out;
 
-- 
1.7.5.4

