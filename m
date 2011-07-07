Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab1GGEzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 00:55:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:43831 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab1GGEze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 00:55:34 -0400
Date: Thu, 7 Jul 2011 04:55:06 GMT
From: tip-bot for Kees Cook <kees.cook@canonical.com>
Message-ID: <tip-7a3136666bc0f0419f7aaa7b1fabb4b0e0a7fb76@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        kees.cook@canonical.com, tglx@linutronix.de, rjw@sisk.pl
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, tglx@linutronix.de, rjw@sisk.pl
In-Reply-To: <20110707011034.GA8523@outflux.net>
References: <20110707011034.GA8523@outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, suspend: Restore MISC_ENABLE MSR in realmode wakeup
Git-Commit-ID: 7a3136666bc0f0419f7aaa7b1fabb4b0e0a7fb76
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Jul 2011 04:55:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a3136666bc0f0419f7aaa7b1fabb4b0e0a7fb76
Gitweb:     http://git.kernel.org/tip/7a3136666bc0f0419f7aaa7b1fabb4b0e0a7fb76
Author:     Kees Cook <kees.cook@canonical.com>
AuthorDate: Wed, 6 Jul 2011 18:10:34 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 6 Jul 2011 20:09:34 -0700

x86, suspend: Restore MISC_ENABLE MSR in realmode wakeup

Some BIOSes will reset the Intel MISC_ENABLE MSR (specifically the
XD_DISABLE bit) when resuming from S3, which can interact poorly with
ebba638ae723d8a8fc2f7abce5ec18b688b791d7. In 32bit PAE mode, this can
lead to a fault when EFER is restored by the kernel wakeup routines,
due to it setting the NX bit for a CPU that (thanks to the BIOS reset)
now incorrectly thinks it lacks the NX feature. (64bit is not affected
because it uses a common CPU bring-up that specifically handles the
XD_DISABLE bit.)

The need for MISC_ENABLE being restored so early is specific to the S3
resume path. Normally, MISC_ENABLE is saved in save_processor_state(),
but this happens after the resume header is created, so just reproduce
the logic here. (acpi_suspend_lowlevel() creates the header, calls
do_suspend_lowlevel, which calls save_processor_state(), so the saved
processor context isn't available during resume header creation.)

[ hpa: Consider for stable if OK in mainline ]

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Link: http://lkml.kernel.org/r/20110707011034.GA8523@outflux.net
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: <stable@kernel.org> 2.6.38+
---
 arch/x86/kernel/acpi/realmode/wakeup.S |   14 ++++++++++++++
 arch/x86/kernel/acpi/realmode/wakeup.h |    6 ++++++
 arch/x86/kernel/acpi/sleep.c           |    6 ++++++
 3 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/acpi/realmode/wakeup.S b/arch/x86/kernel/acpi/realmode/wakeup.S
index ead21b6..b4fd836 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.S
+++ b/arch/x86/kernel/acpi/realmode/wakeup.S
@@ -28,6 +28,8 @@ pmode_cr3:	.long	0	/* Saved %cr3 */
 pmode_cr4:	.long	0	/* Saved %cr4 */
 pmode_efer:	.quad	0	/* Saved EFER */
 pmode_gdt:	.quad	0
+pmode_misc_en:	.quad	0	/* Saved MISC_ENABLE MSR */
+pmode_behavior:	.long	0	/* Wakeup behavior flags */
 realmode_flags:	.long	0
 real_magic:	.long	0
 trampoline_segment:	.word 0
@@ -91,6 +93,18 @@ wakeup_code:
 	/* Call the C code */
 	calll	main
 
+	/* Restore MISC_ENABLE before entering protected mode, in case
+	   BIOS decided to clear XD_DISABLE during S3. */
+	movl	pmode_behavior, %eax
+	btl	$WAKEUP_BEHAVIOR_RESTORE_MISC_ENABLE, %eax
+	jnc	1f
+
+	movl	pmode_misc_en, %eax
+	movl	pmode_misc_en + 4, %edx
+	movl	$MSR_IA32_MISC_ENABLE, %ecx
+	wrmsr
+1:
+
 	/* Do any other stuff... */
 
 #ifndef CONFIG_64BIT
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.h b/arch/x86/kernel/acpi/realmode/wakeup.h
index e1828c0..97a29e1 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.h
+++ b/arch/x86/kernel/acpi/realmode/wakeup.h
@@ -21,6 +21,9 @@ struct wakeup_header {
 	u32 pmode_efer_low;	/* Protected mode EFER */
 	u32 pmode_efer_high;
 	u64 pmode_gdt;
+	u32 pmode_misc_en_low;	/* Protected mode MISC_ENABLE */
+	u32 pmode_misc_en_high;
+	u32 pmode_behavior;	/* Wakeup routine behavior flags */
 	u32 realmode_flags;
 	u32 real_magic;
 	u16 trampoline_segment;	/* segment with trampoline code, 64-bit only */
@@ -39,4 +42,7 @@ extern struct wakeup_header wakeup_header;
 #define WAKEUP_HEADER_SIGNATURE 0x51ee1111
 #define WAKEUP_END_SIGNATURE	0x65a22c82
 
+/* Wakeup behavior bits */
+#define WAKEUP_BEHAVIOR_RESTORE_MISC_ENABLE     0
+
 #endif /* ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H */
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 18a857b..103b6ab 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -77,6 +77,12 @@ int acpi_suspend_lowlevel(void)
 
 	header->pmode_cr0 = read_cr0();
 	header->pmode_cr4 = read_cr4_safe();
+	header->pmode_behavior = 0;
+	if (!rdmsr_safe(MSR_IA32_MISC_ENABLE,
+			&header->pmode_misc_en_low,
+			&header->pmode_misc_en_high))
+		header->pmode_behavior |=
+			(1 << WAKEUP_BEHAVIOR_RESTORE_MISC_ENABLE);
 	header->realmode_flags = acpi_realmode_flags;
 	header->real_magic = 0x12345678;
 
