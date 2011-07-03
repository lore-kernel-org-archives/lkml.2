Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab1GCVWc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 17:22:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:52024 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab1GCVW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 17:22:28 -0400
Date: Sun, 3 Jul 2011 21:22:02 GMT
From: tip-bot for Matthieu CASTET <castet.matthieu@free.fr>
Message-ID: <tip-ababf605370b2c67cc6a37305c5fa17469a4e1f1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        castet.matthieu@free.fr, tglx@linutronix.de, hpa@linux.intel.com,
        rjw@sisk.pl
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        castet.matthieu@free.fr, tglx@linutronix.de, rjw@sisk.pl,
        hpa@linux.intel.com
In-Reply-To: <1309628621-23107-1-git-send-email-castet.matthieu@free.fr>
References: <1309628621-23107-1-git-send-email-castet.matthieu@free.fr>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86, suspend: Merge 32- and 64-bit realmode wakeup code
Git-Commit-ID: ababf605370b2c67cc6a37305c5fa17469a4e1f1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 03 Jul 2011 21:22:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ababf605370b2c67cc6a37305c5fa17469a4e1f1
Gitweb:     http://git.kernel.org/tip/ababf605370b2c67cc6a37305c5fa17469a4e1f1
Author:     Matthieu CASTET <castet.matthieu@free.fr>
AuthorDate: Sat, 2 Jul 2011 19:43:40 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 3 Jul 2011 11:45:44 -0700

x86, suspend: Merge 32- and 64-bit realmode wakeup code

- this mean less ifdef in code
- we could remove now unused field in wakeup_header (pmode_*)

Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Link: http://lkml.kernel.org/r/1309628621-23107-1-git-send-email-castet.matthieu@free.fr
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
