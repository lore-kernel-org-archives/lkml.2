Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab2IJWUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 18:20:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847Ab2IJWUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 18:20:15 -0400
From: Mark Salter <msalter@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Mark Salter <msalter@redhat.com>
Subject: [PATCH 1/2] c6x: implement ret_from_kernel_execve() and switch to generic kernel_execve()
Date: Mon, 10 Sep 2012 18:20:02 -0400
Message-Id: <1347315603-30027-2-git-send-email-msalter@redhat.com>
In-Reply-To: <1347315603-30027-1-git-send-email-msalter@redhat.com>
References: <20120907182004.GE13973@ZenIV.linux.org.uk>
 <1347315603-30027-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/include/asm/unistd.h |    2 ++
 arch/c6x/kernel/entry.S       |   31 ++++++++++++++++++++++++-------
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/arch/c6x/include/asm/unistd.h b/arch/c6x/include/asm/unistd.h
index 6d54ea4..1ce3a6f 100644
--- a/arch/c6x/include/asm/unistd.h
+++ b/arch/c6x/include/asm/unistd.h
@@ -16,6 +16,8 @@
 #if !defined(_ASM_C6X_UNISTD_H) || defined(__SYSCALL)
 #define _ASM_C6X_UNISTD_H
 
+#define __ARCH_WANT_KERNEL_EXECVE
+
 /* Use the standard ABI for syscalls. */
 #include <asm-generic/unistd.h>
 
diff --git a/arch/c6x/kernel/entry.S b/arch/c6x/kernel/entry.S
index 30b37e5..693002b 100644
--- a/arch/c6x/kernel/entry.S
+++ b/arch/c6x/kernel/entry.S
@@ -315,6 +315,30 @@ resume_userspace:
  [A0]	BNOP	.S1	work_pending,5
 	BNOP	.S1	restore_all,5
 
+	;; extern void ret_from_kernel_execve(struct pt_regs *normal,
+	;; 				      struct pt_regs *new)
+	;;
+	;; Copy new regs to normal regs.
+	;; Switch stack to normal regs and return to userspace.
+	;;
+ENTRY(ret_from_kernel_execve)
+#ifdef CONFIG_C6X_BIG_KERNEL
+	MVKL	.S2	memmove,B0
+	MVKH	.S2	memmove,B0
+	B	.S2	B0
+#else
+	B	.S2	memmove
+#endif
+	ADDKPC	.S2	0f,B3,2
+	MVK	.S1	REGS__END,A6	; sizeof(struct pt_regs)
+	SUB	.L2X	A4,8,B10	; save new SP in callee-saved reg
+0:
+	BNOP	.S2	resume_userspace,2
+	MV	.S2	B10,SP			; switch stack
+	MVK	.L2	0,B1
+	STW	.D2T2	B1,*+SP(REGS__END+8)	; clear syscall flag
+ENDPROC(ret_from_kernel_execve)
+
 	;;
 	;; System call handling
 	;; B0 = syscall number (in sys_call_table)
@@ -593,13 +617,6 @@ ENTRY(sys_sigaltstack)
 	NOP	4
 ENDPROC(sys_sigaltstack)
 
-	;; kernel_execve
-ENTRY(kernel_execve)
-	MVK	.S2	__NR_execve,B0
-	SWE
-	BNOP	.S2	B3,5
-ENDPROC(kernel_execve)
-
 	;;
 	;; Special system calls
 	;; return address is in B3
-- 
1.7.9.1

