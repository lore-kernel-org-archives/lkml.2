Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab1EWCb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 22:31:27 -0400
Received: from 173-160-34-133-colorado.hfc.comcastbusiness.net ([173.160.34.133]:18975
	"EHLO ether.astekcorp.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754670Ab1EWCb0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 22:31:26 -0400
From: Dave Carroll <dcarroll@astekcorp.com>
To: "'Milton Miller'" <miltonm@bga.com>
CC: Paul Mackerras <paulus@samba.org>, LPPC <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Sun, 22 May 2011 20:31:11 -0600
Subject: [PATCH v4] powerpc: Force page alignment for initrd reserved memory
Thread-Topic: [PATCH v4] powerpc: Force page alignment for initrd reserved
 memory
Thread-Index: AcwYxbbt15MAeWseSJm2zlfSwRRrGAAKbciA
Message-ID: <522F24EF533FC546962ECFA2054FF777373072AB75@MAILSERVER2.cos.astekcorp.com>
In-Reply-To: <initrd-reserve-reply2@mdm.bga.com>
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
aligned, and adds the same range extension when freeing initrd.

Signed-off-by: Dave Carroll <dcarroll@astekcorp.com>
---

* I think this handles Milton's concerns with the exception of
  a packed FDT next to initrd with mismatched page sizes. That
  would require coordination with the bootloader.

 arch/powerpc/kernel/prom.c |    4 +++-
 arch/powerpc/mm/init_32.c  |   15 +++++++++------
 arch/powerpc/mm/init_64.c  |   15 +++++++++------
 3 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 48aeb55..387e5c9 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -555,7 +555,9 @@ static void __init early_reserve_mem(void)
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
index d65b591..1aad444 100644
--- a/arch/powerpc/mm/init_32.c
+++ b/arch/powerpc/mm/init_32.c
@@ -226,13 +226,16 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-       if (start < end)
+       if (start && (start < end)) {
+               start = _ALIGN_DOWN(start, PAGE_SIZE);
+               end = _ALIGN_UP(end, PAGE_SIZE);
                printk ("Freeing initrd memory: %ldk freed\n", (end - start) >> 10);
-       for (; start < end; start += PAGE_SIZE) {
-               ClearPageReserved(virt_to_page(start));
-               init_page_count(virt_to_page(start));
-               free_page(start);
-               totalram_pages++;
+               for (; start < end; start += PAGE_SIZE) {
+                       ClearPageReserved(virt_to_page(start));
+                       init_page_count(virt_to_page(start));
+                       free_page(start);
+                       totalram_pages++;
+               }
        }
 }
 #endif
diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index 6374b21..fa9586b 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -102,13 +102,16 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-       if (start < end)
+       if (start && (start < end)) {
+               start = _ALIGN_DOWN(start, PAGE_SIZE);
+               end = _ALIGN_UP(end, PAGE_SIZE);
                printk ("Freeing initrd memory: %ldk freed\n", (end - start) >> 10);
-       for (; start < end; start += PAGE_SIZE) {
-               ClearPageReserved(virt_to_page(start));
-               init_page_count(virt_to_page(start));
-               free_page(start);
-               totalram_pages++;
+               for (; start < end; start += PAGE_SIZE) {
+                       ClearPageReserved(virt_to_page(start));
+                       init_page_count(virt_to_page(start));
+                       free_page(start);
+                       totalram_pages++;
+               }
        }
 }
 #endif
--
1.7.4

