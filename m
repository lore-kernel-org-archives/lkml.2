Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab1GCOQS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 10:16:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52951 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab1GCOOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 10:14:55 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/7] debugfs: add debugfs_create_int
Date: Sun,  3 Jul 2011 23:16:16 +0900
Message-Id: <1309702581-16863-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1309702581-16863-1-git-send-email-akinobu.mita@gmail.com>
References: <1309702581-16863-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce debugfs_create_int() for creating a debugfs file that is used to
read and write an int value.

It will be used by notifier error injection and there are two potential
users of it (ceph/writeback_cngestion_kb and ocd/count on avr32)

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/debugfs/file.c       |   56 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/debugfs.h |    9 +++++++
 2 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 90f7657..05cb1c2 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -213,6 +213,62 @@ struct dentry *debugfs_create_u32(const char *name, mode_t mode,
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u32);
 
+static int debugfs_int_set(void *data, u64 val)
+{
+	*(int *)data = val;
+	return 0;
+}
+
+static int debugfs_int_get(void *data, u64 *val)
+{
+	*val = *(int *)data;
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(fops_int, debugfs_int_get, debugfs_int_set, "%lld\n");
+DEFINE_SIMPLE_ATTRIBUTE(fops_int_ro, debugfs_int_get, NULL, "%lld\n");
+DEFINE_SIMPLE_ATTRIBUTE(fops_int_wo, NULL, debugfs_int_set, "%lld\n");
+
+/**
+ * debugfs_create_int - create a debugfs file that is used to read and write an int value
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @value: a pointer to the variable that the file should read to and write
+ *         from.
+ *
+ * This function creates a file in debugfs with the given name that
+ * contains the value of the variable @value.  If the @mode variable is so
+ * set, it can be read from, and written to.
+ *
+ * This function will return a pointer to a dentry if it succeeds.  This
+ * pointer must be passed to the debugfs_remove() function when the file is
+ * to be removed (no automatic cleanup happens if your module is unloaded,
+ * you are responsible here.)  If an error occurs, %NULL will be returned.
+ *
+ * If debugfs is not enabled in the kernel, the value -%ENODEV will be
+ * returned.  It is not wise to check for this value, but rather, check for
+ * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
+ * code.
+ */
+struct dentry *debugfs_create_int(const char *name, mode_t mode,
+				struct dentry *parent, int *value)
+{
+	const struct file_operations *fops = &fops_int;
+
+	/* if there are no write bits set, make read only */
+	if (!(mode & S_IWUGO))
+		fops = &fops_int_ro;
+	/* if there are no read bits set, make write only */
+	if (!(mode & S_IRUGO))
+		fops = &fops_u32_wo;
+
+	return debugfs_create_file(name, mode, parent, value, fops);
+}
+EXPORT_SYMBOL_GPL(debugfs_create_int);
+
 static int debugfs_u64_set(void *data, u64 val)
 {
 	*(u64 *)data = val;
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index e7d9b20..6300792 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -55,6 +55,8 @@ struct dentry *debugfs_create_u16(const char *name, mode_t mode,
 				  struct dentry *parent, u16 *value);
 struct dentry *debugfs_create_u32(const char *name, mode_t mode,
 				  struct dentry *parent, u32 *value);
+struct dentry *debugfs_create_int(const char *name, mode_t mode,
+				  struct dentry *parent, int *value);
 struct dentry *debugfs_create_u64(const char *name, mode_t mode,
 				  struct dentry *parent, u64 *value);
 struct dentry *debugfs_create_x8(const char *name, mode_t mode,
@@ -139,6 +141,13 @@ static inline struct dentry *debugfs_create_u32(const char *name, mode_t mode,
 	return ERR_PTR(-ENODEV);
 }
 
+static inline struct dentry *debugfs_create_int(const char *name, mode_t mode,
+						struct dentry *parent,
+						int *value);
+{
+	return ERR_PTR(-ENODEV);
+}
+
 static inline struct dentry *debugfs_create_u64(const char *name, mode_t mode,
 						struct dentry *parent,
 						u64 *value)
-- 
1.7.4.4

