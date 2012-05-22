Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab2EVN1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 09:27:15 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33999 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754549Ab2EVN1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 09:27:12 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFC 5/6] remoteproc: Support custom firmware handlers
Date: Tue, 22 May 2012 15:26:56 +0200
Message-Id: <1337693217-15466-6-git-send-email-sjur.brandeland@stericsson.com>
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

Make the firmware handling customizable by creating
a rproc_fw_ops structure. Expose the existing
Elf firmware handling in rproc_elf_fw_ops.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/omap_remoteproc.c       |    1 +
 drivers/remoteproc/remoteproc_core.c       |   26 +++++++++++++++++---------
 drivers/remoteproc/remoteproc_elf_loader.c |   11 +++++++++--
 include/linux/remoteproc.h                 |   23 ++++++++++++++++++-----
 4 files changed, 45 insertions(+), 16 deletions(-)

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
index 33384e6..75984ad 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -36,7 +36,6 @@
 #include <linux/remoteproc.h>
 #include <linux/iommu.h>
 #include <linux/klist.h>
-#include <linux/elf.h>
 #include <linux/virtio_ids.h>
 #include <linux/virtio_ring.h>
 #include <asm/byteorder.h>
@@ -781,12 +780,13 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 {
 	struct device *dev = rproc->dev;
 	const char *name = rproc->firmware;
-	struct elf32_hdr *ehdr;
 	struct resource_table *table;
 	int ret, tablesz;
 
-	ehdr = (struct elf32_hdr *)fw->data;
-
+	if (!rproc->ops->fw_ops || !try_module_get(rproc->ops->fw_ops->owner)) {
+		dev_err(dev, "%s: can't get fw_ops->owner\n", __func__);
+		ret = -EINVAL;
+	}
 	dev_info(dev, "Booting fw image %s, size %zd\n", name, fw->size);
 
 	/*
@@ -796,11 +796,11 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 	ret = rproc_enable_iommu(rproc);
 	if (ret) {
 		dev_err(dev, "can't enable iommu: %d\n", ret);
-		return ret;
+		goto out;
 	}
 
 	/* look for the resource table */
-	table = rproc_find_rsc_table(rproc, fw, &tablesz);
+	table = rproc->ops->fw_ops->find_rsc_table(rproc, fw, &tablesz);
 	if (!table) {
 		ret = -EINVAL;
 		goto clean_up;
@@ -813,8 +813,8 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 		goto clean_up;
 	}
 
-	/* load the ELF segments to memory */
-	ret = rproc_load_segments(rproc, fw);
+	/* load the firmware to memory */
+	ret = rproc->ops->fw_ops->load_fw(rproc, fw);
 	if (ret) {
 		dev_err(dev, "Failed to load program segments: %d\n", ret);
 		goto clean_up;
@@ -836,6 +836,8 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 clean_up:
 	rproc_resource_cleanup(rproc);
 	rproc_disable_iommu(rproc);
+out:
+	module_put(rproc->ops->fw_ops->owner);
 	return ret;
 }
 
@@ -853,8 +855,13 @@ static void rproc_fw_config_virtio(const struct firmware *fw, void *context)
 	struct resource_table *table;
 	int ret, tablesz;
 
+	if (!rproc->ops->fw_ops || !try_module_get(rproc->ops->fw_ops->owner)) {
+		dev_err(rproc->dev, "%s: can't get fw_ops->owner\n", __func__);
+		return;
+	}
+
 	/* look for the resource table */
-	table = rproc_find_rsc_table(rproc, fw,  &tablesz);
+	table = rproc->ops->fw_ops->find_rsc_table(rproc, fw,  &tablesz);
 	if (!table)
 		goto out;
 
@@ -864,6 +871,7 @@ static void rproc_fw_config_virtio(const struct firmware *fw, void *context)
 		goto out;
 
 out:
+	module_put(rproc->ops->fw_ops->owner);
 	if (fw)
 		release_firmware(fw);
 	/* allow rproc_unregister() contexts, if any, to proceed */
diff --git a/drivers/remoteproc/remoteproc_elf_loader.c b/drivers/remoteproc/remoteproc_elf_loader.c
index 3a1ae83..b90aeff 100644
--- a/drivers/remoteproc/remoteproc_elf_loader.c
+++ b/drivers/remoteproc/remoteproc_elf_loader.c
@@ -117,7 +117,7 @@ rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw)
  * directly allocate memory for every segment/resource. This is not yet
  * supported, though.
  */
-int
+static int
 rproc_load_segments(struct rproc *rproc, const struct firmware *fw)
 {
 	struct device *dev = rproc->dev;
@@ -198,7 +198,7 @@ rproc_load_segments(struct rproc *rproc, const struct firmware *fw)
  * size into @tablesz. If a valid table isn't found, NULL is returned
  * (and @tablesz isn't set).
  */
-struct resource_table *
+static struct resource_table *
 rproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
 							int *tablesz)
 {
@@ -271,3 +271,10 @@ rproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
 
 	return table;
 }
+
+struct rproc_fw_ops rproc_elf_fw_ops = {
+	.load_fw = rproc_load_segments,
+	.find_rsc_table = rproc_find_rsc_table,
+	.owner = THIS_MODULE
+};
+EXPORT_SYMBOL(rproc_elf_fw_ops);
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index 372d1a8..7ebb1ef 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -327,22 +327,33 @@ struct rproc_mem_entry {
 
 struct rproc;
 
-int
-rproc_load_segments(struct rproc *rproc, const struct firmware *fw);
-struct resource_table *
-rproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
-								int *tablesz);
+/**
+ * struct rproc_fw_ops - firmware format specific operations.
+ * @find_rsc_table:	finds the resource table inside the firmware image.
+ * @load_fw:		load firmeware to memory, where the remote processor
+ *			expects to find it.
+ * @owner:		module owning the operations.
+ */
+struct rproc_fw_ops {
+	struct resource_table *(*find_rsc_table) (struct rproc *rproc,
+						const struct firmware *fw,
+						int *tablesz);
+	int (*load_fw)(struct rproc *rproc, const struct firmware *fw);
+	struct module *owner;
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
@@ -483,4 +494,6 @@ static inline struct rproc *vdev_to_rproc(struct virtio_device *vdev)
 	return rvdev->rproc;
 }
 
+extern struct rproc_fw_ops rproc_elf_fw_ops;
+
 #endif /* REMOTEPROC_H */
-- 
1.7.9.5

