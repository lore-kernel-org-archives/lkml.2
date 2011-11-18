Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794Ab1KRNud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 08:50:33 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:61498 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756185Ab1KRNuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 08:50:32 -0500
Date: Fri, 18 Nov 2011 14:50:21 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: anaghi@mail.gnudd.com, balbi@ti.com, broonie@opensource.wolfsonmicro.com
Subject: [PATCH V2 1/2] debugfs: add tools to printk 32-bit registers
Message-ID: <20111118135021.GA860@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <20111118002049.GA24806@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some debugfs file I deal with are mostly blocks of registers,
i.e. lines of the form "<name> = 0x<value>". Some files are only
registers, some include registers blocks among other material.  This
patch introduces data structures and functions to deal with both
cases.  I expect more users of this over time.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 Documentation/filesystems/debugfs.txt |   32 +++++++++++-
 fs/debugfs/file.c                     |   90 +++++++++++++++++++++++++++++++++
 include/linux/debugfs.h               |   26 +++++++++
 3 files changed, 147 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/debugfs.txt b/Documentation/filesystems/debugfs.txt
index 742cc06..f04066a 100644
--- a/Documentation/filesystems/debugfs.txt
+++ b/Documentation/filesystems/debugfs.txt
@@ -97,7 +97,8 @@ A read on the resulting file will yield either Y (for non-zero values) or
 N, followed by a newline.  If written to, it will accept either upper- or
 lower-case values, or 1 or 0.  Any other input will be silently ignored.
 
