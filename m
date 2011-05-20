Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab1ETVcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 17:32:18 -0400
Received: from 173-160-34-133-colorado.hfc.comcastbusiness.net ([173.160.34.133]:35359
	"EHLO ether.astekcorp.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752965Ab1ETVcI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 17:32:08 -0400
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 May 2011 17:32:08 EDT
From: Dave Carroll <dcarroll@astekcorp.com>
To: "Benjamin Herrenschmidt (E-mail)" <benh@kernel.crashing.org>,
        "Paul Mackerras (E-mail)" <paulus@samba.org>,
        "Grant Likely (E-mail)" <grant.likely@secretlab.ca>
CC: "LPPC (E-mail)" <linuxppc-dev@lists.ozlabs.org>,
        "LKML (E-mail)" <linux-kernel@vger.kernel.org>
Date: Fri, 20 May 2011 15:26:19 -0600
Subject: [PATCH]powerpc: Force page alignment for early reserved memory
Thread-Topic: [PATCH]powerpc: Force page alignment for early reserved memory
Thread-Index: AcwXNI8tqvsOvcI2QU6E/1yfhVl9gA==
Message-ID: <522F24EF533FC546962ECFA2054FF777373072AB71@MAILSERVER2.cos.astekcorp.com>
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


When using 64K pages with a separate cpio rootfs, U-Boot will align the rootfs on a 4K
page boundary. When the memory is reserved, and subsequent early memblock_alloc
is called, it will allocate memory between the 64K page alignment and reserved
memory. When the reserved memory is subsequently freed, it is done so by pages,
causing the early memblock_alloc requests to be re-used, which in my case, caused
the device-tree to be clobbered.

This patch forces all early reserved memory to be kernel page aligned, to match
the mechanism used to free reserved memory.

Signed-off-by: Dave Carroll <dcarroll@astekcorp.com>
---
 arch/powerpc/kernel/prom.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index e74fa12..2744792 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -534,6 +534,19 @@ void __init early_init_dt_setup_initrd_arch(unsigned long start,
 }
 #endif

+static void __init reserve_mem(u64 base, u64 size)
+{
+       u64 top = base + size;
+       if (size == 0)
+               return;
+
+       base = _ALIGN_DOWN(base, PAGE_SIZE);
+       top = _ALIGN_UP(top, PAGE_SIZE);
+       size = top - base;
+       memblock_reserve(base, size);
+
+}
+
 static void __init early_reserve_mem(void)
 {
        u64 base, size;
@@ -547,12 +560,12 @@ static void __init early_reserve_mem(void)
        /* before we do anything, lets reserve the dt blob */
        self_base = __pa((unsigned long)initial_boot_params);
        self_size = initial_boot_params->totalsize;
-       memblock_reserve(self_base, self_size);
+       reserve_mem(self_base, self_size);

 #ifdef CONFIG_BLK_DEV_INITRD
        /* then reserve the initrd, if any */
        if (initrd_start && (initrd_end > initrd_start))
-               memblock_reserve(__pa(initrd_start), initrd_end - initrd_start);
+               reserve_mem(__pa(initrd_start), initrd_end - initrd_start);
 #endif /* CONFIG_BLK_DEV_INITRD */

 #ifdef CONFIG_PPC32
@@ -573,7 +586,7 @@ static void __init early_reserve_mem(void)
                        if (base_32 == self_base && size_32 == self_size)
                                continue;
                        DBG("reserving: %x -> %x\n", base_32, size_32);
-                       memblock_reserve(base_32, size_32);
+                       reserve_mem(base_32, size_32);
                }
                return;
        }
@@ -584,7 +597,7 @@ static void __init early_reserve_mem(void)
                if (size == 0)
                        break;
                DBG("reserving: %llx -> %llx\n", base, size);
-               memblock_reserve(base, size);
+               reserve_mem(base, size);
        }
 }

--
1.7.4
