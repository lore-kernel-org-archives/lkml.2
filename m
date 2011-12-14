Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab1LNLtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 06:49:55 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43585 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928Ab1LNLtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 06:49:35 -0500
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Mark Grosen <mgrosen@ti.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 5/7] remoteproc: look for truncated firmware images
Date: Wed, 14 Dec 2011 13:48:33 +0200
Message-Id: <1323863315-8159-6-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323863315-8159-1-git-send-email-ohad@wizery.com>
References: <1323863315-8159-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure firmware isn't truncated before accessing its data.

Reported-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/remoteproc/remoteproc_core.c |   35 +++++++++++++++++++++++++++++----
 1 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 080c056..f2354ce 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -191,6 +191,7 @@ static void *rproc_da_to_va(struct rproc *rproc, u64 da, int len)
  * rproc_load_segments() - load firmware segments to memory
  * @rproc: remote processor which will be booted using these fw segments
  * @elf_data: the content of the ELF firmware image
+ * @len: firmware size (in bytes)
  *
  * This function loads the firmware segments to memory, where the remote
  * processor expects them.
@@ -211,7 +212,8 @@ static void *rproc_da_to_va(struct rproc *rproc, u64 da, int len)
  * directly allocate memory for every segment/resource. This is not yet
  * supported, though.
  */
-static int rproc_load_segments(struct rproc *rproc, const u8 *elf_data)
+static int
+rproc_load_segments(struct rproc *rproc, const u8 *elf_data, size_t len)
 {
 	struct device *dev = rproc->dev;
 	struct elf32_hdr *ehdr;
@@ -226,6 +228,7 @@ static int rproc_load_segments(struct rproc *rproc, const u8 *elf_data)
 		u32 da = phdr->p_paddr;
 		u32 memsz = phdr->p_memsz;
 		u32 filesz = phdr->p_filesz;
+		u32 offset = phdr->p_offset;
 		void *ptr;
 
 		if (phdr->p_type != PT_LOAD)
@@ -241,6 +244,13 @@ static int rproc_load_segments(struct rproc *rproc, const u8 *elf_data)
 			break;
 		}
 
+		if (offset + filesz > len) {
+			dev_err(dev, "truncated fw: need 0x%x avail 0x%x\n",
+					offset + filesz, len);
+			ret = -EINVAL;
+			break;
+		}
+
 		/* grab the kernel address for this device address */
 		ptr = rproc_da_to_va(rproc, da, memsz);
 		if (!ptr) {
@@ -712,6 +722,7 @@ rproc_handle_virtio_rsc(struct rproc *rproc, struct fw_resource *rsc, int len)
  * rproc_handle_resources() - find and handle the resource table
  * @rproc: the rproc handle
  * @elf_data: the content of the ELF firmware image
+ * @len: firmware size (in bytes)
  * @handler: function that should be used to handle the resource table
  *
  * This function finds the resource table inside the remote processor's
@@ -725,7 +736,7 @@ rproc_handle_virtio_rsc(struct rproc *rproc, struct fw_resource *rsc, int len)
  * processors that don't need a resource table.
  */
 static int rproc_handle_resources(struct rproc *rproc, const u8 *elf_data,
-					rproc_handle_resources_t handler)
+				size_t len, rproc_handle_resources_t handler)
 
 {
 	struct elf32_hdr *ehdr;
@@ -743,6 +754,13 @@ static int rproc_handle_resources(struct rproc *rproc, const u8 *elf_data,
 			struct fw_resource *table = (struct fw_resource *)
 						(elf_data + shdr->sh_offset);
 
+			if (shdr->sh_offset + shdr->sh_size > len) {
+				dev_err(rproc->dev,
+					"truncated fw: need 0x%x avail 0x%x\n",
+					shdr->sh_offset + shdr->sh_size, len);
+				ret = -EINVAL;
+			}
+
 			ret = handler(rproc, table, shdr->sh_size);
 
 			break;
@@ -833,6 +851,11 @@ static int rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw)
 
 	ehdr = (struct elf32_hdr *)fw->data;
 
+	if (fw->size < ehdr->e_shoff + sizeof(struct elf32_shdr)) {
+		dev_err(dev, "Image is too small\n");
+		return -EINVAL;
+	}
+
 	if (memcmp(ehdr->e_ident, ELFMAG, SELFMAG)) {
 		dev_err(dev, "Image is corrupted (bad magic)\n");
 		return -EINVAL;
@@ -887,14 +910,15 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 	rproc->bootaddr = ehdr->e_entry;
 
 	/* handle fw resources which are required to boot rproc */
-	ret = rproc_handle_resources(rproc, fw->data, rproc_handle_boot_rsc);
+	ret = rproc_handle_resources(rproc, fw->data, fw->size,
+						rproc_handle_boot_rsc);
 	if (ret) {
 		dev_err(dev, "Failed to process resources: %d\n", ret);
 		goto clean_up;
 	}
 
 	/* load the ELF segments to memory */
-	ret = rproc_load_segments(rproc, fw->data);
+	ret = rproc_load_segments(rproc, fw->data, fw->size);
 	if (ret) {
 		dev_err(dev, "Failed to load program segments: %d\n", ret);
 		goto clean_up;
@@ -937,7 +961,8 @@ static void rproc_fw_config_virtio(const struct firmware *fw, void *context)
 		goto out;
 
 	/* does the fw supports any virtio devices ? */
-	ret = rproc_handle_resources(rproc, fw->data, rproc_handle_virtio_rsc);
+	ret = rproc_handle_resources(rproc, fw->data, fw->size,
+						rproc_handle_virtio_rsc);
 	if (ret) {
 		dev_info(dev, "No fw virtio device was found\n");
 		goto out;
-- 
1.7.5.4

