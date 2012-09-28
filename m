Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032138Ab2I1UYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:24:01 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:46787 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032118Ab2I1UX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:23:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Murali Nalajala <mnalajal@codeaurora.org>,
        Nicolas Pitre <nico@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 046/218] ARM: Fix ioremap() of address zero
Date: Fri, 28 Sep 2012 13:14:23 -0700
Message-Id: <20120928201506.751821275@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit a849088aa1552b1a28eea3daff599ee22a734ae3 upstream.

Murali Nalajala reports a regression that ioremapping address zero
results in an oops dump:

Unable to handle kernel paging request at virtual address fa200000
pgd = d4f80000
[fa200000] *pgd=00000000
Internal error: Oops: 5 [#1] PREEMPT SMP ARM
Modules linked in:
CPU: 0    Tainted: G        W (3.4.0-g3b5f728-00009-g638207a #13)
PC is at msm_pm_config_rst_vector_before_pc+0x8/0x30
LR is at msm_pm_boot_config_before_pc+0x18/0x20
pc : [<c0078f84>]    lr : [<c007903c>]    psr: a0000093
sp : c0837ef0  ip : cfe00000  fp : 0000000d
r10: da7efc17  r9 : 225c4278  r8 : 00000006
r7 : 0003c000  r6 : c085c824  r5 : 00000001  r4 : fa101000
r3 : fa200000  r2 : c095080c  r1 : 002250fc  r0 : 00000000
Flags: NzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM Segment kernel
Control: 10c5387d  Table: 25180059  DAC: 00000015
[<c0078f84>] (msm_pm_config_rst_vector_before_pc+0x8/0x30) from [<c007903c>] (msm_pm_boot_config_before_pc+0x18/0x20)
[<c007903c>] (msm_pm_boot_config_before_pc+0x18/0x20) from [<c007a55c>] (msm_pm_power_collapse+0x410/0xb04)
[<c007a55c>] (msm_pm_power_collapse+0x410/0xb04) from [<c007b17c>] (arch_idle+0x294/0x3e0)
[<c007b17c>] (arch_idle+0x294/0x3e0) from [<c000eed8>] (default_idle+0x18/0x2c)
[<c000eed8>] (default_idle+0x18/0x2c) from [<c000f254>] (cpu_idle+0x90/0xe4)
[<c000f254>] (cpu_idle+0x90/0xe4) from [<c057231c>] (rest_init+0x88/0xa0)
[<c057231c>] (rest_init+0x88/0xa0) from [<c07ff890>] (start_kernel+0x3a8/0x40c)
Code: c0704256 e12fff1e e59f2020 e5923000 (e5930000)

This is caused by the 'reserved' entries which we insert (see
19b52abe3c5d7 - ARM: 7438/1: fill possible PMD empty section gaps)
which get matched for physical address zero.

Resolve this by marking these reserved entries with a different flag.

Tested-by: Murali Nalajala <mnalajal@codeaurora.org>
Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/mm.h  |    3 +++
 arch/arm/mm/mmu.c |    4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/arch/arm/mm/mm.h
+++ b/arch/arm/mm/mm.h
@@ -55,6 +55,9 @@ extern void __flush_dcache_page(struct a
 /* permanent static mappings from iotable_init() */
 #define VM_ARM_STATIC_MAPPING	0x40000000
 
+/* empty mapping */
+#define VM_ARM_EMPTY_MAPPING	0x20000000
+
 /* mapping type (attributes) for permanent static mappings */
 #define VM_ARM_MTYPE(mt)		((mt) << 20)
 #define VM_ARM_MTYPE_MASK	(0x1f << 20)
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -805,7 +805,7 @@ static void __init pmd_empty_section_gap
 	vm = early_alloc_aligned(sizeof(*vm), __alignof__(*vm));
 	vm->addr = (void *)addr;
 	vm->size = SECTION_SIZE;
-	vm->flags = VM_IOREMAP | VM_ARM_STATIC_MAPPING;
+	vm->flags = VM_IOREMAP | VM_ARM_EMPTY_MAPPING;
 	vm->caller = pmd_empty_section_gap;
 	vm_area_add_early(vm);
 }
@@ -818,7 +818,7 @@ static void __init fill_pmd_gaps(void)
 
 	/* we're still single threaded hence no lock needed here */
 	for (vm = vmlist; vm; vm = vm->next) {
-		if (!(vm->flags & VM_ARM_STATIC_MAPPING))
+		if (!(vm->flags & (VM_ARM_STATIC_MAPPING | VM_ARM_EMPTY_MAPPING)))
 			continue;
 		addr = (unsigned long)vm->addr;
 		if (addr < next)


