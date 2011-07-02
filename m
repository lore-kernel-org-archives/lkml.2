Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab1GBRoM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 13:44:12 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:56148 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab1GBRoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 13:44:11 -0400
From: Matthieu CASTET <castet.matthieu@free.fr>
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, x86@kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthieu CASTET <castet.matthieu@free.fr>
Subject: [PATCH 1/2] merge 32 and 64 realmode wakeup code
Date: Sat,  2 Jul 2011 19:43:40 +0200
Message-Id: <1309628621-23107-1-git-send-email-castet.matthieu@free.fr>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- this mean less ifdef in code
- we could remove now unused field in wakeup_header (pmode_*)

Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
---
 arch/x86/kernel/acpi/realmode/wakeup.S |   26 --------------------------
 arch/x86/kernel/acpi/sleep.c           |   27 ++++++++++-----------------
 arch/x86/kernel/trampoline_32.S        |    4 ----
 3 files changed, 10 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kernel/acpi/realmode/wakeup.S b/arch/x86/kernel/acpi/realmode/wakeup.S
index ead21b6..150a734 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.S
+++ b/arch/x86/kernel/acpi/realmode/wakeup.S
@@ -93,36 +93,10 @@ wakeup_code:
 
 	/* Do any other stuff... */
 
-#ifndef CONFIG_64BIT
-	/* This could also be done in C code... */
-	movl	pmode_cr3, %eax
-	movl	%eax, %cr3
-
-	movl	pmode_cr4, %ecx
-	jecxz	1f
-	movl	%ecx, %cr4
-1:
-	movl	pmode_efer, %eax
-	movl	pmode_efer + 4, %edx
-	movl	%eax, %ecx
-	orl	%edx, %ecx
-	jz	1f
-	movl	$MSR_EFER, %ecx
-	wrmsr
-1:
-
-	lgdtl	pmode_gdt
-
-	/* This really couldn't... */
-	movl	pmode_cr0, %eax
-	movl	%eax, %cr0
-	jmp	pmode_return
-#else
 	pushw	$0
 	pushw	trampoline_segment
 	pushw	$0
 	lret
-#endif
 
 bogus_real_magic:
 1:
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 18a857b..96719ad 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -20,7 +20,7 @@
 
 unsigned long acpi_realmode_flags;
 
-#if defined(CONFIG_SMP) && defined(CONFIG_64BIT)
+#ifdef CONFIG_SMP
 static char temp_stack[4096];
 #endif
 
@@ -67,34 +67,27 @@ int acpi_suspend_lowlevel(void)
 	header->wakeup_gdt[2] =
 		GDT_ENTRY(0x8093, acpi_wakeup_address, 0xfffff);
 
-#ifndef CONFIG_64BIT
-	store_gdt((struct desc_ptr *)&header->pmode_gdt);
-
-	if (rdmsr_safe(MSR_EFER, &header->pmode_efer_low,
-		       &header->pmode_efer_high))
-		header->pmode_efer_low = header->pmode_efer_high = 0;
-#endif /* !CONFIG_64BIT */
-
 	header->pmode_cr0 = read_cr0();
 	header->pmode_cr4 = read_cr4_safe();
 	header->realmode_flags = acpi_realmode_flags;
 	header->real_magic = 0x12345678;
-
-#ifndef CONFIG_64BIT
-	header->pmode_entry = (u32)&wakeup_pmode_return;
-	header->pmode_cr3 = (u32)__pa(&initial_page_table);
-	saved_magic = 0x12345678;
-#else /* CONFIG_64BIT */
 	header->trampoline_segment = trampoline_address() >> 4;
 #ifdef CONFIG_SMP
 	stack_start = (unsigned long)temp_stack + sizeof(temp_stack);
 	early_gdt_descr.address =
 			(unsigned long)get_cpu_gdt_table(smp_processor_id());
+#ifdef CONFIG_64BIT
 	initial_gs = per_cpu_offset(smp_processor_id());
 #endif
+#endif
+
+#ifdef CONFIG_64BIT
 	initial_code = (unsigned long)wakeup_long64;
-       saved_magic = 0x123456789abcdef0L;
-#endif /* CONFIG_64BIT */
+	saved_magic = 0x123456789abcdef0L;
+#else
+	initial_code = (unsigned long)&wakeup_pmode_return;
+	saved_magic = 0x12345678;
+#endif
 
 	do_suspend_lowlevel();
 	return 0;
diff --git a/arch/x86/kernel/trampoline_32.S b/arch/x86/kernel/trampoline_32.S
index 451c0a7..a726f60 100644
--- a/arch/x86/kernel/trampoline_32.S
+++ b/arch/x86/kernel/trampoline_32.S
@@ -32,8 +32,6 @@
 #include <asm/segment.h>
 #include <asm/page_types.h>
 
-#ifdef CONFIG_SMP
-
 	.section ".x86_trampoline","a"
 	.balign PAGE_SIZE
 	.code16
@@ -79,5 +77,3 @@ ENTRY(trampoline_status)
 
 .globl trampoline_end
 trampoline_end:
-
-#endif /* CONFIG_SMP */
-- 
1.7.5.4

