Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab1EZCSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 22:18:48 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44457 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757349Ab1EZCSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 22:18:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=X4iuZM/0zLC40Vb+NuETXq8uBKiEAOlaq8ndcvCxSsIQjQmNFwLbdthC1S25yv7N2C
         +tM6ee5TGvWhSnUF8q+d23zVgaNfBFg0Sg+pBQyCeRbBLzDxFsxcbDl0JHppP+BBQ0Qq
         SwcfUmpOAY5q6n8hFeAqhyBiw61a2Ucr3IIGg=
From: Dave Carroll <dtcarroll@gmail.com>
To: Milton Miller <miltonm@bga.com>
Cc: LPPC <linuxppc-dev@lists.ozlabs.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Carroll <dcarroll@astekcorp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH v6] powerpc: Force page alignment for initrd reserved memory
Date: Wed, 25 May 2011 20:00:14 -0600
Message-Id: <1306375214-12007-1-git-send-email-dcarroll@astekcorp.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <initrd-align-v5-reply@mdm.bga.com>
References: <initrd-align-v5-reply@mdm.bga.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Carroll <dcarroll@astekcorp.com>

When using 64K pages with a separate cpio rootfs, U-Boot will align
the rootfs on a 4K page boundary. When the memory is reserved, and
subsequent early memblock_alloc is called, it will allocate memory
between the 64K page alignment and reserved memory. When the reserved
memory is subsequently freed, it is done so by pages, causing the
early memblock_alloc requests to be re-used, which in my case, caused
the device-tree to be clobbered.

This patch forces the reserved memory for initrd to be kernel page
aligned, and will move the device tree if it overlaps with the range
extension of initrd. This patch will also consolidate the identical
function free_initrd_mem() from mm/init_32.c, init_64.c to mm/mem.c,
and adds the same range extension when freeing initrd.

Many thanks to Milton Miller for his input on this patch.

Signed-off-by: Dave Carroll <dcarroll@astekcorp.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>

---
 arch/powerpc/kernel/prom.c |   21 ++++++++++++++++++---
 arch/powerpc/mm/init_32.c  |   15 ---------------
 arch/powerpc/mm/init_64.c  |   13 -------------
 arch/powerpc/mm/mem.c      |   19 +++++++++++++++++++
 4 files changed, 37 insertions(+), 31 deletions(-)

diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 48aeb55..86966a0 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -81,12 +81,24 @@ static int __init early_parse_mem(char *p)
 	return 0;
 }
 early_param("mem", early_parse_mem);
+/**
+ * overlaps_initrd - check for overlap with page aligned extension of
+ * initrd.
+ */
+static inline int overlaps_initrd(unsigned long start, unsigned long end)
+{
+	if (!initrd_start)
+		return 0;
 
+	return	(start + size) > _ALIGN_DOWN(initrd_start, PAGE_SIZE) &&
+			start <= _ALIGN_UP(initrd_end, PAGE_SIZE);
+}
 /**
  * move_device_tree - move tree to an unused area, if needed.
  *
  * The device tree may be allocated beyond our memory limit, or inside the
- * crash kernel region for kdump. If so, move it out of the way.
+ * crash kernel region for kdump, or within the page aligned range of initrd.
+ * If so, move it out of the way.
  */
 static void __init move_device_tree(void)
 {
@@ -99,7 +111,8 @@ static void __init move_device_tree(void)
 	size = be32_to_cpu(initial_boot_params->totalsize);
 
 	if ((memory_limit && (start + size) > PHYSICAL_START + memory_limit) ||
-			overlaps_crashkernel(start, size)) {
+			overlaps_crashkernel(start, size) ||
+			overlaps_initrd(start, size) {
 		p = __va(memblock_alloc(size, PAGE_SIZE));
 		memcpy(p, initial_boot_params, size);
 		initial_boot_params = (struct boot_param_header *)p;
@@ -555,7 +568,9 @@ static void __init early_reserve_mem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* then reserve the initrd, if any */
 	if (initrd_start && (initrd_end > initrd_start))
-		memblock_reserve(__pa(initrd_start), initrd_end - initrd_start);
+		memblock_reserve(_ALIGN_DOWN(__pa(initrd_start), PAGE_SIZE),
+			_ALIGN_UP(initrd_end, PAGE_SIZE) -
+			_ALIGN_DOWN(initrd_start, PAGE_SIZE));
 #endif /* CONFIG_BLK_DEV_INITRD */
 
 #ifdef CONFIG_PPC32
diff --git a/arch/powerpc/mm/init_32.c b/arch/powerpc/mm/init_32.c
index d65b591..5de0f25 100644
--- a/arch/powerpc/mm/init_32.c
+++ b/arch/powerpc/mm/init_32.c
@@ -223,21 +223,6 @@ void free_initmem(void)
 #undef FREESEC
 }
 
-#ifdef CONFIG_BLK_DEV_INITRD
-void free_initrd_mem(unsigned long start, unsigned long end)
-{
-	if (start < end)
-		printk ("Freeing initrd memory: %ldk freed\n", (end - start) >> 10);
-	for (; start < end; start += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(start));
-		init_page_count(virt_to_page(start));
-		free_page(start);
-		totalram_pages++;
-	}
-}
-#endif
-
-
 #ifdef CONFIG_8xx /* No 8xx specific .c file to put that in ... */
 void setup_initial_memory_limit(phys_addr_t first_memblock_base,
 				phys_addr_t first_memblock_size)
diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index 6374b21..7591a97 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -99,19 +99,6 @@ void free_initmem(void)
 		((unsigned long)__init_end - (unsigned long)__init_begin) >> 10);
 }
 
-#ifdef CONFIG_BLK_DEV_INITRD
-void free_initrd_mem(unsigned long start, unsigned long end)
-{
-	if (start < end)
-		printk ("Freeing initrd memory: %ldk freed\n", (end - start) >> 10);
-	for (; start < end; start += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(start));
-		init_page_count(virt_to_page(start));
-		free_page(start);
-		totalram_pages++;
-	}
-}
-#endif
 
 static void pgd_ctor(void *addr)
 {
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 57e545b..f60e44e 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -160,6 +160,25 @@ walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
 }
 EXPORT_SYMBOL_GPL(walk_system_ram_range);
 
+#ifdef CONFIG_BLK_DEV_INITRD
+void free_initrd_mem(unsigned long start, unsigned long end)
+{
+	if (start >= end)
+		return;
+
+	start = _ALIGN_DOWN(start, PAGE_SIZE);
+	end = _ALIGN_UP(end, PAGE_SIZE);
+	printk(KERN_INFO "Freeing initrd memory: %ldk freed\n",
+			(end - start) >> 10);
+	for (; start < end; start += PAGE_SIZE) {
+		ClearPageReserved(virt_to_page(start));
+		init_page_count(virt_to_page(start));
+		free_page(start);
+		totalram_pages++;
+	}
+}
+#endif
+
 /*
  * Initialize the bootmem system and give it all the memory we
  * have available.  If we are using highmem, we only put the
-- 
1.7.4

