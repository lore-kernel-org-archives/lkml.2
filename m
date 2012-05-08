Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab2EHSXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:23:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:11241 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495Ab2EHSXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:23:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="150637087"
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        Joseph Cihula <joseph.cihula@intel.com>,
        Shane Wang <shane.wang@intel.com>, hpa@linux.intel.com
Subject: [PATCH 13/23] x86, realmode: Remove indirect jumps in trampoline_32 and wakeup_asm
Date: Tue,  8 May 2012 21:22:36 +0300
Message-Id: <1336501366-28617-14-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

Remove indirect jumps in trampoline_32.S and the 32-bit part of
wakeup_asm.S.  There exist systems which are known to do weird
things if an SMI comes in right after a mode switch, and the
safest way to deal with it is to always follow with a simple
absolute far jump.  In the 64-bit code we then to a register
indirect near jump; follow that pattern for the 32-bit code.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
-- 
1.7.9.5

