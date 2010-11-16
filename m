Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab0KPVbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:31:39 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:57870 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932348Ab0KPVbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:31:37 -0500
Message-ID: <4CE2F82E.60601@free.fr>
Date: Tue, 16 Nov 2010 22:31:26 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-next@vger.kernel.org
CC: Arjan van de Ven <arjan@infradead.org>, James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Kees Cook <kees.cook@canonical.com>
Subject: [PATCH 2/3 V8] NX protection for kernel data
Content-Type: multipart/mixed;
 boundary="------------090702070600030400000801"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090702070600030400000801
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

    Note: this patch depends on "Correct improper large page preservation" patch
    
    This patch expands functionality of CONFIG_DEBUG_RODATA to set main
    (static) kernel data area as NX.
    The following steps are taken to achieve this:
    1. Linker script is adjusted so .text always starts and ends on a page bound
    2. Linker script is adjusted so .rodata always start and
    end on a page boundary
    3. NX is set for all pages from _etext through _end in mark_rodata_ro.
    4. free_init_pages() sets released memory NX in arch/x86/mm/init.c
    5. bios rom is set to x when pcibios is used.
    
    The results of patch application may be observed in the diff of kernel page
    table dumps.
    pcibios :
    --- data_nx_pt_before.txt       2009-10-13 07:48:59.000000000 -0400
    +++ data_nx_pt_after.txt        2009-10-13 07:26:46.000000000 -0400
    @@ -2,8 +2,9 @@
     0x00000000-0xc0000000           3G                           pmd
     ---[ Kernel Mapping ]---
    -0xc0000000-0xc0100000           1M     RW             GLB x  pte
    +0xc0000000-0xc00a0000         640K     RW             GLB NX pte
    +0xc00a0000-0xc0100000         384K     RW             GLB x  pte
    -0xc0100000-0xc03d7000        2908K     ro             GLB x  pte
    +0xc0100000-0xc0318000        2144K     ro             GLB x  pte
    +0xc0318000-0xc03d7000         764K     ro             GLB NX pte
    -0xc03d7000-0xc0600000        2212K     RW             GLB x  pte
    +0xc03d7000-0xc0600000        2212K     RW             GLB NX pte
     0xc0600000-0xf7a00000         884M     RW         PSE GLB NX pmd
     0xf7a00000-0xf7bfe000        2040K     RW             GLB NX pte
     0xf7bfe000-0xf7c00000           8K                           pte
    
    no pcibios :
    --- data_nx_pt_before.txt       2009-10-13 07:48:59.000000000 -0400
    +++ data_nx_pt_after.txt        2009-10-13 07:26:46.000000000 -0400
    @@ -2,8 +2,9 @@
     0x00000000-0xc0000000           3G                           pmd
     ---[ Kernel Mapping ]---
    -0xc0000000-0xc0100000           1M     RW             GLB x  pte
    +0xc0000000-0xc0100000           1M     RW             GLB NX pte
    -0xc0100000-0xc03d7000        2908K     ro             GLB x  pte
    +0xc0100000-0xc0318000        2144K     ro             GLB x  pte
    +0xc0318000-0xc03d7000         764K     ro             GLB NX pte
    -0xc03d7000-0xc0600000        2212K     RW             GLB x  pte
    +0xc03d7000-0xc0600000        2212K     RW             GLB NX pte
     0xc0600000-0xf7a00000         884M     RW         PSE GLB NX pmd
     0xf7a00000-0xf7bfe000        2040K     RW             GLB NX pte
     0xf7bfe000-0xf7c00000           8K                           pte
    
    The patch have been developed for Linux 2.6.34-rc2 x86 by Siarhei Liakh
    <sliakh.lkml@gmail.com> and Xuxian Jiang <jiang@cs.ncsu.edu>.
    
    V1:  initial patch for 2.6.30
    V2:  patch for 2.6.31-rc7
    V3:  moved all code into arch/x86, adjusted credits
    V4:  fixed ifdef, removed credits from CREDITS
    V5:  fixed an address calculation bug in mark_nxdata_nx()
    V6:  added acked-by and PT dump diff to commit log
    V7:  minor adjustments for -tip
    V8:  rework with the merge of "Set first MB as RW+NX"
    
    Signed-off-by: Siarhei Liakh <sliakh.lkml@gmail.com>
    Signed-off-by: Xuxian Jiang <jiang@cs.ncsu.edu>
    Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>


--------------090702070600030400000801
Content-Type: text/x-diff;
 name="x86_nx_kernel_data.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x86_nx_kernel_data.diff"

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index 404a880..d5cecf3 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -62,6 +62,7 @@ extern unsigned long pci_mem_start;
 
 #define PCIBIOS_MIN_CARDBUS_IO	0x4000
 
