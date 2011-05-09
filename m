Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab1EIShc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 14:37:32 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:55038 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab1EISgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 14:36:33 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH -v3 4/6] EDAC, MCE, AMD: Convert to debugfs
Date: Mon,  9 May 2011 20:35:53 +0200
Message-Id: <1304966155-9841-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1304966155-9841-1-git-send-email-bp@amd64.org>
References: <1304966155-9841-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This is a module which is used for debugging MCE decoding paths so its
userspace interface should go to debugfs, where it belongs conceptually.

While at it, add a warning to the Kconfig text that this interface is
unstable and no userspace scripts should rely all too much on it.

Make it so.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/Kconfig       |    8 +-
 drivers/edac/mce_amd_inj.c |  191 ++++++++++++++++++++------------------------
 2 files changed, 91 insertions(+), 108 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index af1a17d..19f85da 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -52,15 +52,17 @@ config EDAC_DECODE_MCE
 	  has been initialized.
 
 config EDAC_MCE_INJ
-	tristate "Simple MCE injection interface over /sysfs"
-	depends on EDAC_DECODE_MCE
+	tristate "Simple debugfs MCE injection interface"
+	depends on EDAC_DECODE_MCE && DEBUG_FS
 	default n
 	help
-	  This is a simple interface to inject MCEs over /sysfs and test
+	  This is a simple interface to inject MCEs over debugfs and test
 	  the MCE decoding code in EDAC.
 
 	  This is currently AMD-only.
 
+	  WARNING: Do not even assume that this interface is staying stable!
+
 config EDAC_MM_EDAC
 	tristate "Main Memory EDAC (Error Detection And Correction) reporting"
 	help
diff --git a/drivers/edac/mce_amd_inj.c b/drivers/edac/mce_amd_inj.c
index eb36e15..421c3b5 100644
--- a/drivers/edac/mce_amd_inj.c
+++ b/drivers/edac/mce_amd_inj.c
@@ -10,24 +10,47 @@
  *			Advanced Micro Devices Inc.
  */
 
-#include <linux/kobject.h>
-#include <linux/sysdev.h>
 #include <linux/edac.h>
+#include <linux/debugfs.h>
 #include <asm/mce.h>
 
 #include "mce_amd.h"
 
-struct edac_mce_attr {
-	struct attribute attr;
-	ssize_t (*show) (struct kobject *kobj, struct edac_mce_attr *attr, char *buf);
-	ssize_t (*store)(struct kobject *kobj, struct edac_mce_attr *attr,
-			 const char *buf, size_t count);
-};
+/*
+ * Collect all the MCi_XXX settings
+ */
+static struct mce i_mce;
+static struct dentry *dfs_inj;
+
+#define MCE_INJECT_SET(reg)						\
+static int inj_##reg##_set(void *data, u64 val)				\
+{									\
+	struct mce *m = (struct mce *)data;				\
+									\
+	m->reg = val;							\
+	return 0;							\
+}
+
+MCE_INJECT_SET(status);
+MCE_INJECT_SET(misc);
+MCE_INJECT_SET(addr);
+
+#define MCE_INJECT_GET(reg)						\
+static int inj_##reg##_get(void *data, u64 *val)			\
+{									\
+	struct mce *m = (struct mce *)data;				\
+									\
+	*val = m->reg;							\
+	return 0;							\
+}
 
-#define EDAC_MCE_ATTR(_name, _mode, _show, _store)			\
-static struct edac_mce_attr mce_attr_##_name = __ATTR(_name, _mode, _show, _store)
+MCE_INJECT_GET(status);
+MCE_INJECT_GET(misc);
+MCE_INJECT_GET(addr);
 
-static struct kobject *mce_kobj;
+DEFINE_SIMPLE_ATTRIBUTE(status_fops, inj_status_get, inj_status_set, "%llx\n");
+DEFINE_SIMPLE_ATTRIBUTE(misc_fops, inj_misc_get, inj_misc_set, "%llx\n");
+DEFINE_SIMPLE_ATTRIBUTE(addr_fops, inj_addr_get, inj_addr_set, "%llx\n");
 
 /*
  * Caller needs to be make sure this cpu doesn't disappear
@@ -54,137 +77,95 @@ static int toggle_hw_mce_inject(unsigned int cpu, bool enable)
 }
 
 /*
- * Collect all the MCi_XXX settings
- */
-static struct mce i_mce;
-
-#define MCE_INJECT_STORE(reg)						\
-static ssize_t edac_inject_##reg##_store(struct kobject *kobj,		\
-					 struct edac_mce_attr *attr,	\
-					 const char *data, size_t count)\
-{									\
-	int ret = 0;							\
-	unsigned long value;						\
-									\
-	ret = strict_strtoul(data, 16, &value);				\
-	if (ret < 0)							\
-		printk(KERN_ERR "Error writing MCE " #reg " field.\n");	\
-									\
-	i_mce.reg = value;						\
-									\
-	return count;							\
-}
-
-MCE_INJECT_STORE(status);
-MCE_INJECT_STORE(misc);
-MCE_INJECT_STORE(addr);
-
-#define MCE_INJECT_SHOW(reg)						\
-static ssize_t edac_inject_##reg##_show(struct kobject *kobj,		\
-					struct edac_mce_attr *attr,	\
-					char *buf)			\
-{									\
-	return sprintf(buf, "0x%016llx\n", i_mce.reg);			\
-}
-
-MCE_INJECT_SHOW(status);
-MCE_INJECT_SHOW(misc);
-MCE_INJECT_SHOW(addr);
-
-EDAC_MCE_ATTR(status, 0644, edac_inject_status_show, edac_inject_status_store);
-EDAC_MCE_ATTR(misc, 0644, edac_inject_misc_show, edac_inject_misc_store);
-EDAC_MCE_ATTR(addr, 0644, edac_inject_addr_show, edac_inject_addr_store);
-
-/*
  * This denotes into which bank we're injecting and triggers
  * the injection, at the same time.
  */
