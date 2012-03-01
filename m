Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636Ab2CAIMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 03:12:55 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49993 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758624Ab2CAIMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 03:12:53 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ohad@wizery.com designates 10.180.84.41 as permitted sender) smtp.mail=ohad@wizery.com
MIME-Version: 1.0
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Brian Swetland <swetland@google.com>,
        Iliyan Malchev <malchev@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rusty Russell <rusty@rustcorp.com.au>, Mark Grosen <mgrosen@ti.com>,
        John Williams <john.williams@petalogix.com>,
        Michal Simek <monstr@monstr.eu>,
        Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Guzman Lugo Fernando <fernando.lugo@ti.com>,
        Anna Suman <s-anna@ti.com>, Clark Rob <rob@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Kieran Bingham <kieranbingham@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 7/7] remoteproc: cleanup resource table parsing paths
Date: Thu,  1 Mar 2012 10:11:37 +0200
Message-Id: <1330589497-4139-8-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1330589497-4139-1-git-send-email-ohad@wizery.com>
References: <1330589497-4139-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rproc_handle_resources() looks for the resource table and then
invokes a resource handler function which it took as a parameter.

This works, but it's a bit unintuitive to follow.

Instead of passing around function pointers, this patch changes
rproc_handle_resource() to just find and return the resource table,
and then the calling sites of rproc_handle_resource() invoke their
resource handlers directly.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Brian Swetland <swetland@google.com>
Cc: Iliyan Malchev <malchev@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mark Grosen <mgrosen@ti.com>
Cc: John Williams <john.williams@petalogix.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>
Cc: Ludovic BARRE <ludovic.barre@stericsson.com>
Cc: Omar Ramirez Luna <omar.luna@linaro.org>
Cc: Guzman Lugo Fernando <fernando.lugo@ti.com>
Cc: Anna Suman <s-anna@ti.com>
Cc: Clark Rob <rob@ti.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Saravana Kannan <skannan@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>
Cc: Kieran Bingham <kieranbingham@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
---
 drivers/remoteproc/remoteproc_core.c |   70 ++++++++++++++++++---------------
 1 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 9be5dad..ee15c68 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -822,32 +822,31 @@ rproc_handle_virtio_rsc(struct rproc *rproc, struct resource_table *table, int l
 }
 
 /**
- * rproc_handle_resources() - find and handle the resource table
+ * rproc_find_rsc_table() - find the resource table
  * @rproc: the rproc handle
  * @elf_data: the content of the ELF firmware image
  * @len: firmware size (in bytes)
- * @handler: function that should be used to handle the resource table
+ * @tablesz: place holder for providing back the table size
  *
  * This function finds the resource table inside the remote processor's
- * firmware, and invoke a user-supplied handler with it (we have two
- * possible handlers: one is invoked upon registration of @rproc,
- * in order to register the supported virito devices, and the other is
- * invoked when @rproc is actually booted).
- *
- * Currently this function fails if a resource table doesn't exist.
- * This restriction will be removed when we'll start supporting remote
- * processors that don't need a resource table.
+ * firmware. It is used both upon the registration of @rproc (in order
+ * to look for and register the supported virito devices), and when the
+ * @rproc is booted.
+ *
+ * Returns the pointer to the resource table if it is found, and write its
+ * size into @tablesz. If a valid table isn't found, NULL is returned
+ * (and @tablesz isn't set).
  */
-static int rproc_handle_resources(struct rproc *rproc, const u8 *elf_data,
-				size_t len, rproc_handle_resources_t handler)
-
+static struct resource_table *
+rproc_find_rsc_table(struct rproc *rproc, const u8 *elf_data, size_t len,
+							int *tablesz)
 {
 	struct elf32_hdr *ehdr;
 	struct elf32_shdr *shdr;
 	const char *name_table;
 	struct device *dev = rproc->dev;
-	int i, ret = -EINVAL;
-	struct resource_table *table;
+	struct resource_table *table = NULL;
+	int i;
 
 	ehdr = (struct elf32_hdr *)elf_data;
 	shdr = (struct elf32_shdr *)(elf_data + ehdr->e_shoff);
@@ -866,39 +865,39 @@ static int rproc_handle_resources(struct rproc *rproc, const u8 *elf_data,
 		/* make sure we have the entire table */
 		if (offset + size > len) {
 			dev_err(dev, "resource table truncated\n");
-			return -EINVAL;
+			return NULL;
 		}
 
 		/* make sure table has at least the header */
 		if (sizeof(struct resource_table) > size) {
 			dev_err(dev, "header-less resource table\n");
-			return -EINVAL;
+			return NULL;
 		}
 
 		/* we don't support any version beyond the first */
 		if (table->ver != 1) {
 			dev_err(dev, "unsupported fw ver: %d\n", table->ver);
-			return -EINVAL;
+			return NULL;
 		}
 
 		/* make sure reserved bytes are zeroes */
 		if (table->reserved[0] || table->reserved[1]) {
 			dev_err(dev, "non zero reserved bytes\n");
-			return -EINVAL;
+			return NULL;
 		}
 
 		/* make sure the offsets array isn't truncated */
 		if (table->num * sizeof(table->offset[0]) +
 				sizeof(struct resource_table) > size) {
 			dev_err(dev, "resource table incomplete\n");
-			return -EINVAL;
+			return NULL;
 		}
 
-		ret = handler(rproc, table, shdr->sh_size);
+		*tablesz = shdr->sh_size;
 		break;
 	}
 
-	return ret;
+	return table;
 }
 
 /**
@@ -1012,7 +1011,8 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 	struct device *dev = rproc->dev;
 	const char *name = rproc->firmware;
 	struct elf32_hdr *ehdr;
-	int ret;
+	struct resource_table *table;
+	int ret, tablesz;
 
 	ret = rproc_fw_sanity_check(rproc, fw);
 	if (ret)
@@ -1039,9 +1039,13 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
 	 */
 	rproc->bootaddr = ehdr->e_entry;
 
+	/* look for the resource table */
+	table = rproc_find_rsc_table(rproc, fw->data, fw->size, &tablesz);
+	if (!table)
+		goto clean_up;
+
 	/* handle fw resources which are required to boot rproc */
-	ret = rproc_handle_resources(rproc, fw->data, fw->size,
-						rproc_handle_boot_rsc);
+	ret = rproc_handle_boot_rsc(rproc, table, tablesz);
 	if (ret) {
 		dev_err(dev, "Failed to process resources: %d\n", ret);
 		goto clean_up;
@@ -1084,19 +1088,21 @@ clean_up:
 static void rproc_fw_config_virtio(const struct firmware *fw, void *context)
 {
 	struct rproc *rproc = context;
-	struct device *dev = rproc->dev;
-	int ret;
+	struct resource_table *table;
+	int ret, tablesz;
 
 	if (rproc_fw_sanity_check(rproc, fw) < 0)
 		goto out;
 
-	/* does the fw support any virtio devices ? */
-	ret = rproc_handle_resources(rproc, fw->data, fw->size,
-						rproc_handle_virtio_rsc);
-	if (ret) {
-		dev_info(dev, "No fw virtio device was found\n");
+	/* look for the resource table */
+	table = rproc_find_rsc_table(rproc, fw->data, fw->size, &tablesz);
+	if (!table)
+		goto out;
+
+	/* look for virtio devices and register them */
+	ret = rproc_handle_virtio_rsc(rproc, table, tablesz);
+	if (ret)
 		goto out;
-	}
 
 out:
 	if (fw)
-- 
1.7.5.4

