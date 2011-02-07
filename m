Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab1BGXTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 18:19:13 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:57428 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab1BGXTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 18:19:09 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 03/11] x86, 64bit, gart: Fix allocation with memblock
Date: Mon,  7 Feb 2011 15:17:04 -0800
Message-Id: <1297120632-24933-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297120632-24933-1-git-send-email-yinghai@kernel.org>
References: <1297120632-24933-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D507D91.0036,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When trying to change alloc_bootmem with memblock to go with real top-down
Found one old system:
[    0.000000] Node 0: aperture @ ac000000 size 64 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000]     memblock_x86_reserve_range: [0x2020000000-0x2023ffffff]       aperture64
[    0.000000] Cannot allocate aperture memory hole (ffff882020000000,65536K)
[    0.000000]        memblock_x86_free_range: [0x2020000000-0x2023ffffff]
[    0.000000] Kernel panic - not syncing: Not enough memory for aperture
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.37-rc5-tip-yh-06229-gb792dc2-dirty #331
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81cf50fe>] ? panic+0x91/0x1a3
[    0.000000]  [<ffffffff827c66b2>] ? gart_iommu_hole_init+0x3d7/0x4a3
[    0.000000]  [<ffffffff81d026a9>] ? _etext+0x0/0x3
[    0.000000]  [<ffffffff827ba940>] ? pci_iommu_alloc+0x47/0x71
[    0.000000]  [<ffffffff827c820b>] ? mem_init+0x19/0xec
[    0.000000]  [<ffffffff827b3c40>] ? start_kernel+0x20a/0x3e8
[    0.000000]  [<ffffffff827b32cc>] ? x86_64_start_reservations+0x9c/0xa0
[    0.000000]  [<ffffffff827b33e4>] ? x86_64_start_kernel+0x114/0x11b

it means __alloc_bootmem_nopanic() get too high for that aperture.

Use memblock_find_in_range() with limit directly.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/aperture_64.c |   33 ++++++++++++++++-----------------
 1 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 5955a78..7b1e8e1 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -13,7 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/init.h>
-#include <linux/bootmem.h>
+#include <linux/memblock.h>
 #include <linux/mmzone.h>
 #include <linux/pci_ids.h>
 #include <linux/pci.h>
@@ -57,7 +57,7 @@ static void __init insert_aperture_resource(u32 aper_base, u32 aper_size)
 static u32 __init allocate_aperture(void)
 {
 	u32 aper_size;
-	void *p;
+	unsigned long addr;
 
 	/* aper_size should <= 1G */
 	if (fallback_aper_order > 5)
@@ -83,27 +83,26 @@ static u32 __init allocate_aperture(void)
 	 * so don't use 512M below as gart iommu, leave the space for kernel
 	 * code for safe
 	 */
-	p = __alloc_bootmem_nopanic(aper_size, aper_size, 512ULL<<20);
+	addr = memblock_find_in_range(0, 1ULL<<32, aper_size, 512ULL<<20);
+	if (addr == MEMBLOCK_ERROR || addr + aper_size > 0xffffffff) {
+		printk(KERN_ERR
+			"Cannot allocate aperture memory hole (%lx,%uK)\n",
+				addr, aper_size>>10);
+		return 0;
+	}
+	memblock_x86_reserve_range(addr, addr + aper_size, "aperture64");
 	/*
 	 * Kmemleak should not scan this block as it may not be mapped via the
 	 * kernel direct mapping.
 	 */
-	kmemleak_ignore(p);
-	if (!p || __pa(p)+aper_size > 0xffffffff) {
-		printk(KERN_ERR
-			"Cannot allocate aperture memory hole (%p,%uK)\n",
-				p, aper_size>>10);
-		if (p)
-			free_bootmem(__pa(p), aper_size);
-		return 0;
-	}
+	kmemleak_ignore(phys_to_virt(addr));
 	printk(KERN_INFO "Mapping aperture over %d KB of RAM @ %lx\n",
-			aper_size >> 10, __pa(p));
-	insert_aperture_resource((u32)__pa(p), aper_size);
-	register_nosave_region((u32)__pa(p) >> PAGE_SHIFT,
-				(u32)__pa(p+aper_size) >> PAGE_SHIFT);
+			aper_size >> 10, addr);
+	insert_aperture_resource((u32)addr, aper_size);
+	register_nosave_region(addr >> PAGE_SHIFT,
+			       (addr+aper_size) >> PAGE_SHIFT);
 
-	return (u32)__pa(p);
+	return (u32)addr;
 }
 
 
-- 
1.7.1

