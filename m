Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab0FGBBG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 21:01:06 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38639 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab0FGBBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 21:01:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=sTV7l29hbCSj0yTWFoljAxZFLj87XWjg3avnMPyDq5m0AH31Wx0cT7zTJkHyQFmahn
         BEsxGvbO6TLGR9I1HJ99lQmJWSf55xIb0EwA3aDUNGGumqytRiZpiSsKfXQeme2+Ki5N
         Wx0hDsdpHyfvY5BsRaonQLHSuVrylu6g41R1E=
Message-ID: <4C0C44C9.8060801@gmail.com>
Date: Sun, 06 Jun 2010 21:00:57 -0400
From: Siarhei Liakh <sliakh.lkml@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-next@vger.kernel.org
CC: Arjan van de Ven <arjan@infradead.org>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>
Subject: [PATCH 2/4 V4] [tip:x86/mm] Set first MB as RW+NX
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch ensures that there are no mixed (RW+X) pages mapped within
first megabyte of kernel space (from PAGE_OFFSET up to beginning of .text).
This is achieved through introduction of new compile-time option
CONFIG_DEBUG_SET_1ST_MB_RWNX which controls how is_kernel_text()
and static_protections() view the memory area in question.

Special accommodations have been made for BIOS32/PCI BIOS services:
according to BIOS32 specification
(http://members.datafast.net.au/dft0802/specs/bios32.pdf), at most two
pages per BIOS32 service should be set executable and no pages need to
be writeable. This patch modifies bios32_service() to set proper page
access permissions at time of service discovery, as described in the
specification. Further, hardcoded protection of memory area between 640k
to 1Mb have been removed from static_protections(), since only pages
mentioned above need to be executable, not whole BIOS region.

The net result of the patch application is as follows:
========== BEFORE ==========
0xc0000000-0xc0100000           1M     RW             GLB x  pte
0xc0100000-0xc04b6000        3800K     ro             GLB x  pte
...

=========== AFTER ===========
0xc0000000-0xc00fb000        1004K     RW             GLB NX pte
0xc00fb000-0xc00fd000           8K     ro             GLB x  pte
0xc00fd000-0xc0100000          12K     RW             GLB NX pte
0xc0100000-0xc04b6000        3800K     ro             GLB x  pte
...

Note that first MB is now RW+NX, except for 8K of RO+X used by BIOS32.

The patch have been developed for Linux 2.6.33-rc5 x86 by Siarhei Liakh
<sliakh.lkml@gmail.com> and Xuxian Jiang <jiang@cs.ncsu.edu>.

V1: original patch "Reducing footprint of BIOS32 service mappings"
V2: Set first MB as RW+NX for linux 2.6.33-rc5
V3: minor adjustments for -tip
V4: Replaced "1st" with "first"

Signed-off-by: Siarhei Liakh <sliakh.lkml@gmail.com>
Signed-off-by: Xuxian Jiang <jiang@cs.ncsu.edu>
---

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 8b3c711..adeaa39 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -121,6 +121,17 @@ config DEBUG_NX_TEST
 	  and the software setup of this feature.
 	  If in doubt, say "N"
 
+config DEBUG_SET_1ST_MB_RWNX
+       bool "Set first MB of kernel space mapping as RW+NX"
+       default n
+       depends on X86
+       ---help---
+         This option helps to catch unintended modifications/execution of
+         1st megabyte of kernel address space. Such protection may interfere
+         with run-time code patching and legacy BIOS services residing within
+         the first MB of physical address space.
+         If in doubt, say "N".
+
 config 4KSTACKS
 	bool "Use 4Kb for kernel stacks instead of 8Kb"
 	depends on X86_32
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index bca7909..8fb9c3d 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -52,6 +52,12 @@
 #include <asm/page_types.h>
 #include <asm/init.h>
 
+#ifdef CONFIG_DEBUG_SET_1ST_MB_RWNX
+#define TEXT_START _text
+#else
+#define TEXT_START PAGE_OFFSET
+#endif
+
 unsigned long highstart_pfn, highend_pfn;
 
 static noinline int do_test_wp_bit(void);
@@ -225,7 +231,8 @@ page_table_range_init(unsigned long start, unsigned long end, pgd_t *pgd_base)
 
 static inline int is_kernel_text(unsigned long addr)
 {
-	if (addr >= PAGE_OFFSET && addr <= (unsigned long)__init_end)
+	if (addr >= (unsigned long)TEXT_START
+		&& addr <= (unsigned long)__init_end)
 		return 1;
 	return 0;
 }
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 532e793..93ac4e6 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -256,13 +256,14 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 {
 	pgprot_t forbidden = __pgprot(0);
 
+#ifndef CONFIG_DEBUG_SET_1ST_MB_RWNX
 	/*
 	 * The BIOS area between 640k and 1Mb needs to be executable for
 	 * PCI BIOS based config access (CONFIG_PCI_GOBIOS) support.
 	 */
 	if (within(pfn, BIOS_BEGIN >> PAGE_SHIFT, BIOS_END >> PAGE_SHIFT))
 		pgprot_val(forbidden) |= _PAGE_NX;
-
+#endif
 	/*
 	 * The kernel text needs to be executable for obvious reasons
 	 * Does not cover __inittext since that is gone later on. On
diff --git a/arch/x86/pci/pcbios.c b/arch/x86/pci/pcbios.c
index 2492d16..1102096 100644
--- a/arch/x86/pci/pcbios.c
+++ b/arch/x86/pci/pcbios.c
@@ -9,6 +9,7 @@
 #include <linux/uaccess.h>
 #include <asm/pci_x86.h>
 #include <asm/pci-functions.h>
+#include <asm/cacheflush.h>
 
 /* BIOS32 signature: "_32_" */
 #define BIOS32_SIGNATURE	(('_' << 0) + ('3' << 8) + ('2' << 16) + ('_' << 24))
@@ -59,6 +60,16 @@ static struct {
 	unsigned short segment;
 } bios32_indirect = { 0, __KERNEL_CS };
 
+/* Set two consecutive pages as read-only and executable */
+void set_2_pages_rox(unsigned long addr)
+{
+#ifdef CONFIG_DEBUG_SET_1ST_MB_RWNX
+	unsigned long pg_address = PFN_DOWN(addr + PAGE_OFFSET) << PAGE_SHIFT;
+	set_memory_ro(pg_address, 2);
+	set_memory_x(pg_address, 2);
+#endif
+}
+
 /*
  * Returns the entry point for the given service, NULL on error
  */
@@ -83,15 +94,19 @@ static unsigned long bios32_service(unsigned long service)
 	local_irq_restore(flags);
 
 	switch (return_code) {
-		case 0:
-			return address + entry;
-		case 0x80:	/* Not present */
-			printk(KERN_WARNING "bios32_service(0x%lx): not present\n", service);
-			return 0;
-		default: /* Shouldn't happen */
-			printk(KERN_WARNING "bios32_service(0x%lx): returned 0x%x -- BIOS bug!\n",
-				service, return_code);
-			return 0;
+	case 0:	/* Service present, set proper page access */
+		address += entry;
+		set_2_pages_rox(address);
+		return address;
+	case 0x80: /* Not present */
+		printk(KERN_WARNING "bios32_service(0x%lx): not present\n",
+			service);
+		return 0;
+	default: /* Shouldn't happen */
+		printk(KERN_WARNING "bios32_service(0x%lx): "
+			"returned 0x%x -- BIOS bug!\n",
+			service, return_code);
+		return 0;
 	}
 }
 
@@ -332,6 +347,7 @@ static struct pci_raw_ops * __devinit pci_find_bios(void)
 			DBG("PCI: BIOS32 Service Directory entry at 0x%lx\n",
 					bios32_entry);
 			bios32_indirect.address = bios32_entry + PAGE_OFFSET;
+			set_2_pages_rox(bios32_entry);
 			if (check_pcibios())
 				return &pci_bios_access;
 		}
