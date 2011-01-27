Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab1A0V4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 16:56:42 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:57911 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab1A0V4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 16:56:40 -0500
Message-ID: <4D41EA12.1030402@free.fr>
Date: Thu, 27 Jan 2011 22:56:34 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [RFC] merge 32/64 bits realmode wakeup code
Content-Type: multipart/mixed;
 boundary="------------020609000400080508010404"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020609000400080508010404
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

this patch merge 32 and 64 realmode wakeup code :
- this mean less ifdef in code
- we could remove now unused field in wakeup_header (pmode_*)
- this allow to set the first 1 MB NX.

Do you think it is safe on all X86 32 bit machine ?

Matthieu


Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>

--------------020609000400080508010404
Content-Type: text/x-diff;
 name="wake32_use_trampoline.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="wake32_use_trampoline.diff"

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3ed5ad9..3baa11c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -219,7 +219,7 @@ config X86_HT
 
 config X86_TRAMPOLINE
 	def_bool y
-	depends on SMP || (64BIT && ACPI_SLEEP)
+	depends on SMP || ACPI_SLEEP
 
 config X86_32_LAZY_GS
 	def_bool y
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.S b/arch/x86/kernel/acpi/realmode/wakeup.S
index 28595d6..2c2d5b8 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.S
+++ b/arch/x86/kernel/acpi/realmode/wakeup.S
@@ -90,36 +90,10 @@ _start:
 
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
index 69fd72a..d32bef9 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -26,7 +26,7 @@ unsigned long acpi_realmode_flags;
 /* address in low memory of the wakeup routine. */
 static unsigned long acpi_realmode;
 
-#if defined(CONFIG_SMP) && defined(CONFIG_64BIT)
+#if defined(CONFIG_SMP)
 static char temp_stack[4096];
 #endif
 
@@ -80,31 +80,24 @@ int acpi_save_state_mem(void)
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
 	header->trampoline_segment = setup_trampoline() >> 4;
 #ifdef CONFIG_SMP
 	stack_start.sp = temp_stack + sizeof(temp_stack);
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
        saved_magic = 0x123456789abcdef0L;
 #endif /* CONFIG_64BIT */
diff --git a/arch/x86/kernel/trampoline_32.S b/arch/x86/kernel/trampoline_32.S
index 8508237..11f0387 100644
--- a/arch/x86/kernel/trampoline_32.S
+++ b/arch/x86/kernel/trampoline_32.S
@@ -32,8 +32,12 @@
 #include <asm/segment.h>
 #include <asm/page_types.h>
 
-/* We can free up trampoline after bootup if cpu hotplug is not supported. */
+#ifdef CONFIG_ACPI_SLEEP
+.section .rodata, "a", @progbits
+#else
+/* We can free up the trampoline after bootup if cpu hotplug is not supported. */
 __CPUINITRODATA
+#endif
 .code16
 
 ENTRY(trampoline_data)

--------------020609000400080508010404--
