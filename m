Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab0IXMeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 08:34:22 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:34182 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab0IXMeV convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Fri, 24 Sep 2010 08:34:21 -0400
Message-Id: <4C9CB7170200007800018D0B@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 24 Sep 2010 13:35:03 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <hpa@zytor.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <akpm@linux-foundation.org>,
        "Roland McGrath" <roland@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: simplify is32entry.S again
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commits 36d001c70d8a0144ac1d038f6876c484849a74de and
eefdca043e8391dcd719711716492063030b55ac fixed the same problem in two
different, redundant of one another ways: Zero-extending the system
call index from 32 to 64 bits and then doing comparison on the 64 bit
register is just pointless.

Undo the second commit completely, as using REX prefixes where needed
produces more efficient code than having an extra instruction in the
stream (no matter how simple it is).

The first commit by itself also did quite a bit more than needed -
comparison on the full 64-bit register is definitely unnecessary in
all paths where the value is known to zero extended from 32 bits
already (in one case this is even directly visible from the patch, as
the zero extending instruction is the immediately preceding one). Undo
those parts of the first commit too.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>

---
 arch/x86/ia32/ia32entry.S |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- linux-2.6.36-rc5/arch/x86/ia32/ia32entry.S
+++ 2.6.36-rc5-x86_64-ia32entry-simplify/arch/x86/ia32/ia32entry.S
@@ -50,12 +50,7 @@
 	/*
 	 * Reload arg registers from stack in case ptrace changed them.
 	 * We don't reload %eax because syscall_trace_enter() returned
-	 * the %rax value we should see.  Instead, we just truncate that
-	 * value to 32 bits again as we did on entry from user mode.
-	 * If it's a new value set by user_regset during entry tracing,
-	 * this matches the normal truncation of the user-mode value.
-	 * If it's -1 to make us punt the syscall, then (u32)-1 is still
-	 * an appropriately invalid value.
+	 * the value it wants us to use in the table lookup.
 	 */
 	.macro LOAD_ARGS32 offset, _r9=0
 	.if \_r9
@@ -65,7 +60,6 @@
 	movl \offset+48(%rsp),%edx
 	movl \offset+56(%rsp),%esi
 	movl \offset+64(%rsp),%edi
-	movl %eax,%eax			/* zero extension */
 	.endm
 	
 	.macro CFI_STARTPROC32 simple
@@ -159,7 +153,7 @@ ENTRY(ia32_sysenter_target)
 	testl  $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
 	CFI_REMEMBER_STATE
 	jnz  sysenter_tracesys
-	cmpq	$(IA32_NR_syscalls-1),%rax
+	cmpl	$(IA32_NR_syscalls-1),%eax
 	ja	ia32_badsys
 sysenter_do_call:
 	IA32_ARG_FIXUP
@@ -201,7 +195,7 @@ sysexit_from_sys_call:
 	movl $AUDIT_ARCH_I386,%edi	/* 1st arg: audit arch */
 	call audit_syscall_entry
 	movl RAX-ARGOFFSET(%rsp),%eax	/* reload syscall number */
-	cmpq $(IA32_NR_syscalls-1),%rax
+	cmpl $(IA32_NR_syscalls-1),%eax
 	ja ia32_badsys
 	movl %ebx,%edi			/* reload 1st syscall arg */
 	movl RCX-ARGOFFSET(%rsp),%esi	/* reload 2nd syscall arg */
@@ -320,7 +314,7 @@ ENTRY(ia32_cstar_target)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
 	CFI_REMEMBER_STATE
 	jnz   cstar_tracesys
-	cmpq $IA32_NR_syscalls-1,%rax
+	cmpl $IA32_NR_syscalls-1,%eax
 	ja  ia32_badsys
 cstar_do_call:
 	IA32_ARG_FIXUP 1
@@ -431,7 +425,7 @@ ENTRY(ia32_syscall)
 	orl   $TS_COMPAT,TI_status(%r10)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
 	jnz ia32_tracesys
-	cmpq $(IA32_NR_syscalls-1),%rax
+	cmpl $(IA32_NR_syscalls-1),%eax
 	ja ia32_badsys
 ia32_do_call:
 	IA32_ARG_FIXUP



