Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab0ICHMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 03:12:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:43181 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab0ICHMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 03:12:50 -0400
Date: Fri, 3 Sep 2010 07:12:27 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@novell.com, heukelum@fastmail.fm, JBeulich@novell.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, JBeulich@novell.com, heukelum@fastmail.fm,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4C7FBCF00200007800013F99@vpn.id2.novell.com>
References: <4C7FBCF00200007800013F99@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] i386: Add unwind directives to syscall ptregs stubs
Message-ID: <tip-a34107b5577968dc53cf9c2195c7c2d4a2caf9ce@git.kernel.org>
Git-Commit-ID: a34107b5577968dc53cf9c2195c7c2d4a2caf9ce
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 07:12:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a34107b5577968dc53cf9c2195c7c2d4a2caf9ce
Gitweb:     http://git.kernel.org/tip/a34107b5577968dc53cf9c2195c7c2d4a2caf9ce
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Thu, 2 Sep 2010 14:04:16 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Sep 2010 08:14:10 +0200

i386: Add unwind directives to syscall ptregs stubs

When these stubs are actual functions (i.e. having a return
instruction) and have stack manipulation instructions in them,
they should also be annotated to allow unwinding through them.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>
LKML-Reference: <4C7FBCF00200007800013F99@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/entry_32.S |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 227d009..d9b950e 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -750,14 +750,18 @@ ptregs_##name: \
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
@@ -772,15 +776,19 @@ PTREGSCALL1(vm86old)
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
