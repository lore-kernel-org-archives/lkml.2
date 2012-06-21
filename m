Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017Ab2FURiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 13:38:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51367 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760000Ab2FURh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 13:37:58 -0400
Date: Thu, 21 Jun 2012 10:37:45 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-9751d7627582fc1cc64625d63bde9528c14f1544@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
In-Reply-To: <tip-jopx7y6g6dbcx4tpal8q0jlr@git.kernel.org>
References: <tip-jopx7y6g6dbcx4tpal8q0jlr@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/reboot] x86-64, reboot: Be more paranoid in 64-bit reboot
 =bios
Git-Commit-ID: 9751d7627582fc1cc64625d63bde9528c14f1544
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 21 Jun 2012 10:37:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9751d7627582fc1cc64625d63bde9528c14f1544
Gitweb:     http://git.kernel.org/tip/9751d7627582fc1cc64625d63bde9528c14f1544
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Thu, 21 Jun 2012 10:25:03 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 21 Jun 2012 10:25:03 -0700

x86-64, reboot: Be more paranoid in 64-bit reboot=bios

Be a bit more paranoid in the transition back to 16-bit mode.  In
particular, in case the kernel is residing above the 4 GiB mark,
switch to the trampoline GDT, and make the jump after turning off
paging a far jump.  In theory, none of this should matter, but it is
exactly the kind of things that broken SMM or virtualization software
could trip up on.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/r/tip-jopx7y6g6dbcx4tpal8q0jlr@git.kernel.org
---
 arch/x86/realmode/rm/reboot.S |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/realmode/rm/reboot.S b/arch/x86/realmode/rm/reboot.S
index 6bf8fea..f932ea6 100644
--- a/arch/x86/realmode/rm/reboot.S
+++ b/arch/x86/realmode/rm/reboot.S
@@ -22,14 +22,18 @@
 ENTRY(machine_real_restart_asm)
 
 #ifdef CONFIG_X86_64
+	/* Switch to trampoline GDT as it is guaranteed < 4 GiB */
+	movl	$__KERNEL_DS, %eax
+	movl	%eax, %ds
+	lgdtl	pa_tr_gdt
 
 	/* Disable paging to drop us out of long mode */
 	movl	%cr0, %eax
 	andl	$~X86_CR0_PG, %eax
 	movl	%eax, %cr0
-	jmp	1f	/* "A branch" may be needed here, assume near is OK */
+	ljmpl	$__KERNEL32_CS, $pa_machine_real_restart_paging_off
 
-1:
+GLOBAL(machine_real_restart_paging_off)
 	xorl	%eax, %eax
 	xorl	%edx, %edx
 	movl	$MSR_EFER, %ecx
