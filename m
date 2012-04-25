Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759154Ab2DYVKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 17:10:11 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52811 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757504Ab2DYVKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 17:10:08 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>
Subject: Remoteproc adaptations for ST-Ericsson modems
Date: Wed, 25 Apr 2012 23:10:00 +0200
Message-Id: <1335388200-18504-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad.

I have been thinking a bit more on the requirement we may have for
using remoteproc. I've also played around with remoteproc a bit,
and this is what I've found so far.

1. Support for non-ELF binaries:
I'd like to see a solution for finding the ”resource_table” in non-ELF
binaries and loading a non-ELF file. I have put together a patch below
doing this by ”overloading” the functions find_rsc_table() and load().

2. Physical addressing:
Support for specifying physical memory locations in resource table.
We need some way to specify physical memory locations instead of using
carveouts. The physical address will be outside the allocatable Linux
memory. I'm not sure what is best approach here.


And a couple "nice to have":

User-space life-cycle interface:
The modem life-cycle is managed from user-space. It would be nice to
have e.g. sysfs entries for start and stop of the modem from
remoteproc.

Skip the dependency on a driver:
Current solution assume that remoteproc is initiated from device
driver. In the current C2C driver implementation we have internally,
the device and driver is hidden underneath a functional API.
So it doesn't necessarily make sense for us that remoteproc requires
a device and driver as input.

Skip load of firmware during early boot:
I probably missed something, but this feature doesn't make sense
to me. Also it causes big warning from sysfs if I don't finish
the async loading before starting the blocking loading of firmware.
And I fail to see the need for it. I think it would be nice to be
able to turn this feature off.

Below is a stab at supporting non-ELF binaries and disabling the
pre-loading of ELF. Please consider this as an idea - I'd be quite
happy if you take over the initiative and come up with a competely
different solution...

Regards,
Sjur


---
 drivers/remoteproc/remoteproc_core.c |   62 ++++++++++++++++++++++------------
 include/linux/remoteproc.h           |   12 +++++-
 2 files changed, 50 insertions(+), 24 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index ee15c68..f1b2fc9 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -45,6 +45,7 @@
 
 static void klist_rproc_get(struct klist_node *n);
 static void klist_rproc_put(struct klist_node *n);
+static void rproc_fw_config_virtio(const struct firmware *fw, void *context);
 
 /*
  * klist of the available remote processors.
@@ -215,7 +216,7 @@ static void *rproc_da_to_va(struct rproc *rproc, u64 da, int len)
  * supported, though.
  */
 static int
