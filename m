Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab1JWTFp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 15:05:45 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:36464 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab1JWTFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 15:05:43 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Gleb Natapov <gleb@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        KVM <kvm@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        Xen <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Date: Mon, 24 Oct 2011 00:34:04 +0530
Message-Id: <20111023190403.16364.30897.sendpatchset@oc5400248562.ibm.com>
In-Reply-To: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com>
References: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com>
Subject: [PATCH RFC V2 1/5] debugfs: Add support to print u32 array in debugfs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add debugfs support to print u32-arrays in debugfs. Move the code from Xen to debugfs
to make the code common for other users as well.

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
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
diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 90f7657..9aa12e3 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -18,6 +18,7 @@
 #include <linux/pagemap.h>
 #include <linux/namei.h>
 #include <linux/debugfs.h>
+#include <linux/slab.h>
 
 static ssize_t default_read_file(struct file *file, char __user *buf,
 				 size_t count, loff_t *ppos)
@@ -525,3 +526,110 @@ struct dentry *debugfs_create_blob(const char *name, mode_t mode,
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
+static char *format_array_alloc(const char *fmt, u32 *array,
+						unsigned array_size)
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
+static int xen_array_release(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+
+	return 0;
+}
+
+static const struct file_operations u32_array_fops = {
+	.owner	 = THIS_MODULE,
+	.open	 = u32_array_open,
+	.release = xen_array_release,
+	.read	 = u32_array_read,
+	.llseek  = no_llseek,
+};
+
+struct dentry *xen_debugfs_create_u32_array(const char *name, mode_t mode,
+					    struct dentry *parent,
+					    u32 *array, unsigned elements)
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
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index e7d9b20..8c08636 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -74,6 +74,10 @@ struct dentry *debugfs_create_blob(const char *name, mode_t mode,
 				  struct dentry *parent,
 				  struct debugfs_blob_wrapper *blob);
 
+struct dentry *xen_debugfs_create_u32_array(const char *name, mode_t mode,
+					    struct dentry *parent,
+					    u32 *array, unsigned elements);
+
 bool debugfs_initialized(void);
 
 #else
@@ -193,6 +197,13 @@ static inline bool debugfs_initialized(void)
 	return false;
 }
 
+struct dentry *xen_debugfs_create_u32_array(const char *name, mode_t mode,
+					    struct dentry *parent,
+					    u32 *array, unsigned elements)
+{
+	return ERR_PTR(-ENODEV);
+}
+
 #endif
 
 #endif
