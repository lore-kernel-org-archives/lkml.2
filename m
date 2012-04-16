Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab2DPUnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:43:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755638Ab2DPUi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:38:57 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: [EDAC ABI v13 16/25] edac: Add debufs nodes to allow doing fake error inject
Date: Mon, 16 Apr 2012 17:38:40 -0300
Message-Id: <1334608729-30803-17-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes, it is useful to have a mechanism that generates fake
errors, in order to test the EDAC core code, and the userspace
tools.

Provide such mechanism by adding a few debugfs nodes.

Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc_sysfs.c |   87 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/edac.h         |    7 +++
 2 files changed, 94 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 67a07c4..5f7f0f1 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -17,6 +17,7 @@
 #include <linux/edac.h>
 #include <linux/bug.h>
 #include <linux/pm_runtime.h>
+#include <linux/uaccess.h>
 
 #include "edac_core.h"
 #include "edac_module.h"
@@ -783,6 +784,47 @@ static ssize_t mci_max_location_show(struct device *dev,
 	return p - data;
 }
 
+#ifdef CONFIG_EDAC_DEBUG
+static ssize_t edac_fake_inject_write(struct file *file,
+				      const char __user *data,
+				      size_t count, loff_t *ppos)
+{
+	struct device *dev = file->private_data;
+	struct mem_ctl_info *mci = to_mci(dev);
+	static enum hw_event_mc_err_type type;
+
+	type = mci->fake_inject_ue ? HW_EVENT_ERR_UNCORRECTED
+				   : HW_EVENT_ERR_CORRECTED;
+
+	printk(KERN_DEBUG
+	       "Generating a %s fake error to %d.%d.%d to test core handling. NOTE: this won't test the driver-specific decoding logic.\n",
+		(type == HW_EVENT_ERR_UNCORRECTED) ? "UE" : "CE",
+		mci->fake_inject_layer[0],
+		mci->fake_inject_layer[1],
+		mci->fake_inject_layer[2]
+	       );
+	edac_mc_handle_error(type, mci, 0, 0, 0,
+			     mci->fake_inject_layer[0],
+			     mci->fake_inject_layer[1],
+			     mci->fake_inject_layer[2],
+			     "FAKE ERROR", "for EDAC testing only", NULL);
+
+	return count;
+}
+
+static int debugfs_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+static const struct file_operations debug_fake_inject_fops = {
+	.open = debugfs_open,
+	.write = edac_fake_inject_write,
+	.llseek = generic_file_llseek,
+};
+#endif
+
 /* default Control file */
 DEVICE_ATTR(reset_counters, S_IWUSR, NULL, mci_reset_counters_store);
 
@@ -833,6 +875,45 @@ static struct device_type mci_attr_type = {
 	.release	= mci_attr_release,
 };
 
+#ifdef CONFIG_EDAC_DEBUG
+int edac_create_debug_nodes(struct mem_ctl_info *mci)
+{
+	struct dentry *d, *parent;
+	char name[80];
+	int i;
+
+	d = debugfs_create_dir(mci->dev.kobj.name, mci->debugfs);
+	if (!d)
+		return -ENOMEM;
+	parent = d;
+
+	for (i = 0; i < mci->n_layers; i++) {
+		sprintf(name, "fake_inject_%s",
+			     edac_layer_name[mci->layers[i].type]);
+		d = debugfs_create_u8(name, S_IRUGO | S_IWUSR, parent,
+				      &mci->fake_inject_layer[i]);
+		if (!d)
+			goto nomem;
+	}
+
+	d = debugfs_create_bool("fake_inject_ue", S_IRUGO | S_IWUSR, parent,
+				&mci->fake_inject_ue);
+	if (!d)
+		goto nomem;
+
+	d = debugfs_create_file("fake_inject", S_IWUSR, parent,
+				&mci->dev,
+				&debug_fake_inject_fops);
+	if (!d)
+		goto nomem;
+
+	return 0;
+nomem:
+	debugfs_remove(mci->debugfs);
+	return -ENOMEM;
+}
+#endif
+
 /*
  * Create a new Memory Controller kobject instance,
  *	mc<id> under the 'mc' directory
@@ -898,6 +979,9 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 		goto fail;
 #endif
 
+#ifdef CONFIG_EDAC_DEBUG
+	edac_create_debug_nodes(mci);
+#endif
 	return 0;
 
 fail:
@@ -922,6 +1006,9 @@ void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci)
 
 	debugf0("%s()\n", __func__);
 
+#ifdef CONFIG_EDAC_DEBUG
+	debugfs_remove(mci->debugfs);
+#endif
 #ifdef CONFIG_EDAC_LEGACY_SYSFS
 	edac_delete_csrow_objects(mci);
 #endif
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 676b893..a32ed72 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -14,6 +14,7 @@
 
 #include <linux/atomic.h>
 #include <linux/device.h>
+#include <linux/debugfs.h>
 
 #define EDAC_OPSTATE_INVAL	-1
 #define EDAC_OPSTATE_POLL	0
@@ -608,6 +609,12 @@ struct mem_ctl_info {
 
 	/* the internal state of this controller instance */
 	int op_state;
+
+#ifdef CONFIG_EDAC_DEBUG
+	struct dentry *debugfs;
+	u8 fake_inject_layer[EDAC_MAX_LAYERS];
+	u32 fake_inject_ue;
+#endif
 };
 
 #endif
-- 
1.7.8

