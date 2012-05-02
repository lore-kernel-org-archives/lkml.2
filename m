Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab2EBMsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 08:48:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62122 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2EBMsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 08:48:36 -0400
From: Sasikantha babu <sasikanth.v19@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Sasikantha babu <sasikanth.v19@gmail.com>
Subject: [PATCH] debugfs: New debugfs interface for creation of files, directory and symlinks
Date: Wed,  2 May 2012 18:20:54 +0530
Message-Id: <1335963054-24750-1-git-send-email-sasikanth.v19@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we know the current debugfs file or directory or symlink creation
doesn't return proper error codes to the caller on failure. Because 
of this caller and user could not able to find the exact reason of
the failure.

As Andrew Morton suggested (http://www.spinics.net/lists/linux-mm/msg33617.html)
introduced new debugfs interface to create debugfs entries. Newer APIs 
returns proper error codes(ERR_PTR) on failure. Since fixing older 
APIs will break the existing debugfs layer (because the API's used 
in 100s of places, first we must address all those caller code before 
fixing the debugfs creation API's. Instead of that, creating newer interface
and migrating to newer interface is much simpler).

And also added read only and write only support for x64 and u64.

New Debug FS API
-----------------

debugfs_file_create
debugfs_dir_create
debugfs_symlink_create
debugfs_u8_create
debugfs_u16_create
debugfs_u32_create
debugfs_u64_create
debugfs_x8_create
debugfs_x16_create
debugfs_x32_create
debugfs_x64_create
debugfs_size_t_create
debugfs_bool_create
debugfs_blob_create
debugfs_regset32_create

All new debug fs APIs returns pointer to an error (ERR_PTR). Once
everyone migrated to new ones we can remove the older ones.

Note : 1) old debugfs API names "debugfs_X_Y" changed to "debugfs_Y_X".
       2) No change in the arguments passed

For Example : 
            OLD API:    debugfs_create_file
            NEW API:    debugfs_file_create

I had tested and verified all new APIs and it is working fine.


Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
---
 fs/debugfs/file.c       |  440 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/debugfs/inode.c      |  125 +++++++++++++
 include/linux/debugfs.h |  120 +++++++++++++
 3 files changed, 685 insertions(+), 0 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 5dfafdd..12ffe3e 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -21,6 +21,20 @@
 #include <linux/debugfs.h>
 #include <linux/io.h>
 