-Finally, a block of arbitrary binary data can be exported with:
+Another option is exporting a block of arbitrary binary data, with
+this structure and function:
 
     struct debugfs_blob_wrapper {
 	void *data;
@@ -115,6 +116,35 @@ can be used to export binary information, but there does not appear to be
 any code which does so in the mainline.  Note that all files created with
 debugfs_create_blob() are read-only.
 
+If you want to dump a block of registers (something that happens quite
+often during development, even if little such code reaches mainline.
+Debugfs offers two functions: one to make a registers-only file, and
+another to insert a register block in the middle of another sequential
+file.
+
+    struct debugfs_reg32 {
+	char *name;
+	unsigned long offset;
+    };
+
+    struct debugfs_regset32 {
+	struct debugfs_reg32 *regs;
+	int nregs;
+	void __iomem *base;
+    };
+
+    struct dentry *debugfs_create_regset32(const char *name, mode_t mode,
+				     struct dentry *parent,
+				     struct debugfs_regset32 *regset);
+
+    int debugfs_print_regs32(struct seq_file *s, struct debugfs_reg32 *regs,
+			 int nregs, void __iomem *base, char *prefix);
+
+The "base" argument may be 0, but you may want to build the reg32 array
+using __stringify, and a number of register names (macros) are actually
+byte offsets over a base for the register block.
+
+
 There are a couple of other directory-oriented helper functions:
 
     struct dentry *debugfs_rename(struct dentry *old_dir, 
diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 90f7657..f31a27c 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -15,6 +15,7 @@
 
 #include <linux/module.h>
 #include <linux/fs.h>
+#include <linux/seq_file.h>
 #include <linux/pagemap.h>
 #include <linux/namei.h>
 #include <linux/debugfs.h>
@@ -525,3 +526,92 @@ struct dentry *debugfs_create_blob(const char *name, mode_t mode,
 	return debugfs_create_file(name, mode, parent, blob, &fops_blob);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_blob);
+
+/*
+ * The regset32 stuff is used to print 32-bit registers using the
+ * seq_file utilities. We offer printing a register set in an already-opened
+ * sequential file or create a debugfs file that only prints a regset32.
+ */
+
+/**
+ * debugfs_print_regs32 - use seq_print to describe a set of registers
+ * @s: the seq_file structure being used to generate output
+ * @regs: an array if struct debugfs_reg32 structures
+ * @mregs: the length of the above array
+ * @base: the base address to be used in reading the registers
+ * @prefix: a string to be prefixed to every output line
+ *
+ * This function outputs a text block describing the current values of
+ * some 32-bit hardware registers. It is meant to be used within debugfs
+ * files based on seq_file that need to show registers, intermixed with other
+ * information. The prefix argument may be used to specify a leading string,
+ * because some peripherals have several blocks of identical registers,
+ * for example configuration of dma channels
+ */
+int debugfs_print_regs32(struct seq_file *s, struct debugfs_reg32 *regs,
+			   int nregs, void __iomem *base, char *prefix)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < nregs; i++, regs++) {
+		if (prefix)
+			ret += seq_printf(s, "%s", prefix);
+		ret += seq_printf(s, "%s = 0x%08x\n", regs->name,
+				  readl((void *)(base + regs->offset)));
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(debugfs_print_regs32);
+
+static int debugfs_show_regset32(struct seq_file *s, void *data)
+{
+	struct debugfs_regset32 *regset = s->private;
+
+	debugfs_print_regs32(s, regset->regs, regset->nregs, regset->base, "");
+	return 0;
+}
+
+static int debugfs_open_regset32(struct inode *inode, struct file *file)
+{
+	return single_open(file, debugfs_show_regset32, inode->i_private);
+}
+
+static const struct file_operations fops_regset32 = {
+	.open =		debugfs_open_regset32,
+	.read =		seq_read,
+	.llseek =	seq_lseek,
+	.release =	single_release,
+};
+
+/**
+ * debugfs_create_regset32 - create a debugfs file that returns register values
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
+ * you are responsible here.)  If an error occurs, %NULL will be returned.
+ *
+ * If debugfs is not enabled in the kernel, the value -%ENODEV will be
+ * returned.  It is not wise to check for this value, but rather, check for
+ * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
+ * code.
+ */
+struct dentry *debugfs_create_regset32(const char *name, mode_t mode,
+				       struct dentry *parent,
+				       struct debugfs_regset32 *regset)
+{
+	return debugfs_create_file(name, mode, parent, regset, &fops_regset32);
+}
+EXPORT_SYMBOL_GPL(debugfs_create_regset32);
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index e7d9b20..5e6b01f 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -16,6 +16,7 @@
 #define _DEBUGFS_H_
 
 #include <linux/fs.h>
+#include <linux/seq_file.h>
 
 #include <linux/types.h>
 
@@ -26,6 +27,17 @@ struct debugfs_blob_wrapper {
 	unsigned long size;
 };
 
+struct debugfs_reg32 {
+	char *name;
+	unsigned long offset;
+};
+
+struct debugfs_regset32 {
+	struct debugfs_reg32 *regs;
+	int nregs;
+	void __iomem *base;
+};
+
 extern struct dentry *arch_debugfs_dir;
 
 #if defined(CONFIG_DEBUG_FS)
@@ -74,6 +86,13 @@ struct dentry *debugfs_create_blob(const char *name, mode_t mode,
 				  struct dentry *parent,
 				  struct debugfs_blob_wrapper *blob);
 
+struct dentry *debugfs_create_regset32(const char *name, mode_t mode,
+				     struct dentry *parent,
+				     struct debugfs_regset32 *regset);
+
+int debugfs_print_regs32(struct seq_file *s, struct debugfs_reg32 *regs,
+			 int nregs, void __iomem *base, char *prefix);
+
 bool debugfs_initialized(void);
 
 #else
@@ -188,6 +207,13 @@ static inline struct dentry *debugfs_create_blob(const char *name, mode_t mode,
 	return ERR_PTR(-ENODEV);
 }
 
+static inline struct dentry *debugfs_create_regset32(const char *name,
+				   mode_t mode, struct dentry *parent,
+				   struct debugfs_regset32 *regset)
+{
+	return ERR_PTR(-ENODEV);
+}
+
 static inline bool debugfs_initialized(void)
 {
 	return false;
-- 
1.6.0.2
