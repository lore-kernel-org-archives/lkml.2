Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947046Ab2LFTfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 14:35:45 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:43707 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947012Ab2LFTfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 14:35:40 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        sjurbren@gmail.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFC 2/5] remoteproc: Add operation to find resource table in memory
Date: Thu,  6 Dec 2012 20:35:21 +0100
Message-Id: <1354822524-4497-3-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354822524-4497-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1354822524-4497-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add function find_rsc_table_va to firmware ops. This function
returns the location of the resource table in device memory
after the firmware is loaded.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_elf_loader.c |   16 ++++++++++-
 drivers/remoteproc/remoteproc_internal.h   |   13 +++++++++
 drivers/remoteproc/ste_modem_rproc.c       |   43 +++++++++++++++++++---------
 3 files changed, 57 insertions(+), 15 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_elf_loader.c b/drivers/remoteproc/remoteproc_elf_loader.c
index 69832d9..3f6e315 100644
--- a/drivers/remoteproc/remoteproc_elf_loader.c
+++ b/drivers/remoteproc/remoteproc_elf_loader.c
@@ -306,9 +306,23 @@ rproc_elf_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
 	return table;
 }
 
+struct resource_table *rproc_elf_get_rsctab_addr(struct rproc *rproc,
+						 const struct firmware *fw)
+{
+	struct elf32_shdr *shdr;
+
+	shdr = find_rsc_shdr(&rproc->dev, (struct elf32_hdr *)fw->data);
+	if (!shdr)
+		return NULL;
+
+	/* Find resource table in loaded segments */
+	return rproc_da_to_va(rproc, shdr->sh_addr, shdr->sh_size);
+}
+
 const struct rproc_fw_ops rproc_elf_fw_ops = {
 	.load = rproc_elf_load_segments,
 	.find_rsc_table = rproc_elf_find_rsc_table,
 	.sanity_check = rproc_elf_sanity_check,
-	.get_boot_addr = rproc_elf_get_boot_addr
+	.get_boot_addr = rproc_elf_get_boot_addr,
+	.get_rsctab_addr = rproc_elf_get_rsctab_addr
 };
diff --git a/drivers/remoteproc/remoteproc_internal.h b/drivers/remoteproc/remoteproc_internal.h
index 7bb6648..3a5cb7d 100644
--- a/drivers/remoteproc/remoteproc_internal.h
+++ b/drivers/remoteproc/remoteproc_internal.h
@@ -32,6 +32,7 @@ struct rproc;
  *			expects to find it
  * @sanity_check:	sanity check the fw image
  * @get_boot_addr:	get boot address to entry point specified in firmware
+ * @get_rsctab_addr:	get resouce table address as specified in firmware
  */
 struct rproc_fw_ops {
 	struct resource_table *(*find_rsc_table) (struct rproc *rproc,
@@ -40,6 +41,8 @@ struct rproc_fw_ops {
 	int (*load)(struct rproc *rproc, const struct firmware *fw);
 	int (*sanity_check)(struct rproc *rproc, const struct firmware *fw);
 	u32 (*get_boot_addr)(struct rproc *rproc, const struct firmware *fw);
+	struct resource_table *(*get_rsctab_addr)(struct rproc *rproc,
+						const struct firmware *fw);
 };
 
 /* from remoteproc_core.c */
@@ -102,6 +105,16 @@ struct resource_table *rproc_find_rsc_table(struct rproc *rproc,
 	return NULL;
 }
 
+static inline
+struct resource_table *rproc_get_rsctab_addr(struct rproc *rproc,
+				const struct firmware *fw)
+{
+	if (rproc->fw_ops->get_rsctab_addr)
+		return rproc->fw_ops->get_rsctab_addr(rproc, fw);
+
+	return NULL;
+}
+
 extern const struct rproc_fw_ops rproc_elf_fw_ops;
 
 #endif /* REMOTEPROC_INTERNAL_H */
diff --git a/drivers/remoteproc/ste_modem_rproc.c b/drivers/remoteproc/ste_modem_rproc.c
index a7743c0..59e99f1 100644
--- a/drivers/remoteproc/ste_modem_rproc.c
+++ b/drivers/remoteproc/ste_modem_rproc.c
@@ -64,26 +64,18 @@ static int sproc_load_segments(struct rproc *rproc, const struct firmware *fw)
 }
 
 /* Find the entry for resource table in the Table of Content */
-static struct ste_toc_entry *sproc_find_rsc_entry(const struct firmware *fw)
+static const struct ste_toc_entry *sproc_find_rsc_entry(const void *data)
 {
 	int i;
-	struct ste_toc *toc;
-
-	if (!fw)
-		return NULL;
-
-	toc = (void *)fw->data;
+	const struct ste_toc *toc;
+	toc = data;
 
 	/* Search the table for the resource table */
 	for (i = 0; i < SPROC_MAX_TOC_ENTRIES &&
 		    toc->table[i].start != 0xffffffff; i++) {
-
 		if (!strncmp(toc->table[i].name, SPROC_RESOURCE_NAME,
-			     sizeof(toc->table[i].name))) {
-			if (toc->table[i].start > fw->size)
-				return NULL;
+			     sizeof(toc->table[i].name)))
 			return &toc->table[i];
-		}
 	}
 
 	return NULL;
@@ -96,9 +88,12 @@ sproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
 {
 	struct sproc *sproc = rproc->priv;
 	struct resource_table *table;
-	struct ste_toc_entry *entry;
+	const struct ste_toc_entry *entry;
 
-	entry = sproc_find_rsc_entry(fw);
+	if (!fw)
+		return NULL;
+
+	entry = sproc_find_rsc_entry(fw->data);
 	if (!entry) {
 		sproc_err(sproc, "resource table not found in fw\n");
 		return NULL;
@@ -149,10 +144,30 @@ sproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
 	return table;
 }
 
+/* Find the resource table inside the remote processor's firmware. */
+static struct resource_table *
+sproc_get_rsctab_addr(struct rproc *rproc, const struct firmware *fw)
+{
+	struct sproc *sproc = rproc->priv;
+	const struct ste_toc_entry *entry;
+
+	if (!fw || !sproc->fw_addr)
+		return NULL;
+
+	entry = sproc_find_rsc_entry(sproc->fw_addr);
+	if (!entry) {
+		sproc_err(sproc, "resource table not found in fw\n");
+		return NULL;
+	}
+
+	return sproc->fw_addr + entry->start;
+}
+
 /* STE modem firmware handler operations */
 const struct rproc_fw_ops sproc_fw_ops = {
 	.load = sproc_load_segments,
 	.find_rsc_table = sproc_find_rsc_table,
+	.get_rsctab_addr = sproc_get_rsctab_addr,
 };
 
 /* Kick the modem with specified notification id */
-- 
1.7.9.5

