Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab1ABHWy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:22:54 -0500
Received: from mail.windriver.com ([147.11.1.11]:35106 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab1ABHWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:51 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Roland McGrath <roland@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 079/260] x86-64, compat: Test %rax for the syscall number, not %eax
Date: Sun,  2 Jan 2011 02:16:15 -0500
Message-Id: <1293952756-15010-80-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:34.0836 (UTC) FILETIME=[AFC5A340:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@linux.intel.com>

commit 36d001c70d8a0144ac1d038f6876c484849a74de upstream.

On 64 bits, we always, by necessity, jump through the system call
table via %rax.  For 32-bit system calls, in theory the system call
number is stored in %eax, and the code was testing %eax for a valid
system call number.  At one point we loaded the stored value back from
the stack to enforce zero-extension, but that was removed in checkin
d4d67150165df8bf1cc05e532f6efca96f907cab.  An actual 32-bit process
will not be able to introduce a non-zero-extended number, but it can
happen via ptrace.

Instead of re-introducing the zero-extension, test what we are
actually going to use, i.e. %rax.  This only adds a handful of REX
prefixes to the code.

Reported-by: Ben Hawkes <hawkes@sota.gen.nz>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/ia32/ia32entry.S |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index e790bc1..944e3fc 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -153,7 +153,7 @@ ENTRY(ia32_sysenter_target)
 	testl  $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
 	CFI_REMEMBER_STATE
 	jnz  sysenter_tracesys
-	cmpl	$(IA32_NR_syscalls-1),%eax
+	cmpq	$(IA32_NR_syscalls-1),%rax
 	ja	ia32_badsys
 sysenter_do_call:
 	IA32_ARG_FIXUP
@@ -195,7 +195,7 @@ sysexit_from_sys_call:
 	movl $AUDIT_ARCH_I386,%edi	/* 1st arg: audit arch */
 	call audit_syscall_entry
 	movl RAX-ARGOFFSET(%rsp),%eax	/* reload syscall number */
-	cmpl $(IA32_NR_syscalls-1),%eax
+	cmpq $(IA32_NR_syscalls-1),%rax
 	ja ia32_badsys
 	movl %ebx,%edi			/* reload 1st syscall arg */
 	movl RCX-ARGOFFSET(%rsp),%esi	/* reload 2nd syscall arg */
@@ -248,7 +248,7 @@ sysenter_tracesys:
 	call	syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
-	cmpl	$(IA32_NR_syscalls-1),%eax
+	cmpq	$(IA32_NR_syscalls-1),%rax
 	ja	int_ret_from_sys_call /* sysenter_tracesys has set RAX(%rsp) */
 	jmp	sysenter_do_call
 	CFI_ENDPROC
@@ -314,7 +314,7 @@ ENTRY(ia32_cstar_target)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
 	CFI_REMEMBER_STATE
 	jnz   cstar_tracesys
-	cmpl $IA32_NR_syscalls-1,%eax
+	cmpq $IA32_NR_syscalls-1,%rax
 	ja  ia32_badsys
 cstar_do_call:
 	IA32_ARG_FIXUP 1
@@ -367,7 +367,7 @@ cstar_tracesys:
 	LOAD_ARGS32 ARGOFFSET, 1  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
 	xchgl %ebp,%r9d
-	cmpl $(IA32_NR_syscalls-1),%eax
+	cmpq $(IA32_NR_syscalls-1),%rax
 	ja int_ret_from_sys_call /* cstar_tracesys has set RAX(%rsp) */
 	jmp cstar_do_call
 END(ia32_cstar_target)
@@ -425,7 +425,7 @@ ENTRY(ia32_syscall)
 	orl   $TS_COMPAT,TI_status(%r10)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
 	jnz ia32_tracesys
-	cmpl $(IA32_NR_syscalls-1),%eax
+	cmpq $(IA32_NR_syscalls-1),%rax
 	ja ia32_badsys
 ia32_do_call:
 	IA32_ARG_FIXUP
@@ -444,7 +444,7 @@ ia32_tracesys:
 	call syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
-	cmpl $(IA32_NR_syscalls-1),%eax
+	cmpq $(IA32_NR_syscalls-1),%rax
 	ja  int_ret_from_sys_call	/* ia32_tracesys has set RAX(%rsp) */
 	jmp ia32_do_call
 END(ia32_syscall)
-- 
1.7.3.3

