Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934049Ab0HLWYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 18:24:52 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:33218 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934035Ab0HLWYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 18:24:49 -0400
Message-ID: <4C6474AA.4040802@free.fr>
Date: Fri, 13 Aug 2010 00:24:42 +0200
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Siarhei Liakh <sliakh.lkml@gmail.com>
CC: Xuxian Jiang <jiang@cs.ncsu.edu>, Arjan van de Ven <arjan@linux.intel.com>,
        James Morris <jmorris@namei.org>
Subject: [RFC] reworked NX protection for kernel data
Content-Type: multipart/mixed;
 boundary="------------070500000409030504090205"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070500000409030504090205
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

because nobody seems to work on "NX protection for kernel data" patches [1], I decided to rework them a bit :
- remove unneeded alignment in vmlinux.lds
- call mark_nxdata_nx in mark_rodata_ro instead of free_initmem
- fix a bug in my machine where memory was x and rw after kernel data
- static_protections for bios rom is only enabled when CONFIG_PCI_BIOS (no x64)
- bios rom is set to x only when probing pcibios (this won't be done is mmconfig is supported).

A second patch is more radical : it make the ROM bios memory (0xe0000-0x100000) ro and x, but only for system
supporting NX (to avoid breaking very old machine). I don't know if it is safe.

I am waiting for your comment before reposting all the patches (module and improper large page preservation)
I only test it on a 32bit NX cpu.


Matthieu

[1]
Note: this patch depends on "Correct improper large page preservation" patch

This patch expands functionality of CONFIG_DEBUG_RODATA to set main
(static) kernel data area as NX.
The following steps are taken to achieve this:
1. Linker script is adjusted so .text always starts and ends on a page bound
2. Linker script is adjusted so .rodata and .data always start and
end on a page boundary
3. void mark_nxdata_nx(void) added to arch/x86/mm/init.c with actual
functionality: NX is set for all pages from _etext through _end.
4. mark_nxdata_nx() called from free_initmem() (after init has been released
5. free_init_pages() sets released memory NX in arch/x86/mm/init.c

The results of patch application may be observed in the diff of kernel page
table dumps:
--- data_nx_pt_before.txt       2009-10-13 07:48:59.000000000 -0400
+++ data_nx_pt_after.txt        2009-10-13 07:26:46.000000000 -0400
@@ -2,8 +2,9 @@
 0x00000000-0xc0000000           3G                           pmd
 ---[ Kernel Mapping ]---
 0xc0000000-0xc0100000           1M     RW             GLB x  pte
-0xc0100000-0xc048d000        3636K     ro             GLB x  pte
-0xc048d000-0xc0600000        1484K     RW             GLB x  pte
+0xc0100000-0xc0381000        2564K     ro             GLB x  pte
+0xc0381000-0xc048d000        1072K     ro             GLB NX pte
+0xc048d000-0xc0600000        1484K     RW             GLB NX pte
 0xc0600000-0xf7800000         882M     RW         PSE GLB NX pmd
 0xf7800000-0xf79fe000        2040K     RW             GLB NX pte
 0xf79fe000-0xf7a00000           8K                           pte

The patch have been developed for Linux 2.6.34-rc2 x86 by Siarhei Liakh
<sliakh.lkml@gmail.com> and Xuxian Jiang <jiang@cs.ncsu.edu>.

V1:  initial patch for 2.6.30
V2:  patch for 2.6.31-rc7
V3:  moved all code into arch/x86, adjusted credits
V4:  fixed ifdef, removed credits from CREDITS
V5:  fixed an address calculation bug in mark_nxdata_nx()
V6:  added acked-by and PT dump diff to commit log
V7:  minor adjustments for -tip

Signed-off-by: Siarhei Liakh <sliakh.lkml@gmail.com>
Signed-off-by: Xuxian Jiang <jiang@cs.ncsu.edu>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Reviewed-by: James Morris <jmorris@namei.org>

--------------070500000409030504090205
Content-Type: text/x-diff;
 name="kernelnx.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kernelnx.diff"

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index d0bb522..958ac45 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -69,7 +69,7 @@ jiffies_64 = jiffies;
 
 PHDRS {
 	text PT_LOAD FLAGS(5);          /* R_E */
-	data PT_LOAD FLAGS(7);          /* RWE */
+	data PT_LOAD FLAGS(6);          /* RW_ */
 #ifdef CONFIG_X86_64
 	user PT_LOAD FLAGS(5);          /* R_E */
 #ifdef CONFIG_SMP
@@ -116,6 +116,10 @@ SECTIONS
 
 	EXCEPTION_TABLE(16) :text = 0x9090
 
+#if defined(CONFIG_DEBUG_RODATA)
+	/* .text should occupy whole number of pages */
+	. = ALIGN(PAGE_SIZE);
+#endif
 	X64_ALIGN_DEBUG_RODATA_BEGIN
 	RO_DATA(PAGE_SIZE)
 	X64_ALIGN_DEBUG_RODATA_END
@@ -307,7 +311,7 @@ SECTIONS
 		__bss_start = .;
 		*(.bss..page_aligned)
 		*(.bss)
-		. = ALIGN(4);
+		. = ALIGN(PAGE_SIZE);
 		__bss_stop = .;
 	}
 
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index b278535..bfacdbe 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -362,8 +362,9 @@ void free_init_pages(char *what, unsigned long begin, unsigned long end)
 	/*
 	 * We just marked the kernel text read only above, now that
 	 * we are going to free part of that, we need to make that
-	 * writeable first.
+	 * writeable and non-executable first.
 	 */
+	set_memory_nx(begin, (end - begin) >> PAGE_SHIFT);
 	set_memory_rw(begin, (end - begin) >> PAGE_SHIFT);
 
 	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index bca7909..85a1a75 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -225,7 +225,7 @@ page_table_range_init(unsigned long start, unsigned long end, pgd_t *pgd_base)
 
 static inline int is_kernel_text(unsigned long addr)
 {
-	if (addr >= PAGE_OFFSET && addr <= (unsigned long)__init_end)
+	if (addr >= (unsigned long)_text && addr <= (unsigned long)__init_end)
 		return 1;
 	return 0;
 }
@@ -1033,6 +1033,22 @@ void set_kernel_text_ro(void)
 	set_pages_ro(virt_to_page(start), size >> PAGE_SHIFT);
 }
 
+static void mark_nxdata_nx(void)
+{
+	/*
+	 * When this called, init has already been executed and released,
+	 * so everything past _etext sould be NX.
+	 */
+	unsigned long start = PFN_ALIGN(_etext);
+	/* this comes from is_kernel_text upper limit. Also HPAGE where used */
+	unsigned long size = (((unsigned long)__init_end + HPAGE_SIZE) & HPAGE_MASK)- start;
+
+	if (__supported_pte_mask & _PAGE_NX)
+		printk(KERN_INFO "NX-protecting the kernel data: %luk\n",
+			size >> 10);
+	set_pages_nx(virt_to_page(start), size >> PAGE_SHIFT);
+}
+
 void mark_rodata_ro(void)
 {
 	unsigned long start = PFN_ALIGN(_text);
@@ -1067,6 +1083,7 @@ void mark_rodata_ro(void)
 	printk(KERN_INFO "Testing CPA: write protecting again\n");
 	set_pages_ro(virt_to_page(start), size >> PAGE_SHIFT);
 #endif
+	mark_nxdata_nx();
 }
 #endif
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index ee41bba..0dec7f2 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -761,7 +761,7 @@ void mark_rodata_ro(void)
 	unsigned long start = PFN_ALIGN(_text);
 	unsigned long rodata_start =
 		((unsigned long)__start_rodata + PAGE_SIZE - 1) & PAGE_MASK;
-	unsigned long end = (unsigned long) &__end_rodata_hpage_align;
+	unsigned long end = (((unsigned long)__init_end + HPAGE_SIZE) & HPAGE_MASK);
 	unsigned long text_end = PAGE_ALIGN((unsigned long) &__stop___ex_table);
 	unsigned long rodata_end = PAGE_ALIGN((unsigned long) &__end_rodata);
 	unsigned long data_start = (unsigned long) &_sdata;
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 91ce756..d130dc5 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -261,8 +261,10 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 	 * The BIOS area between 640k and 1Mb needs to be executable for
 	 * PCI BIOS based config access (CONFIG_PCI_GOBIOS) support.
 	 */
+#ifdef CONFIG_PCI_BIOS
 	if (within(pfn, BIOS_BEGIN >> PAGE_SHIFT, BIOS_END >> PAGE_SHIFT))
 		pgprot_val(forbidden) |= _PAGE_NX;
+#endif
 
 	/*
 	 * The kernel text needs to be executable for obvious reasons
diff --git a/arch/x86/pci/pcbios.c b/arch/x86/pci/pcbios.c
index 2492d16..34ccb73 100644
--- a/arch/x86/pci/pcbios.c
+++ b/arch/x86/pci/pcbios.c
@@ -9,6 +9,7 @@
 #include <linux/uaccess.h>
 #include <asm/pci_x86.h>
 #include <asm/pci-functions.h>
+#include <asm/cacheflush.h>
 
 /* BIOS32 signature: "_32_" */
 #define BIOS32_SIGNATURE	(('_' << 0) + ('3' << 8) + ('2' << 16) + ('_' << 24))
@@ -420,11 +421,24 @@ int pcibios_set_irq_routing(struct pci_dev *dev, int pin, int irq)
 }
 EXPORT_SYMBOL(pcibios_set_irq_routing);
 
