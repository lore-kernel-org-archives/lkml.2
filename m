Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab2K2Ql1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 11:41:27 -0500
Received: from www.linutronix.de ([62.245.132.108]:46178 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab2K2QlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 11:41:25 -0500
Date: Thu, 29 Nov 2012 17:41:23 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Joel Becker <jlbec@evilplan.org>
Cc: linux-kernel@vger.kernel.org, andrzej.p@samsung.com,
        linux-usb@vger.kernel.org
Subject: [PATCH] fs/configfs: allow to create groups on demand
Message-ID: <20121129164123.GA8551@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a function add a group to an existing one and its
counterart. The newly created group behaves as it would be created via
default_groups[] which means the user can't rmdir it.
This should be used by the upcomming USB gadget interface in order to
add the currently available UDCs as a child of the UDC node. The UDC
itself will appear once the hardware driver is loaded and can appear
later.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 fs/configfs/dir.c        |   63 ++++++++++++++++++++++++++++++++++------------
 include/linux/configfs.h |    4 +++
 2 files changed, 51 insertions(+), 16 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 7414ae2..50ee2bd 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1663,19 +1663,13 @@ const struct file_operations configfs_dir_operations = {
 	.readdir	= configfs_readdir,
 };
 
-int configfs_register_subsystem(struct configfs_subsystem *subsys)
+static int __create_group(struct config_group *group, struct dentry *root)
 {
 	int err;
-	struct config_group *group = &subsys->su_group;
 	struct qstr name;
 	struct dentry *dentry;
-	struct dentry *root;
 	struct configfs_dirent *sd;
 
-	root = configfs_pin_fs();
-	if (IS_ERR(root))
-		return PTR_ERR(root);
-
 	if (!group->cg_item.ci_name)
 		group->cg_item.ci_name = group->cg_item.ci_namebuf;
 
@@ -1708,25 +1702,48 @@ int configfs_register_subsystem(struct configfs_subsystem *subsys)
 
 	mutex_unlock(&root->d_inode->i_mutex);
 
-	if (err) {
+	if (err)
 		unlink_group(group);
-		configfs_release_fs();
+
+	return err;
+}
+
+int configfs_create_group(struct config_group *parent, struct config_group *new)
+{
+	int ret;
+
+	ret = __create_group(new, parent->cg_item.ci_dentry);
+	if (!ret) {
+		struct configfs_dirent *sd = new->cg_item.ci_dentry->d_fsdata;
+
+		sd->s_type |= CONFIGFS_USET_DEFAULT;
 	}
 
+	return ret;
+}
+EXPORT_SYMBOL_GPL(configfs_create_group);
+
+int configfs_register_subsystem(struct configfs_subsystem *subsys)
+{
+	int err;
+	struct dentry *root;
+
+	root = configfs_pin_fs();
+	if (IS_ERR(root))
+		return PTR_ERR(root);
+
+	err = __create_group(&subsys->su_group, root);
+	if (err)
+		configfs_release_fs();
+
 	return err;
 }
 
-void configfs_unregister_subsystem(struct configfs_subsystem *subsys)
+void configfs_remove_group(struct config_group *group)
 {
-	struct config_group *group = &subsys->su_group;
 	struct dentry *dentry = group->cg_item.ci_dentry;
 	struct dentry *root = dentry->d_sb->s_root;
 
-	if (dentry->d_parent != root) {
-		printk(KERN_ERR "configfs: Tried to unregister non-subsystem!\n");
-		return;
-	}
-
 	mutex_lock_nested(&root->d_inode->i_mutex,
 			  I_MUTEX_PARENT);
 	mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
@@ -1749,6 +1766,20 @@ void configfs_unregister_subsystem(struct configfs_subsystem *subsys)
 	dput(dentry);
 
 	unlink_group(group);
+}
+EXPORT_SYMBOL_GPL(configfs_remove_group);
+
+void configfs_unregister_subsystem(struct configfs_subsystem *subsys)
+{
+	struct config_group *group = &subsys->su_group;
+	struct dentry *dentry = group->cg_item.ci_dentry;
+	struct dentry *root = dentry->d_sb->s_root;
+
+	if (dentry->d_parent != root) {
+		pr_err("configfs: Tried to unregister non-subsystem!\n");
+		return;
+	}
+	configfs_remove_group(group);
 	configfs_release_fs();
 }
 
diff --git a/include/linux/configfs.h b/include/linux/configfs.h
index 34025df..660c25d 100644
--- a/include/linux/configfs.h
+++ b/include/linux/configfs.h
@@ -249,6 +249,10 @@ static inline struct configfs_subsystem *to_configfs_subsystem(struct config_gro
 		NULL;
 }
 
+int configfs_create_group(struct config_group *parent,
+		struct config_group *new);
+void configfs_remove_group(struct config_group *group);
+
 int configfs_register_subsystem(struct configfs_subsystem *subsys);
 void configfs_unregister_subsystem(struct configfs_subsystem *subsys);
 
-- 
1.7.10.4

