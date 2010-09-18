Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab0IRTte (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:49:34 -0400
Received: from kroah.org ([198.145.64.141]:51474 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755601Ab0IRTBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:49 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:58 2010
Message-Id: <20100918185958.027321003@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Roland McGrath <roland@redhat.com>
Subject: [061/123] x86-64, compat: Test %rax for the syscall number, not %eax
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=x86-64-compat-test-rax-for-the-syscall-number-not-eax.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/ia32/ia32entry.S |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

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


