Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab2I0GMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 02:12:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54792 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab2I0GMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 02:12:13 -0400
Date: Wed, 26 Sep 2012 23:11:58 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-73201dbec64aebf6b0dca855b523f437972dc7bb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, rjw@sisk.pl, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, rjw@sisk.pl
In-Reply-To: <1348529239-17943-1-git-send-email-hpa@linux.intel.com>
References: <1348529239-17943-1-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/smap] x86, suspend:
  On wakeup always initialize cr4 and EFER
Git-Commit-ID: 73201dbec64aebf6b0dca855b523f437972dc7bb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 23:12:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  73201dbec64aebf6b0dca855b523f437972dc7bb
Gitweb:     http://git.kernel.org/tip/73201dbec64aebf6b0dca855b523f437972dc7bb
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 26 Sep 2012 15:02:34 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 26 Sep 2012 15:06:22 -0700

x86, suspend: On wakeup always initialize cr4 and EFER

We already have a flag word to indicate the existence of MISC_ENABLES,
so use the same flag word to indicate existence of cr4 and EFER, and
always restore them if they exist.  That way if something passes a
nonzero value when the value *should* be zero, we will still
initialize it.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Link: http://lkml.kernel.org/r/1348529239-17943-1-git-send-email-hpa@linux.intel.com
---
 arch/x86/kernel/acpi/sleep.c      |   15 ++++++++++-----
 arch/x86/realmode/rm/wakeup.h     |    2 ++
 arch/x86/realmode/rm/wakeup_asm.S |   29 +++++++++++++++++++----------
 3 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 1b8e5a0..11676cf 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -43,17 +43,22 @@ int acpi_suspend_lowlevel(void)
 
 	header->video_mode = saved_video_mode;
 
+	header->pmode_behavior = 0;
+
 #ifndef CONFIG_64BIT
 	store_gdt((struct desc_ptr *)&header->pmode_gdt);
 
-	if (rdmsr_safe(MSR_EFER, &header->pmode_efer_low,
-		       &header->pmode_efer_high))
-		header->pmode_efer_low = header->pmode_efer_high = 0;
+	if (!rdmsr_safe(MSR_EFER,
+			&header->pmode_efer_low,
+			&header->pmode_efer_high))
+		header->pmode_behavior |= (1 << WAKEUP_BEHAVIOR_RESTORE_EFER);
 #endif /* !CONFIG_64BIT */
 
 	header->pmode_cr0 = read_cr0();
-	header->pmode_cr4 = read_cr4_safe();
-	header->pmode_behavior = 0;
+	if (__this_cpu_read(cpu_info.cpuid_level) >= 0) {
+		header->pmode_cr4 = read_cr4();
+		header->pmode_behavior |= (1 << WAKEUP_BEHAVIOR_RESTORE_CR4);
+	}
 	if (!rdmsr_safe(MSR_IA32_MISC_ENABLE,
 			&header->pmode_misc_en_low,
 			&header->pmode_misc_en_high))
diff --git a/arch/x86/realmode/rm/wakeup.h b/arch/x86/realmode/rm/wakeup.h
index 9317e00..7dd86a4 100644
--- a/arch/x86/realmode/rm/wakeup.h
+++ b/arch/x86/realmode/rm/wakeup.h
@@ -36,5 +36,7 @@ extern struct wakeup_header wakeup_header;
 
 /* Wakeup behavior bits */
 #define WAKEUP_BEHAVIOR_RESTORE_MISC_ENABLE     0
+#define WAKEUP_BEHAVIOR_RESTORE_CR4		1
+#define WAKEUP_BEHAVIOR_RESTORE_EFER		2
 
 #endif /* ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H */
diff --git a/arch/x86/realmode/rm/wakeup_asm.S b/arch/x86/realmode/rm/wakeup_asm.S
index 8905166..e56479e 100644
--- a/arch/x86/realmode/rm/wakeup_asm.S
+++ b/arch/x86/realmode/rm/wakeup_asm.S
@@ -74,9 +74,18 @@ ENTRY(wakeup_start)
 
 	lidtl	wakeup_idt
 
-	/* Clear the EFLAGS */
-	pushl	$0
+	/* Clear the EFLAGS but remember if we have EFLAGS.ID */
+	movl $X86_EFLAGS_ID, %ecx
+	pushl %ecx
 	popfl
+	pushfl
+	popl %edi
+	pushl $0
+	popfl
+	pushfl
+	popl %edx
+	xorl %edx, %edi
+	andl %ecx, %edi		/* %edi is zero iff CPUID & %cr4 are missing */
 
 	/* Check header signature... */
 	movl	signature, %eax
@@ -93,8 +102,8 @@ ENTRY(wakeup_start)
 
 	/* Restore MISC_ENABLE before entering protected mode, in case
 	   BIOS decided to clear XD_DISABLE during S3. */
-	movl	pmode_behavior, %eax
-	btl	$WAKEUP_BEHAVIOR_RESTORE_MISC_ENABLE, %eax
+	movl	pmode_behavior, %edi
+	btl	$WAKEUP_BEHAVIOR_RESTORE_MISC_ENABLE, %edi
 	jnc	1f
 
 	movl	pmode_misc_en, %eax
@@ -110,15 +119,15 @@ ENTRY(wakeup_start)
 	movl	pmode_cr3, %eax
 	movl	%eax, %cr3
 
-	movl	pmode_cr4, %ecx
-	jecxz	1f
-	movl	%ecx, %cr4
+	btl	$WAKEUP_BEHAVIOR_RESTORE_CR4, %edi
+	jz	1f
+	movl	pmode_cr4, %eax
+	movl	%eax, %cr4
 1:
+	btl	$WAKEUP_BEHAVIOR_RESTORE_EFER, %edi
+	jz	1f
 	movl	pmode_efer, %eax
 	movl	pmode_efer + 4, %edx
-	movl	%eax, %ecx
-	orl	%edx, %ecx
-	jz	1f
 	movl	$MSR_EFER, %ecx
 	wrmsr
 1:
