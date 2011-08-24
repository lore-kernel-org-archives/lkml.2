Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab1HXMo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 08:44:29 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:11381 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab1HXMo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 08:44:27 -0400
X-SpamScore: 1
X-BigFish: VPS1(zz98dKzz1202h1082kzz8275bh8275dhz32i668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LQFNDT-02-I0B-02
X-M-MSG: 
Date: Wed, 24 Aug 2011 14:44:19 +0200
From: Borislav Petkov <bp@amd64.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Lutomirski <luto@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: [PATCH] x86, asm: Document some of the syscall asm glue
Message-ID: <20110824124419.GA21066@gere.osrc.amd.com>
References: <4E52EF2A.8060608@zytor.com>
 <CA+55aFx9zRTD72jaztLvyB68ejHcqM3Z3=b+6W64opfYu3ANjA@mail.gmail.com>
 <20110823010146.GY2203@ZenIV.linux.org.uk>
 <20110823011312.GZ2203@ZenIV.linux.org.uk>
 <20110823021717.GA2203@ZenIV.linux.org.uk>
 <20110823061531.GC2203@ZenIV.linux.org.uk>
 <CA+55aFzUAuPEwcvVvuXooWMT6XpDuOjEHi-Ab+SOhZVjfbVYpA@mail.gmail.com>
 <CAObL_7F-E2y_cd1MK4ayBx_CqszrewSrBt6V7=ndVuBQrrmTKQ@mail.gmail.com>
 <CA+55aFwozG02mX5hrjNo4k4i2X2=yNf_dgEnBvv8brYb1q9fDg@mail.gmail.com>
 <20110823173317.GI2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110823173317.GI2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 06:33:17PM +0100, Al Viro wrote:
> 	* asm glue is subtle, evil and doesn't have anywhere near enough
> documentation ;-/

I took the liberty to document some of your asm glue analysis in an
attempt to make the code a bit more understandable. How about the
following:

--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Wed, 24 Aug 2011 14:30:43 +0200
Subject: [PATCH] x86, asm: Document some of the syscall asm glue

Document some of the asm glue around compat SYSCALL32 and do a
whitespace cleanup while at it. See linked thread below for further
reference.

Link: http://lkml.kernel.org/r/20110820011845.GC2203@ZenIV.linux.org.uk
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/ia32/ia32entry.S  |  138 ++++++++++++++++++++++++++-----------------
 arch/x86/kernel/entry_64.S |   19 +++++-
 2 files changed, 98 insertions(+), 59 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index a0e866d..8254432 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -1,16 +1,16 @@
 /*
- * Compatibility mode system call entry point for x86-64. 
- * 		
+ * Compatibility mode system call entry point for x86-64.
+ *
  * Copyright 2000-2002 Andi Kleen, SuSE Labs.
- */		 
+ */
 
 #include <asm/dwarf2.h>
 #include <asm/calling.h>
 #include <asm/asm-offsets.h>
 #include <asm/current.h>
 #include <asm/errno.h>
-#include <asm/ia32_unistd.h>	
-#include <asm/thread_info.h>	
+#include <asm/ia32_unistd.h>
+#include <asm/thread_info.h>
 #include <asm/segment.h>
 #include <asm/irqflags.h>
 #include <linux/linkage.h>
@@ -38,11 +38,11 @@
 	xchg	%ecx,%esi
 	movl	%ebx,%edi
 	movl	%edx,%edx	/* zero extension */
-	.endm 
+	.endm
 
-	/* clobbers %eax */	
+	/* clobbers %eax */
 	.macro  CLEAR_RREGS offset=0, _r9=rax
-	xorl 	%eax,%eax
+	xorl	%eax,%eax
 	movq	%rax,\offset+R11(%rsp)
 	movq	%rax,\offset+R10(%rsp)
 	movq	%\_r9,\offset+R9(%rsp)
@@ -69,7 +69,7 @@
 	movl \offset+64(%rsp),%edi
 	movl %eax,%eax			/* zero extension */
 	.endm
-	
+
 	.macro CFI_STARTPROC32 simple
 	CFI_STARTPROC	\simple
 	CFI_UNDEFINED	r8
@@ -106,14 +106,14 @@ ENDPROC(native_irq_enable_sysexit)
  * %esi Arg4
  * %edi Arg5
  * %ebp user stack
- * 0(%ebp) Arg6	
- * 	
+ * 0(%ebp) Arg6
+ *
  * Interrupts off.
- *	
+ *
  * This is purely a fast path. For anything complicated we use the int 0x80
  * path below.	Set up a complete hardware stack frame to share code
  * with the int 0x80 path.
- */ 	
+ */
 ENTRY(ia32_sysenter_target)
 	CFI_STARTPROC32	simple
 	CFI_SIGNAL_FRAME
@@ -127,7 +127,7 @@ ENTRY(ia32_sysenter_target)
 	 * disabled irqs, here we enable it straight after entry:
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
- 	movl	%ebp,%ebp		/* zero extension */
+	movl	%ebp,%ebp		/* zero extension */
 	pushq_cfi $__USER32_DS
 	/*CFI_REL_OFFSET ss,0*/
 	pushq_cfi %rbp
@@ -144,12 +144,12 @@ ENTRY(ia32_sysenter_target)
 	pushq_cfi %rax
 	cld
 	SAVE_ARGS 0,1,0
- 	/* no need to do an access_ok check here because rbp has been
- 	   32bit zero extended */ 
+	/* no need to do an access_ok check here because rbp has been
+	   32bit zero extended */
 1:	movl	(%rbp),%ebp
- 	.section __ex_table,"a"
- 	.quad 1b,ia32_badarg
- 	.previous	
+	.section __ex_table,"a"
+	.quad 1b,ia32_badarg
+	.previous
 	GET_THREAD_INFO(%r10)
 	orl    $TS_COMPAT,TI_status(%r10)
 	testl  $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
@@ -170,7 +170,7 @@ sysenter_dispatch:
 sysexit_from_sys_call:
 	andl    $~TS_COMPAT,TI_status(%r10)
 	/* clear IF, that popfq doesn't enable interrupts early */
-	andl  $~0x200,EFLAGS-R11(%rsp) 
+	andl  $~0x200,EFLAGS-R11(%rsp)
 	movl	RIP-R11(%rsp),%edx		/* User %eip */
 	CFI_REGISTER rip,rdx
 	RESTORE_ARGS 0,24,0,0,0,0
@@ -260,20 +260,21 @@ ENDPROC(ia32_sysenter_target)
  * Arguments:
  * %eax	System call number.
  * %ebx Arg1
- * %ecx return EIP 
+ * %ecx return EIP
  * %edx Arg3
  * %esi Arg4
  * %edi Arg5
- * %ebp Arg2    [note: not saved in the stack frame, should not be touched]
- * %esp user stack 
+ * %ebp Arg2    [note: not saved in the stack frame, should not be touched
+ *		 because it is callee-saved in 64-bit calling convention]
+ * %esp user stack
  * 0(%esp) Arg6
- * 	
+ *
  * Interrupts off.
- *	
+ *
  * This is purely a fast path. For anything complicated we use the int 0x80
  * path below.	Set up a complete hardware stack frame to share code
- * with the int 0x80 path.	
- */ 	
+ * with the int 0x80 path.
+ */
 ENTRY(ia32_cstar_target)
 	CFI_STARTPROC32	simple
 	CFI_SIGNAL_FRAME
@@ -281,34 +282,57 @@ ENTRY(ia32_cstar_target)
 	CFI_REGISTER	rip,rcx
 	/*CFI_REGISTER	rflags,r11*/
 	SWAPGS_UNSAFE_STACK
+
+	/* stash away usermode stack ptr */
 	movl	%esp,%r8d
 	CFI_REGISTER	rsp,r8
 	movq	PER_CPU_VAR(kernel_stack),%rsp
+
 	/*
 	 * No need to follow this irqs on/off section: the syscall
 	 * disabled irqs and here we enable it straight after entry:
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	SAVE_ARGS 8,0,0
-	movl 	%eax,%eax	/* zero extension */
+	movl	%eax,%eax	/* zero extension */
 	movq	%rax,ORIG_RAX-ARGOFFSET(%rsp)
+
+	/* return-RIP is in %ecx when executing SYSCALL */
 	movq	%rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
-	movq	%rbp,RCX-ARGOFFSET(%rsp) /* this lies slightly to ptrace */
+
+	/*
+	 * Put Arg2 into %rcx pt_regs slot to match kernel syscall
+	 * calling conventions, i.e. what INT80 would expect;
+	 * this lies slightly to ptrace
+	 */
+	movq	%rbp,RCX-ARGOFFSET(%rsp)
 	movl	%ebp,%ecx
 	movq	$__USER32_CS,CS-ARGOFFSET(%rsp)
 	movq	$__USER32_DS,SS-ARGOFFSET(%rsp)
+
+	/* rFLAGS is in %r11 when executing SYSCALL */
 	movq	%r11,EFLAGS-ARGOFFSET(%rsp)
 	/*CFI_REL_OFFSET rflags,EFLAGS-ARGOFFSET*/
-	movq	%r8,RSP-ARGOFFSET(%rsp)	
+
+	/* save usermode stack ptr into pt_regs */
+	movq	%r8,RSP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rsp,RSP-ARGOFFSET
-	/* no need to do an access_ok check here because r8 has been
-	   32bit zero extended */ 
-	/* hardware stack frame is complete now */	
+
+	/*
+	 * Get Arg6 which is on the usermode stack; no need to do an
+	 * access_ok check here because %r8 has been 32bit zero extended.
+	 * hardware stack frame is complete now.
+	 */
 1:	movl	(%r8),%r9d
+
+	/*
+	 * handle pagefaulting when accessing usermode stack by returning
+	 * -EFAULT
+	 */
 	.section __ex_table,"a"
 	.quad 1b,ia32_badarg
-	.previous	
+	.previous
 	GET_THREAD_INFO(%r10)
 	orl   $TS_COMPAT,TI_status(%r10)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
@@ -331,7 +355,7 @@ sysretl_from_sys_call:
 	RESTORE_ARGS 0,-ARG_SKIP,0,0,0
 	movl RIP-ARGOFFSET(%rsp),%ecx
 	CFI_REGISTER rip,rcx
-	movl EFLAGS-ARGOFFSET(%rsp),%r11d	
+	movl EFLAGS-ARGOFFSET(%rsp),%r11d
 	/*CFI_REGISTER rflags,r11*/
 	xorq	%r10,%r10
 	xorq	%r9,%r9
@@ -340,7 +364,7 @@ sysretl_from_sys_call:
 	movl RSP-ARGOFFSET(%rsp),%esp
 	CFI_RESTORE rsp
 	USERGS_SYSRET32
-	
+
 #ifdef CONFIG_AUDITSYSCALL
 cstar_auditsys:
 	CFI_RESTORE_STATE
@@ -358,6 +382,8 @@ cstar_tracesys:
 	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%r10)
 	jz cstar_auditsys
 #endif
+
+	/* put Arg6 into %ebp where ptrace expects it */
 	xchgl %r9d,%ebp
 	SAVE_REST
 	CLEAR_RREGS 0, r9
@@ -366,21 +392,23 @@ cstar_tracesys:
 	call syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET, 1  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
+
+	/* sync back Arg6's possibly changed value where it is expected by C */
 	xchgl %ebp,%r9d
 	cmpq $(IA32_NR_syscalls-1),%rax
 	ja int_ret_from_sys_call /* cstar_tracesys has set RAX(%rsp) */
 	jmp cstar_do_call
 END(ia32_cstar_target)
-				
+
 ia32_badarg:
 	movq $-EFAULT,%rax
 	jmp ia32_sysret
 	CFI_ENDPROC
 
-/* 
- * Emulated IA32 system calls via int 0x80. 
+/*
+ * Emulated IA32 system calls via int 0x80.
  *
- * Arguments:	 
+ * Arguments:
  * %eax	System call number.
  * %ebx Arg1
  * %ecx Arg2
@@ -390,13 +418,13 @@ ia32_badarg:
  * %ebp Arg6    [note: not saved in the stack frame, should not be touched]
  *
  * Notes:
- * Uses the same stack frame as the x86-64 version.	
+ * Uses the same stack frame as the x86-64 version.
  * All registers except %eax must be saved (but ptrace may violate that)
  * Arguments are zero extended. For system calls that want sign extension and
  * take long arguments a wrapper is needed. Most calls can just be called
  * directly.
- * Assumes it is only called from user space and entered with interrupts off.	
- */ 				
+ * Assumes it is only called from user space and entered with interrupts off.
+ */
 
 ENTRY(ia32_syscall)
 	CFI_STARTPROC32	simple
