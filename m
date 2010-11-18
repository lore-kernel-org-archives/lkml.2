Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327Ab0KROJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:09:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:41392 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758296Ab0KROJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:09:25 -0500
Date: Thu, 18 Nov 2010 14:08:22 GMT
From: tip-bot for Matthieu Castet <castet.matthieu@free.fr>
Cc: linux-kernel@vger.kernel.org, jmorris@namei.org, sliakh.lkml@gmail.com,
        hpa@zytor.com, mingo@redhat.com, torvalds@linux-foundation.org,
        rusty@rustcorp.com.au, davej@redhat.com, ak@muc.de, jiang@cs.ncsu.edu,
        arjan@infradead.org, castet.matthieu@free.fr, kees.cook@canonical.com,
        sfr@canb.auug.org.au, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, sliakh.lkml@gmail.com,
        jmorris@namei.org, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        torvalds@linux-foundation.org, ak@muc.de, davej@redhat.com,
        jiang@cs.ncsu.edu, arjan@infradead.org, castet.matthieu@free.fr,
        kees.cook@canonical.com, tglx@linutronix.de, sfr@canb.auug.org.au,
        mingo@elte.hu
In-Reply-To: <4CE2F82E.60601@free.fr>
References: <4CE2F82E.60601@free.fr>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/security] x86: Add NX protection for kernel data
Message-ID: <tip-5bd5a452662bc37c54fb6828db1a3faf87e6511c@git.kernel.org>
Git-Commit-ID: 5bd5a452662bc37c54fb6828db1a3faf87e6511c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 14:08:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5bd5a452662bc37c54fb6828db1a3faf87e6511c
Gitweb:     http://git.kernel.org/tip/5bd5a452662bc37c54fb6828db1a3faf87e6511c
Author:     Matthieu Castet <castet.matthieu@free.fr>
AuthorDate: Tue, 16 Nov 2010 22:31:26 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Nov 2010 12:52:04 +0100

x86: Add NX protection for kernel data

This patch expands functionality of CONFIG_DEBUG_RODATA to set main
(static) kernel data area as NX.

The following steps are taken to achieve this:

 1. Linker script is adjusted so .text always starts and ends on a page bound
 2. Linker script is adjusted so .rodata always start and end on a page boundary
 3. NX is set for all pages from _etext through _end in mark_rodata_ro.
 4. free_init_pages() sets released memory NX in arch/x86/mm/init.c
 5. bios rom is set to x when pcibios is used.

The results of patch application may be observed in the diff of kernel page
table dumps:

pcibios:

 -- data_nx_pt_before.txt       2009-10-13 07:48:59.000000000 -0400
 ++ data_nx_pt_after.txt        2009-10-13 07:26:46.000000000 -0400
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

No pcibios:

 -- data_nx_pt_before.txt       2009-10-13 07:48:59.000000000 -0400
 ++ data_nx_pt_after.txt        2009-10-13 07:26:46.000000000 -0400
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

The patch has been originally developed for Linux 2.6.34-rc2 x86 by
Siarhei Liakh <sliakh.lkml@gmail.com> and Xuxian Jiang <jiang@cs.ncsu.edu>.

 -v1:  initial patch for 2.6.30
 -v2:  patch for 2.6.31-rc7
 -v3:  moved all code into arch/x86, adjusted credits
 -v4:  fixed ifdef, removed credits from CREDITS
 -v5:  fixed an address calculation bug in mark_nxdata_nx()
 -v6:  added acked-by and PT dump diff to commit log
 -v7:  minor adjustments for -tip
 -v8:  rework with the merge of "Set first MB as RW+NX"

Signed-off-by: Siarhei Liakh <sliakh.lkml@gmail.com>
Signed-off-by: Xuxian Jiang <jiang@cs.ncsu.edu>
Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: James Morris <jmorris@namei.org>
Cc: Andi Kleen <ak@muc.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dave Jones <davej@redhat.com>
Cc: Kees Cook <kees.cook@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <4CE2F82E.60601@free.fr>
[ minor cleanliness edits ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/pci.h    |    1 +
 arch/x86/kernel/vmlinux.lds.S |    8 ++++++--
 arch/x86/mm/init.c            |    3 ++-
 arch/x86/mm/init_32.c         |   20 +++++++++++++++++++-
 arch/x86/mm/init_64.c         |    3 ++-
 arch/x86/mm/pageattr.c        |    5 ++++-
 arch/x86/pci/pcbios.c         |   23 +++++++++++++++++++++++
 7 files changed, 57 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index ca0437c..6761292 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -65,6 +65,7 @@ extern unsigned long pci_mem_start;
 
 #define PCIBIOS_MIN_CARDBUS_IO	0x4000
 
+extern int pcibios_enabled;
 void pcibios_config_init(void);
 struct pci_bus *pcibios_scan_root(int bus);
 
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index e03530a..bf47007 100644
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
@@ -335,7 +339,7 @@ SECTIONS
 		__bss_start = .;
 		*(.bss..page_aligned)
 		*(.bss)
-		. = ALIGN(4);
+		. = ALIGN(PAGE_SIZE);
 		__bss_stop = .;
 	}
 
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index c0e28a1..947f42a 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -364,8 +364,9 @@ void free_init_pages(char *what, unsigned long begin, unsigned long end)
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
index 0e969f9..f89b5bb 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -226,7 +226,7 @@ page_table_range_init(unsigned long start, unsigned long end, pgd_t *pgd_base)
 
 static inline int is_kernel_text(unsigned long addr)
 {
-	if (addr >= PAGE_OFFSET && addr <= (unsigned long)__init_end)
+	if (addr >= (unsigned long)_text && addr <= (unsigned long)__init_end)
 		return 1;
 	return 0;
 }
