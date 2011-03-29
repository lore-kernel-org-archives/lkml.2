Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab1C2OiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:38:13 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:53205 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab1C2OiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:38:12 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "Paul Mundt" <lethal@linux-sh.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "'Guan Xuetao'" <gxt@mprc.pku.edu.cn>,
        <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>
Subject: [PATCH] unicore32 framebuffer driver fix: make videomemory kmalloc-ed and floatable
Date: Tue, 29 Mar 2011 22:37:02 +0800
Message-ID: <019701cbee1e$c4e2d260$4ea87720$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcvuHnRC8rOoW1BASZGW/2GdqROH3w==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1. make videomemory kmalloc-ed in fb-puv3.c
2. remove resource reservation for old fixed UNIGFX_MMAP & UVC_MMAP space
3. remove unused PKUNTIY_UNIGFX_MMAP_BASE, PKUNITY_UNIGFX_MMAP_SIZE,
	PKUNITY_UVC_MMAP_BASE, PKUNITY_UVC_MMAP_SIZE and KUSER_UNIGFX_BASE
4. remove unused header linux/vmalloc.h in fb-puv3.c

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/include/mach/PKUnity.h |   10 ----------
 arch/unicore32/include/mach/memory.h  |    1 -
 arch/unicore32/kernel/puv3-core.c     |    5 -----
 arch/unicore32/kernel/setup.c         |   15 ++-------------
 arch/unicore32/mm/mmu.c               |   20 --------------------
 drivers/video/fb-puv3.c               |   27 ++++++++++++++++-----------
 6 files changed, 18 insertions(+), 60 deletions(-)

diff --git a/arch/unicore32/include/mach/PKUnity.h b/arch/unicore32/include/mach/PKUnity.h
index a18bdc3..8040d57 100644
--- a/arch/unicore32/include/mach/PKUnity.h
+++ b/arch/unicore32/include/mach/PKUnity.h
@@ -24,16 +24,6 @@
 #define PKUNITY_MMIO_BASE		0x80000000 /* 0x80000000 - 0xFFFFFFFF 2GB */
 
 /*
- * PKUNITY Memory Map Addresses: 0x0D000000 - 0x0EFFFFFF (32MB)
- *	0x0D000000 - 0x0DFFFFFF 16MB: for UVC
- *	0x0E000000 - 0x0EFFFFFF 16MB: for UNIGFX
- */
-#define PKUNITY_UVC_MMAP_BASE		0x0D000000
-#define PKUNITY_UVC_MMAP_SIZE		0x01000000 /* 16MB */
-#define PKUNITY_UNIGFX_MMAP_BASE        0x0E000000
-#define PKUNITY_UNIGFX_MMAP_SIZE        0x01000000 /* 16MB */
-
-/*
  * PKUNITY System Bus Addresses (PCI): 0x80000000 - 0xBFFFFFFF (1GB)
  * 0x80000000 - 0x8000000B 12B    PCI Configuration regs
  * 0x80010000 - 0x80010250 592B   PCI Bridge Base
diff --git a/arch/unicore32/include/mach/memory.h b/arch/unicore32/include/mach/memory.h
index 0bf21c9..4be72c2 100644
--- a/arch/unicore32/include/mach/memory.h
+++ b/arch/unicore32/include/mach/memory.h
@@ -50,7 +50,6 @@ void puv3_pci_adjust_zones(unsigned long *size, unsigned long *holes);
 
 /* kuser area */
 #define KUSER_VECPAGE_BASE	(KUSER_BASE + UL(0x3fff0000))
-#define KUSER_UNIGFX_BASE	(PAGE_OFFSET + PKUNITY_UNIGFX_MMAP_BASE)
 /* kuser_vecpage (0xbfff0000) is ro, and vectors page (0xffff0000) is rw */
 #define kuser_vecpage_to_vectors(x)	((x) - (KUSER_VECPAGE_BASE)	\
 					+ (VECTORS_BASE))
diff --git a/arch/unicore32/kernel/puv3-core.c b/arch/unicore32/kernel/puv3-core.c
index 8b1b6be..1a505a7 100644
--- a/arch/unicore32/kernel/puv3-core.c
+++ b/arch/unicore32/kernel/puv3-core.c
@@ -99,11 +99,6 @@ static struct resource puv3_unigfx_resources[] = {
 		.end	= io_v2p(PKUNITY_UNIGFX_BASE) + 0xfff,
 		.flags	= IORESOURCE_MEM,
 	},
