Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab0IXUir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 16:38:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55901 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751781Ab0IXUiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 16:38:46 -0400
Date: Fri, 24 Sep 2010 16:38:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] sysfs: add sysfs_merge_group and sysfs_unmerge_group
Message-ID: <Pine.LNX.4.44L0.1009241632260.1287-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as1420) adds sysfs_merge_group() and sysfs_unmerge_group()
functions, allowing drivers easily to add and remove sets of
attributes to a pre-existing attribute group directory.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

For LKML readers: The remaining patches in this series affect 
only the PM core, whereas this one affects sysfs and is therefore of 
more general interest.  That's why I'm CC-ing LKML on just this 1/7 
patch.


Index: usb-2.6/fs/sysfs/group.c
===================================================================
--- usb-2.6.orig/fs/sysfs/group.c
+++ usb-2.6/fs/sysfs/group.c
@@ -148,6 +148,65 @@ void sysfs_remove_group(struct kobject *
 	sysfs_put(sd);
 }
 
+/**
+ * sysfs_merge_group - merge files into a pre-existing attribute group.
+ * @kobj:	The kobject containing the group.
+ * @grp:	The files to create and the attribute group they belong to.
+ *
+ * This function returns an error if the group doesn't exist or any of the
+ * files already exist in that group, in which case none of the new files
+ * are created.
+ */
+int sysfs_merge_group(struct kobject *kobj,
+		       const struct attribute_group *grp)
+{
+	struct sysfs_dirent *dir_sd;
+	int error = 0;
+	struct attribute *const *attr;
+	int i;
+
+	if (grp)
+		dir_sd = sysfs_get_dirent(kobj->sd, NULL, grp->name);
+	else
+		dir_sd = sysfs_get(kobj->sd);
+	if (!dir_sd)
+		return -ENOENT;
+
+	for ((i = 0, attr = grp->attrs); *attr && !error; (++i, ++attr))
+		error = sysfs_add_file(dir_sd, *attr, SYSFS_KOBJ_ATTR);
+	if (error) {
+		while (--i >= 0)
+			sysfs_hash_and_remove(dir_sd, NULL, (*--attr)->name);
+	}
+	sysfs_put(dir_sd);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(sysfs_merge_group);
+
+/**
+ * sysfs_unmerge_group - remove files from a pre-existing attribute group.
+ * @kobj:	The kobject containing the group.
+ * @grp:	The files to remove and the attribute group they belong to.
+ */
+void sysfs_unmerge_group(struct kobject *kobj,
+		       const struct attribute_group *grp)
+{
+	struct sysfs_dirent *dir_sd;
+	struct attribute *const *attr;
+
+	if (grp)
+		dir_sd = sysfs_get_dirent(kobj->sd, NULL, grp->name);
+	else
+		dir_sd = sysfs_get(kobj->sd);
+	if (dir_sd) {
+		for (attr = grp->attrs; *attr; ++attr)
+			sysfs_hash_and_remove(dir_sd, NULL, (*attr)->name);
+		sysfs_put(dir_sd);
+	}
+}
+EXPORT_SYMBOL_GPL(sysfs_unmerge_group);
+
 
 EXPORT_SYMBOL_GPL(sysfs_create_group);
 EXPORT_SYMBOL_GPL(sysfs_update_group);
Index: usb-2.6/include/linux/sysfs.h
===================================================================
--- usb-2.6.orig/include/linux/sysfs.h
+++ usb-2.6/include/linux/sysfs.h
@@ -164,6 +164,10 @@ int sysfs_add_file_to_group(struct kobje
 			const struct attribute *attr, const char *group);
 void sysfs_remove_file_from_group(struct kobject *kobj,
 			const struct attribute *attr, const char *group);
+int sysfs_merge_group(struct kobject *kobj,
+		       const struct attribute_group *grp);
+void sysfs_unmerge_group(struct kobject *kobj,
+		       const struct attribute_group *grp);
 
 void sysfs_notify(struct kobject *kobj, const char *dir, const char *attr);
 void sysfs_notify_dirent(struct sysfs_dirent *sd);
@@ -302,6 +306,17 @@ static inline void sysfs_remove_file_fro
 {
 }
 
+static inline int sysfs_merge_group(struct kobject *kobj,
+		       const struct attribute_group *grp)
+{
+	return 0;
+}
+
+static inline void sysfs_unmerge_group(struct kobject *kobj,
+		       const struct attribute_group *grp)
+{
+}
+
 static inline void sysfs_notify(struct kobject *kobj, const char *dir,
 				const char *attr)
 {