@@ -912,6 +912,23 @@ void set_kernel_text_ro(void)
 	set_pages_ro(virt_to_page(start), size >> PAGE_SHIFT);
 }
 
+static void mark_nxdata_nx(void)
+{
+	/*
+	 * When this called, init has already been executed and released,
+	 * so everything past _etext sould be NX.
+	 */
+	unsigned long start = PFN_ALIGN(_etext);
+	/*
+	 * This comes from is_kernel_text upper limit. Also HPAGE where used:
+	 */
+	unsigned long size = (((unsigned long)__init_end + HPAGE_SIZE) & HPAGE_MASK) - start;
+
+	if (__supported_pte_mask & _PAGE_NX)
+		printk(KERN_INFO "NX-protecting the kernel data: %luk\n", size >> 10);
+	set_pages_nx(virt_to_page(start), size >> PAGE_SHIFT);
+}
+
 void mark_rodata_ro(void)
 {
 	unsigned long start = PFN_ALIGN(_text);
@@ -946,6 +963,7 @@ void mark_rodata_ro(void)
 	printk(KERN_INFO "Testing CPA: write protecting again\n");
 	set_pages_ro(virt_to_page(start), size >> PAGE_SHIFT);
 #endif
+	mark_nxdata_nx();
 }
 #endif
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 71a5929..ce59c05 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -788,6 +788,7 @@ void mark_rodata_ro(void)
 	unsigned long rodata_start =
 		((unsigned long)__start_rodata + PAGE_SIZE - 1) & PAGE_MASK;
 	unsigned long end = (unsigned long) &__end_rodata_hpage_align;
+	unsigned long kernel_end = (((unsigned long)&__init_end + HPAGE_SIZE) & HPAGE_MASK);
 	unsigned long text_end = PAGE_ALIGN((unsigned long) &__stop___ex_table);
 	unsigned long rodata_end = PAGE_ALIGN((unsigned long) &__end_rodata);
 	unsigned long data_start = (unsigned long) &_sdata;
@@ -802,7 +803,7 @@ void mark_rodata_ro(void)
 	 * The rodata section (but not the kernel text!) should also be
 	 * not-executable.
 	 */
-	set_memory_nx(rodata_start, (end - rodata_start) >> PAGE_SHIFT);
+	set_memory_nx(rodata_start, (kernel_end - rodata_start) >> PAGE_SHIFT);
 
 	rodata_test();
 
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 6f2a6b6..8b830ca 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -13,6 +13,7 @@
 #include <linux/pfn.h>
 #include <linux/percpu.h>
 #include <linux/gfp.h>
+#include <linux/pci.h>
 
 #include <asm/e820.h>
 #include <asm/processor.h>
@@ -261,8 +262,10 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 	 * The BIOS area between 640k and 1Mb needs to be executable for
 	 * PCI BIOS based config access (CONFIG_PCI_GOBIOS) support.
 	 */
-	if (within(pfn, BIOS_BEGIN >> PAGE_SHIFT, BIOS_END >> PAGE_SHIFT))
+#ifdef CONFIG_PCI_BIOS
+	if (pcibios_enabled && within(pfn, BIOS_BEGIN >> PAGE_SHIFT, BIOS_END >> PAGE_SHIFT))
 		pgprot_val(forbidden) |= _PAGE_NX;
+#endif
 
 	/*
 	 * The kernel text needs to be executable for obvious reasons
diff --git a/arch/x86/pci/pcbios.c b/arch/x86/pci/pcbios.c
index 2492d16..a5f7d0d 100644
--- a/arch/x86/pci/pcbios.c
+++ b/arch/x86/pci/pcbios.c
@@ -9,6 +9,7 @@
 #include <linux/uaccess.h>
 #include <asm/pci_x86.h>
 #include <asm/pci-functions.h>
+#include <asm/cacheflush.h>
 
 /* BIOS32 signature: "_32_" */
 #define BIOS32_SIGNATURE	(('_' << 0) + ('3' << 8) + ('2' << 16) + ('_' << 24))
@@ -25,6 +26,27 @@
 #define PCIBIOS_HW_TYPE1_SPEC		0x10
 #define PCIBIOS_HW_TYPE2_SPEC		0x20
 
+int pcibios_enabled;
+
+/* According to the BIOS specification at:
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
+		printk(KERN_INFO "PCI : PCI BIOS aera is rw and x. Use pci=nobios if you want it NX.\n");
+}
+
 /*
  * This is the standard structure used to identify the entry point
  * to the BIOS32 Service Directory, as documented in
@@ -332,6 +354,7 @@ static struct pci_raw_ops * __devinit pci_find_bios(void)
 			DBG("PCI: BIOS32 Service Directory entry at 0x%lx\n",
 					bios32_entry);
 			bios32_indirect.address = bios32_entry + PAGE_OFFSET;
+			set_bios_x();
 			if (check_pcibios())
 				return &pci_bios_access;
 		}
