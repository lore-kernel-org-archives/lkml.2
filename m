Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab2FRPWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 11:22:15 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55444 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab2FRPWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 11:22:11 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCHv3 4/4] remoteproc: Support custom firmware handlers
Date: Mon, 18 Jun 2012 17:21:55 +0200
Message-Id: <1340032915-10734-5-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340032915-10734-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1340032915-10734-1-git-send-email-sjur.brandeland@stericsson.com>
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
format (such as ELF). The ELF functions are default used
unless the HW driver explicitly injects another firmware
handler by updating rproc->fw_ops.
The function rproc_da_to_va() is exported, as custom
firmware handlers may need to use this function.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c       |    4 +++
 drivers/remoteproc/remoteproc_elf_loader.c |   27 +++++++++++++--------
 drivers/remoteproc/remoteproc_internal.h   |   35 ++++++++++++++++++++++++++++
 include/linux/remoteproc.h                 |   29 ++++++++++++++++------
 4 files changed, 77 insertions(+), 18 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index b642850..6779c2a 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -188,6 +188,7 @@ void *rproc_da_to_va(struct rproc *rproc, u64 da, int len)
 
 	return ptr;
 }
+EXPORT_SYMBOL(rproc_da_to_va);
 
 static int
 __rproc_handle_vring(struct rproc_vdev *rvdev, struct fw_rsc_vdev *rsc, int i)
@@ -1251,6 +1252,9 @@ struct rproc *rproc_alloc(struct device *dev, const char *name,
 
 	atomic_set(&rproc->power, 0);
 
+	/* Set ELF as the default fw_ops handler */
+	rproc->fw_ops = &rproc_elf_fw_ops;
+
 	kref_init(&rproc->refcount);
 
 	mutex_init(&rproc->lock);
diff --git a/drivers/remoteproc/remoteproc_elf_loader.c b/drivers/remoteproc/remoteproc_elf_loader.c
index 06e35dc..5e8ee06 100644
--- a/drivers/remoteproc/remoteproc_elf_loader.c
+++ b/drivers/remoteproc/remoteproc_elf_loader.c
@@ -33,13 +33,13 @@
 #include "remoteproc_internal.h"
 
 /**
- * rproc_fw_sanity_check() - Sanity Check ELF firmware image
+ * _rproc_sanity_check() - Sanity Check ELF firmware image
  * @fw: the ELF firmware image
  *
  * Make sure this fw image is sane.
  */
-int
-rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw)
+static int
+_rproc_sanity_check(struct rproc *rproc, const struct firmware *fw)
 {
 	const char *name = rproc->firmware;
 	struct device *dev = rproc->dev;
@@ -99,14 +99,14 @@ rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw)
 }
 
 /**
- * rproc_get_boot_addr() - Get rproc's boot address.
+ * _rproc_get_boot_addr() - Get rproc's boot address.
  * @fw: the ELF firmware image
  *
  * This function reads the ELF entry point address.
  * Note that the boot address is not a configurable property of all remote
  * processors. Some will always boot at a specific hard-coded address.
  */
-u32 rproc_get_boot_addr(struct rproc *rproc, const struct firmware *fw)
+static u32 _rproc_get_boot_addr(struct rproc *rproc, const struct firmware *fw)
 {
 	struct elf32_hdr *ehdr  = (struct elf32_hdr *)fw->data;
 	return ehdr->e_entry;
@@ -136,8 +136,8 @@ u32 rproc_get_boot_addr(struct rproc *rproc, const struct firmware *fw)
  * directly allocate memory for every segment/resource. This is not yet
  * supported, though.
  */
-int
-rproc_load_segments(struct rproc *rproc, const struct firmware *fw)
+static int
+_rproc_load_segments(struct rproc *rproc, const struct firmware *fw)
 {
 	struct device *dev = rproc->dev;
 	struct elf32_hdr *ehdr;
@@ -203,7 +203,7 @@ rproc_load_segments(struct rproc *rproc, const struct firmware *fw)
 }
 
 /**
- * rproc_find_rsc_table() - find the resource table
+ * _rproc_find_rsc_table() - find the resource table
  * @rproc: the rproc handle
  * @fw: the ELF firmware image
  * @tablesz: place holder for providing back the table size
@@ -217,8 +217,8 @@ rproc_load_segments(struct rproc *rproc, const struct firmware *fw)
  * size into @tablesz. If a valid table isn't found, NULL is returned
  * (and @tablesz isn't set).
  */
-struct resource_table *
-rproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
+static struct resource_table *
+_rproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
 							int *tablesz)
 {
 	struct elf32_hdr *ehdr;
@@ -280,3 +280,10 @@ rproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
 
 	return table;
 }
