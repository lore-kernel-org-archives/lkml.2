Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab2EVN2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 09:28:08 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50049 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab2EVN1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 09:27:09 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFC 2/6] remoteproc: Pass struct fw to load_segments and find_rsc_table.
Date: Tue, 22 May 2012 15:26:53 +0200
Message-Id: <1337693217-15466-3-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337693217-15466-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1337693217-15466-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Use struct firmware as arguments to functions rproc_find_rcs_table()
and rproc_load_segments().

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c |   38 +++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 1bba479..3d980ea 100644
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
@@ -847,11 +846,19 @@ rproc_find_rsc_table(struct rproc *rproc, const u8 *elf_data, size_t len,
 	struct device *dev = rproc->dev;
 	struct resource_table *table = NULL;
 	int i;
+	const u8 *elf_data = fw->data;
 
 	ehdr = (struct elf32_hdr *)elf_data;
 	shdr = (struct elf32_shdr *)(elf_data + ehdr->e_shoff);
 	name_table = elf_data + shdr[ehdr->e_shstrndx].sh_offset;
 
+	/*
+	 * The ELF entry point is the rproc's boot addr (though this is not
+	 * a configurable property of all remote processors: some will always
+	 * boot at a specific hardcoded address).
+	 */
+	rproc->bootaddr = ehdr->e_entry;
+
 	/* look for the resource table and handle it */
 	for (i = 0; i < ehdr->e_shnum; i++, shdr++) {
 		int size = shdr->sh_size;
@@ -863,7 +870,7 @@ rproc_find_rsc_table(struct rproc *rproc, const u8 *elf_data, size_t len,
 		table = (struct resource_table *)(elf_data + offset);
 
 		/* make sure we have the entire table */
-		if (offset + size > len) {
+		if (offset + size > fw->size) {
 			dev_err(dev, "resource table truncated\n");
 			return NULL;
 		}
@@ -1032,15 +1039,8 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 		return ret;
 	}
 
-	/*
-	 * The ELF entry point is the rproc's boot addr (though this is not
-	 * a configurable property of all remote processors: some will always
-	 * boot at a specific hardcoded address).
-	 */
-	rproc->bootaddr = ehdr->e_entry;
-
 	/* look for the resource table */
-	table = rproc_find_rsc_table(rproc, fw->data, fw->size, &tablesz);
+	table = rproc_find_rsc_table(rproc, fw, &tablesz);
 	if (!table)
 		goto clean_up;
 
@@ -1052,7 +1052,7 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 	}
 
 	/* load the ELF segments to memory */
-	ret = rproc_load_segments(rproc, fw->data, fw->size);
+	ret = rproc_load_segments(rproc, fw);
 	if (ret) {
 		dev_err(dev, "Failed to load program segments: %d\n", ret);
 		goto clean_up;
@@ -1095,7 +1095,7 @@ static void rproc_fw_config_virtio(const struct firmware *fw, void *context)
 		goto out;
 
 	/* look for the resource table */
-	table = rproc_find_rsc_table(rproc, fw->data, fw->size, &tablesz);
+	table = rproc_find_rsc_table(rproc, fw,  &tablesz);
 	if (!table)
 		goto out;
 
-- 
1.7.9.5

