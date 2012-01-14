Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab2ANS0Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 13:26:25 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57915 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756215Ab2ANS0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 13:26:22 -0500
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, KVM <kvm@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Glauber Costa <glommer@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Rik van Riel <riel@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Landley <rlandley@parallels.com>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>,
        Alexander Graf <agraf@suse.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Paul Mackerras <paulus@samba.org>, Sedat Dilek <sedat.dilek@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xen <xen-devel@lists.xensource.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Date: Sat, 14 Jan 2012 23:55:28 +0530
Message-Id: <20120114182527.8604.2705.sendpatchset@oc5400248562.ibm.com>
In-Reply-To: <20120114182501.8604.68416.sendpatchset@oc5400248562.ibm.com>
References: <20120114182501.8604.68416.sendpatchset@oc5400248562.ibm.com>
Subject: [PATCH RFC V4 1/5] debugfs: Add support to print u32 array in debugfs
x-cbid: 12011418-1976-0000-0000-00000980BF08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add debugfs support to print u32-arrays in debugfs. Move the code from Xen to debugfs
to make the code common for other users as well.

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
diff --git a/arch/x86/xen/debugfs.c b/arch/x86/xen/debugfs.c
index 7c0fedd..c8377fb 100644
--- a/arch/x86/xen/debugfs.c
+++ b/arch/x86/xen/debugfs.c
@@ -19,107 +19,3 @@ struct dentry * __init xen_init_debugfs(void)
 	return d_xen_debug;
 }
 
-struct array_data
-{
-	void *array;
-	unsigned elements;
-};
-
-static int u32_array_open(struct inode *inode, struct file *file)
-{
-	file->private_data = NULL;
-	return nonseekable_open(inode, file);
-}
-
-static size_t format_array(char *buf, size_t bufsize, const char *fmt,
-			   u32 *array, unsigned array_size)
-{
-	size_t ret = 0;
-	unsigned i;
-
-	for(i = 0; i < array_size; i++) {
-		size_t len;
-
-		len = snprintf(buf, bufsize, fmt, array[i]);
-		len++;	/* ' ' or '\n' */
-		ret += len;
-
-		if (buf) {
-			buf += len;
-			bufsize -= len;
-			buf[-1] = (i == array_size-1) ? '\n' : ' ';
-		}
-	}
-
-	ret++;		/* \0 */
-	if (buf)
-		*buf = '\0';
-
-	return ret;
-}
-
-static char *format_array_alloc(const char *fmt, u32 *array, unsigned array_size)
-{
-	size_t len = format_array(NULL, 0, fmt, array, array_size);
-	char *ret;
-
-	ret = kmalloc(len, GFP_KERNEL);
-	if (ret == NULL)
-		return NULL;
-
-	format_array(ret, len, fmt, array, array_size);
-	return ret;
-}
-
-static ssize_t u32_array_read(struct file *file, char __user *buf, size_t len,
-			      loff_t *ppos)
-{
-	struct inode *inode = file->f_path.dentry->d_inode;
-	struct array_data *data = inode->i_private;
-	size_t size;
-
-	if (*ppos == 0) {
-		if (file->private_data) {
-			kfree(file->private_data);
-			file->private_data = NULL;
-		}
-
-		file->private_data = format_array_alloc("%u", data->array, data->elements);
-	}
-
-	size = 0;
-	if (file->private_data)
-		size = strlen(file->private_data);
-
-	return simple_read_from_buffer(buf, len, ppos, file->private_data, size);
-}
-
-static int xen_array_release(struct inode *inode, struct file *file)
-{
-	kfree(file->private_data);
-
-	return 0;
-}
-
-static const struct file_operations u32_array_fops = {
-	.owner	= THIS_MODULE,
-	.open	= u32_array_open,
-	.release= xen_array_release,
-	.read	= u32_array_read,
-	.llseek = no_llseek,
-};
-
-struct dentry *xen_debugfs_create_u32_array(const char *name, mode_t mode,
-					    struct dentry *parent,
-					    u32 *array, unsigned elements)
-{
-	struct array_data *data = kmalloc(sizeof(*data), GFP_KERNEL);
-
-	if (data == NULL)
-		return NULL;
-
-	data->array = array;
-	data->elements = elements;
-
-	return debugfs_create_file(name, mode, parent, data, &u32_array_fops);
-}
diff --git a/arch/x86/xen/debugfs.h b/arch/x86/xen/debugfs.h
index e281320..12ebf33 100644
--- a/arch/x86/xen/debugfs.h
+++ b/arch/x86/xen/debugfs.h
@@ -3,8 +3,4 @@
 
 struct dentry * __init xen_init_debugfs(void);
 
-struct dentry *xen_debugfs_create_u32_array(const char *name, mode_t mode,
-					    struct dentry *parent,
-					    u32 *array, unsigned elements);
-
 #endif /* _XEN_DEBUGFS_H */
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index fc506e6..14a8961 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -286,7 +286,7 @@ static int __init xen_spinlock_debugfs(void)
 	debugfs_create_u64("time_blocked", 0444, d_spin_debug,
 			   &spinlock_stats.time_blocked);
 
