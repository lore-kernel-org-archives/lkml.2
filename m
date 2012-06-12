Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab2FLCcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 22:32:48 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58083 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab2FLCcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 22:32:33 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: mchehab@redhat.com, Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 1/3] edac: create top-level debugfs directory
Date: Mon, 11 Jun 2012 21:32:12 -0500
Message-Id: <1339468334-9927-2-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339468334-9927-1-git-send-email-robherring2@gmail.com>
References: <1339468334-9927-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Create a single, top-level "edac" directory for debugfs. An "mc[0-N]"
directory is then created for each memory controller. Individual drivers
can create additional entries such as h/w error injection control.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 drivers/edac/edac_mc_sysfs.c |   23 ++++++++++++++++++++++-
 drivers/edac/edac_module.c   |    3 +++
 drivers/edac/edac_module.h   |   14 ++++++++++++++
 3 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 55b2f0a..a2bf7e9 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -899,13 +899,33 @@ static struct device_type mci_attr_type = {
 };
 
 #ifdef CONFIG_EDAC_DEBUG
+static struct dentry *edac_debugfs;
+
+int __init edac_debugfs_init(void)
+{
+	edac_debugfs = debugfs_create_dir("edac", NULL);
+	if (IS_ERR(edac_debugfs)) {
+		edac_debugfs = NULL;
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+void __exit edac_debugfs_exit(void)
+{
+	debugfs_remove(edac_debugfs);
+}
+
 int edac_create_debug_nodes(struct mem_ctl_info *mci)
 {
 	struct dentry *d, *parent;
 	char name[80];
 	int i;
 
-	d = debugfs_create_dir(mci->dev.kobj.name, mci->debugfs);
+	if (!edac_debugfs)
+		return -ENODEV;
+
+	d = debugfs_create_dir(mci->dev.kobj.name, edac_debugfs);
 	if (!d)
 		return -ENOMEM;
 	parent = d;
@@ -930,6 +950,7 @@ int edac_create_debug_nodes(struct mem_ctl_info *mci)
 	if (!d)
 		goto nomem;
 
+	mci->debugfs = parent;
 	return 0;
 nomem:
 	debugfs_remove(mci->debugfs);
diff --git a/drivers/edac/edac_module.c b/drivers/edac/edac_module.c
index 3454798..58a28d8 100644
--- a/drivers/edac/edac_module.c
+++ b/drivers/edac/edac_module.c
@@ -94,6 +94,8 @@ static int __init edac_init(void)
 	if (err)
 		goto error;
 
+	edac_debugfs_init();
+
 	/* Setup/Initialize the workq for this core */
 	err = edac_workqueue_setup();
 	if (err) {
@@ -118,6 +120,7 @@ static void __exit edac_exit(void)
 	/* tear down the various subsystems */
 	edac_workqueue_teardown();
 	edac_mc_sysfs_exit();
+	edac_debugfs_exit();
 }
 
 /*
diff --git a/drivers/edac/edac_module.h b/drivers/edac/edac_module.h
index 62de640..3d139c6 100644
--- a/drivers/edac/edac_module.h
+++ b/drivers/edac/edac_module.h
@@ -57,6 +57,20 @@ extern void edac_mc_reset_delay_period(int value);
 extern void *edac_align_ptr(void **p, unsigned size, int n_elems);
 
 /*
+ * EDAC debugfs functions
+ */
+#ifdef CONFIG_EDAC_DEBUG
+int edac_debugfs_init(void);
+void edac_debugfs_exit(void);
+#else
+static inline int edac_debugfs_init(void)
+{
+	return -ENODEV;
+}
+static inline void edac_debugfs_exit(void) {}
+#endif
+
+/*
  * EDAC PCI functions
  */
 #ifdef	CONFIG_PCI
-- 
1.7.9.5

