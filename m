Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab0ICHLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 03:11:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:43121 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832Ab0ICHLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 03:11:42 -0400
Date: Fri, 3 Sep 2010 07:11:22 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@novell.com, heukelum@fastmail.fm, JBeulich@novell.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, JBeulich@novell.com, heukelum@fastmail.fm,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4C7FBA3D0200007800013F61@vpn.id2.novell.com>
References: <4C7FBA3D0200007800013F61@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86-64: Fix unwind annotations in syscall stubs
Message-ID: <tip-e6b04b6b5a3182ae36cf9a69f1aaaee432edc8ad@git.kernel.org>
Git-Commit-ID: e6b04b6b5a3182ae36cf9a69f1aaaee432edc8ad
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 07:11:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6b04b6b5a3182ae36cf9a69f1aaaee432edc8ad
Gitweb:     http://git.kernel.org/tip/e6b04b6b5a3182ae36cf9a69f1aaaee432edc8ad
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Thu, 2 Sep 2010 13:52:45 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Sep 2010 08:14:09 +0200

x86-64: Fix unwind annotations in syscall stubs

With the return address removed from the stack, these should
really refer to their caller's register state.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>
LKML-Reference: <4C7FBA3D0200007800013F61@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/entry_64.S |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 17be5ec..16aeff0 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -714,9 +714,8 @@ END(ptregscall_common)
 
 ENTRY(stub_execve)
 	CFI_STARTPROC
-	popq %r11
-	CFI_ADJUST_CFA_OFFSET -8
-	CFI_REGISTER rip, r11
+	addq $8, %rsp
+	PARTIAL_FRAME 0
 	SAVE_REST
 	FIXUP_TOP_OF_STACK %r11
 	movq %rsp, %rcx
@@ -735,7 +734,7 @@ END(stub_execve)
 ENTRY(stub_rt_sigreturn)
 	CFI_STARTPROC
 	addq $8, %rsp
-	CFI_ADJUST_CFA_OFFSET	-8
+	PARTIAL_FRAME 0
 	SAVE_REST
 	movq %rsp,%rdi
 	FIXUP_TOP_OF_STACK %r11
@@ -1445,7 +1444,6 @@ error_swapgs:
 error_sti:
 	TRACE_IRQS_OFF
 	ret
-	CFI_ENDPROC
 
 /*
  * There are two places in the kernel that can potentially fault with
@@ -1470,6 +1468,7 @@ bstep_iret:
 	/* Fix truncated RIP */
 	movq %rcx,RIP+8(%rsp)
 	jmp error_swapgs
+	CFI_ENDPROC
 END(error_entry)
 
 
