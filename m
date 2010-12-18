Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab0LRA7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 19:59:33 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:40237 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381Ab0LRA7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 19:59:31 -0500
Message-ID: <4D0C0740.90104@kernel.org>
Date: Fri, 17 Dec 2010 16:58:40 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 2/3] x86, 64bit, gart: Fix allocation with memblock
References: <4D0C0336.9010009@kernel.org>
In-Reply-To: <4D0C0336.9010009@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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
 1 file changed, 16 insertions(+), 17 deletions(-)

Index: linux-2.6/arch/x86/kernel/aperture_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/aperture_64.c
+++ linux-2.6/arch/x86/kernel/aperture_64.c
@@ -13,7 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/init.h>
-#include <linux/bootmem.h>
+#include <linux/memblock.h>
 #include <linux/mmzone.h>
 #include <linux/pci_ids.h>
 #include <linux/pci.h>
@@ -69,7 +69,7 @@ static void __init insert_aperture_resou
 static u32 __init allocate_aperture(void)
 {
 	u32 aper_size;
-	void *p;
+	unsigned long addr;
 
 	/* aper_size should <= 1G */
 	if (fallback_aper_order > 5)
@@ -95,27 +95,26 @@ static u32 __init allocate_aperture(void
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
 
 