-	xen_debugfs_create_u32_array("histo_blocked", 0444, d_spin_debug,
+	debugfs_create_u32_array("histo_blocked", 0444, d_spin_debug,
 				     spinlock_stats.histo_spin_blocked, HISTO_BUCKETS + 1);
 
 	return 0;
diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 90f7657..df44ccf 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -18,6 +18,7 @@
 #include <linux/pagemap.h>
 #include <linux/namei.h>
 #include <linux/debugfs.h>
+#include <linux/slab.h>
 
 static ssize_t default_read_file(struct file *file, char __user *buf,
 				 size_t count, loff_t *ppos)
@@ -525,3 +526,130 @@ struct dentry *debugfs_create_blob(const char *name, mode_t mode,
 	return debugfs_create_file(name, mode, parent, blob, &fops_blob);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_blob);
+
+struct array_data {
+	void *array;
+	u32 elements;
+};
+
+static int u32_array_open(struct inode *inode, struct file *file)
+{
+	file->private_data = NULL;
+	return nonseekable_open(inode, file);
+}
+
+static size_t format_array(char *buf, size_t bufsize, const char *fmt,
+			   u32 *array, u32 array_size)
+{
+	size_t ret = 0;
+	u32 i;
+
+	for (i = 0; i < array_size; i++) {
+		size_t len;
+
+		len = snprintf(buf, bufsize, fmt, array[i]);
+		len++;	/* ' ' or '\n' */
+		ret += len;
+
+		if (buf) {
+			buf += len;
+			bufsize -= len;
+			buf[-1] = (i == array_size-1) ? '\n' : ' ';
+		}
+	}
+
+	ret++;		/* \0 */
+	if (buf)
+		*buf = '\0';
+
+	return ret;
+}
+
+static char *format_array_alloc(const char *fmt, u32 *array,
+						u32 array_size)
+{
+	size_t len = format_array(NULL, 0, fmt, array, array_size);
+	char *ret;
+
+	ret = kmalloc(len, GFP_KERNEL);
+	if (ret == NULL)
+		return NULL;
+
+	format_array(ret, len, fmt, array, array_size);
+	return ret;
+}
+
+static ssize_t u32_array_read(struct file *file, char __user *buf, size_t len,
+			      loff_t *ppos)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct array_data *data = inode->i_private;
+	size_t size;
+
+	if (*ppos == 0) {
+		if (file->private_data) {
+			kfree(file->private_data);
+			file->private_data = NULL;
+		}
+
+		file->private_data = format_array_alloc("%u", data->array,
+							      data->elements);
+	}
+
+	size = 0;
+	if (file->private_data)
+		size = strlen(file->private_data);
+
+	return simple_read_from_buffer(buf, len, ppos,
+					file->private_data, size);
+}
+
+static int u32_array_release(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+
+	return 0;
+}
+
+static const struct file_operations u32_array_fops = {
+	.owner	 = THIS_MODULE,
+	.open	 = u32_array_open,
+	.release = u32_array_release,
+	.read	 = u32_array_read,
+	.llseek  = no_llseek,
+};
+
+/**
+ * debugfs_create_u32_array - create a debugfs file that is used to read u32
+ * array.
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have.
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @array: u32 array that provides data.
+ * @elements: total number of elements in the array.
+ *
+ * This function creates a file in debugfs with the given name that exports
+ * @array as data. If the @mode variable is so set it can be read from.
+ * Writing is not supported. Seek within the file is also not supported.
+ * Once array is created its size can not be changed.
+ *
+ * The function returns a pointer to dentry on success. If debugfs is not
+ * enabled in the kernel, the value -%ENODEV will be returned.
+ */
+struct dentry *debugfs_create_u32_array(const char *name, mode_t mode,
+					    struct dentry *parent,
+					    u32 *array, u32 elements)
+{
+	struct array_data *data = kmalloc(sizeof(*data), GFP_KERNEL);
+
+	if (data == NULL)
+		return NULL;
+
+	data->array = array;
+	data->elements = elements;
+
+	return debugfs_create_file(name, mode, parent, data, &u32_array_fops);
+}
+EXPORT_SYMBOL_GPL(debugfs_create_u32_array);
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index e7d9b20..253e2fb 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -74,6 +74,10 @@ struct dentry *debugfs_create_blob(const char *name, mode_t mode,
 				  struct dentry *parent,
 				  struct debugfs_blob_wrapper *blob);
 
+struct dentry *debugfs_create_u32_array(const char *name, mode_t mode,
+					struct dentry *parent,
+					u32 *array, u32 elements);
+
 bool debugfs_initialized(void);
 
 #else
@@ -193,6 +197,13 @@ static inline bool debugfs_initialized(void)
 	return false;
 }
 
+struct dentry *debugfs_create_u32_array(const char *name, mode_t mode,
+					struct dentry *parent,
+					u32 *array, u32 elements)
+{
+	return ERR_PTR(-ENODEV);
+}
+
 #endif
 
 #endif