-	[1] = {
-		.start	= PKUNITY_UNIGFX_MMAP_BASE,
-		.end	= PKUNITY_UNIGFX_MMAP_BASE + PKUNITY_UNIGFX_MMAP_SIZE,
-		.flags	= IORESOURCE_MEM,
-	},
 };
 
 static struct resource puv3_rtc_resources[] = {
diff --git a/arch/unicore32/kernel/setup.c b/arch/unicore32/kernel/setup.c
index 1e175a8..471b6bc 100644
--- a/arch/unicore32/kernel/setup.c
+++ b/arch/unicore32/kernel/setup.c
@@ -64,12 +64,6 @@ static char default_command_line[COMMAND_LINE_SIZE] __initdata = CONFIG_CMDLINE;
  */
 static struct resource mem_res[] = {
 	{
-		.name = "Video RAM",
-		.start = 0,
-		.end = 0,
-		.flags = IORESOURCE_MEM
-	},
-	{
 		.name = "Kernel text",
 		.start = 0,
 		.end = 0,
@@ -83,9 +77,8 @@ static struct resource mem_res[] = {
 	}
 };
 
-#define video_ram   mem_res[0]
-#define kernel_code mem_res[1]
-#define kernel_data mem_res[2]
+#define kernel_code mem_res[0]
+#define kernel_data mem_res[1]
 
 /*
  * These functions re-use the assembly code in head.S, which
@@ -224,10 +217,6 @@ request_standard_resources(struct meminfo *mi)
 		    kernel_data.end <= res->end)
 			request_resource(res, &kernel_data);
 	}
-
-	video_ram.start = PKUNITY_UNIGFX_MMAP_BASE;
-	video_ram.end   = PKUNITY_UNIGFX_MMAP_BASE + PKUNITY_UNIGFX_MMAP_SIZE;
-	request_resource(&iomem_resource, &video_ram);
 }
 
 static void (*init_machine)(void) __initdata;
diff --git a/arch/unicore32/mm/mmu.c b/arch/unicore32/mm/mmu.c
index 7bf3d58..db2d334 100644
--- a/arch/unicore32/mm/mmu.c
+++ b/arch/unicore32/mm/mmu.c
@@ -338,15 +338,6 @@ void __init uc32_mm_memblock_reserve(void)
 	 * and can only be in node 0.
 	 */
 	memblock_reserve(__pa(swapper_pg_dir), PTRS_PER_PGD * sizeof(pgd_t));
-
-#ifdef CONFIG_PUV3_UNIGFX
-	/*
-	 * These should likewise go elsewhere.  They pre-reserve the
-	 * screen/video memory region at the 48M~64M of main system memory.
-	 */
-	memblock_reserve(PKUNITY_UNIGFX_MMAP_BASE, PKUNITY_UNIGFX_MMAP_SIZE);
-	memblock_reserve(PKUNITY_UVC_MMAP_BASE, PKUNITY_UVC_MMAP_SIZE);
-#endif
 }
 
 /*
@@ -371,17 +362,6 @@ static void __init devicemaps_init(void)
 		pmd_clear(pmd_off_k(addr));
 
 	/*
-	 * Create a mapping for UniGFX VRAM
-	 */
-#ifdef CONFIG_PUV3_UNIGFX
-	map.pfn = __phys_to_pfn(PKUNITY_UNIGFX_MMAP_BASE);
-	map.virtual = KUSER_UNIGFX_BASE;
-	map.length = PKUNITY_UNIGFX_MMAP_SIZE;
-	map.type = MT_KUSER;
-	create_mapping(&map);
-#endif
-
-	/*
 	 * Create a mapping for the machine vectors at the high-vectors
 	 * location (0xffff0000).  If we aren't using high-vectors, also
 	 * create a mapping at the low-vectors virtual address.
diff --git a/drivers/video/fb-puv3.c b/drivers/video/fb-puv3.c
index dbd2dc4..286e295 100644
--- a/drivers/video/fb-puv3.c
+++ b/drivers/video/fb-puv3.c
@@ -13,7 +13,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#include <linux/vmalloc.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/fb.h>
@@ -531,7 +530,7 @@ static int unifb_set_par(struct fb_info *info)
 		return -EINVAL;
 	}
 
-	writel(PKUNITY_UNIGFX_MMAP_BASE, UDE_FSA);
+	writel(info->fix.smem_start, UDE_FSA);
 	writel(info->var.yres, UDE_LS);
 	writel(get_line_length(info->var.xres,
 			info->var.bits_per_pixel) >> 3, UDE_PS);
@@ -680,13 +679,26 @@ static int unifb_probe(struct platform_device *dev)
 	struct fb_info *info;
 	u32 unifb_regs[UNIFB_REGS_NUM];
 	int retval = -ENOMEM;
-	struct resource *iomem, *mapmem;
+	struct resource *iomem;
+	void *videomemory;
+
+	videomemory = kmalloc(UNIFB_MEMSIZE, GFP_KERNEL);
+	if (!videomemory)
+		goto err;
+
+	memset(videomemory, 0, UNIFB_MEMSIZE);
+
+	unifb_fix.smem_start = virt_to_phys(videomemory);
+	unifb_fix.smem_len = UNIFB_MEMSIZE;
+
+	iomem = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	unifb_fix.mmio_start = iomem->start;
 
 	info = framebuffer_alloc(sizeof(u32)*256, &dev->dev);
 	if (!info)
 		goto err;
 
-	info->screen_base = (char __iomem *)KUSER_UNIGFX_BASE;
+	info->screen_base = (char __iomem *)videomemory;
 	info->fbops = &unifb_ops;
 
 	retval = fb_find_mode(&info->var, info, NULL,
@@ -695,13 +707,6 @@ static int unifb_probe(struct platform_device *dev)
 	if (!retval || (retval == 4))
 		info->var = unifb_default;
 
-	iomem = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	unifb_fix.mmio_start = iomem->start;
-
-	mapmem = platform_get_resource(dev, IORESOURCE_MEM, 1);
-	unifb_fix.smem_start = mapmem->start;
-	unifb_fix.smem_len = UNIFB_MEMSIZE;
-
 	info->fix = unifb_fix;
 	info->pseudo_palette = info->par;
 	info->par = NULL;
-- 
1.6.2.2


