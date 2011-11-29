Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab1K2LYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 06:24:15 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:20499 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab1K2LYO convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Tue, 29 Nov 2011 06:24:14 -0500
Message-Id: <4ED4CEEA020000780006407D@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 29 Nov 2011 11:24:10 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: cleanup some assembly entry points
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

system_call_after_swapgs doesn't really benefit from forcing alignment
from it - quite the opposite, native code needlessly so far got a big
NOP instruction inserted in front of it. Xen being the only user of
the separate entry point can well live with the branch going to three
bytes into a cache line.

The compatibility mode ptregs entry points for one can make use of the
GLOBAL() macro, and should be suitably aligned. Their shared
continuation point (ia32_ptregs_common) otoh doesn't need to be global
at all, but should continue to be properly aligned.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/ia32/ia32entry.S  |    7 ++++---
 arch/x86/kernel/entry_64.S |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

--- 3.2-rc3/arch/x86/ia32/ia32entry.S
+++ 3.2-rc3-x86_64-entry-cleanup/arch/x86/ia32/ia32entry.S
@@ -459,8 +459,8 @@ quiet_ni_syscall:
 	CFI_ENDPROC
 	
 	.macro PTREGSCALL label, func, arg
-	.globl \label
-\label:
+	ALIGN
+GLOBAL(\label)
 	leaq \func(%rip),%rax
 	leaq -ARGOFFSET+8(%rsp),\arg	/* 8 for return address */
 	jmp  ia32_ptregs_common	
@@ -477,7 +477,8 @@ quiet_ni_syscall:
 	PTREGSCALL stub32_vfork, sys_vfork, %rdi
 	PTREGSCALL stub32_iopl, sys_iopl, %rsi
 
-ENTRY(ia32_ptregs_common)
+	ALIGN
+ia32_ptregs_common:
 	popq %r11
 	CFI_ENDPROC
 	CFI_STARTPROC32	simple
--- 3.2-rc3/arch/x86/kernel/entry_64.S
+++ 3.2-rc3-x86_64-entry-cleanup/arch/x86/kernel/entry_64.S
@@ -465,7 +465,7 @@ ENTRY(system_call)
 	 * after the swapgs, so that it can do the swapgs
 	 * for the guest and jump here on syscall.
 	 */
-ENTRY(system_call_after_swapgs)
+GLOBAL(system_call_after_swapgs)
 
 	movq	%rsp,PER_CPU_VAR(old_rsp)
 	movq	PER_CPU_VAR(kernel_stack),%rsp