+extern int pcibios_enabled;
 void pcibios_config_init(void);
 struct pci_bus *pcibios_scan_root(int bus);
 
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
index 9a66746..6dfacec 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -762,6 +762,7 @@ void mark_rodata_ro(void)
 	unsigned long rodata_start =
 		((unsigned long)__start_rodata + PAGE_SIZE - 1) & PAGE_MASK;
 	unsigned long end = (unsigned long) &__end_rodata_hpage_align;
+	unsigned long kernel_end = (((unsigned long)&__init_end + HPAGE_SIZE) & HPAGE_MASK);
 	unsigned long text_end = PAGE_ALIGN((unsigned long) &__stop___ex_table);
 	unsigned long rodata_end = PAGE_ALIGN((unsigned long) &__end_rodata);
 	unsigned long data_start = (unsigned long) &_sdata;
@@ -776,7 +777,7 @@ void mark_rodata_ro(void)
 	 * The rodata section (but not the kernel text!) should also be
 	 * not-executable.
 	 */
-	set_memory_nx(rodata_start, (end - rodata_start) >> PAGE_SHIFT);
+	set_memory_nx(rodata_start, (kernel_end - rodata_start) >> PAGE_SHIFT);
 
 	rodata_test();
 
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 91ce756..ab01c6d 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -13,6 +13,7 @@
 #include <linux/pfn.h>
 #include <linux/percpu.h>
 #include <linux/gfp.h>
+#include <linux/pci.h>
 
 #include <asm/e820.h>
 #include <asm/processor.h>
@@ -261,8 +262,11 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 	 * The BIOS area between 640k and 1Mb needs to be executable for
 	 * PCI BIOS based config access (CONFIG_PCI_GOBIOS) support.
 	 */
-	if (within(pfn, BIOS_BEGIN >> PAGE_SHIFT, BIOS_END >> PAGE_SHIFT))
+#ifdef CONFIG_PCI_BIOS
+	if (pcibios_enabled &&
+			within(pfn, BIOS_BEGIN >> PAGE_SHIFT, BIOS_END >> PAGE_SHIFT))
 		pgprot_val(forbidden) |= _PAGE_NX;
+#endif
 
 	/*
 	 * The kernel text needs to be executable for obvious reasons
diff --git a/arch/x86/pci/pcbios.c b/arch/x86/pci/pcbios.c
index 2492d16..e1f08b5 100644
--- a/arch/x86/pci/pcbios.c
+++ b/arch/x86/pci/pcbios.c
@@ -9,6 +9,7 @@
 #include <linux/uaccess.h>
 #include <asm/pci_x86.h>
 #include <asm/pci-functions.h>
+#include <asm/cacheflush.h>
 
 /* BIOS32 signature: "_32_" */
 #define BIOS32_SIGNATURE	(('_' << 0) + ('3' << 8) + ('2' << 16) + ('_' << 24))
@@ -25,6 +26,28 @@
 #define PCIBIOS_HW_TYPE1_SPEC		0x10
 #define PCIBIOS_HW_TYPE2_SPEC		0x20
 
+int pcibios_enabled;
+
+/* according some bios specification 
+ * http://members.datafast.net.au/dft0802/specs/bios21.pdf, we could 
+ * restrict the x zone to some pages and make it ro. But this may be
+ * broken on some bios, complex to handle with static_protections.
+ * We could make the 0xe0000-0x100000 range rox, but this can break
+ * some ISA mapping.
+ *
+ * So we let's an rw and x hole when pcibios is used. This shouldn't
+ * happen for modern system with mmconfig, and if you don't want it
+ * you could disable pcibios...
+ */
+static inline void set_bios_x(void)
+{
+	pcibios_enabled = 1;
+	set_memory_x(PAGE_OFFSET + BIOS_BEGIN, (BIOS_END - BIOS_BEGIN) >> PAGE_SHIFT);
+	if (__supported_pte_mask & _PAGE_NX)
+		printk(KERN_INFO "PCI : PCI BIOS aera is rw and x. "
+				"Use pci=nobios if you want it NX.\n");
+}
+
 /*
  * This is the standard structure used to identify the entry point
  * to the BIOS32 Service Directory, as documented in
@@ -332,6 +355,7 @@ static struct pci_raw_ops * __devinit pci_find_bios(void)
 			DBG("PCI: BIOS32 Service Directory entry at 0x%lx\n",
 					bios32_entry);
 			bios32_indirect.address = bios32_entry + PAGE_OFFSET;
+			set_bios_x();
 			if (check_pcibios())
 				return &pci_bios_access;
 		}


--------------090702070600030400000801--
