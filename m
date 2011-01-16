Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689Ab1APFsN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 00:48:13 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33766 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab1APFsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 00:48:12 -0500
Subject: [PATCH] dt/flattree: Return virtual address from
	early_init_dt_alloc_memory_arch()
To: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 15 Jan 2011 22:48:09 -0700
Message-ID: <20110116054809.2966.67560.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The physical address is never used by the device tree code when
allocating memory for unflattening.  Change the architecture's alloc
hook to return the virutal address instead.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/microblaze/kernel/prom.c |    4 ++--
 arch/mips/kernel/prom.c       |    6 ++----
 arch/powerpc/kernel/prom.c    |    4 ++--
 drivers/of/fdt.c              |    8 +-------
 include/linux/of_fdt.h        |    2 +-
 5 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
index c881393..bceaa55 100644
--- a/arch/microblaze/kernel/prom.c
+++ b/arch/microblaze/kernel/prom.c
@@ -47,9 +47,9 @@ void __init early_init_dt_add_memory_arch(u64 base, u64 size)
 	memblock_add(base, size);
 }
 
-u64 __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
+void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 {
-	return memblock_alloc(size, align);
+	return __va(memblock_alloc(size, align));
 }
 
 #ifdef CONFIG_EARLY_PRINTK
diff --git a/arch/mips/kernel/prom.c b/arch/mips/kernel/prom.c
index 9dbe583..a19811e 100644
--- a/arch/mips/kernel/prom.c
+++ b/arch/mips/kernel/prom.c
@@ -45,11 +45,9 @@ void __init free_mem_mach(unsigned long addr, unsigned long size)
 	return free_bootmem(addr, size);
 }
 
-u64 __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
+void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 {
-	return virt_to_phys(
-		__alloc_bootmem(size, align, __pa(MAX_DMA_ADDRESS))
-		);
+	return __alloc_bootmem(size, align, __pa(MAX_DMA_ADDRESS));
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 9e3132d..7185f0d 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -519,9 +519,9 @@ void __init early_init_dt_add_memory_arch(u64 base, u64 size)
 	memblock_add(base, size);
 }
 
-u64 __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
+void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 {
-	return memblock_alloc(size, align);
+	return __va(memblock_alloc(size, align));
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index c787c3d..af824e7 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -692,12 +692,6 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
 	return 1;
 }
 
-static void *__init early_device_tree_alloc(u64 size, u64 align)
-{
-	unsigned long mem = early_init_dt_alloc_memory_arch(size, align);
-	return __va(mem);
-}
-
 /**
  * unflatten_device_tree - create tree of device_nodes from flat blob
  *
@@ -709,7 +703,7 @@ static void *__init early_device_tree_alloc(u64 size, u64 align)
 void __init unflatten_device_tree(void)
 {
 	__unflatten_device_tree(initial_boot_params, &allnodes,
-				early_device_tree_alloc);
+				early_init_dt_alloc_memory_arch);
 
 	/* Get pointer to OF "/chosen" node for use everywhere */
 	of_chosen = of_find_node_by_path("/chosen");
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index 0ef22a1..c84d900 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -97,7 +97,7 @@ extern void early_init_dt_check_for_initrd(unsigned long node);
 extern int early_init_dt_scan_memory(unsigned long node, const char *uname,
 				     int depth, void *data);
 extern void early_init_dt_add_memory_arch(u64 base, u64 size);
-extern u64 early_init_dt_alloc_memory_arch(u64 size, u64 align);
+extern void * early_init_dt_alloc_memory_arch(u64 size, u64 align);
 extern u64 dt_mem_next_cell(int s, __be32 **cellp);
 
 /*

