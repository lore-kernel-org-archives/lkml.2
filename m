Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab1K2Ky3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 05:54:29 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:7440 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab1K2Ky0 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Tue, 29 Nov 2011 05:54:26 -0500
Message-Id: <4ED4C7EE0200007800064028@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 29 Nov 2011 10:54:22 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: slightly shorten int_ret_from_sys_call
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Testing for a return to ring 0 was necessary here solely because of the
branch out of ret_from_fork. That branch, however, can be directed to
retint_restore_args, and thus the test-and-branch can be eliminated
here.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/kernel/entry_64.S |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- 3.2-rc3/arch/x86/kernel/entry_64.S
+++ 3.2-rc3-x86_64-entry-iret-from-syscall/arch/x86/kernel/entry_64.S
@@ -411,7 +411,7 @@ ENTRY(ret_from_fork)
 	RESTORE_REST
 
 	testl $3, CS-ARGOFFSET(%rsp)		# from kernel_thread?
-	je   int_ret_from_sys_call
+	jz   retint_restore_args
 
 	testl $_TIF_IA32, TI_flags(%rcx)	# 32-bit compat task needs IRET
 	jnz  int_ret_from_sys_call
@@ -612,8 +612,6 @@ tracesys:
 GLOBAL(int_ret_from_sys_call)
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	testl $3,CS-ARGOFFSET(%rsp)
-	je retint_restore_args
 	movl $_TIF_ALLWORK_MASK,%edi
 	/* edi:	mask to check */
 GLOBAL(int_with_check)