+
+const struct rproc_fw_ops rproc_elf_fw_ops = {
+	.load = _rproc_load_segments,
+	.find_rsc_table = _rproc_find_rsc_table,
+	.sanity_check = _rproc_sanity_check,
+	.get_boot_addr = _rproc_get_boot_addr
+};
diff --git a/drivers/remoteproc/remoteproc_internal.h b/drivers/remoteproc/remoteproc_internal.h
index 25e0b91..ddb45de 100644
--- a/drivers/remoteproc/remoteproc_internal.h
+++ b/drivers/remoteproc/remoteproc_internal.h
@@ -42,4 +42,39 @@ void rproc_init_debugfs(void);
 void rproc_exit_debugfs(void);
 void *rproc_da_to_va(struct rproc *rproc, u64 da, int len);
 
+static inline int
+rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw)
+{
+	if (rproc->fw_ops->sanity_check)
+		return rproc->fw_ops->sanity_check(rproc, fw);
+	return 0;
+}
+
+static inline
+u32 rproc_get_boot_addr(struct rproc *rproc, const struct firmware *fw)
+{
+	if (rproc->fw_ops->get_boot_addr)
+		return rproc->fw_ops->get_boot_addr(rproc, fw);
+	return 0;
+}
+
+static inline int
+rproc_load_segments(struct rproc *rproc, const struct firmware *fw)
+{
+	if (rproc->fw_ops->load)
+		return rproc->fw_ops->load(rproc, fw);
+	return -EINVAL;
+}
+
+static inline struct resource_table *
+rproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
+							int *tablesz)
+{
+	if (rproc->fw_ops->find_rsc_table)
+		return rproc->fw_ops->find_rsc_table(rproc, fw, tablesz);
+	return NULL;
+}
+
+extern const struct rproc_fw_ops rproc_elf_fw_ops;
+
 #endif /* REMOTEPROC_INTERNAL_H */
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index d6853da..7404734 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -327,14 +327,6 @@ struct rproc_mem_entry {
 
 struct rproc;
 
-struct resource_table *rproc_find_rsc_table(struct rproc *rproc,
-						const struct firmware *fw,
-						int *tablesz);
-int rproc_load_segments(struct rproc *rproc, const struct firmware *fw);
-int rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw);
-u32 rproc_get_boot_addr(struct rproc *rproc, const struct firmware *fw);
-
-
 /**
  * struct rproc_ops - platform-specific device handlers
  * @start:	power on the device and boot it
@@ -347,6 +339,25 @@ struct rproc_ops {
 	void (*kick)(struct rproc *rproc, int vqid);
 };
 
+
+/**
+ * struct rproc_fw_ops - firmware format specific operations.
+ *
+ * @find_rsc_table:	finds the resource table inside the firmware image
+ * @load:		load firmeware to memory, where the remote processor
+ *			expects to find it
+ * @sanity_check:	sanity check the fw image
+ * @get_boot_addr:	get boot address to entry point specified in firmware
+ */
+struct rproc_fw_ops {
+	struct resource_table *(*find_rsc_table) (struct rproc *rproc,
+						const struct firmware *fw,
+						int *tablesz);
+	int (*load)(struct rproc *rproc, const struct firmware *fw);
+	int (*sanity_check)(struct rproc *rproc, const struct firmware *fw);
+	u32 (*get_boot_addr)(struct rproc *rproc, const struct firmware *fw);
+};
+
 /**
  * enum rproc_state - remote processor states
  * @RPROC_OFFLINE:	device is powered off
@@ -378,6 +389,7 @@ enum rproc_state {
  * @firmware: name of firmware file to be loaded
  * @priv: private data which belongs to the platform-specific rproc module
  * @ops: platform-specific start/stop rproc handlers
+ * @fw_ops: firmware-specific handlers
  * @dev: underlying device
  * @refcount: refcount of users that have a valid pointer to this rproc
  * @power: refcount of users who need this rproc powered up
@@ -400,6 +412,7 @@ struct rproc {
 	const char *firmware;
 	void *priv;
 	const struct rproc_ops *ops;
+	const struct rproc_fw_ops *fw_ops;
 	struct device *dev;
 	struct kref refcount;
 	atomic_t power;
-- 
1.7.5.4

