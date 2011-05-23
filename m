Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850Ab1EWWyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:54:43 -0400
Received: from 173-160-34-133-colorado.hfc.comcastbusiness.net ([173.160.34.133]:56862
	"EHLO ether.astekcorp.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755210Ab1EWWyj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:54:39 -0400
From: Dave Carroll <dcarroll@astekcorp.com>
To: "'Milton Miller'" <miltonm@bga.com>
CC: LPPC <linuxppc-dev@lists.ozlabs.org>, Paul Mackerras <paulus@samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Mon, 23 May 2011 16:54:25 -0600
Subject: [PATCH  v5] powerpc: Force page alignment for initrd reserved memory
Thread-Topic: [PATCH  v5] powerpc: Force page alignment for initrd reserved
 memory
Thread-Index: AcwZcFh+5VZUVdjdQa+TutYV+wnzbAAKYEnQ
Message-ID: <522F24EF533FC546962ECFA2054FF777373072AB79@MAILSERVER2.cos.astekcorp.com>
In-Reply-To: <initrd-align-withdrawn@mdm.bga.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using 64K pages with a separate cpio rootfs, U-Boot will align
the rootfs on a 4K page boundary. When the memory is reserved, and
subsequent early memblock_alloc is called, it will allocate memory
between the 64K page alignment and reserved memory. When the reserved
memory is subsequently freed, it is done so by pages, causing the
early memblock_alloc requests to be re-used, which in my case, caused
the device-tree to be clobbered.

This patch forces the reserved memory for initrd to be kernel page
aligned, and adds the same range extension when freeing initrd. It
will also move the device tree if it overlaps with the reserved memory
for initrd.

Many thanks to Milton Miller for his input on this patch.

Signed-off-by: Dave Carroll <dcarroll@astekcorp.com>
---
 * This patch is based on Linus' current tree

 arch/powerpc/kernel/prom.c |   11 ++++++++---
 arch/powerpc/mm/init_32.c  |    5 ++++-
 arch/powerpc/mm/init_64.c  |    5 ++++-
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 48aeb55..58871df 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -86,7 +86,8 @@ early_param("mem", early_parse_mem);
  * move_device_tree - move tree to an unused area, if needed.
  *
  * The device tree may be allocated beyond our memory limit, or inside the
- * crash kernel region for kdump. If so, move it out of the way.
+ * crash kernel region for kdump, or within the page aligned range of initrd.
+ * If so, move it out of the way.
  */
 static void __init move_device_tree(void)
 {
@@ -99,7 +100,9 @@ static void __init move_device_tree(void)
        size = be32_to_cpu(initial_boot_params->totalsize);

        if ((memory_limit && (start + size) > PHYSICAL_START + memory_limit) ||
-                       overlaps_crashkernel(start, size)) {
+                       overlaps_crashkernel(start, size) ||
+                       ((start + size) > _ALIGN_DOWN(initrd_start, PAGE_SIZE)
+                       && start <= _ALIGN_UP(initrd_end, PAGE_SIZE))) {
                p = __va(memblock_alloc(size, PAGE_SIZE));
                memcpy(p, initial_boot_params, size);
                initial_boot_params = (struct boot_param_header *)p;
@@ -555,7 +558,9 @@ static void __init early_reserve_mem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
        /* then reserve the initrd, if any */
        if (initrd_start && (initrd_end > initrd_start))
-               memblock_reserve(__pa(initrd_start), initrd_end - initrd_start);
+               memblock_reserve(_ALIGN_DOWN(__pa(initrd_start), PAGE_SIZE),
+                       _ALIGN_UP(initrd_end, PAGE_SIZE) -
+                       _ALIGN_DOWN(initrd_start, PAGE_SIZE));
 #endif /* CONFIG_BLK_DEV_INITRD */

 #ifdef CONFIG_PPC32
diff --git a/arch/powerpc/mm/init_32.c b/arch/powerpc/mm/init_32.c
index d65b591..4835c4f 100644
--- a/arch/powerpc/mm/init_32.c
+++ b/arch/powerpc/mm/init_32.c
@@ -226,8 +226,11 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-       if (start < end)
+       if (start < end) {
+               start = _ALIGN_DOWN(start, PAGE_SIZE);
+               end = _ALIGN_UP(end, PAGE_SIZE);
                printk ("Freeing initrd memory: %ldk freed\n", (end - start) >> 10);
+       }
        for (; start < end; start += PAGE_SIZE) {
                ClearPageReserved(virt_to_page(start));
                init_page_count(virt_to_page(start));
diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index 6374b21..060c952 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -102,8 +102,11 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-       if (start < end)
+       if (start < end) {
+               start = _ALIGN_DOWN(start, PAGE_SIZE);
+               end = _ALIGN_UP(end, PAGE_SIZE);
                printk ("Freeing initrd memory: %ldk freed\n", (end - start) >> 10);
+       }
        for (; start < end; start += PAGE_SIZE) {
                ClearPageReserved(virt_to_page(start));
                init_page_count(virt_to_page(start));
--
1.7.4


