Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab2I0SXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 14:23:22 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:47488 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab2I0SW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 14:22:26 -0400
X-Greylist: delayed 864 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Sep 2012 14:22:16 EDT
From: Daniel Kiper <daniel.kiper@oracle.com>
To: konrad.wilk@oracle.com, andrew.cooper3@citrix.com, jbeulich@suse.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH 06/11] x86/xen: Add i386 kexec/kdump implementation
Date: Thu, 27 Sep 2012 20:06:33 +0200
Message-Id: <1348769198-29580-7-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1348769198-29580-6-git-send-email-daniel.kiper@oracle.com>
References: <1348769198-29580-1-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-2-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-3-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-4-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-5-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-6-git-send-email-daniel.kiper@oracle.com>
X-Bogosity: No, spamicity=0.001861
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add i386 kexec/kdump implementation.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 arch/x86/xen/machine_kexec_32.c   |  245 ++++++++++++++++++++++++++++
 arch/x86/xen/relocate_kernel_32.S |  323 +++++++++++++++++++++++++++++++++++++
 2 files changed, 568 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/xen/machine_kexec_32.c
 create mode 100644 arch/x86/xen/relocate_kernel_32.S

diff --git a/arch/x86/xen/machine_kexec_32.c b/arch/x86/xen/machine_kexec_32.c
new file mode 100644
index 0000000..6b5141e
--- /dev/null
+++ b/arch/x86/xen/machine_kexec_32.c
@@ -0,0 +1,245 @@
+/*
+ * Copyright (c) 2011 Daniel Kiper
+ * Copyright (c) 2012 Daniel Kiper, Oracle Corporation
+ *
+ * kexec/kdump implementation for Xen was written by Daniel Kiper.
+ * Initial work on it was sponsored by Google under Google Summer
+ * of Code 2011 program and Citrix. Konrad Rzeszutek Wilk from Oracle
+ * was the mentor for this project.
+ *
+ * Some ideas are taken from:
+ *   - native kexec/kdump implementation,
+ *   - kexec/kdump implementation for Xen Linux Kernel Ver. 2.6.18,
+ *   - PV-GRUB.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/kexec.h>
+#include <linux/mm.h>
+#include <linux/string.h>
+
+#include <xen/xen.h>
+#include <xen/xen-ops.h>
+
+#include <asm/xen/hypercall.h>
+#include <asm/xen/kexec.h>
+#include <asm/xen/page.h>
+
+#define __ma(vaddr)	(virt_to_machine(vaddr).maddr)
+
+static struct page *kimage_alloc_pages(gfp_t gfp_mask,
+					unsigned int order,
+					unsigned long limit)
+{
+	struct page *pages;
+	unsigned int address_bits, i;
+
+	pages = alloc_pages(gfp_mask, order);
+
+	if (!pages)
+		return NULL;
+
+	address_bits = (limit == ULONG_MAX) ? BITS_PER_LONG : ilog2(limit);
+
+	/* Relocate set of pages below given limit. */
+	if (xen_create_contiguous_region((unsigned long)page_address(pages),
+							order, address_bits)) {
+		__free_pages(pages, order);
+		return NULL;
+	}
+
+	pages->mapping = NULL;
+	set_page_private(pages, order);
+
+	for (i = 0; i < (1 << order); ++i)
+		SetPageReserved(pages + i);
+
+	return pages;
+}
+
+static void kimage_free_pages(struct page *page)
+{
+	unsigned int i, order;
+
+	order = page_private(page);
+
+	for (i = 0; i < (1 << order); ++i)
+		ClearPageReserved(page + i);
+
+	xen_destroy_contiguous_region((unsigned long)page_address(page), order);
+	__free_pages(page, order);
+}
+
+static unsigned long xen_page_to_mfn(struct page *page)
+{
+	return pfn_to_mfn(page_to_pfn(page));
+}
+
+static struct page *xen_mfn_to_page(unsigned long mfn)
+{
+	return pfn_to_page(mfn_to_pfn(mfn));
+}
+
+static unsigned long xen_virt_to_machine(volatile void *address)
+{
+	return virt_to_machine(address).maddr;
+}
+
+static void *xen_machine_to_virt(unsigned long address)
+{
+	return phys_to_virt(machine_to_phys(XMADDR(address)).paddr);
+}
+
+static void free_transition_pgtable(struct kimage *image)
+{
+	free_page((unsigned long)image->arch.pgd);
+	free_page((unsigned long)image->arch.pmd0);
+	free_page((unsigned long)image->arch.pmd1);
+	free_page((unsigned long)image->arch.pte0);
+	free_page((unsigned long)image->arch.pte1);
+}
+
+static int alloc_transition_pgtable(struct kimage *image)
+{
+	image->arch.pgd = (pgd_t *)get_zeroed_page(GFP_KERNEL);
+
+	if (!image->arch.pgd)
+		goto err;
+
+	image->arch.pmd0 = (pmd_t *)get_zeroed_page(GFP_KERNEL);
+
+	if (!image->arch.pmd0)
+		goto err;
+
+	image->arch.pmd1 = (pmd_t *)get_zeroed_page(GFP_KERNEL);
+
+	if (!image->arch.pmd1)
+		goto err;
+
+	image->arch.pte0 = (pte_t *)get_zeroed_page(GFP_KERNEL);
+
+	if (!image->arch.pte0)
+		goto err;
+
+	image->arch.pte1 = (pte_t *)get_zeroed_page(GFP_KERNEL);
+
+	if (!image->arch.pte1)
+		goto err;
+
+	return 0;
+
+err:
+	free_transition_pgtable(image);
+
+	return -ENOMEM;
+}
+
+static int machine_xen_kexec_prepare(struct kimage *image)
+{
+#ifdef CONFIG_KEXEC_JUMP
+	if (image->preserve_context) {
+		pr_info_once("kexec: Context preservation is not "
+				"supported in Xen domains.\n");
+		return -ENOSYS;
+	}
+#endif
+
+	return alloc_transition_pgtable(image);
+}
+
+static int machine_xen_kexec_load(struct kimage *image)
+{
+	void *control_page;
+	struct xen_kexec_load xkl = {};
+
+	if (!image)
+		return 0;
+
+	control_page = page_address(image->control_code_page);
+	memcpy(control_page, xen_relocate_kernel, xen_kexec_control_code_size);
+
+	xkl.type = image->type;
+	xkl.image.page_list[XK_MA_CONTROL_PAGE] = __ma(control_page);
+	xkl.image.page_list[XK_MA_TABLE_PAGE] = 0; /* Unused. */
+	xkl.image.page_list[XK_MA_PGD_PAGE] = __ma(image->arch.pgd);
+	xkl.image.page_list[XK_MA_PUD0_PAGE] = 0; /* Unused. */
+	xkl.image.page_list[XK_MA_PUD1_PAGE] = 0; /* Unused. */
+	xkl.image.page_list[XK_MA_PMD0_PAGE] = __ma(image->arch.pmd0);
+	xkl.image.page_list[XK_MA_PMD1_PAGE] = __ma(image->arch.pmd1);
+	xkl.image.page_list[XK_MA_PTE0_PAGE] = __ma(image->arch.pte0);
+	xkl.image.page_list[XK_MA_PTE1_PAGE] = __ma(image->arch.pte1);
+	xkl.image.indirection_page = image->head;
+	xkl.image.start_address = image->start;
+
+	return HYPERVISOR_kexec_op(KEXEC_CMD_kexec_load, &xkl);
+}
+
+static void machine_xen_kexec_cleanup(struct kimage *image)
+{
+	free_transition_pgtable(image);
+}
+
+static void machine_xen_kexec_unload(struct kimage *image)
+{
+	int rc;
+	struct xen_kexec_load xkl = {};
+
+	if (!image)
+		return;
+
+	xkl.type = image->type;
+	rc = HYPERVISOR_kexec_op(KEXEC_CMD_kexec_unload, &xkl);
+
+	WARN(rc, "kexec: %s: HYPERVISOR_kexec_op(): %i\n", __func__, rc);
+}
+
+static void machine_xen_kexec_shutdown(void)
+{
+}
+
+static void machine_xen_kexec(struct kimage *image)
+{
+	int rc;
+	struct xen_kexec_exec xke = {};
+
+	xke.type = image->type;
+	rc = HYPERVISOR_kexec_op(KEXEC_CMD_kexec, &xke);
+
+	pr_emerg("kexec: %s: HYPERVISOR_kexec_op(): %i\n", __func__, rc);
+	BUG();
+}
+
+void __init xen_init_kexec_ops(void)
+{
+	if (!xen_initial_domain())
+		return;
+
+	kexec_ops.always_use_normal_alloc = true;
+	kexec_ops.kimage_alloc_pages = kimage_alloc_pages;
+	kexec_ops.kimage_free_pages = kimage_free_pages;
+	kexec_ops.page_to_pfn = xen_page_to_mfn;
+	kexec_ops.pfn_to_page = xen_mfn_to_page;
+	kexec_ops.virt_to_phys = xen_virt_to_machine;
+	kexec_ops.phys_to_virt = xen_machine_to_virt;
+	kexec_ops.machine_kexec_prepare = machine_xen_kexec_prepare;
+	kexec_ops.machine_kexec_load = machine_xen_kexec_load;
+	kexec_ops.machine_kexec_cleanup = machine_xen_kexec_cleanup;
+	kexec_ops.machine_kexec_unload = machine_xen_kexec_unload;
+	kexec_ops.machine_kexec_shutdown = machine_xen_kexec_shutdown;
+	kexec_ops.machine_kexec = machine_xen_kexec;
+}
diff --git a/arch/x86/xen/relocate_kernel_32.S b/arch/x86/xen/relocate_kernel_32.S
new file mode 100644
index 0000000..0e81830
--- /dev/null
+++ b/arch/x86/xen/relocate_kernel_32.S
@@ -0,0 +1,323 @@
+/*
+ * Copyright (c) 2002-2005 Eric Biederman <ebiederm@xmission.com>
+ * Copyright (c) 2011 Daniel Kiper
+ * Copyright (c) 2012 Daniel Kiper, Oracle Corporation
+ *
+ * kexec/kdump implementation for Xen was written by Daniel Kiper.
+ * Initial work on it was sponsored by Google under Google Summer
+ * of Code 2011 program and Citrix. Konrad Rzeszutek Wilk from Oracle
+ * was the mentor for this project.
+ *
+ * Some ideas are taken from:
+ *   - native kexec/kdump implementation,
+ *   - kexec/kdump implementation for Xen Linux Kernel Ver. 2.6.18,
+ *   - PV-GRUB.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either veesion 2 of the License, or
+ * (at your option) any later veesion.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <asm/cache.h>
+#include <asm/page_types.h>
+#include <asm/pgtable_types.h>
+#include <asm/processor-flags.h>
+
+#include <asm/xen/kexec.h>
+
+#define ARG_INDIRECTION_PAGE	0x4
+#define ARG_PAGE_LIST		0x8
+#define ARG_START_ADDRESS	0xc
+
+#define PTR(x)	(x << 2)
+
+	.text
+	.align	PAGE_SIZE
+	.globl	xen_kexec_control_code_size, xen_relocate_kernel
+
+xen_relocate_kernel:
+	/*
+	 * Must be relocatable PIC code callable as a C function.
+	 *
+	 * This function is called by Xen but here hypervisor is dead.
+	 * We are playing on bare metal.
+	 *
+	 * Every machine address passed to this function through
+	 * page_list (e.g. XK_MA_CONTROL_PAGE) is established
+	 * by dom0 during kexec load phase.
+	 *
+	 * Every virtual address passed to this function through page_list
+	 * (e.g. XK_VA_CONTROL_PAGE) is established by hypervisor during
+	 * HYPERVISOR_kexec_op(KEXEC_CMD_kexec_load) hypercall.
+	 *
+	 * 0x4(%esp) - indirection_page,
+	 * 0x8(%esp) - page_list,
+	 * 0xc(%esp) - start_address,
+	 * 0x10(%esp) - cpu_has_pae (ignored),
+	 * 0x14(%esp) - preserve_context (ignored).
+	 */
+
+	/* Zero out flags, and disable interrupts. */
+	pushl	$0
+	popfl
+
+	/* Get page_list address. */
+	movl	ARG_PAGE_LIST(%esp), %esi
+
+	/*
+	 * Map the control page at its virtual address
+	 * in transition page table.
+	 */
+	movl	PTR(XK_VA_CONTROL_PAGE)(%esi), %eax
+
+	/* Get PGD address and PGD entry index. */
+	movl	PTR(XK_VA_PGD_PAGE)(%esi), %ebx
+	movl	%eax, %ecx
+	shrl	$PGDIR_SHIFT, %ecx
+	andl	$(PTRS_PER_PGD - 1), %ecx
+
+	/* Fill PGD entry with PMD0 reference. */
+	movl	PTR(XK_MA_PMD0_PAGE)(%esi), %edx
+	orl	$_PAGE_PRESENT, %edx
+	movl	%edx, (%ebx, %ecx, 8)
+
+	/* Get PMD0 address and PMD0 entry index. */
+	movl	PTR(XK_VA_PMD0_PAGE)(%esi), %ebx
+	movl	%eax, %ecx
+	shrl	$PMD_SHIFT, %ecx
+	andl	$(PTRS_PER_PMD - 1), %ecx
+
+	/* Fill PMD0 entry with PTE0 reference. */
+	movl	PTR(XK_MA_PTE0_PAGE)(%esi), %edx
+	orl	$_KERNPG_TABLE, %edx
+	movl	%edx, (%ebx, %ecx, 8)
+
+	/* Get PTE0 address and PTE0 entry index. */
+	movl	PTR(XK_VA_PTE0_PAGE)(%esi), %ebx
+	movl	%eax, %ecx
+	shrl	$PAGE_SHIFT, %ecx
+	andl	$(PTRS_PER_PTE - 1), %ecx
+
+	/* Fill PTE0 entry with control page reference. */
+	movl	PTR(XK_MA_CONTROL_PAGE)(%esi), %edx
+	orl	$__PAGE_KERNEL_EXEC, %edx
+	movl	%edx, (%ebx, %ecx, 8)
+
+	/*
+	 * Identity map the control page at its machine address
+	 * in transition page table.
+	 */
+	movl	PTR(XK_MA_CONTROL_PAGE)(%esi), %eax
+
+	/* Get PGD address and PGD entry index. */
+	movl	PTR(XK_VA_PGD_PAGE)(%esi), %ebx
+	movl	%eax, %ecx
+	shrl	$PGDIR_SHIFT, %ecx
+	andl	$(PTRS_PER_PGD - 1), %ecx
+
+	/* Fill PGD entry with PMD1 reference. */
+	movl	PTR(XK_MA_PMD1_PAGE)(%esi), %edx
+	orl	$_PAGE_PRESENT, %edx
+	movl	%edx, (%ebx, %ecx, 8)
+
+	/* Get PMD1 address and PMD1 entry index. */
+	movl	PTR(XK_VA_PMD1_PAGE)(%esi), %ebx
+	movl	%eax, %ecx
+	shrl	$PMD_SHIFT, %ecx
+	andl	$(PTRS_PER_PMD - 1), %ecx
+
+	/* Fill PMD1 entry with PTE1 reference. */
+	movl	PTR(XK_MA_PTE1_PAGE)(%esi), %edx
+	orl	$_KERNPG_TABLE, %edx
+	movl	%edx, (%ebx, %ecx, 8)
+
+	/* Get PTE1 address and PTE1 entry index. */
+	movl	PTR(XK_VA_PTE1_PAGE)(%esi), %ebx
+	movl	%eax, %ecx
+	shrl	$PAGE_SHIFT, %ecx
+	andl	$(PTRS_PER_PTE - 1), %ecx
+
+	/* Fill PTE1 entry with control page reference. */
+	movl	PTR(XK_MA_CONTROL_PAGE)(%esi), %edx
+	orl	$__PAGE_KERNEL_EXEC, %edx
+	movl	%edx, (%ebx, %ecx, 8)
+
+	/*
+	 * Get machine address of control page now.
+	 * This is impossible after page table switch.
+	 */
+	movl	PTR(XK_MA_CONTROL_PAGE)(%esi), %ebx
+
+	/* Get machine address of transition page table now too. */
+	movl	PTR(XK_MA_PGD_PAGE)(%esi), %ecx
+
+	/* Get start_address too. */
+	movl	ARG_START_ADDRESS(%esp), %edx
+
+	/* Get indirection_page address too. */
+	movl	ARG_INDIRECTION_PAGE(%esp), %edi
+
+	/* Switch to transition page table. */
+	movl	%ecx, %cr3
+
+	/* Load IDT. */
+	lidtl	(idt_48 - xen_relocate_kernel)(%ebx)
+
+	/* Load GDT. */
+	leal	(gdt - xen_relocate_kernel)(%ebx), %eax
+	movl	%eax, (gdt_48 - xen_relocate_kernel + 2)(%ebx)
+	lgdtl	(gdt_48 - xen_relocate_kernel)(%ebx)
+
+	/* Load data segment registers. */
+	movl	$(gdt_ds - gdt), %eax
+	movl	%eax, %ds
+	movl	%eax, %es
+	movl	%eax, %fs
+	movl	%eax, %gs
+	movl	%eax, %ss
+
+	/* Setup a new stack at the end of machine address of control page. */
+	leal	PAGE_SIZE(%ebx), %esp
+
+	/* Store start_address on the stack. */
+	pushl   %edx
+
+	/* Jump to identity mapped page. */
+	pushl	$0
+	pushl	$(gdt_cs - gdt)
+	addl	$(identity_mapped - xen_relocate_kernel), %ebx
+	pushl	%ebx
+	iretl
+
+identity_mapped:
+	/*
+	 * Set %cr0 to a known state:
+	 *   - disable alignment check,
+	 *   - disable floating point emulation,
+	 *   - disable paging,
+	 *   - no task switch,
+	 *   - disable write protect,
+	 *   - enable protected mode.
+	 */
+	movl	%cr0, %eax
+	andl	$~(X86_CR0_AM | X86_CR0_EM | X86_CR0_PG | X86_CR0_TS | X86_CR0_WP), %eax
+	orl	$(X86_CR0_PE), %eax
+	movl	%eax, %cr0
+
+	/* Set %cr4 to a known state. */
+	xorl	%eax, %eax
+	movl	%eax, %cr4
+
+	jmp	1f
+
+1:
+	/* Flush the TLB (needed?). */
+	movl	%eax, %cr3
+
+	/* Do the copies. */
+	movl	%edi, %ecx	/* Put the indirection_page in %ecx. */
+	xorl	%edi, %edi
+	xorl	%esi, %esi
+	jmp	1f
+
+0:
+	/*
+	 * Top, read another doubleword from the indirection page.
+	 * Indirection page is an array which contains source
+	 * and destination address pairs. If all pairs could
+	 * not fit in one page then at the end of given
+	 * indirection page is pointer to next one.
+	 * Copy is stopped when done indicator
+	 * is found in indirection page.
+	 */
+	movl	(%ebx), %ecx
+	addl	$4, %ebx
+
+1:
+	testl	$0x1, %ecx	/* Is it a destination page? */
+	jz	2f
+
+	movl	%ecx, %edi
+	andl	$PAGE_MASK, %edi
+	jmp	0b
+
+2:
+	testl	$0x2, %ecx	/* Is it an indirection page? */
+	jz	2f
+
+	movl	%ecx, %ebx
+	andl	$PAGE_MASK, %ebx
+	jmp	0b
+
+2:
+	testl	$0x4, %ecx	/* Is it the done indicator? */
+	jz	2f
+	jmp	3f
+
+2:
+	testl	$0x8, %ecx	/* Is it the source indicator? */
+	jz	0b		/* Ignore it otherwise. */
+
+	movl	%ecx, %esi
+	andl	$PAGE_MASK, %esi
+	movl	$1024, %ecx
+
+	/* Copy page. */
+	rep	movsl
+	jmp	0b
+
+3:
+	/*
+	 * To be certain of avoiding problems with self-modifying code
+	 * I need to execute a serializing instruction here.
+	 * So I flush the TLB by reloading %cr3 here, it's handy,
+	 * and not processor dependent.
+	 */
+	xorl	%eax, %eax
+	movl	%eax, %cr3
+
+	/*
+	 * Set all of the registers to known values.
+	 * Leave %esp alone.
+	 */
+	xorl	%ebx, %ebx
+	xorl    %ecx, %ecx
+	xorl    %edx, %edx
+	xorl    %esi, %esi
+	xorl    %edi, %edi
+	xorl    %ebp, %ebp
+
+	/* Jump to start_address. */
+	retl
+
+	.align	L1_CACHE_BYTES
+
+gdt:
+	.quad	0x0000000000000000	/* NULL descriptor. */
+
+gdt_cs:
+	.quad	0x00cf9a000000ffff	/* 4 GiB code segment at 0x00000000. */
+
+gdt_ds:
+	.quad	0x00cf92000000ffff	/* 4 GiB data segment at 0x00000000. */
+gdt_end:
+
+gdt_48:
+	.word	gdt_end - gdt - 1	/* GDT limit. */
+	.long	0			/* GDT base - filled in by code above. */
+
+idt_48:
+	.word	0			/* IDT limit. */
+	.long	0			/* IDT base. */
+
+xen_kexec_control_code_size:
+	.long	. - xen_relocate_kernel
-- 
1.5.6.5