@@ -433,9 +461,9 @@ ia32_sysret:
 	movq %rax,RAX-ARGOFFSET(%rsp)
 ia32_ret_from_sys_call:
 	CLEAR_RREGS -ARGOFFSET
-	jmp int_ret_from_sys_call 
+	jmp int_ret_from_sys_call
 
-ia32_tracesys:			 
+ia32_tracesys:
 	SAVE_REST
 	CLEAR_RREGS
 	movq $-ENOSYS,RAX(%rsp)	/* ptrace can change this for a bad syscall */
@@ -457,13 +485,13 @@ quiet_ni_syscall:
 	movq $-ENOSYS,%rax
 	ret
 	CFI_ENDPROC
-	
+
 	.macro PTREGSCALL label, func, arg
 	.globl \label
 \label:
 	leaq \func(%rip),%rax
 	leaq -ARGOFFSET+8(%rsp),\arg	/* 8 for return address */
-	jmp  ia32_ptregs_common	
+	jmp  ia32_ptregs_common
 	.endm
 
 	CFI_STARTPROC32
@@ -537,7 +565,7 @@ ia32_sys_call_table:
 	.quad quiet_ni_syscall	/* old stty syscall holder */
 	.quad quiet_ni_syscall	/* old gtty syscall holder */
 	.quad sys_access
