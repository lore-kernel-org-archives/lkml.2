Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab2FFNjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 09:39:46 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58275 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044Ab2FFNin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 09:38:43 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCH 6/7] remoteproc: Support custom firmware handlers
Date: Wed,  6 Jun 2012 15:38:26 +0200
Message-Id: <1338989907-25360-7-git-send-email-sjur.brandeland@stericsson.com>
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

Firmware handling is made customizable.
This is done by creating a separate ops structure for the
firmware functions that depends on a particular firmware
format (such as ELF). The ELF specific functions are exported
by the structure rproc_elf_fw_ops.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/omap_remoteproc.c       |    1 +
 drivers/remoteproc/remoteproc_core.c       |    2 +-
 drivers/remoteproc/remoteproc_elf_loader.c |   22 +++++++---
 include/linux/remoteproc.h                 |   61 ++++++++++++++++++++++++----
 4 files changed, 70 insertions(+), 16 deletions(-)

diff --git a/drivers/remoteproc/omap_remoteproc.c b/drivers/remoteproc/omap_remoteproc.c
index 69425c4..53ceaab 100644
--- a/drivers/remoteproc/omap_remoteproc.c
+++ b/drivers/remoteproc/omap_remoteproc.c
@@ -171,6 +171,7 @@ static struct rproc_ops omap_rproc_ops = {
 	.start		= omap_rproc_start,
 	.stop		= omap_rproc_stop,
 	.kick		= omap_rproc_kick,
+	.fw		= &rproc_elf_fw_ops
 };
 
 static int __devinit omap_rproc_probe(struct platform_device *pdev)
diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index db5359a..a68df8c 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1237,7 +1237,7 @@ struct rproc *rproc_alloc(struct device *dev, const char *name,
 {
 	struct rproc *rproc;
 
-	if (!dev || !name || !ops)
+	if (!dev || !name || !ops || !ops->fw_ops)
 		return NULL;
 
 	rproc = kzalloc(sizeof(struct rproc) + len, GFP_KERNEL);
diff --git a/drivers/remoteproc/remoteproc_elf_loader.c b/drivers/remoteproc/remoteproc_elf_loader.c
index 2017ae3..9a53871 100644
--- a/drivers/remoteproc/remoteproc_elf_loader.c
+++ b/drivers/remoteproc/remoteproc_elf_loader.c
@@ -33,8 +33,8 @@
 #include "remoteproc_internal.h"
 
 /* make sure this fw image is sane */
-int
-rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw)
+static int
+elf_sanity_check(struct rproc *rproc, const struct firmware *fw)
 {
 	const char *name = rproc->firmware;
 	struct device *dev = rproc->dev;
@@ -103,7 +103,7 @@ rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw)
  * Note that the boot address is not a configurable property of all remote
  * processors. Some will always boot at a specific hard-coded address.
  */
-void rproc_set_boot_addr(struct rproc *rproc, const struct firmware *fw)
+static void elf_set_boot_addr(struct rproc *rproc, const struct firmware *fw)
 {
 	struct elf32_hdr *ehdr  = (struct elf32_hdr *)fw->data;
 	rproc->bootaddr = ehdr->e_entry;
@@ -133,8 +133,8 @@ void rproc_set_boot_addr(struct rproc *rproc, const struct firmware *fw)
  * directly allocate memory for every segment/resource. This is not yet
  * supported, though.
  */
-int
-rproc_load_segments(struct rproc *rproc, const struct firmware *fw)
+static int
+elf_load_segments(struct rproc *rproc, const struct firmware *fw)
 {
 	struct device *dev = rproc->dev;
 	struct elf32_hdr *ehdr;
@@ -214,8 +214,8 @@ rproc_load_segments(struct rproc *rproc, const struct firmware *fw)
  * size into @tablesz. If a valid table isn't found, NULL is returned
  * (and @tablesz isn't set).
  */
-struct resource_table *
-rproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
+static struct resource_table *
+elf_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
 							int *tablesz)
 {
 	struct elf32_hdr *ehdr;
@@ -277,3 +277,11 @@ rproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
 
 	return table;
 }
+
+struct rproc_fw_ops rproc_elf_fw_ops = {
+	.load = elf_load_segments,
+	.find_rsc_table = elf_find_rsc_table,
+	.sanity_check = elf_sanity_check,
+	.set_boot_addr = elf_set_boot_addr
+};
+EXPORT_SYMBOL(rproc_elf_fw_ops);
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index 997e816..23c5c254 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -327,25 +327,37 @@ struct rproc_mem_entry {
 
 struct rproc;
 
-int
-rproc_load_segments(struct rproc *rproc, const struct firmware *fw);
-struct resource_table *
-rproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
-								int *tablesz);
-int
-rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw);
-void rproc_set_boot_addr(struct rproc *rproc, const struct firmware *fw);
+/**
+ * struct rproc_fw_ops - firmware format specific operations.
+ *
+ * @find_rsc_table:	finds the resource table inside the firmware image.
+ * @load_fw:		load firmeware to memory, where the remote processor
+ *			expects to find it.
+ * @sanity_check:	sanity check the fw image.
+ * @set_boot_addr:	set boot address to entry point as specified in
+ *			firmware.
+ */
+struct rproc_fw_ops {
+	struct resource_table *(*find_rsc_table) (struct rproc *rproc,
+						const struct firmware *fw,
+						int *tablesz);
+	int (*load)(struct rproc *rproc, const struct firmware *fw);
+	int (*sanity_check)(struct rproc *rproc, const struct firmware *fw);
+	void (*set_boot_addr)(struct rproc *rproc, const struct firmware *fw);
+};
 
 /**
  * struct rproc_ops - platform-specific device handlers
  * @start:	power on the device and boot it
  * @stop:	power off the device
  * @kick:	kick a virtqueue (virtqueue id given as a parameter)
+ * @fw_ops:	firmware operations for the remote processor
  */
 struct rproc_ops {
 	int (*start)(struct rproc *rproc);
 	int (*stop)(struct rproc *rproc);
 	void (*kick)(struct rproc *rproc, int vqid);
+	struct rproc_fw_ops *fw_ops;
 };
 
 /**
@@ -486,4 +498,37 @@ static inline struct rproc *vdev_to_rproc(struct virtio_device *vdev)
 	return rvdev->rproc;
 }
 
+static inline int
+rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw)
+{
+	if (rproc->ops->fw_ops->sanity_check)
+		return rproc->ops->fw_ops->sanity_check(rproc, fw);
+	return 0;
+}
+
+static inline
+void rproc_set_boot_addr(struct rproc *rproc, const struct firmware *fw)
+{
+	if (rproc->ops->fw_ops->set_boot_addr)
+		rproc->ops->fw_ops->set_boot_addr(rproc, fw);
+}
+
+static inline int
+rproc_load_segments(struct rproc *rproc, const struct firmware *fw)
+{
+	if (rproc->ops->fw_ops->load)
+		return rproc->ops->fw_ops->load(rproc, fw);
+	return -EINVAL;
+}
+static inline struct resource_table *
+rproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
+							int *tablesz)
+{
+	if (rproc->ops->fw_ops->find_rsc_table)
+		return rproc->ops->fw_ops->find_rsc_table(rproc, fw, tablesz);
+	return NULL;
+}
+
+extern struct rproc_fw_ops rproc_elf_fw_ops;
+
 #endif /* REMOTEPROC_H */
-- 
1.7.5.4

