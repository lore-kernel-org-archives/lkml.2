Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218Ab2ILQEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:04:41 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58323 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab2ILQEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:04:39 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-ia64@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-sh@vger.kernel.org>
CC: <arnd@arndb.de>, <dhowells@redhat.com>, <fenghua.yu@intel.com>,
        <gregkh@linuxfoundation.org>, <lethal@linux-sh.org>,
        <linux@arm.linux.org.uk>, <nico@linaro.org>, <rob.herring@calxeda.com>,
        <tony.luck@intel.com>, <tony@atomide.com>, <will.deacon@arm.com>,
        Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH] /dev/mem: use phys_addr_t for physical addresses
Date: Wed, 12 Sep 2012 12:04:06 -0400
Message-ID: <1347465846-6844-1-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the /dev/mem driver to use phys_addr_t for physical
addresses.  This is required on PAE systems, especially those that run
entirely out of >4G physical memory space.
---
 arch/arm/include/asm/io.h  |    2 +-
 arch/arm/mm/mmap.c         |    2 +-
 arch/ia64/include/asm/io.h |    2 +-
 arch/ia64/kernel/efi.c     |    2 +-
 arch/sh/include/asm/io.h   |    2 +-
 arch/sh/mm/mmap.c          |    2 +-
 drivers/char/mem.c         |   10 +++++-----
 7 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index 35c1ed8..f52a93d 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -374,7 +374,7 @@ extern void pci_iounmap(struct pci_dev *dev, void __iomem *addr);
 
 #ifdef CONFIG_MMU
 #define ARCH_HAS_VALID_PHYS_ADDR_RANGE
-extern int valid_phys_addr_range(unsigned long addr, size_t size);
+extern int valid_phys_addr_range(phys_addr_t addr, size_t size);
 extern int valid_mmap_phys_addr_range(unsigned long pfn, size_t size);
 extern int devmem_is_allowed(unsigned long pfn);
 #endif
diff --git a/arch/arm/mm/mmap.c b/arch/arm/mm/mmap.c
index ce8cb19..89f2b7f 100644
--- a/arch/arm/mm/mmap.c
+++ b/arch/arm/mm/mmap.c
@@ -279,7 +279,7 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
  * You really shouldn't be using read() or write() on /dev/mem.  This
  * might go away in the future.
  */
-int valid_phys_addr_range(unsigned long addr, size_t size)
+int valid_phys_addr_range(phys_addr_t addr, size_t size)
 {
 	if (addr < PHYS_OFFSET)
 		return 0;
diff --git a/arch/ia64/include/asm/io.h b/arch/ia64/include/asm/io.h
index 2c26321..74a7cc3 100644
--- a/arch/ia64/include/asm/io.h
+++ b/arch/ia64/include/asm/io.h
@@ -90,7 +90,7 @@ phys_to_virt (unsigned long address)
 
 #define ARCH_HAS_VALID_PHYS_ADDR_RANGE
 extern u64 kern_mem_attribute (unsigned long phys_addr, unsigned long size);
-extern int valid_phys_addr_range (unsigned long addr, size_t count); /* efi.c */
+extern int valid_phys_addr_range (phys_addr_t addr, size_t count); /* efi.c */
 extern int valid_mmap_phys_addr_range (unsigned long pfn, size_t count);
 
 /*
diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
index d37bbd4..f034563 100644
--- a/arch/ia64/kernel/efi.c
+++ b/arch/ia64/kernel/efi.c
@@ -870,7 +870,7 @@ kern_mem_attribute (unsigned long phys_addr, unsigned long size)
 EXPORT_SYMBOL(kern_mem_attribute);
 
 int
-valid_phys_addr_range (unsigned long phys_addr, unsigned long size)
+valid_phys_addr_range (phys_addr_t phys_addr, unsigned long size)
 {
 	u64 attr;
 
diff --git a/arch/sh/include/asm/io.h b/arch/sh/include/asm/io.h
index 0cf60a6..c4302a5 100644
--- a/arch/sh/include/asm/io.h
+++ b/arch/sh/include/asm/io.h
@@ -382,7 +382,7 @@ static inline int iounmap_fixed(void __iomem *addr) { return -EINVAL; }
 #define xlate_dev_kmem_ptr(p)	p
 
 #define ARCH_HAS_VALID_PHYS_ADDR_RANGE
-int valid_phys_addr_range(unsigned long addr, size_t size);
+int valid_phys_addr_range(phys_addr_t addr, size_t size);
 int valid_mmap_phys_addr_range(unsigned long pfn, size_t size);
 
 #endif /* __KERNEL__ */
diff --git a/arch/sh/mm/mmap.c b/arch/sh/mm/mmap.c
index afeb710..80bf494 100644
--- a/arch/sh/mm/mmap.c
+++ b/arch/sh/mm/mmap.c
@@ -238,7 +238,7 @@ bottomup:
  * You really shouldn't be using read() or write() on /dev/mem.  This
  * might go away in the future.
  */
-int valid_phys_addr_range(unsigned long addr, size_t count)
+int valid_phys_addr_range(phys_addr_t addr, size_t count)
 {
 	if (addr < __MEMORY_START)
 		return 0;
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 0537903..c6fa3bc 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -48,7 +48,7 @@ static inline unsigned long size_inside_page(unsigned long start,
 }
 
 #ifndef ARCH_HAS_VALID_PHYS_ADDR_RANGE
-static inline int valid_phys_addr_range(unsigned long addr, size_t count)
+static inline int valid_phys_addr_range(phys_addr_t addr, size_t count)
 {
 	return addr + count <= __pa(high_memory);
 }
@@ -96,7 +96,7 @@ void __weak unxlate_dev_mem_ptr(unsigned long phys, void *addr)
 static ssize_t read_mem(struct file *file, char __user *buf,
 			size_t count, loff_t *ppos)
 {
-	unsigned long p = *ppos;
+	phys_addr_t p = *ppos;
 	ssize_t read, sz;
 	char *ptr;
 
@@ -153,7 +153,7 @@ static ssize_t read_mem(struct file *file, char __user *buf,
 static ssize_t write_mem(struct file *file, const char __user *buf,
 			 size_t count, loff_t *ppos)
 {
-	unsigned long p = *ppos;
+	phys_addr_t p = *ppos;
 	ssize_t written, sz;
 	unsigned long copied;
 	void *ptr;
@@ -226,7 +226,7 @@ int __weak phys_mem_access_prot_allowed(struct file *file,
  *
  */
 #ifdef pgprot_noncached
-static int uncached_access(struct file *file, unsigned long addr)
+static int uncached_access(struct file *file, phys_addr_t addr)
 {
 #if defined(CONFIG_IA64)
 	/*
@@ -258,7 +258,7 @@ static pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 				     unsigned long size, pgprot_t vma_prot)
 {
 #ifdef pgprot_noncached
-	unsigned long offset = pfn << PAGE_SHIFT;
+	phys_addr_t offset = pfn << PAGE_SHIFT;
 
 	if (uncached_access(file, offset))
 		return pgprot_noncached(vma_prot);
-- 
1.7.9.5