-static ssize_t edac_inject_bank_store(struct kobject *kobj,
-				      struct edac_mce_attr *attr,
-				      const char *data, size_t count)
+static int inj_bank_set(void *data, u64 val)
 {
-	int ret = 0;
-	unsigned long value;
-
-	ret = strict_strtoul(data, 10, &value);
-	if (ret < 0) {
-		printk(KERN_ERR "Invalid bank value!\n");
-		return -EINVAL;
-	}
+	struct mce *m = (struct mce *)data;
 
-	if (value > 5)
-		if (boot_cpu_data.x86 != 0x15 || value > 6) {
-			printk(KERN_ERR "Non-existent MCE bank: %lu\n", value);
+	if (val > 5)
+		if (boot_cpu_data.x86 != 0x15 || val > 6) {
+			printk(KERN_ERR "Non-existent MCE bank: %llu\n", val);
 			return -EINVAL;
 		}
 
-	i_mce.bank = value;
+	m->bank = val;
 
-	amd_decode_mce(NULL, 0, &i_mce);
+	amd_decode_mce(NULL, 0, m);
 
-	return count;
+	return 0;
 }
 
-static ssize_t edac_inject_bank_show(struct kobject *kobj,
-				     struct edac_mce_attr *attr, char *buf)
+static int inj_bank_get(void *data, u64 *val)
 {
-	return sprintf(buf, "%d\n", i_mce.bank);
-}
+	struct mce *m = (struct mce *)data;
 
-EDAC_MCE_ATTR(bank, 0644, edac_inject_bank_show, edac_inject_bank_store);
+	*val = m->bank;
+	return 0;
+}
 
-static struct edac_mce_attr *sysfs_attrs[] = { &mce_attr_status, &mce_attr_misc,
-					       &mce_attr_addr, &mce_attr_bank
+DEFINE_SIMPLE_ATTRIBUTE(bank_fops, inj_bank_get, inj_bank_set, "%llu\n");
+
+struct dfs_node {
+	char *name;
+	struct dentry *d;
+	const struct file_operations *fops;
+} dfs_fls[] = {
+	{ .name = "status",	.fops = &status_fops },
+	{ .name = "misc",	.fops = &misc_fops },
+	{ .name = "addr",	.fops = &addr_fops },
+	{ .name = "bank",	.fops = &bank_fops },
 };
 
 static int __init edac_init_mce_inject(void)
 {
-	struct sysdev_class *edac_class = NULL;
-	int i, err = 0;
+	struct dentry *dfs_mce_root;
+	int i;
 
-	edac_class = edac_get_sysfs_class();
-	if (!edac_class)
+	dfs_mce_root = mce_get_debugfs_dir();
+	if (!dfs_mce_root)
 		return -EINVAL;
 
-	mce_kobj = kobject_create_and_add("mce", &edac_class->kset.kobj);
-	if (!mce_kobj) {
-		printk(KERN_ERR "Error creating a mce kset.\n");
-		err = -ENOMEM;
-		goto err_mce_kobj;
-	}
+	dfs_inj = debugfs_create_dir("inject", dfs_mce_root);
+	if (!dfs_inj)
+		return -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(dfs_fls); i++) {
+		dfs_fls[i].d = debugfs_create_file(dfs_fls[i].name,
+						    S_IRUSR | S_IWUSR,
+						    dfs_inj,
+						    &i_mce,
+						    dfs_fls[i].fops);
+
+		if (!dfs_fls[i].d)
+			goto err_dfs_add;
 
-	for (i = 0; i < ARRAY_SIZE(sysfs_attrs); i++) {
-		err = sysfs_create_file(mce_kobj, &sysfs_attrs[i]->attr);
-		if (err) {
-			printk(KERN_ERR "Error creating %s in sysfs.\n",
-					sysfs_attrs[i]->attr.name);
-			goto err_sysfs_create;
-		}
 	}
+
 	return 0;
 
-err_sysfs_create:
+err_dfs_add:
 	while (--i >= 0)
-		sysfs_remove_file(mce_kobj, &sysfs_attrs[i]->attr);
+		debugfs_remove(dfs_fls[i].d);
 
-	kobject_del(mce_kobj);
+	debugfs_remove(dfs_inj);
+	dfs_inj = NULL;
 
-err_mce_kobj:
-	edac_put_sysfs_class();
-
-	return err;
+	return -ENOMEM;
 }
 
 static void __exit edac_exit_mce_inject(void)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(sysfs_attrs); i++)
-		sysfs_remove_file(mce_kobj, &sysfs_attrs[i]->attr);
+	for (i = 0; i < ARRAY_SIZE(dfs_fls); i++)
+		debugfs_remove(dfs_fls[i].d);
 
-	kobject_del(mce_kobj);
+	memset(&dfs_fls, 0, sizeof(dfs_fls));
 
-	edac_put_sysfs_class();
+	debugfs_remove(dfs_inj);
+	dfs_inj = NULL;
 }
 
 module_init(edac_init_mce_inject);
-- 
1.7.4.rc2

