Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab0F3NY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 09:24:57 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:52726 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab0F3NY4 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Wed, 30 Jun 2010 09:24:56 -0400
Message-Id: <4C2B61E40200007800008D47@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 30 Jun 2010 14:25:24 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: fix unwind annotations in syscall stubs
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the return address removed from the stack, these should really
refer to their caller's register state.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

--- linux-2.6.35-rc3/arch/x86/kernel/entry_64.S
+++ 2.6.35-rc3-x86_64-unwind-annotations/arch/x86/kernel/entry_64.S
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



