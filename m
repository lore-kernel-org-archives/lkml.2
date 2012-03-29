Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759672Ab2C2RQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 13:16:33 -0400
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4071 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758638Ab2C2RQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 13:16:28 -0400
From: Maarten ter Huurne <maarten@treewalker.org>
To: linux-kernel@vger.kernel.org
Cc: Maarten ter Huurne <maarten@treewalker.org>
Subject: [PATCH] /dev/mem: Add kernel config option to omit this device.
Date: Thu, 29 Mar 2012 19:22:04 +0200
Message-Id: <1333041724-20532-1-git-send-email-maarten@treewalker.org>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many systems don't need /dev/mem, so make it optional.
It saves some space on embedded systems.

Signed-off-by: Maarten ter Huurne <maarten@treewalker.org>
---
 arch/x86/Kconfig.debug |    1 +
 drivers/char/Kconfig   |   10 ++++++++++
 drivers/char/mem.c     |   17 +++++++++++++++++
 3 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index e46c214..a47825b 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -7,6 +7,7 @@ source "lib/Kconfig.debug"
 
 config STRICT_DEVMEM
 	bool "Filter access to /dev/mem"
+	depends on DEVMEM
 	---help---
 	  If this option is disabled, you allow userspace (root) access to all
 	  of memory, including kernel and userspace memory. Accidental
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 4364303..a2e462e 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -6,6 +6,16 @@ menu "Character devices"
 
 source "drivers/tty/Kconfig"
 
+config DEVMEM
+	bool "/dev/mem virtual device support"
+	default y
+	help
+	  Say Y here if you want to support the /dev/mem device.
+	  Some X server drivers access the video hardware using this device.
+	  Accessing hardware directly from user space can be useful in some
+	  cases, but it is not without risks.
+	  When in doubt, say "N".
+
 config DEVKMEM
 	bool "/dev/kmem virtual device support"
 	default y
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index d6e9d08..97a35c2 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -87,6 +87,8 @@ void __weak unxlate_dev_mem_ptr(unsigned long phys, void *addr)
 {
 }
 
+#ifdef CONFIG_DEVMEM
+
 /*
  * This funcion reads the *physical* memory. The f_pos points directly to the
  * memory location.
@@ -210,6 +212,10 @@ static ssize_t write_mem(struct file *file, const char __user *buf,
 	return written;
 }
 
+#endif
+
+#if defined(CONFIG_DEVMEM) || defined(CONFIG_DEVKMEM)
+
 int __weak phys_mem_access_prot_allowed(struct file *file,
 	unsigned long pfn, unsigned long size, pgprot_t *vma_prot)
 {
@@ -331,6 +337,8 @@ static int mmap_mem(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
+#endif
+
 #ifdef CONFIG_DEVKMEM
 static int mmap_kmem(struct file *file, struct vm_area_struct *vma)
 {
@@ -694,6 +702,7 @@ static loff_t null_lseek(struct file *file, loff_t offset, int orig)
 	return file->f_pos = 0;
 }
 
+#if defined(CONFIG_DEVMEM) || defined(CONFIG_DEVKMEM) || defined(CONFIG_DEVPORT)
 /*
  * The memory devices use the full 32/64 bits of the offset, and so we cannot
  * check against negative addresses: they are ok. The return value is weird,
@@ -726,11 +735,15 @@ static loff_t memory_lseek(struct file *file, loff_t offset, int orig)
 	mutex_unlock(&file->f_path.dentry->d_inode->i_mutex);
 	return ret;
 }
+#endif
 
+#if defined(CONFIG_DEVMEM) || defined(CONFIG_DEVKMEM) || \
+		defined(CONFIG_DEVPORT) || defined(CONFIG_CRASH_DUMP)
 static int open_port(struct inode * inode, struct file * filp)
 {
 	return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
 }
+#endif
 
 #define zero_lseek	null_lseek
 #define full_lseek      null_lseek
@@ -740,6 +753,7 @@ static int open_port(struct inode * inode, struct file * filp)
 #define open_kmem	open_mem
 #define open_oldmem	open_mem
 
+#ifdef CONFIG_DEVMEM
 static const struct file_operations mem_fops = {
 	.llseek		= memory_lseek,
 	.read		= read_mem,
@@ -748,6 +762,7 @@ static const struct file_operations mem_fops = {
 	.open		= open_mem,
 	.get_unmapped_area = get_unmapped_area_mem,
 };
+#endif
 
 #ifdef CONFIG_DEVKMEM
 static const struct file_operations kmem_fops = {
@@ -851,7 +866,9 @@ static const struct memdev {
 	const struct file_operations *fops;
 	struct backing_dev_info *dev_info;
 } devlist[] = {
+#ifdef CONFIG_DEVMEM
 	 [1] = { "mem", 0, &mem_fops, &directly_mappable_cdev_bdi },
+#endif
 #ifdef CONFIG_DEVKMEM
 	 [2] = { "kmem", 0, &kmem_fops, &directly_mappable_cdev_bdi },
 #endif
-- 
1.7.7