-	.quad sys_nice	
+	.quad sys_nice
 	.quad quiet_ni_syscall	/* 35 */	/* old ftime syscall holder */
 	.quad sys_sync
 	.quad sys32_kill
@@ -616,7 +644,7 @@ ia32_sys_call_table:
 	.quad stub32_iopl		/* 110 */
 	.quad sys_vhangup
 	.quad quiet_ni_syscall	/* old "idle" system call */
-	.quad sys32_vm86_warning	/* vm86old */ 
+	.quad sys32_vm86_warning	/* vm86old */
 	.quad compat_sys_wait4
 	.quad sys_swapoff		/* 115 */
 	.quad compat_sys_sysinfo
@@ -669,7 +697,7 @@ ia32_sys_call_table:
 	.quad sys_mremap
 	.quad sys_setresuid16
 	.quad sys_getresuid16	/* 165 */
-	.quad sys32_vm86_warning	/* vm86 */ 
+	.quad sys32_vm86_warning	/* vm86 */
 	.quad quiet_ni_syscall	/* query_module */
 	.quad sys_poll
 	.quad compat_sys_nfsservctl
@@ -724,10 +752,10 @@ ia32_sys_call_table:
 	.quad sys_mincore
 	.quad sys_madvise
 	.quad compat_sys_getdents64	/* 220 getdents64 */
-	.quad compat_sys_fcntl64	
+	.quad compat_sys_fcntl64
 	.quad quiet_ni_syscall		/* tux */
-	.quad quiet_ni_syscall    	/* security */
-	.quad sys_gettid	
+	.quad quiet_ni_syscall		/* security */
+	.quad sys_gettid
 	.quad sys32_readahead	/* 225 */
 	.quad sys_setxattr
 	.quad sys_lsetxattr
@@ -742,7 +770,7 @@ ia32_sys_call_table:
 	.quad sys_lremovexattr
 	.quad sys_fremovexattr
 	.quad sys_tkill
-	.quad sys_sendfile64 
+	.quad sys_sendfile64
 	.quad compat_sys_futex		/* 240 */
 	.quad compat_sys_sched_setaffinity
 	.quad compat_sys_sched_getaffinity
@@ -754,7 +782,7 @@ ia32_sys_call_table:
 	.quad compat_sys_io_submit
 	.quad sys_io_cancel
 	.quad sys32_fadvise64		/* 250 */
-	.quad quiet_ni_syscall 	/* free_huge_pages */
+	.quad quiet_ni_syscall	/* free_huge_pages */
 	.quad sys_exit_group
 	.quad sys32_lookup_dcookie
 	.quad sys_epoll_create
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 6419bb0..9569f11 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -607,10 +607,16 @@ tracesys:
 GLOBAL(int_ret_from_sys_call)
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
+
+	/*
+	 * check the Requestor Privilege Level of the CS selector
+	 * previously pushed on the stack. If 0, we're returning
+	 * to kernel space.
+	 */
 	testl $3,CS-ARGOFFSET(%rsp)
 	je retint_restore_args
-	movl $_TIF_ALLWORK_MASK,%edi
 	/* edi:	mask to check */
+	movl $_TIF_ALLWORK_MASK,%edi
 GLOBAL(int_with_check)
 	LOCKDEP_SYS_EXIT_IRQ
 	GET_THREAD_INFO(%rcx)
@@ -618,11 +624,16 @@ GLOBAL(int_with_check)
 	andl %edi,%edx
 	jnz   int_careful
 	andl    $~TS_COMPAT,TI_status(%rcx)
+
+	/* no work pending, return to userspace */
 	jmp   retint_swapgs
 
-	/* Either reschedule or signal or syscall exit tracking needed. */
-	/* First do a reschedule test. */
-	/* edx:	work, edi: workmask */
+	/*
+	 * Either reschedule or signal or syscall exit tracking
+	 * needed. First do a reschedule test.
+	 *
+	 * edx:	work, edi: workmask
+	 */
 int_careful:
 	bt $TIF_NEED_RESCHED,%edx
 	jnc  int_very_careful
-- 
1.7.4


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

