Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab1CMWEK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 18:04:10 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:45648 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab1CMWEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 18:04:06 -0400
Message-ID: <4D7D3F4B.2070801@free.fr>
Date: Sun, 13 Mar 2011 23:03:55 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, x86@kernel.org
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/2] merge 32 and 64 realmode wakeup code
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- this mean less ifdef in code
- we could remove now unused field in wakeup_header (pmode_*)

Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
---
 arch/x86/kernel/acpi/realmode/wakeup.S |   26 --------------------------
 arch/x86/kernel/acpi/sleep.c           |   25 +++++++++----------------
 arch/x86/kernel/trampoline_32.S        |    4 ----
 3 files changed, 9 insertions(+), 46 deletions(-)

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
index 4572c58..58a0b4b 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -20,7 +20,7 @@
 
 unsigned long acpi_realmode_flags;
 
-#if defined(CONFIG_SMP) && defined(CONFIG_64BIT)
+#if defined(CONFIG_SMP)
 static char temp_stack[4096];
 #endif
 
@@ -67,33 +67,26 @@ int acpi_save_state_mem(void)
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
+#ifndef CONFIG_64BIT
+	initial_code = (unsigned long)&wakeup_pmode_return;
+	saved_magic = 0x12345678;
+#else
 	initial_code = (unsigned long)wakeup_long64;
-       saved_magic = 0x123456789abcdef0L;
+	saved_magic = 0x123456789abcdef0L;
 #endif /* CONFIG_64BIT */
 
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
1.7.4.1