+enum debugfs_u8_type {
+	DEBUGFS_U8 = 0x1,
+	DEBUGFS_U16,
+	DEBUGFS_U32,
+	DEBUGFS_U64
+};
+
+enum debugfs_x8_type {
+	DEBUGFS_X8 = 0x1,
+	DEBUGFS_X16,
+	DEBUGFS_X32,
+	DEBUGFS_X64
+};
+
 static ssize_t default_read_file(struct file *file, char __user *buf,
 				 size_t count, loff_t *ppos)
 {
@@ -273,6 +287,8 @@ DEFINE_SIMPLE_ATTRIBUTE(fops_x32_ro, debugfs_u32_get, NULL, "0x%08llx\n");
 DEFINE_SIMPLE_ATTRIBUTE(fops_x32_wo, NULL, debugfs_u32_set, "0x%08llx\n");
 
 DEFINE_SIMPLE_ATTRIBUTE(fops_x64, debugfs_u64_get, debugfs_u64_set, "0x%016llx\n");
+DEFINE_SIMPLE_ATTRIBUTE(fops_x64_ro, debugfs_u64_get, NULL, "0x%016llx\n");
+DEFINE_SIMPLE_ATTRIBUTE(fops_x64_wo, NULL, debugfs_u64_set, "0x%016llx\n");
 
 /*
  * debugfs_create_x{8,16,32,64} - create a debugfs file that is used to read and write an unsigned {8,16,32,64}-bit value
@@ -611,4 +627,428 @@ struct dentry *debugfs_create_regset32(const char *name, umode_t mode,
 }
 EXPORT_SYMBOL_GPL(debugfs_create_regset32);
 
+/**
+ * debugfs_regset32_create - create a debugfs file that returns register values
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @regset: a pointer to a struct debugfs_regset32, which contains a pointer
+ *          to an array of register definitions, the array size and the base
+ *          address where the register bank is to be found.
+ *
+ * This function creates a file in debugfs with the given name that reports
+ * the names and values of a set of 32-bit registers. If the @mode variable
+ * is so set it can be read from. Writing is not supported.
+ *
+ * This function will return a pointer to a dentry if it succeeds.  This
+ * pointer must be passed to the debugfs_remove() function when the file is
+ * to be removed (no automatic cleanup happens if your module is unloaded,
+ * you are responsible here.)  If an error occurs, error pointer will be
+ * returned.
+ *
+ * If debugfs is not enabled in the kernel, the value -%ENODEV will be
+ * returned.  It is not wise to check for this value, but rather, check for
+ * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
+ * code.
+ */
+
+struct dentry *debugfs_regset32_create(const char *name, umode_t mode,
+				       struct dentry *parent,
+				       struct debugfs_regset32 *regset)
+{
+	return debugfs_file_create(name, mode, parent, regset, &fops_regset32);
+}
+EXPORT_SYMBOL_GPL(debugfs_regset32_create);
+
 #endif /* CONFIG_HAS_IOMEM */
+
+/*
+ * debugfs_create_u{8,16,32,64} - create a debugfs file that is used to read and
+ * write an unsigned {8,16,32,64}-bit value
+ */
+
+static struct dentry *debugfs_create_uX(const char *name, umode_t mode,
+					struct dentry *parent, void *value,
+					enum debugfs_u8_type type)
+{
+	const struct file_operations *fops = NULL;
+
+	switch (type) {
+	case DEBUGFS_U8:
+		if (!(mode & S_IWUGO))
+			fops = &fops_u8_ro;
+		else if (!(mode & S_IRUGO))
+			fops = &fops_u8_wo;
+		else
+			fops = &fops_u8;
+		break;
+	case DEBUGFS_U16:
+		if (!(mode & S_IWUGO))
+			fops = &fops_u16_ro;
+		else if (!(mode & S_IRUGO))
+			fops = &fops_u16_wo;
+		else
+			fops = &fops_u16;
+		break;
+	case DEBUGFS_U32:
+		if (!(mode & S_IWUGO))
+			fops = &fops_u32_ro;
+		else if (!(mode & S_IRUGO))
+			fops = &fops_u32_wo;
+		else
+			fops = &fops_u32;
+		break;
+	case DEBUGFS_U64:
+		if (!(mode & S_IWUGO))
+			fops = &fops_u64_ro;
+		else if (!(mode & S_IRUGO))
+			fops = &fops_u64_wo;
+		else
+			fops = &fops_u64;
+		break;
+	}
+
+	return debugfs_file_create(name, mode, parent, value, fops);
+}
+
+/**
+ * debugfs_u8_create - create a debugfs file that is used to read and write
+ * an unsigned 8-bit value
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
+ * you are responsible here.)  If an error occurs, error pointer will be
+ * returned.
+ *
+ * If debugfs is not enabled in the kernel, the value -%ENODEV will be
+ * returned.  It is not wise to check for this value, but rather, check for
+ * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
+ * code.
+ */
+
+struct dentry *debugfs_u8_create(const char *name, umode_t mode,
+				 struct dentry *parent, u8 *value)
+{
+	return debugfs_create_uX(name, mode, parent, value, DEBUGFS_U8);
+}
+EXPORT_SYMBOL_GPL(debugfs_u8_create);
+
+/**
+ * debugfs_u16_create - create a debugfs file that is used to read and write
+ * an unsigned 16-bit value
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
+ * you are responsible here.)  If an error occurs, error pointer will be
+ * returned.
+ *
+ * If debugfs is not enabled in the kernel, the value -%ENODEV will be
+ * returned.  It is not wise to check for this value, but rather, check for
+ * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
+ * code.
+ */
+struct dentry *debugfs_u16_create(const char *name, umode_t mode,
+				  struct dentry *parent, u16 *value)
+{
+	return debugfs_create_uX(name, mode, parent, value, DEBUGFS_U16);
+}
+EXPORT_SYMBOL_GPL(debugfs_u16_create);
+
+/**
+ * debugfs_u32_create - create a debugfs file that is used to read and write
+ * an unsigned 32-bit value
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
+struct dentry *debugfs_u32_create(const char *name, umode_t mode,
+				 struct dentry *parent, u32 *value)
+{
+	return debugfs_create_uX(name, mode, parent, value, DEBUGFS_U32);
+}
+EXPORT_SYMBOL_GPL(debugfs_u32_create);
+
+/**
+ * debugfs_u64_create - create a debugfs file that is used to read and write
+ * an unsigned 64-bit value
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
+struct dentry *debugfs_u64_create(const char *name, umode_t mode,
+				 struct dentry *parent, u64 *value)
+{
+	return debugfs_create_uX(name, mode, parent, value, DEBUGFS_U64);
+}
+EXPORT_SYMBOL_GPL(debugfs_u64_create);
+
+/*
+ * debugfs_create_x{8,16,32,64} - create a debugfs file that is used to read and
+ * write an unsigned {8,16,32,64}-bit value
+ *
+ * These functions are exactly the same as the above functions (but use a hex
+ * output for the decimal challenged). For details look at the above unsigned
+ * decimal functions.
+ */
+
+static struct dentry *debugfs_create_xX(const char *name, umode_t mode,
+					struct dentry *parent, void *value,
+					enum debugfs_x8_type type)
+{
+	const struct file_operations *fops = NULL;
+
+	switch (type) {
+	case DEBUGFS_X8:
+		if (!(mode & S_IWUGO))
+			fops = &fops_x8_ro;
+		else if (!(mode & S_IRUGO))
+			fops = &fops_x8_wo;
+		else
+			fops = &fops_x8;
+		break;
+	case DEBUGFS_X16:
+		if (!(mode & S_IWUGO))
+			fops = &fops_x16_ro;
+		else if (!(mode & S_IRUGO))
+			fops = &fops_x16_wo;
+		else
+			fops = &fops_x16;
+		break;
+	case DEBUGFS_X32:
+		if (!(mode & S_IWUGO))
+			fops = &fops_x32_ro;
+		else if (!(mode & S_IRUGO))
+			fops = &fops_x32_wo;
+		else
+			fops = &fops_x32;
+		break;
+	case DEBUGFS_X64:
+		if (!(mode & S_IWUGO))
+			fops = &fops_x64_ro;
+		else if (!(mode & S_IRUGO))
+			fops = &fops_x64_wo;
+		else
+			fops = &fops_x64;
+		break;
+	}
+
+	return debugfs_file_create(name, mode, parent, value, fops);
+}
+
+/**
+ * debugfs_x8_create - create a debugfs file that is used to read and write an
+ * unsigned 8-bit value
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @value: a pointer to the variable that the file should read to and write
+ *         from.
+ */
+struct dentry *debugfs_x8_create(const char *name, umode_t mode,
+				 struct dentry *parent, u8 *value)
+{
+	return debugfs_create_xX(name, mode, parent, value, DEBUGFS_X8);
+}
+EXPORT_SYMBOL_GPL(debugfs_x8_create);
+
+/**
+ * debugfs_x16_create - create a debugfs file that is used to read and write
+ * an unsigned 16-bit value
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @value: a pointer to the variable that the file should read to and write
+ *         from.
+ */
+struct dentry *debugfs_x16_create(const char *name, umode_t mode,
+				 struct dentry *parent, u16 *value)
+{
+	return debugfs_create_xX(name, mode, parent, value, DEBUGFS_X16);
+}
+EXPORT_SYMBOL_GPL(debugfs_x16_create);
+
+/**
+ * debugfs_x32_create - create a debugfs file that is used to read and write
+ * an unsigned 32-bit value
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @value: a pointer to the variable that the file should read to and write
+ *         from.
+ */
+struct dentry *debugfs_x32_create(const char *name, umode_t mode,
+				 struct dentry *parent, u32 *value)
+{
+	return debugfs_create_xX(name, mode, parent, value, DEBUGFS_X32);
+}
+EXPORT_SYMBOL_GPL(debugfs_x32_create);
+
+/**
+ * debugfs_x64_create - create a debugfs file that is used to read and write
+ * an unsigned 64-bit value
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @value: a pointer to the variable that the file should read to and write
+ *         from.
+ */
+struct dentry *debugfs_x64_create(const char *name, umode_t mode,
+				 struct dentry *parent, u64 *value)
+{
+	return debugfs_create_xX(name, mode, parent, value, DEBUGFS_X64);
+}
+EXPORT_SYMBOL_GPL(debugfs_x64_create);
+
+/**
+ * debugfs_size_t_create - create a debugfs file that is used to read and write
+ * an size_t value
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @value: a pointer to the variable that the file should read to and write
+ *         from.
+ */
+struct dentry *debugfs_size_t_create(const char *name, umode_t mode,
+				     struct dentry *parent, size_t *value)
+{
+	return debugfs_file_create(name, mode, parent, value, &fops_size_t);
+}
+EXPORT_SYMBOL_GPL(debugfs_size_t_create);
+/**
+ * debugfs_bool_create - create a debugfs file that is used to read and
+ * write a boolean value
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
+ * you are responsible here.)  If an error occurs, error pointer will be
+ * returned.
+ *
+ * If debugfs is not enabled in the kernel, the value -%ENODEV will be
+ * returned.  It is not wise to check for this value, but rather, check for
+ * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
+ * code.
+ */
+struct dentry *debugfs_bool_create(const char *name, umode_t mode,
+				   struct dentry *parent, u32 *value)
+{
+	return debugfs_file_create(name, mode, parent, value, &fops_bool);
+}
+EXPORT_SYMBOL_GPL(debugfs_bool_create);
+
+/**
+ * debugfs_blob_create - create a debugfs file that is used to read a binary
+ * blob
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @blob: a pointer to a struct debugfs_blob_wrapper which contains a pointer
+ *        to the blob data and the size of the data.
+ *
+ * This function creates a file in debugfs with the given name that exports
+ * @blob->data as a binary blob. If the @mode variable is so set it can be
+ * read from. Writing is not supported.
+ *
+ * This function will return a pointer to a dentry if it succeeds.  This
+ * pointer must be passed to the debugfs_remove() function when the file is
+ * to be removed (no automatic cleanup happens if your module is unloaded,
+ * you are responsible here.)  If an error occurs, error pointer will be
+ * returned.
+ *
+ * If debugfs is not enabled in the kernel, the value -%ENODEV will be
+ * returned.  It is not wise to check for this value, but rather, check for
+ * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
+ * code.
+ */
+struct dentry *debugfs_blob_create(const char *name, umode_t mode,
+				   struct dentry *parent,
+				   struct debugfs_blob_wrapper *blob)
+{
+	return debugfs_file_create(name, mode, parent, blob, &fops_blob);
+}
+EXPORT_SYMBOL_GPL(debugfs_blob_create);
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index b80bc84..a8e91f5 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -660,6 +660,131 @@ exit:
 EXPORT_SYMBOL_GPL(debugfs_rename);
 
 /**
+ * debugfs_file_create - create a file in the debugfs filesystem
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have.
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this paramater is NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @data: a pointer to something that the caller will want to get to later
+ *        on.  The inode.i_private pointer will point to this value on
+ *        the open() call.
+ * @fops: a pointer to a struct file_operations that should be used for
+ *        this file.
+ *
+ * This is the basic "create a file" function for debugfs.  It allows for a
+ * wide range of flexibility in creating a file, or a directory (if you want
+ * to create a directory, the debugfs_dir_create() function is
+ * recommended to be used instead.)
+ *
+ * This function will return a pointer to a dentry if it succeeds.  This
+ * pointer must be passed to the debugfs_remove() function when the file is
+ * to be removed (no automatic cleanup happens if your module is unloaded,
+ * you are responsible here.)  If an error occurs, error pointer will be
+ * returned.
+ *
+ * If debugfs is not enabled in the kernel, the value -%ENODEV will be
+ * returned.
+ */
+struct dentry *debugfs_file_create(const char *name, umode_t mode,
+				   struct dentry *parent, void *data,
+				   const struct file_operations *fops)
+{
+	struct dentry *dentry = NULL;
+	int error;
+
+	pr_debug("debugfs: creating file '%s'\n", name);
+
+	error = simple_pin_fs(&debug_fs_type, &debugfs_mount,
+			      &debugfs_mount_count);
+	if (error)
+		return ERR_PTR(error);
+
+	error = debugfs_create_by_name(name, mode, parent, &dentry,
+				       data, fops);
+	if (error) {
+		dentry = ERR_PTR(error);
+		simple_release_fs(&debugfs_mount, &debugfs_mount_count);
+	}
+
+	return dentry;
+}
+EXPORT_SYMBOL_GPL(debugfs_file_create);
+
+/**
+ * debugfs_dir_create - create a directory in the debugfs filesystem
+ * @name: a pointer to a string containing the name of the directory to
+ *        create.
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this paramater is NULL, then the
+ *          directory will be created in the root of the debugfs filesystem.
+ *
+ * This function creates a directory in debugfs with the given name.
+ *
+ * This function will return a pointer to a dentry if it succeeds.  This
+ * pointer must be passed to the debugfs_remove() function when the file is
+ * to be removed (no automatic cleanup happens if your module is unloaded,
+ * you are responsible here.)  If an error occurs, error pointer will be
+ * returned.
+ *
+ * If debugfs is not enabled in the kernel, the value -%ENODEV will be
+ * returned.
+ */
+struct dentry *debugfs_dir_create(const char *name, struct dentry *parent)
+{
+	return debugfs_file_create(name,
+				   S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
+				   parent, NULL, NULL);
+}
+EXPORT_SYMBOL_GPL(debugfs_dir_create);
+
+/**
+ * debugfs_symlink_create- create a symbolic link in the debugfs filesystem
+ * @name: a pointer to a string containing the name of the symbolic link to
+ *        create.
+ * @parent: a pointer to the parent dentry for this symbolic link.  This
+ *          should be a directory dentry if set.  If this paramater is NULL,
+ *          then the symbolic link will be created in the root of the debugfs
+ *          filesystem.
+ * @target: a pointer to a string containing the path to the target of the
+ *          symbolic link.
+ *
+ * This function creates a symbolic link with the given name in debugfs that
+ * links to the given target path.
+ *
+ * This function will return a pointer to a dentry if it succeeds.  This
+ * pointer must be passed to the debugfs_remove() function when the symbolic
+ * link is to be removed (no automatic cleanup happens if your module is
+ * unloaded, you are responsible here.)  If an error occurs, error pointer
+ * will be returned.
+ *
+ * If debugfs is not enabled in the kernel, the value -%ENODEV will be
+ * returned.
+ */
+struct dentry *debugfs_symlink_create(const char *name, struct dentry *parent,
+				      const char *target)
+{
+	struct dentry *result;
+	char *link;
+
+	if (!target)
+		/*XXX: is this return value correct one*/
+		return ERR_PTR(-ENODEV);
+
+	link = kstrdup(target, GFP_KERNEL);
+	if (!link)
+		return ERR_PTR(-ENOMEM);
+
+	result = debugfs_file_create(name, S_IFLNK | S_IRWXUGO, parent, link,
+				     NULL);
+	if (IS_ERR(result))
+		kfree(link);
+
+	return result;
+}
+EXPORT_SYMBOL_GPL(debugfs_symlink_create);
+
+/**
  * debugfs_initialized - Tells whether debugfs has been registered
  */
 bool debugfs_initialized(void)
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index ae36b72..8271c2e 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -95,6 +95,45 @@ int debugfs_print_regs32(struct seq_file *s, const struct debugfs_reg32 *regs,
 
 bool debugfs_initialized(void);
 
+/*Debug Fs New interface prototypes*/
+struct dentry *debugfs_file_create(const char *name, umode_t mode,
+				   struct dentry *parent, void *data,
+				   const struct file_operations *fops);
+
+struct dentry *debugfs_dir_create(const char *name, struct dentry *parent);
+
+struct dentry *debugfs_symlink_create(const char *name, struct dentry *parent,
+				      const char *dest);
+struct dentry *debugfs_u8_create(const char *name, umode_t mode,
+				 struct dentry *parent, u8 *value);
+struct dentry *debugfs_u16_create(const char *name, umode_t mode,
+				  struct dentry *parent, u16 *value);
+struct dentry *debugfs_u32_create(const char *name, umode_t mode,
+				  struct dentry *parent, u32 *value);
+struct dentry *debugfs_u64_create(const char *name, umode_t mode,
+				  struct dentry *parent, u64 *value);
+struct dentry *debugfs_x8_create(const char *name, umode_t mode,
+				 struct dentry *parent, u8 *value);
+struct dentry *debugfs_x16_create(const char *name, umode_t mode,
+				  struct dentry *parent, u16 *value);
+struct dentry *debugfs_x32_create(const char *name, umode_t mode,
+				  struct dentry *parent, u32 *value);
+struct dentry *debugfs_x64_create(const char *name, umode_t mode,
+				  struct dentry *parent, u64 *value);
+struct dentry *debugfs_size_t_create(const char *name, umode_t mode,
+				     struct dentry *parent, size_t *value);
+struct dentry *debugfs_bool_create(const char *name, umode_t mode,
+				  struct dentry *parent, u32 *value);
+
+struct dentry *debugfs_blob_create(const char *name, umode_t mode,
+				  struct dentry *parent,
+				  struct debugfs_blob_wrapper *blob);
+
+struct dentry *debugfs_regset32_create(const char *name, umode_t mode,
+				     struct dentry *parent,
+				     struct debugfs_regset32 *regset);
+
+
 #else
 
 #include <linux/err.h>
@@ -219,6 +258,87 @@ static inline bool debugfs_initialized(void)
 	return false;
 }
 
+struct dentry *debugfs_file_create(const char *name, umode_t mode,
+				   struct dentry *parent, void *data,
+				   const struct file_operations *fops)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+struct dentry *debugfs_dir_create(const char *name, struct dentry *parent)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+struct dentry *debugfs_symlink_create(const char *name, struct dentry *parent,
+				      const char *dest)
+{
+	return ERR_PTR(-ENODEV);
+}
+struct dentry *debugfs_u8_create(const char *name, umode_t mode,
+				 struct dentry *parent, u8 *value)
+{
+	return ERR_PTR(-ENODEV);
+}
+struct dentry *debugfs_u16_create(const char *name, umode_t mode,
+				  struct dentry *parent, u16 *value)
+{
+	return ERR_PTR(-ENODEV);
+}
+struct dentry *debugfs_u32_create(const char *name, umode_t mode,
+				  struct dentry *parent, u32 *value)
+{
+	return ERR_PTR(-ENODEV);
+}
+struct dentry *debugfs_u64_create(const char *name, umode_t mode,
+				  struct dentry *parent, u64 *value)
+{
+	return ERR_PTR(-ENODEV);
+}
+struct dentry *debugfs_x8_create(const char *name, umode_t mode,
+				 struct dentry *parent, u8 *value)
+{
+	return ERR_PTR(-ENODEV);
+}
+struct dentry *debugfs_x16_create(const char *name, umode_t mode,
+				  struct dentry *parent, u16 *value)
+{
+	return ERR_PTR(-ENODEV);
+}
+struct dentry *debugfs_x32_create(const char *name, umode_t mode,
+				  struct dentry *parent, u32 *value)
+{
+	return ERR_PTR(-ENODEV);
+}
+struct dentry *debugfs_x64_create(const char *name, umode_t mode,
+				  struct dentry *parent, u64 *value)
+{
+	return ERR_PTR(-ENODEV);
+}
+struct dentry *debugfs_size_t_create(const char *name, umode_t mode,
+				     struct dentry *parent, size_t *value)
+{
+	return ERR_PTR(-ENODEV);
+}
+struct dentry *debugfs_bool_create(const char *name, umode_t mode,
+				  struct dentry *parent, u32 *value)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+struct dentry *debugfs_blob_create(const char *name, umode_t mode,
+				  struct dentry *parent,
+				  struct debugfs_blob_wrapper *blob)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+struct dentry *debugfs_regset32_create(const char *name, umode_t mode,
+				     struct dentry *parent,
+				     struct debugfs_regset32 *regset)
+{
+	return ERR_PTR(-ENODEV);
+}
 #endif
 
 #endif
-- 
1.7.3.4

