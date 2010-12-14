Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525Ab0LNQYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:24:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab0LNQY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:24:26 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Amerigo Wang <amwang@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] x86: merge crash_dump_32.c and crash_dump_64.c
Date: Wed, 15 Dec 2010 00:23:49 +0800
Message-Id: <1292343833-5023-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch merges crash_dump_32.c and crash_dump_64.c into crash_dump.c.
Compile tested.

Signed-off-by: WANG Cong <amwang@redhat.com>
---
 arch/x86/kernel/Makefile        |    2 +-
 arch/x86/kernel/crash_dump.c    |  142 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/crash_dump_32.c |   98 ---------------------------
 arch/x86/kernel/crash_dump_64.c |   52 --------------
 4 files changed, 143 insertions(+), 151 deletions(-)
 create mode 100644 arch/x86/kernel/crash_dump.c
 delete mode 100644 arch/x86/kernel/crash_dump_32.c
 delete mode 100644 arch/x86/kernel/crash_dump_64.c

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 9e13763..2cd2d6f 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -77,7 +77,7 @@ obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += ftrace.o
 obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
 obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
-obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
+obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_MODULES)		+= module.o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
diff --git a/arch/x86/kernel/crash_dump.c b/arch/x86/kernel/crash_dump.c
new file mode 100644
index 0000000..987b244
--- /dev/null
+++ b/arch/x86/kernel/crash_dump.c
@@ -0,0 +1,142 @@
+/*
+ *	Memory preserving reboot related code.
+ *
+ *	Created by: Hariprasad Nellitheertha (hari@in.ibm.com)
+ *	Copyright (C) IBM Corporation, 2004. All rights reserved
+ */
+
+#include <linux/slab.h>
+#include <linux/errno.h>
+#include <linux/highmem.h>
+#include <linux/crash_dump.h>
+#include <linux/io.h>
+
+#include <asm/uaccess.h>
+
+
+/* Stores the physical address of elf header of crash image. */
+unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
+
+#ifdef CONFIG_X86_32
+
+static void *kdump_buf_page;
+static int __init kdump_buf_page_init(void)
+{
+	int ret = 0;
+
+	kdump_buf_page = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!kdump_buf_page) {
+		printk(KERN_WARNING "Kdump: Failed to allocate kdump buffer"
+			 " page\n");
+		ret = -ENOMEM;
+	}
+
+	return ret;
+}
+arch_initcall(kdump_buf_page_init);
+
+static inline bool is_crashed_pfn_valid(unsigned long pfn)
+{
+#ifndef CONFIG_X86_PAE
+	/*
+	 * non-PAE kdump kernel executed from a PAE one will crop high pte
+	 * bits and poke unwanted space counting again from address 0, we
+	 * don't want that. pte must fit into unsigned long. In fact the
+	 * test checks high 12 bits for being zero (pfn will be shifted left
+	 * by PAGE_SHIFT).
+	 */
+	return pte_pfn(pfn_pte(pfn, __pgprot(0))) == pfn;
+#else
+	return true;
+#endif
+}
+
+ssize_t copy_oldmem_page_32(unsigned long pfn, char *buf,
+                               size_t csize, unsigned long offset, int userbuf)
+{
+	void  *vaddr;
+
+	if (!csize)
+		return 0;
+
+	if (!is_crashed_pfn_valid(pfn))
+		return -EFAULT;
+
+	vaddr = kmap_atomic_pfn(pfn);
+
+	if (!userbuf) {
+		memcpy(buf, (vaddr + offset), csize);
+		kunmap_atomic(vaddr, KM_PTE0);
+	} else {
+		if (!kdump_buf_page) {
+			printk(KERN_WARNING "Kdump: Kdump buffer page not"
+				" allocated\n");
+			kunmap_atomic(vaddr, KM_PTE0);
+			return -EFAULT;
+		}
+		copy_page(kdump_buf_page, vaddr);
+		kunmap_atomic(vaddr, KM_PTE0);
+		if (copy_to_user(buf, (kdump_buf_page + offset), csize))
+			return -EFAULT;
+	}
+
+	return csize;
+}
+
+#else /*CONFIG_X86_32*/
+
+ssize_t copy_oldmem_page_64(unsigned long pfn, char *buf,
+		size_t csize, unsigned long offset, int userbuf)
+{
+	void  *vaddr;
+
+	if (!csize)
+		return 0;
+
+	vaddr = ioremap_cache(pfn << PAGE_SHIFT, PAGE_SIZE);
+	if (!vaddr)
+		return -ENOMEM;
+
+	if (userbuf) {
+		if (copy_to_user(buf, vaddr + offset, csize)) {
+			iounmap(vaddr);
+			return -EFAULT;
+		}
+	} else
+		memcpy(buf, vaddr + offset, csize);
+
+	set_iounmap_nonlazy();
+	iounmap(vaddr);
+	return csize;
+}
+#endif
+
+
+/**
+ * copy_oldmem_page - copy one page from "oldmem"
+ * @pfn: page frame number to be copied
+ * @buf: target memory address for the copy; this can be in kernel address
+ *	space or user address space (see @userbuf)
+ * @csize: number of bytes to copy
+ * @offset: offset in bytes into the page (based on pfn) to begin the copy
+ * @userbuf: if set, @buf is in user address space, use copy_to_user(),
+ *	otherwise @buf is in kernel address space, use memcpy().
+ *
+ * Copy a page from "oldmem". For this page, there is no pte mapped
+ * in the current kernel. We stitch up a pte, similar to kmap_atomic.
+ *
+ * Calling copy_to_user() in atomic context is not desirable. Hence first
+ * copying the data to a pre-allocated kernel page and then copying to user
+ * space in non-atomic context.
+ */
+ssize_t copy_oldmem_page(unsigned long pfn, char *buf, size_t csize,
+			 unsigned long offset, int userbuf)
+{
+#ifdef CONFIG_X86_32
+	return copy_oldmem_page_32(pfn, buf, csize, offset, userbuf);
+#else
+	return copy_oldmem_page_64(pfn, buf, csize, offset, userbuf);
+#endif
+}
+
+
diff --git a/arch/x86/kernel/crash_dump_32.c b/arch/x86/kernel/crash_dump_32.c
deleted file mode 100644
index d5cd139..0000000
--- a/arch/x86/kernel/crash_dump_32.c
+++ /dev/null
@@ -1,98 +0,0 @@
-/*
- *	Memory preserving reboot related code.
- *
- *	Created by: Hariprasad Nellitheertha (hari@in.ibm.com)
- *	Copyright (C) IBM Corporation, 2004. All rights reserved
- */
-
-#include <linux/slab.h>
-#include <linux/errno.h>
-#include <linux/highmem.h>
-#include <linux/crash_dump.h>
-
-#include <asm/uaccess.h>
-
-static void *kdump_buf_page;
-
-/* Stores the physical address of elf header of crash image. */
-unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
-
-static inline bool is_crashed_pfn_valid(unsigned long pfn)
-{
-#ifndef CONFIG_X86_PAE
-	/*
-	 * non-PAE kdump kernel executed from a PAE one will crop high pte
-	 * bits and poke unwanted space counting again from address 0, we
-	 * don't want that. pte must fit into unsigned long. In fact the
-	 * test checks high 12 bits for being zero (pfn will be shifted left
-	 * by PAGE_SHIFT).
-	 */
-	return pte_pfn(pfn_pte(pfn, __pgprot(0))) == pfn;
-#else
-	return true;
-#endif
-}
-
-/**
- * copy_oldmem_page - copy one page from "oldmem"
- * @pfn: page frame number to be copied
- * @buf: target memory address for the copy; this can be in kernel address
- *	space or user address space (see @userbuf)
- * @csize: number of bytes to copy
- * @offset: offset in bytes into the page (based on pfn) to begin the copy
- * @userbuf: if set, @buf is in user address space, use copy_to_user(),
- *	otherwise @buf is in kernel address space, use memcpy().
- *
- * Copy a page from "oldmem". For this page, there is no pte mapped
- * in the current kernel. We stitch up a pte, similar to kmap_atomic.
- *
- * Calling copy_to_user() in atomic context is not desirable. Hence first
- * copying the data to a pre-allocated kernel page and then copying to user
- * space in non-atomic context.
- */
-ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
-                               size_t csize, unsigned long offset, int userbuf)
-{
-	void  *vaddr;
-
-	if (!csize)
-		return 0;
-
-	if (!is_crashed_pfn_valid(pfn))
-		return -EFAULT;
-
-	vaddr = kmap_atomic_pfn(pfn);
-
-	if (!userbuf) {
-		memcpy(buf, (vaddr + offset), csize);
-		kunmap_atomic(vaddr, KM_PTE0);
-	} else {
-		if (!kdump_buf_page) {
-			printk(KERN_WARNING "Kdump: Kdump buffer page not"
-				" allocated\n");
-			kunmap_atomic(vaddr, KM_PTE0);
-			return -EFAULT;
-		}
-		copy_page(kdump_buf_page, vaddr);
-		kunmap_atomic(vaddr, KM_PTE0);
-		if (copy_to_user(buf, (kdump_buf_page + offset), csize))
-			return -EFAULT;
-	}
-
-	return csize;
-}
-
-static int __init kdump_buf_page_init(void)
-{
-	int ret = 0;
-
-	kdump_buf_page = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!kdump_buf_page) {
-		printk(KERN_WARNING "Kdump: Failed to allocate kdump buffer"
-			 " page\n");
-		ret = -ENOMEM;
-	}
-
-	return ret;
-}
-arch_initcall(kdump_buf_page_init);
diff --git a/arch/x86/kernel/crash_dump_64.c b/arch/x86/kernel/crash_dump_64.c
deleted file mode 100644
index 9948288..0000000
--- a/arch/x86/kernel/crash_dump_64.c
+++ /dev/null
@@ -1,52 +0,0 @@
-/*
- *	Memory preserving reboot related code.
- *
- *	Created by: Hariprasad Nellitheertha (hari@in.ibm.com)
- *	Copyright (C) IBM Corporation, 2004. All rights reserved
- */
-
-#include <linux/errno.h>
-#include <linux/crash_dump.h>
-#include <linux/uaccess.h>
-#include <linux/io.h>
-
-/* Stores the physical address of elf header of crash image. */
-unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
-
-/**
- * copy_oldmem_page - copy one page from "oldmem"
- * @pfn: page frame number to be copied
- * @buf: target memory address for the copy; this can be in kernel address
- *	space or user address space (see @userbuf)
- * @csize: number of bytes to copy
- * @offset: offset in bytes into the page (based on pfn) to begin the copy
- * @userbuf: if set, @buf is in user address space, use copy_to_user(),
- *	otherwise @buf is in kernel address space, use memcpy().
- *
- * Copy a page from "oldmem". For this page, there is no pte mapped
- * in the current kernel. We stitch up a pte, similar to kmap_atomic.
- */
-ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
-		size_t csize, unsigned long offset, int userbuf)
-{
-	void  *vaddr;
-
-	if (!csize)
-		return 0;
-
-	vaddr = ioremap_cache(pfn << PAGE_SHIFT, PAGE_SIZE);
-	if (!vaddr)
-		return -ENOMEM;
-
-	if (userbuf) {
-		if (copy_to_user(buf, vaddr + offset, csize)) {
-			iounmap(vaddr);
-			return -EFAULT;
-		}
-	} else
-		memcpy(buf, vaddr + offset, csize);
-
-	set_iounmap_nonlazy();
-	iounmap(vaddr);
-	return csize;
-}
-- 
1.7.3.3

