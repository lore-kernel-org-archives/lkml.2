Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab2I0SWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 14:22:23 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:47488 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab2I0SWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 14:22:20 -0400
X-Greylist: delayed 864 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Sep 2012 14:22:16 EDT
From: Daniel Kiper <daniel.kiper@oracle.com>
To: konrad.wilk@oracle.com, andrew.cooper3@citrix.com, jbeulich@suse.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH 07/11] x86/xen: Add x86_64 kexec/kdump implementation
Date: Thu, 27 Sep 2012 20:06:34 +0200
Message-Id: <1348769198-29580-8-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1348769198-29580-7-git-send-email-daniel.kiper@oracle.com>
References: <1348769198-29580-1-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-2-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-3-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-4-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-5-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-6-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-7-git-send-email-daniel.kiper@oracle.com>
X-Bogosity: No, spamicity=0.001479
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add x86_64 kexec/kdump implementation.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 arch/x86/xen/machine_kexec_64.c   |  301 ++++++++++++++++++++++++++++++++++++
 arch/x86/xen/relocate_kernel_64.S |  309 +++++++++++++++++++++++++++++++++++++
 2 files changed, 610 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/xen/machine_kexec_64.c
 create mode 100644 arch/x86/xen/relocate_kernel_64.S

diff --git a/arch/x86/xen/machine_kexec_64.c b/arch/x86/xen/machine_kexec_64.c
new file mode 100644
index 0000000..f87ffe0
--- /dev/null
+++ b/arch/x86/xen/machine_kexec_64.c
@@ -0,0 +1,301 @@
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
+#include <xen/interface/memory.h>
+#include <xen/xen.h>
+
+#include <asm/xen/hypercall.h>
+#include <asm/xen/kexec.h>
+#include <asm/xen/page.h>
+
+#define __ma(vaddr)	(virt_to_machine(vaddr).maddr)
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
+static void init_level2_page(pmd_t *pmd, unsigned long addr)
+{
+	unsigned long end_addr = addr + PUD_SIZE;
+
+	while (addr < end_addr) {
+		native_set_pmd(pmd++, native_make_pmd(addr | __PAGE_KERNEL_LARGE_EXEC));
+		addr += PMD_SIZE;
+	}
+}
+
+static int init_level3_page(struct kimage *image, pud_t *pud,
+				unsigned long addr, unsigned long last_addr)
+{
+	pmd_t *pmd;
+	struct page *page;
+	unsigned long end_addr = addr + PGDIR_SIZE;
+
+	while ((addr < last_addr) && (addr < end_addr)) {
+		page = kimage_alloc_control_pages(image, 0);
+
+		if (!page)
+			return -ENOMEM;
+
+		pmd = page_address(page);
+		init_level2_page(pmd, addr);
+		native_set_pud(pud++, native_make_pud(__ma(pmd) | _KERNPG_TABLE));
+		addr += PUD_SIZE;
+	}
+
+	/* Clear the unused entries. */
+	while (addr < end_addr) {
+		native_pud_clear(pud++);
+		addr += PUD_SIZE;
+	}
+
+	return 0;
+}
+
+
+static int init_level4_page(struct kimage *image, pgd_t *pgd,
+				unsigned long addr, unsigned long last_addr)
+{
+	int rc;
+	pud_t *pud;
+	struct page *page;
+	unsigned long end_addr = addr + PTRS_PER_PGD * PGDIR_SIZE;
+
+	while ((addr < last_addr) && (addr < end_addr)) {
+		page = kimage_alloc_control_pages(image, 0);
+
+		if (!page)
+			return -ENOMEM;
+
+		pud = page_address(page);
+		rc = init_level3_page(image, pud, addr, last_addr);
+
+		if (rc)
+			return rc;
+
+		native_set_pgd(pgd++, native_make_pgd(__ma(pud) | _KERNPG_TABLE));
+		addr += PGDIR_SIZE;
+	}
+
+	/* Clear the unused entries. */
+	while (addr < end_addr) {
+		native_pgd_clear(pgd++);
+		addr += PGDIR_SIZE;
+	}
+
+	return 0;
+}
+
+static void free_transition_pgtable(struct kimage *image)
+{
+	free_page((unsigned long)image->arch.pgd);
+	free_page((unsigned long)image->arch.pud0);
+	free_page((unsigned long)image->arch.pud1);
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
+	image->arch.pud0 = (pud_t *)get_zeroed_page(GFP_KERNEL);
+
+	if (!image->arch.pud0)
+		goto err;
+
+	image->arch.pud1 = (pud_t *)get_zeroed_page(GFP_KERNEL);
+
+	if (!image->arch.pud1)
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
+static int init_pgtable(struct kimage *image, pgd_t *pgd)
+{
+	int rc;
+	unsigned long max_mfn;
+
+	max_mfn = HYPERVISOR_memory_op(XENMEM_maximum_ram_page, NULL);
+
+	rc = init_level4_page(image, pgd, 0, PFN_PHYS(max_mfn));
+
+	if (rc)
+		return rc;
+
+	return alloc_transition_pgtable(image);
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
+	return init_pgtable(image, page_address(image->control_code_page));
+}
+
+static int machine_xen_kexec_load(struct kimage *image)
+{
+	void *control_page, *table_page;
+	struct xen_kexec_load xkl = {};
+
+	if (!image)
+		return 0;
+
+	table_page = page_address(image->control_code_page);
+	control_page = table_page + PAGE_SIZE;
+
+	memcpy(control_page, xen_relocate_kernel, xen_kexec_control_code_size);
+
+	xkl.type = image->type;
+	xkl.image.page_list[XK_MA_CONTROL_PAGE] = __ma(control_page);
+	xkl.image.page_list[XK_MA_TABLE_PAGE] = __ma(table_page);
+	xkl.image.page_list[XK_MA_PGD_PAGE] = __ma(image->arch.pgd);
+	xkl.image.page_list[XK_MA_PUD0_PAGE] = __ma(image->arch.pud0);
+	xkl.image.page_list[XK_MA_PUD1_PAGE] = __ma(image->arch.pud1);
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
diff --git a/arch/x86/xen/relocate_kernel_64.S b/arch/x86/xen/relocate_kernel_64.S
new file mode 100644
index 0000000..8f641f1
--- /dev/null
+++ b/arch/x86/xen/relocate_kernel_64.S
@@ -0,0 +1,309 @@
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
+#include <asm/page_types.h>
+#include <asm/pgtable_types.h>
+#include <asm/processor-flags.h>
+
+#include <asm/xen/kexec.h>
+
+#define PTR(x)	(x << 3)
+
+	.text
+	.code64
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
+	 * %rdi - indirection_page,
+	 * %rsi - page_list,
+	 * %rdx - start_address,
+	 * %ecx - preserve_context (ignored).
+	 */
+
+	/* Zero out flags, and disable interrupts. */
+	pushq	$0
+	popfq
+
+	/*
+	 * Map the control page at its virtual address
+	 * in transition page table.
+	 */
+	movq	PTR(XK_VA_CONTROL_PAGE)(%rsi), %r8
+
+	/* Get PGD address and PGD entry index. */
+	movq	PTR(XK_VA_PGD_PAGE)(%rsi), %r9
+	movq	%r8, %r10
+	shrq	$PGDIR_SHIFT, %r10
+	andq	$(PTRS_PER_PGD - 1), %r10
+
+	/* Fill PGD entry with PUD0 reference. */
+	movq	PTR(XK_MA_PUD0_PAGE)(%rsi), %r11
+	orq	$_KERNPG_TABLE, %r11
+	movq	%r11, (%r9, %r10, 8)
+
+	/* Get PUD0 address and PUD0 entry index. */
+	movq	PTR(XK_VA_PUD0_PAGE)(%rsi), %r9
+	movq	%r8, %r10
+	shrq	$PUD_SHIFT, %r10
+	andq	$(PTRS_PER_PUD - 1), %r10
+
+	/* Fill PUD0 entry with PMD0 reference. */
+	movq	PTR(XK_MA_PMD0_PAGE)(%rsi), %r11
+	orq	$_KERNPG_TABLE, %r11
+	movq	%r11, (%r9, %r10, 8)
+
+	/* Get PMD0 address and PMD0 entry index. */
+	movq	PTR(XK_VA_PMD0_PAGE)(%rsi), %r9
+	movq	%r8, %r10
+	shrq	$PMD_SHIFT, %r10
+	andq	$(PTRS_PER_PMD - 1), %r10
+
+	/* Fill PMD0 entry with PTE0 reference. */
+	movq	PTR(XK_MA_PTE0_PAGE)(%rsi), %r11
+	orq	$_KERNPG_TABLE, %r11
+	movq	%r11, (%r9, %r10, 8)
+
+	/* Get PTE0 address and PTE0 entry index. */
+	movq	PTR(XK_VA_PTE0_PAGE)(%rsi), %r9
+	movq	%r8, %r10
+	shrq	$PAGE_SHIFT, %r10
+	andq	$(PTRS_PER_PTE - 1), %r10
+
+	/* Fill PTE0 entry with control page reference. */
+	movq	PTR(XK_MA_CONTROL_PAGE)(%rsi), %r11
+	orq	$__PAGE_KERNEL_EXEC, %r11
+	movq	%r11, (%r9, %r10, 8)
+
+	/*
+	 * Identity map the control page at its machine address
+	 * in transition page table.
+	 */
+	movq	PTR(XK_MA_CONTROL_PAGE)(%rsi), %r8
+
+	/* Get PGD address and PGD entry index. */
+	movq	PTR(XK_VA_PGD_PAGE)(%rsi), %r9
+	movq	%r8, %r10
+	shrq	$PGDIR_SHIFT, %r10
+	andq	$(PTRS_PER_PGD - 1), %r10
+
+	/* Fill PGD entry with PUD1 reference. */
+	movq	PTR(XK_MA_PUD1_PAGE)(%rsi), %r11
+	orq	$_KERNPG_TABLE, %r11
+	movq	%r11, (%r9, %r10, 8)
+
+	/* Get PUD1 address and PUD1 entry index. */
+	movq	PTR(XK_VA_PUD1_PAGE)(%rsi), %r9
+	movq	%r8, %r10
+	shrq	$PUD_SHIFT, %r10
+	andq	$(PTRS_PER_PUD - 1), %r10
+
+	/* Fill PUD1 entry with PMD1 reference. */
+	movq	PTR(XK_MA_PMD1_PAGE)(%rsi), %r11
+	orq	$_KERNPG_TABLE, %r11
+	movq	%r11, (%r9, %r10, 8)
+
+	/* Get PMD1 address and PMD1 entry index. */
+	movq	PTR(XK_VA_PMD1_PAGE)(%rsi), %r9
+	movq	%r8, %r10
+	shrq	$PMD_SHIFT, %r10
+	andq	$(PTRS_PER_PMD - 1), %r10
+
+	/* Fill PMD1 entry with PTE1 reference. */
+	movq	PTR(XK_MA_PTE1_PAGE)(%rsi), %r11
+	orq	$_KERNPG_TABLE, %r11
+	movq	%r11, (%r9, %r10, 8)
+
+	/* Get PTE1 address and PTE1 entry index. */
+	movq	PTR(XK_VA_PTE1_PAGE)(%rsi), %r9
+	movq	%r8, %r10
+	shrq	$PAGE_SHIFT, %r10
+	andq	$(PTRS_PER_PTE - 1), %r10
+
+	/* Fill PTE1 entry with control page reference. */
+	movq	PTR(XK_MA_CONTROL_PAGE)(%rsi), %r11
+	orq	$__PAGE_KERNEL_EXEC, %r11
+	movq	%r11, (%r9, %r10, 8)
+
+	/*
+	 * Get machine address of control page now.
+	 * This is impossible after page table switch.
+	 */
+	movq	PTR(XK_MA_CONTROL_PAGE)(%rsi), %r8
+
+	/* Get machine address of identity page table now too. */
+	movq	PTR(XK_MA_TABLE_PAGE)(%rsi), %r9
+
+	/* Get machine address of transition page table now too. */
+	movq	PTR(XK_MA_PGD_PAGE)(%rsi), %r10
+
+	/* Switch to transition page table. */
+	movq	%r10, %cr3
+
+	/* Setup a new stack at the end of machine address of control page. */
+	leaq	PAGE_SIZE(%r8), %rsp
+
+	/* Store start_address on the stack. */
+	pushq   %rdx
+
+	/* Jump to identity mapped page. */
+	addq	$(identity_mapped - xen_relocate_kernel), %r8
+	jmpq	*%r8
+
+identity_mapped:
+	/* Switch to identity page table. */
+	movq	%r9, %cr3
+
+	/*
+	 * Set %cr0 to a known state:
+	 *   - disable alignment check,
+	 *   - disable floating point emulation,
+	 *   - no task switch,
+	 *   - disable write protect,
+	 *   - enable protected mode,
+	 *   - enable paging.
+	 */
+	movq	%cr0, %rax
+	andq	$~(X86_CR0_AM | X86_CR0_EM | X86_CR0_TS | X86_CR0_WP), %rax
+	orl	$(X86_CR0_PE | X86_CR0_PG), %eax
+	movq	%rax, %cr0
+
+	/*
+	 * Set %cr4 to a known state:
+	 *   - enable physical address extension.
+	 */
+	movq	$X86_CR4_PAE, %rax
+	movq	%rax, %cr4
+
+	jmp	1f
+
+1:
+	/* Flush the TLB (needed?). */
+	movq	%r9, %cr3
+
+	/* Do the copies. */
+	movq	%rdi, %rcx	/* Put the indirection_page in %rcx. */
+	xorq	%rdi, %rdi
+	xorq	%rsi, %rsi
+	jmp	1f
+
+0:
+	/*
+	 * Top, read another quadword from the indirection page.
+	 * Indirection page is an array which contains source
+	 * and destination address pairs. If all pairs could
+	 * not fit in one page then at the end of given
+	 * indirection page is pointer to next one.
+	 * Copy is stopped when done indicator
+	 * is found in indirection page.
+	 */
+	movq	(%rbx), %rcx
+	addq	$8, %rbx
+
+1:
+	testq	$0x1, %rcx	/* Is it a destination page? */
+	jz	2f
+
+	movq	%rcx, %rdi
+	andq	$PAGE_MASK, %rdi
+	jmp	0b
+
+2:
+	testq	$0x2, %rcx	/* Is it an indirection page? */
+	jz	2f
+
+	movq	%rcx, %rbx
+	andq	$PAGE_MASK, %rbx
+	jmp	0b
+
+2:
+	testq	$0x4, %rcx	/* Is it the done indicator? */
+	jz	2f
+	jmp	3f
+
+2:
+	testq	$0x8, %rcx	/* Is it the source indicator? */
+	jz	0b		/* Ignore it otherwise. */
+
+	movq	%rcx, %rsi
+	andq	$PAGE_MASK, %rsi
+	movq	$512, %rcx
+
+	/* Copy page. */
+	rep	movsq
+	jmp	0b
+
+3:
+	/*
+	 * To be certain of avoiding problems with self-modifying code
+	 * I need to execute a serializing instruction here.
+	 * So I flush the TLB by reloading %cr3 here, it's handy,
+	 * and not processor dependent.
+	 */
+	movq	%cr3, %rax
+	movq	%rax, %cr3
+
+	/*
+	 * Set all of the registers to known values.
+	 * Leave %rsp alone.
+	 */
+	xorq	%rax, %rax
+	xorq	%rbx, %rbx
+	xorq    %rcx, %rcx
+	xorq    %rdx, %rdx
+	xorq    %rsi, %rsi
+	xorq    %rdi, %rdi
+	xorq    %rbp, %rbp
+	xorq	%r8, %r8
+	xorq	%r9, %r9
+	xorq	%r10, %r10
+	xorq	%r11, %r11
+	xorq	%r12, %r12
+	xorq	%r13, %r13
+	xorq	%r14, %r14
+	xorq	%r15, %r15
+
+	/* Jump to start_address. */
+	retq
+
+xen_kexec_control_code_size:
+	.long	. - xen_relocate_kernel
-- 
1.5.6.5

