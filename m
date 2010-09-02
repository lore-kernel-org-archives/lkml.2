Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab0IBNEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 09:04:20 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:50639 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab0IBNET convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Thu, 2 Sep 2010 09:04:19 -0400
Message-Id: <4C7FBCF00200007800013F99@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 02 Sep 2010 14:04:16 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: add unwind directives to syscall ptregs stubs
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When these stubs are actual functions (i.e. having a return
instruction) and have stack manipulation instructions in them, they
should also be annotated to allow unwinding through them.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/entry_32.S    |  16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- linux-2.6.36-rc3/arch/x86/kernel/entry_32.S
+++ 2.6.36-rc3-x86-push-pop-cfi/arch/x86/kernel/entry_32.S
@@ -750,14 +710,18 @@ ptregs_##name: \
 #define PTREGSCALL3(name) \
 	ALIGN; \
 ptregs_##name: \
+	CFI_STARTPROC; \
 	leal 4(%esp),%eax; \
-	pushl %eax; \
+	pushl_cfi %eax; \
 	movl PT_EDX(%eax),%ecx; \
 	movl PT_ECX(%eax),%edx; \
 	movl PT_EBX(%eax),%eax; \
 	call sys_##name; \
 	addl $4,%esp; \
-	ret
+	CFI_ADJUST_CFA_OFFSET -4; \
+	ret; \
+	CFI_ENDPROC; \
+ENDPROC(ptregs_##name)
 
 PTREGSCALL1(iopl)
 PTREGSCALL0(fork)
@@ -772,15 +736,19 @@ PTREGSCALL1(vm86old)
 /* Clone is an oddball.  The 4th arg is in %edi */
 	ALIGN;
 ptregs_clone:
+	CFI_STARTPROC
 	leal 4(%esp),%eax
-	pushl %eax
-	pushl PT_EDI(%eax)
+	pushl_cfi %eax
+	pushl_cfi PT_EDI(%eax)
 	movl PT_EDX(%eax),%ecx
 	movl PT_ECX(%eax),%edx
 	movl PT_EBX(%eax),%eax
 	call sys_clone
 	addl $8,%esp
+	CFI_ADJUST_CFA_OFFSET -8
 	ret
+	CFI_ENDPROC
+ENDPROC(ptregs_clone)
 
 .macro FIXUP_ESPFIX_STACK
 /*