-rproc_load_segments(struct rproc *rproc, const u8 *elf_data, size_t len)
+default_rproc_load_segments(struct rproc *rproc, const u8 *elf_data, size_t len)
 {
 	struct device *dev = rproc->dev;
 	struct elf32_hdr *ehdr;
@@ -822,7 +823,7 @@ rproc_handle_virtio_rsc(struct rproc *rproc, struct resource_table *table, int l
 }
 
 /**
- * rproc_find_rsc_table() - find the resource table
+ * default_rproc_find_rsc_table() - find the resource table
  * @rproc: the rproc handle
  * @elf_data: the content of the ELF firmware image
  * @len: firmware size (in bytes)
@@ -838,8 +839,8 @@ rproc_handle_virtio_rsc(struct rproc *rproc, struct resource_table *table, int l
  * (and @tablesz isn't set).
  */
 static struct resource_table *
-rproc_find_rsc_table(struct rproc *rproc, const u8 *elf_data, size_t len,
-							int *tablesz)
+default_rproc_find_rsc_table(struct rproc *rproc, const u8 *elf_data,
+			     size_t len, int *tablesz)
 {
 	struct elf32_hdr *ehdr;
 	struct elf32_shdr *shdr;
@@ -1014,11 +1015,18 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 	struct resource_table *table;
 	int ret, tablesz;
 
-	ret = rproc_fw_sanity_check(rproc, fw);
-	if (ret)
-		return ret;
-
-	ehdr = (struct elf32_hdr *)fw->data;
+	if (rproc->feature & RPROC_DO_USE_ELF) {
+		ret = rproc_fw_sanity_check(rproc, fw);
+		if (ret)
+			return ret;
+		/*
+		 * The ELF entry point is the rproc's boot addr (though this
+		 * is not a configurable property of all remote processors:
+		 * some will always boot at a specific hardcoded address).
+		 */
+		ehdr = (struct elf32_hdr *)fw->data;
+		rproc->bootaddr = ehdr->e_entry;
+	}
 
 	dev_info(dev, "Booting fw image %s, size %d\n", name, fw->size);
 
@@ -1032,18 +1040,14 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
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
+	table = rproc->ops->find_rsc_table(rproc, fw->data, fw->size, &tablesz);
 	if (!table)
 		goto clean_up;
 
+	if (!(rproc->feature & RPROC_DO_EARLY_LOAD))
+		rproc_fw_config_virtio(fw, rproc);
+
 	/* handle fw resources which are required to boot rproc */
 	ret = rproc_handle_boot_rsc(rproc, table, tablesz);
 	if (ret) {
@@ -1052,7 +1056,7 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 	}
 
 	/* load the ELF segments to memory */
-	ret = rproc_load_segments(rproc, fw->data, fw->size);
+	ret = rproc->ops->load(rproc, fw->data, fw->size);
 	if (ret) {
 		dev_err(dev, "Failed to load program segments: %d\n", ret);
 		goto clean_up;
@@ -1091,11 +1095,13 @@ static void rproc_fw_config_virtio(const struct firmware *fw, void *context)
 	struct resource_table *table;
 	int ret, tablesz;
 
-	if (rproc_fw_sanity_check(rproc, fw) < 0)
+	if ((rproc->feature & RPROC_DO_USE_ELF) &&
+	    rproc_fw_sanity_check(rproc, fw) < 0)
 		goto out;
 
 	/* look for the resource table */
-	table = rproc_find_rsc_table(rproc, fw->data, fw->size, &tablesz);
+	table = rproc->ops->find_rsc_table(rproc, fw->data,
+					   fw->size, &tablesz);
 	if (!table)
 		goto out;
 
@@ -1422,6 +1428,10 @@ int rproc_register(struct rproc *rproc)
 	/* rproc_unregister() calls must wait until async loader completes */
 	init_completion(&rproc->firmware_loading_complete);
 
+	/* look for the resource table */
+	if (!(rproc->feature & RPROC_DO_EARLY_LOAD))
+		return ret;
+
 	/*
 	 * We must retrieve early virtio configuration info from
 	 * the firmware (e.g. whether to register a virtio device,
@@ -1467,7 +1477,7 @@ EXPORT_SYMBOL(rproc_register);
  * yet. Instead, if you just need to unroll rproc_alloc(), use rproc_free().
  */
 struct rproc *rproc_alloc(struct device *dev, const char *name,
-				const struct rproc_ops *ops,
+				struct rproc_ops *ops,
 				const char *firmware, int len)
 {
 	struct rproc *rproc;
@@ -1487,6 +1497,13 @@ struct rproc *rproc_alloc(struct device *dev, const char *name,
 	rproc->firmware = firmware;
 	rproc->priv = &rproc[1];
 
+
+	if (!rproc->ops->find_rsc_table)
+		rproc->ops->find_rsc_table = default_rproc_find_rsc_table;
+
+	if (!rproc->ops->load)
+		rproc->ops->load = default_rproc_load_segments;
+
 	atomic_set(&rproc->power, 0);
 
 	kref_init(&rproc->refcount);
@@ -1501,7 +1518,8 @@ struct rproc *rproc_alloc(struct device *dev, const char *name,
 	INIT_LIST_HEAD(&rproc->rvdevs);
 
 	rproc->state = RPROC_OFFLINE;
-
+	rproc->feature = RPROC_DO_EARLY_LOAD;
+	rproc->feature = RPROC_DO_USE_ELF;
 	return rproc;
 }
 EXPORT_SYMBOL(rproc_alloc);
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index f1ffabb..2f88b5e 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -336,6 +336,10 @@ struct rproc_ops {
 	int (*start)(struct rproc *rproc);
 	int (*stop)(struct rproc *rproc);
 	void (*kick)(struct rproc *rproc, int vqid);
+	struct resource_table *(*find_rsc_table) (struct rproc *rproc,
+						  const u8 *data,
+						  size_t len, int *tablesz);
+	int (*load)(struct rproc *rproc, const u8 *data, size_t len);
 };
 
 /**
@@ -390,7 +394,7 @@ struct rproc {
 	const char *name;
 	const char *firmware;
 	void *priv;
-	const struct rproc_ops *ops;
+	struct rproc_ops *ops;
 	struct device *dev;
 	struct kref refcount;
 	atomic_t power;
@@ -405,8 +409,12 @@ struct rproc {
 	u32 bootaddr;
 	struct list_head rvdevs;
 	struct idr notifyids;
+	u32 feature;
 };
 
+#define RPROC_DO_EARLY_LOAD (1 << 1)
+#define RPROC_DO_USE_ELF (1 << 2)
+
 /* we currently support only two vrings per rvdev */
 #define RVDEV_NUM_VRINGS 2
 
@@ -454,7 +462,7 @@ struct rproc *rproc_get_by_name(const char *name);
 void rproc_put(struct rproc *rproc);
 
 struct rproc *rproc_alloc(struct device *dev, const char *name,
-				const struct rproc_ops *ops,
+				struct rproc_ops *ops,
 				const char *firmware, int len);
 void rproc_free(struct rproc *rproc);
 int rproc_register(struct rproc *rproc);
-- 
1.7.5.4

