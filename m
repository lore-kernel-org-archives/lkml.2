Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab0GZGOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 02:14:07 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59204 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab0GZGOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 02:14:03 -0400
Date: Mon, 26 Jul 2010 11:43:40 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: avi@redhat.com
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        linux-kernel@vger.kernel.org, npiggin@suse.de,
        Jeremy Fitzhardinge <jeremy@goop.org>, kvm@vger.kernel.org,
        bharata@in.ibm.com, Balbir Singh <balbir@in.ibm.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: [PATCH RFC 1/4] Debugfs support for reading an array of u32-type
 integers
Message-ID: <20100726061340.GA8402@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20100726061150.GB21699@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100726061150.GB21699@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Debugfs support for reading an array of u32-type integers. This is a rework of
what code already exists for Xen.

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
---
 arch/x86/xen/debugfs.c    |  104 ----------------------------------------
 arch/x86/xen/debugfs.h    |    4 -
 arch/x86/xen/mmu.c        |    2 
 arch/x86/xen/multicalls.c |    6 +-
 arch/x86/xen/spinlock.c   |    6 +-
 fs/debugfs/file.c         |  117 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/debugfs.h   |   11 ++++
 7 files changed, 135 insertions(+), 115 deletions(-)

Index: current/arch/x86/xen/debugfs.c
===================================================================
--- current.orig/arch/x86/xen/debugfs.c
+++ current/arch/x86/xen/debugfs.c
@@ -18,107 +18,3 @@ struct dentry * __init xen_init_debugfs(
 
 	return d_xen_debug;
 }
-
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
Index: current/arch/x86/xen/debugfs.h
===================================================================
--- current.orig/arch/x86/xen/debugfs.h
+++ current/arch/x86/xen/debugfs.h
@@ -3,8 +3,4 @@
 
 struct dentry * __init xen_init_debugfs(void);
 
-struct dentry *xen_debugfs_create_u32_array(const char *name, mode_t mode,
-					    struct dentry *parent,
-					    u32 *array, unsigned elements);
-
 #endif /* _XEN_DEBUGFS_H */
Index: current/arch/x86/xen/mmu.c
===================================================================
--- current.orig/arch/x86/xen/mmu.c
+++ current/arch/x86/xen/mmu.c
@@ -1983,7 +1983,7 @@ static int __init xen_mmu_debugfs(void)
 	debugfs_create_u32("mmu_update", 0444, d_mmu_debug, &mmu_stats.mmu_update);
 	debugfs_create_u32("mmu_update_extended", 0444, d_mmu_debug,
 			   &mmu_stats.mmu_update_extended);