+/* according some bios specification 
+ * http://members.datafast.net.au/dft0802/specs/bios21.pdf, we could 
+ * restrict the x zone to some pages and make it ro. But we
+ * really don't care, processor with NX support should be able to use 
+ * mmconfig for pci that disable pcibios...
+ */
+static inline void set_bios_x(void)
+{
+	set_memory_x(PAGE_OFFSET + BIOS_BEGIN, (BIOS_END - BIOS_BEGIN) >> PAGE_SHIFT);
+}
+
 void __init pci_pcbios_init(void)
 {
-	if ((pci_probe & PCI_PROBE_BIOS) 
-		&& ((raw_pci_ops = pci_find_bios()))) {
-		pci_bios_present = 1;
+	if (pci_probe & PCI_PROBE_BIOS) {
+		set_bios_x();
+		if ((raw_pci_ops = pci_find_bios())) {
+			pci_bios_present = 1;
+		}
 	}
 }
 

--------------070500000409030504090205
Content-Type: text/x-diff;
 name="kernelnx2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kernelnx2.diff"

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index d130dc5..5fd5f4d 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -258,12 +258,13 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 	pgprot_t required = __pgprot(0);
 
 	/*
-	 * The BIOS area between 640k and 1Mb needs to be executable for
+	 * The BIOS area between 896k and 1Mb (ROM) needs to be executable for
 	 * PCI BIOS based config access (CONFIG_PCI_GOBIOS) support.
 	 */
 #ifdef CONFIG_PCI_BIOS
-	if (within(pfn, BIOS_BEGIN >> PAGE_SHIFT, BIOS_END >> PAGE_SHIFT))
-		pgprot_val(forbidden) |= _PAGE_NX;
+	if ((__supported_pte_mask & _PAGE_NX) &&
+			within(pfn, 0xe0000 >> PAGE_SHIFT, BIOS_END >> PAGE_SHIFT))
+		pgprot_val(forbidden) |= _PAGE_NX|_PAGE_RW;
 #endif
 
 	/*
diff --git a/arch/x86/pci/pcbios.c b/arch/x86/pci/pcbios.c
index 34ccb73..ac35d6f 100644
--- a/arch/x86/pci/pcbios.c
+++ b/arch/x86/pci/pcbios.c
@@ -11,6 +11,7 @@
 #include <asm/pci-functions.h>
 #include <asm/cacheflush.h>
 
+#define ROM_BEGIN 0xe0000
 /* BIOS32 signature: "_32_" */
 #define BIOS32_SIGNATURE	(('_' << 0) + ('3' << 8) + ('2' << 16) + ('_' << 24))
 
@@ -301,7 +302,7 @@ static struct pci_raw_ops * __devinit pci_find_bios(void)
 	 * 0xe0000 through 0xfffff for a valid BIOS32 structure.
 	 */
 
-	for (check = (union bios32 *) __va(0xe0000);
+	for (check = (union bios32 *) __va(ROM_BEGIN);
 	     check <= (union bios32 *) __va(0xffff0);
 	     ++check) {
 		long sig;
@@ -424,18 +425,20 @@ EXPORT_SYMBOL(pcibios_set_irq_routing);
 /* according some bios specification 
  * http://members.datafast.net.au/dft0802/specs/bios21.pdf, we could 
  * restrict the x zone to some pages and make it ro. But we
- * really don't care, processor with NX support should be able to use 
- * mmconfig for pci that disable pcibios...
+ * really don't care, system rom should always be ro and x.
  */
-static inline void set_bios_x(void)
+static inline void set_bios_rox(void)
 {
-	set_memory_x(PAGE_OFFSET + BIOS_BEGIN, (BIOS_END - BIOS_BEGIN) >> PAGE_SHIFT);
+	if (__supported_pte_mask & _PAGE_NX) {
+		set_memory_ro(PAGE_OFFSET + ROM_BEGIN, (BIOS_END - ROM_BEGIN) >> PAGE_SHIFT);
+		set_memory_x(PAGE_OFFSET + ROM_BEGIN, (BIOS_END - ROM_BEGIN) >> PAGE_SHIFT);
+	}
 }
 
 void __init pci_pcbios_init(void)
 {
 	if (pci_probe & PCI_PROBE_BIOS) {
-		set_bios_x();
+		set_bios_rox();
 		if ((raw_pci_ops = pci_find_bios())) {
 			pci_bios_present = 1;
 		}

--------------070500000409030504090205--
