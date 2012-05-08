Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab2EHWYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:24:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34550 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab2EHWYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:24:17 -0400
Date: Tue, 8 May 2012 15:24:07 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-968ff9ee56f1e3ed4ff4a6d10185865dc77d8f7e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1336501366-28617-14-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-14-git-send-email-jarkko.sakkinen@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86, realmode:
  Remove indirect jumps in trampoline_32 and wakeup_asm
Git-Commit-ID: 968ff9ee56f1e3ed4ff4a6d10185865dc77d8f7e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 15:24:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  968ff9ee56f1e3ed4ff4a6d10185865dc77d8f7e
Gitweb:     http://git.kernel.org/tip/968ff9ee56f1e3ed4ff4a6d10185865dc77d8f7e
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Tue, 8 May 2012 21:22:36 +0300
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 8 May 2012 11:48:03 -0700

x86, realmode: Remove indirect jumps in trampoline_32 and wakeup_asm

Remove indirect jumps in trampoline_32.S and the 32-bit part of
wakeup_asm.S.  There exist systems which are known to do weird
things if an SMI comes in right after a mode switch, and the
safest way to deal with it is to always follow with a simple
absolute far jump.  In the 64-bit code we then to a register
indirect near jump; follow that pattern for the 32-bit code.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1336501366-28617-14-git-send-email-jarkko.sakkinen@intel.com
---
 arch/x86/realmode/rm/trampoline_32.S     |   22 +++++++++++++---------
 arch/x86/realmode/rm/wakeup/wakeup_asm.S |    8 +++++---
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/x86/realmode/rm/trampoline_32.S b/arch/x86/realmode/rm/trampoline_32.S
index 1f9e331..1315ef4 100644
--- a/arch/x86/realmode/rm/trampoline_32.S
+++ b/arch/x86/realmode/rm/trampoline_32.S
@@ -47,24 +47,29 @@ trampoline_data:
 
 	cli			# We should be safe anyway
 
+	movl	startup_32_smp, %eax	# where we need to go
+
 	movl	$0xA5A5A5A5, trampoline_status
 				# write marker for master knows we're running
 
-	/* GDT tables in non default location kernel can be beyond 16MB and
+	/*
+	 * GDT tables in non default location kernel can be beyond 16MB and
 	 * lgdt will not be able to load the address as in real mode default
 	 * operand size is 16bit. Use lgdtl instead to force operand size
 	 * to 32 bit.
 	 */
-
 	lidtl	boot_idt_descr		# load idt with 0, 0
 	lgdtl	boot_gdt_descr		# load gdt with whatever is appropriate
 
-	xor	%ax, %ax
-	inc	%ax			# protected mode (PE) bit
-	lmsw	%ax			# into protected mode
+	movw	$1, %dx			# protected mode (PE) bit
+	lmsw	%dx			# into protected mode
 
-	# flush prefetch and jump to startup_32_smp in arch/i386/kernel/head.S
-	ljmpl	*(startup_32_smp)
+	ljmpl	$__BOOT_CS, $pa_startup_32
+
+	.section ".text32","ax"
+	.code32
+ENTRY(startup_32)			# note: also used from wakeup_asm.S
+	jmp	*%eax
 
 	.data
 	.globl startup_32_smp, boot_gdt, trampoline_status
@@ -82,5 +87,4 @@ trampoline_status:
 	.long	0
 
 startup_32_smp:
-	.long	0x00000000
-	.word	__BOOT_CS, 0
+	.long	0
diff --git a/arch/x86/realmode/rm/wakeup/wakeup_asm.S b/arch/x86/realmode/rm/wakeup/wakeup_asm.S
index b61126c..4c5c5f2 100644
--- a/arch/x86/realmode/rm/wakeup/wakeup_asm.S
+++ b/arch/x86/realmode/rm/wakeup/wakeup_asm.S
@@ -124,9 +124,11 @@ wakeup_start:
 	lgdtl	pmode_gdt
 
 	/* This really couldn't... */
-	movl	pmode_cr0, %eax
-	movl	%eax, %cr0
-	ljmpl	*pmode_entry
+	movl	pmode_entry, %eax
+	movl	pmode_cr0, %ecx
+	movl	%ecx, %cr0
+	ljmpl	$__KERNEL_CS, $pa_startup_32
+	/* -> jmp *%eax in trampoline_32.S */
 #else
 	jmp	trampoline_data
 #endif
