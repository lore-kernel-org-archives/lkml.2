Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087Ab0JZC4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:56:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932598Ab0JZC42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:56:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 37/43] MN10300: Map userspace atomic op regs as a vmalloc
 page
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Mark Salter <msalter@redhat.com>
Date: Tue, 26 Oct 2010 03:56:19 +0100
Message-ID: <20101026025619.23512.61850.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Salter <msalter@redhat.com>

The AM34 processor has an atomic operation that's the equivalent of LL/SC on
other architectures.  However, rather than being done through a pair of
instructions, it's driven by writing to a pair of memory-mapped CPU control
registers.

One set of these registers (AARU/ADRU/ASRU) is available for use by userspace,
but for userspace to access them a PTE must be set up to cover the region.
This is done by dedicating the first vmalloc region page to this purpose,
setting the permissions on its PTE such that userspace can access the page.

glibc is hardcoded to expect the registers to be there.

The way atomic ops are done through these registers is straightforward:

 (1) Write the address of the word you wish to access into AARU.  This causes
     the CPU to go and fetch that word and load it into ADRU.  The status bits
     are also cleared in ASRU.

 (2) The current data value is read from the ADRU register and modified.

 (3) To alter the data in RAM, the revised data is written back to the ADRU
     register, which causes the CPU to attempt to write it back.

 (4) The ASRU.RW flag (ASRU read watch), ASRU.LW flag (bus lock watch),
     ASRU.IW (interrupt watch) and the ASRU.BW (bus error watch) flags then
     must be checked to confirm that the operation wasn't aborted.  If any of
     the watches have been set to true, the operation was aborted.

Signed-off-by: Mark Salter <msalter@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/pgtable.h |    3 +++
 arch/mn10300/mm/init.c             |   21 +++++++++++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)


diff --git a/arch/mn10300/include/asm/pgtable.h b/arch/mn10300/include/asm/pgtable.h
index ba66606..b6e77f5 100644
--- a/arch/mn10300/include/asm/pgtable.h
+++ b/arch/mn10300/include/asm/pgtable.h
@@ -182,6 +182,9 @@ extern pte_t kernel_vmalloc_ptes[(VMALLOC_END - VMALLOC_START) / PAGE_SIZE];
 #define PAGE_KERNEL_LARGE	__pgprot(__PAGE_KERNEL_LARGE)
 #define PAGE_KERNEL_LARGE_EXEC	__pgprot(__PAGE_KERNEL_LARGE_EXEC)
 
+#define __PAGE_USERIO		(__PAGE_KERNEL_BASE | _PAGE_PROT_WKWU | _PAGE_NX)
+#define PAGE_USERIO		__pgprot(__PAGE_USERIO)
+
 /*
  * Whilst the MN10300 can do page protection for execute (given separate data
  * and insn TLBs), we are not supporting it at the moment. Write permission,
diff --git a/arch/mn10300/mm/init.c b/arch/mn10300/mm/init.c
index 1daf97f..48907cc 100644
--- a/arch/mn10300/mm/init.c
+++ b/arch/mn10300/mm/init.c
@@ -41,6 +41,10 @@ DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
 unsigned long highstart_pfn, highend_pfn;
 
+#ifdef CONFIG_MN10300_HAS_ATOMIC_OPS_UNIT
+static struct vm_struct user_iomap_vm;
+#endif
+
 /*
  * set up paging
  */
@@ -73,6 +77,23 @@ void __init paging_init(void)
 	/* pass the memory from the bootmem allocator to the main allocator */
 	free_area_init(zones_size);
 
+#ifdef CONFIG_MN10300_HAS_ATOMIC_OPS_UNIT
+	/* The Atomic Operation Unit registers need to be mapped to userspace
+	 * for all processes.  The following uses vm_area_register_early() to
+	 * reserve the first page of the vmalloc area and sets the pte for that
+	 * page.
+	 *
+	 * glibc hardcodes this virtual mapping, so we're pretty much stuck with
+	 * it from now on.
+	 */
+	user_iomap_vm.flags = VM_USERMAP;
+	user_iomap_vm.size = 1 << PAGE_SHIFT;
+	vm_area_register_early(&user_iomap_vm, PAGE_SIZE);
+	ppte = kernel_vmalloc_ptes;
+	set_pte(ppte, pfn_pte(USER_ATOMIC_OPS_PAGE_ADDR >> PAGE_SHIFT,
+			      PAGE_USERIO));
+#endif
+
 	local_flush_tlb_all();
 }
 