-	xen_debugfs_create_u32_array("mmu_update_histo", 0444, d_mmu_debug,
+	debugfs_create_u32_array("mmu_update_histo", 0444, d_mmu_debug,
 				     mmu_stats.mmu_update_histo, 20);
 
 	debugfs_create_u32("set_pte_at", 0444, d_mmu_debug, &mmu_stats.set_pte_at);
Index: current/arch/x86/xen/multicalls.c
===================================================================
--- current.orig/arch/x86/xen/multicalls.c
+++ current/arch/x86/xen/multicalls.c
@@ -269,11 +269,11 @@ static int __init xen_mc_debugfs(void)
 	debugfs_create_u32("hypercalls", 0444, d_mc_debug, &mc_stats.hypercalls);
 	debugfs_create_u32("arg_total", 0444, d_mc_debug, &mc_stats.arg_total);
 
-	xen_debugfs_create_u32_array("batch_histo", 0444, d_mc_debug,
+	debugfs_create_u32_array("batch_histo", 0444, d_mc_debug,
 				     mc_stats.histo, MC_BATCH);
-	xen_debugfs_create_u32_array("hypercall_histo", 0444, d_mc_debug,
+	debugfs_create_u32_array("hypercall_histo", 0444, d_mc_debug,
 				     mc_stats.histo_hypercalls, NHYPERCALLS);
-	xen_debugfs_create_u32_array("flush_reasons", 0444, d_mc_debug,
+	debugfs_create_u32_array("flush_reasons", 0444, d_mc_debug,
 				     mc_stats.flush, FL_N_REASONS);
 
 	return 0;
Index: current/arch/x86/xen/spinlock.c
===================================================================
--- current.orig/arch/x86/xen/spinlock.c
+++ current/arch/x86/xen/spinlock.c
@@ -423,11 +423,11 @@ static int __init xen_spinlock_debugfs(v
 	debugfs_create_u64("time_total", 0444, d_spin_debug,
 			   &spinlock_stats.time_total);
 
-	xen_debugfs_create_u32_array("histo_total", 0444, d_spin_debug,
+	debugfs_create_u32_array("histo_total", 0444, d_spin_debug,
 				     spinlock_stats.histo_spin_total, HISTO_BUCKETS + 1);
-	xen_debugfs_create_u32_array("histo_spinning", 0444, d_spin_debug,
+	debugfs_create_u32_array("histo_spinning", 0444, d_spin_debug,
 				     spinlock_stats.histo_spin_spinning, HISTO_BUCKETS + 1);
-	xen_debugfs_create_u32_array("histo_blocked", 0444, d_spin_debug,
+	debugfs_create_u32_array("histo_blocked", 0444, d_spin_debug,
 				     spinlock_stats.histo_spin_blocked, HISTO_BUCKETS + 1);
 
 	return 0;
Index: current/fs/debugfs/file.c
===================================================================
--- current.orig/fs/debugfs/file.c
+++ current/fs/debugfs/file.c
@@ -18,6 +18,7 @@
 #include <linux/pagemap.h>
 #include <linux/namei.h>
 #include <linux/debugfs.h>
+#include <linux/slab.h>
 
 static ssize_t default_read_file(struct file *file, char __user *buf,
 				 size_t count, loff_t *ppos)
@@ -531,3 +532,119 @@ struct dentry *debugfs_create_blob(const
 	return debugfs_create_file(name, mode, parent, blob, &fops_blob);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_blob);
+
+struct array_data {
+	void *array;
+	unsigned elements;
+};
+
+static int u32_array_open(struct inode *inode, struct file *file)
+{
+	file->private_data = NULL;
+	return nonseekable_open(inode, file);
+}
+
+static size_t format_array(char *buf, size_t bufsize, const char *fmt,
+			   u32 *array, unsigned array_size)
+{
+	size_t ret = 0;
+	unsigned i;
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
+static char *
+format_array_alloc(const char *fmt, u32 *array, unsigned array_size)
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
+		kfree(file->private_data);
+		file->private_data = format_array_alloc("%u", data->array,
+							 data->elements);
+	}
+
+	size = 0;
+	if (file->private_data)
+		size = strlen(file->private_data);
+
+	return simple_read_from_buffer(buf, len, ppos,
+						file->private_data, size);
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
+	.owner		= THIS_MODULE,
+	.open		= u32_array_open,
+	.release	= u32_array_release,
+	.read		= u32_array_read,
+};
+
+/**
+ * debugfs_create_u32_array - create a debugfs file that is used to read an array of unsigned 32-bit values.
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @array: array of integers of type u32
+ * @elements: number of elements in the array
+ */
+struct dentry *debugfs_create_u32_array(const char *name, mode_t mode,
+					    struct dentry *parent,
+					    u32 *array, unsigned elements)
+{
+	struct array_data *data = kmalloc(sizeof(*data), GFP_KERNEL);
+
+	if (data == NULL)
+		return NULL;
+
+	/* u32 array can't be written or executed! */
+	if (mode & (S_IWUGO | S_IXUGO))
+		return ERR_PTR(-EINVAL);
+
+	data->array = array;
+	data->elements = elements;
+
+	return debugfs_create_file(name, mode, parent, data, &u32_array_fops);
+}
Index: current/include/linux/debugfs.h
===================================================================
--- current.orig/include/linux/debugfs.h
+++ current/include/linux/debugfs.h
@@ -74,6 +74,10 @@ struct dentry *debugfs_create_blob(const
 				  struct dentry *parent,
 				  struct debugfs_blob_wrapper *blob);
 
+struct dentry *debugfs_create_u32_array(const char *name, mode_t mode,
+					    struct dentry *parent,
+					    u32 *array, unsigned elements);
+
 bool debugfs_initialized(void);
 
 #else
@@ -188,6 +192,13 @@ static inline struct dentry *debugfs_cre
 	return ERR_PTR(-ENODEV);
 }
 
+struct dentry *debugfs_create_u32_array(const char *name, mode_t mode,
+					    struct dentry *parent,
+					    u32 *array, unsigned elements)
+{
+	return ERR_PTR(-ENODEV);
+}
+
 static inline bool debugfs_initialized(void)
 {
 	return false;
