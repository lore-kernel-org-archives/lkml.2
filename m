Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab0JUNm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:42:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59335 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756475Ab0JUNmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:42:54 -0400
Date: Thu, 21 Oct 2010 15:42:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/debug for v2.6.37
Message-ID: <20101021134243.GA5292@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-debug-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-debug-for-linus

 Thanks,

	Ingo

------------------>
Jan Beulich (5):
      x86-64: Fix unwind annotations in syscall stubs
      x86-64: Adjust frame type at paranoid_exit:
      x86-64: Use symbolics instead of raw numbers in entry_64.S
      i386: Add unwind directives to syscall ptregs stubs
      x86: Use {push,pop}{l,q}_cfi in more places

Jin Dongming (1):
      therm_throt.c: Trivial printk message fix for a unsuitable abbreviation of 'thermal'

Joe Perches (1):
      x86: Remove pr_<level> uses of KERN_<level>


 arch/x86/include/asm/dwarf2.h            |   20 ++
 arch/x86/kernel/apb_timer.c              |    4 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +-
 arch/x86/kernel/entry_32.S               |  310 +++++++++++-------------------
 arch/x86/kernel/entry_64.S               |  108 +++++------
 5 files changed, 177 insertions(+), 267 deletions(-)

diff --git a/arch/x86/include/asm/dwarf2.h b/arch/x86/include/asm/dwarf2.h
index 733f7e9..3260991 100644
--- a/arch/x86/include/asm/dwarf2.h
+++ b/arch/x86/include/asm/dwarf2.h
@@ -89,6 +89,16 @@
 	CFI_ADJUST_CFA_OFFSET -8
 	.endm
 
+	.macro pushfq_cfi
+	pushfq
+	CFI_ADJUST_CFA_OFFSET 8
+	.endm
+
+	.macro popfq_cfi
+	popfq
+	CFI_ADJUST_CFA_OFFSET -8
+	.endm
+
 	.macro movq_cfi reg offset=0
 	movq %\reg, \offset(%rsp)
 	CFI_REL_OFFSET \reg, \offset
@@ -109,6 +119,16 @@
 	CFI_ADJUST_CFA_OFFSET -4
 	.endm
 
+	.macro pushfl_cfi
+	pushfl
+	CFI_ADJUST_CFA_OFFSET 4
+	.endm
+
+	.macro popfl_cfi
+	popfl
+	CFI_ADJUST_CFA_OFFSET -4
+	.endm
+
 	.macro movl_cfi reg offset=0
 	movl %\reg, \offset(%esp)
 	CFI_REL_OFFSET \reg, \offset
diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 8dd7780..4004417 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -398,7 +398,7 @@ static int apbt_cpuhp_notify(struct notifier_block *n,
 		}
 		break;
 	default:
-		pr_debug(KERN_INFO "APBT notified %lu, no action\n", action);
+		pr_debug("APBT notified %lu, no action\n", action);
 	}
 	return NOTIFY_OK;
 }
@@ -552,7 +552,7 @@ bad_count:
 		pr_debug("APB CS going back %lx:%lx:%lx ",
 			 t2, last_read, t2 - last_read);
 bad_count_x3:
-		pr_debug(KERN_INFO "tripple check enforced\n");
+		pr_debug("triple check enforced\n");
 		t0 = apbt_readl(phy_cs_timer_id,
 				APBTMR_N_CURRENT_VALUE);
 		udelay(1);
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index c2a8b26..1d0f743 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -348,7 +348,7 @@ static void intel_thermal_interrupt(void)
 
 static void unexpected_thermal_interrupt(void)
 {
-	printk(KERN_ERR "CPU%d: Unexpected LVT TMR interrupt!\n",
+	printk(KERN_ERR "CPU%d: Unexpected LVT thermal interrupt!\n",
 			smp_processor_id());
 	add_taint(TAINT_MACHINE_CHECK);
 }
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 227d009..9fb188d 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -115,8 +115,7 @@
 
  /* unfortunately push/pop can't be no-op */
 .macro PUSH_GS
-	pushl $0
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi $0
 .endm
 .macro POP_GS pop=0
 	addl $(4 + \pop), %esp
@@ -140,14 +139,12 @@
 #else	/* CONFIG_X86_32_LAZY_GS */
 
 .macro PUSH_GS
-	pushl %gs
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %gs
 	/*CFI_REL_OFFSET gs, 0*/
 .endm
 
 .macro POP_GS pop=0
-98:	popl %gs
-	CFI_ADJUST_CFA_OFFSET -4
+98:	popl_cfi %gs
 	/*CFI_RESTORE gs*/
   .if \pop <> 0
 	add $\pop, %esp
@@ -195,35 +192,25 @@
 .macro SAVE_ALL
 	cld
 	PUSH_GS
-	pushl %fs
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %fs
 	/*CFI_REL_OFFSET fs, 0;*/
-	pushl %es
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %es
 	/*CFI_REL_OFFSET es, 0;*/
-	pushl %ds
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ds
 	/*CFI_REL_OFFSET ds, 0;*/
-	pushl %eax
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %eax
 	CFI_REL_OFFSET eax, 0
-	pushl %ebp
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ebp
 	CFI_REL_OFFSET ebp, 0
-	pushl %edi
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %edi
 	CFI_REL_OFFSET edi, 0
-	pushl %esi
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %esi
 	CFI_REL_OFFSET esi, 0
-	pushl %edx
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %edx
 	CFI_REL_OFFSET edx, 0
-	pushl %ecx
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ecx
 	CFI_REL_OFFSET ecx, 0
-	pushl %ebx
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ebx
 	CFI_REL_OFFSET ebx, 0
 	movl $(__USER_DS), %edx
 	movl %edx, %ds
@@ -234,39 +221,29 @@
 .endm
 
 .macro RESTORE_INT_REGS
-	popl %ebx
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %ebx
 	CFI_RESTORE ebx
-	popl %ecx
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %ecx
 	CFI_RESTORE ecx
-	popl %edx
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %edx
 	CFI_RESTORE edx
-	popl %esi
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %esi
 	CFI_RESTORE esi
-	popl %edi
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %edi
 	CFI_RESTORE edi
-	popl %ebp
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %ebp
 	CFI_RESTORE ebp
-	popl %eax
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %eax
 	CFI_RESTORE eax
 .endm
 
 .macro RESTORE_REGS pop=0
 	RESTORE_INT_REGS
-1:	popl %ds
-	CFI_ADJUST_CFA_OFFSET -4
+1:	popl_cfi %ds
 	/*CFI_RESTORE ds;*/
-2:	popl %es
-	CFI_ADJUST_CFA_OFFSET -4
+2:	popl_cfi %es
 	/*CFI_RESTORE es;*/
-3:	popl %fs
-	CFI_ADJUST_CFA_OFFSET -4
+3:	popl_cfi %fs
 	/*CFI_RESTORE fs;*/
 	POP_GS \pop
 .pushsection .fixup, "ax"
@@ -320,16 +297,12 @@
 
 ENTRY(ret_from_fork)
 	CFI_STARTPROC
-	pushl %eax
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %eax
 	call schedule_tail
 	GET_THREAD_INFO(%ebp)
-	popl %eax
-	CFI_ADJUST_CFA_OFFSET -4
-	pushl $0x0202			# Reset kernel eflags
-	CFI_ADJUST_CFA_OFFSET 4
-	popfl
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %eax
+	pushl_cfi $0x0202		# Reset kernel eflags
+	popfl_cfi
 	jmp syscall_exit
 	CFI_ENDPROC
 END(ret_from_fork)
@@ -409,29 +382,23 @@ sysenter_past_esp:
 	 * enough kernel state to call TRACE_IRQS_OFF can be called - but
 	 * we immediately enable interrupts at that point anyway.
 	 */
-	pushl $(__USER_DS)
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi $(__USER_DS)
 	/*CFI_REL_OFFSET ss, 0*/
-	pushl %ebp
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ebp
 	CFI_REL_OFFSET esp, 0
-	pushfl
+	pushfl_cfi
 	orl $X86_EFLAGS_IF, (%esp)
-	CFI_ADJUST_CFA_OFFSET 4
-	pushl $(__USER_CS)
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi $(__USER_CS)
 	/*CFI_REL_OFFSET cs, 0*/
 	/*
 	 * Push current_thread_info()->sysenter_return to the stack.
 	 * A tiny bit of offset fixup is necessary - 4*4 means the 4 words
 	 * pushed above; +8 corresponds to copy_thread's esp0 setting.
 	 */
-	pushl (TI_sysenter_return-THREAD_SIZE+8+4*4)(%esp)
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi (TI_sysenter_return-THREAD_SIZE+8+4*4)(%esp)
 	CFI_REL_OFFSET eip, 0
 
-	pushl %eax
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %eax
 	SAVE_ALL
 	ENABLE_INTERRUPTS(CLBR_NONE)
 
@@ -486,8 +453,7 @@ sysenter_audit:
 	movl %eax,%edx			/* 2nd arg: syscall number */
 	movl $AUDIT_ARCH_I386,%eax	/* 1st arg: audit arch */
 	call audit_syscall_entry
-	pushl %ebx
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ebx
 	movl PT_EAX(%esp),%eax		/* reload syscall number */
 	jmp sysenter_do_call
 
@@ -529,8 +495,7 @@ ENDPROC(ia32_sysenter_target)
 	# system call handler stub
 ENTRY(system_call)
 	RING0_INT_FRAME			# can't unwind into user space anyway
-	pushl %eax			# save orig_eax
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %eax			# save orig_eax
 	SAVE_ALL
 	GET_THREAD_INFO(%ebp)
 					# system call tracing in operation / emulation
@@ -566,7 +531,6 @@ restore_all_notrace:
 	je ldt_ss			# returning to user-space with LDT SS
 restore_nocheck:
 	RESTORE_REGS 4			# skip orig_eax/error_code
-	CFI_ADJUST_CFA_OFFSET -4
 irq_return:
 	INTERRUPT_RETURN
 .section .fixup,"ax"
@@ -619,10 +583,8 @@ ldt_ss:
 	shr $16, %edx
 	mov %dl, GDT_ESPFIX_SS + 4 /* bits 16..23 */
 	mov %dh, GDT_ESPFIX_SS + 7 /* bits 24..31 */
-	pushl $__ESPFIX_SS
-	CFI_ADJUST_CFA_OFFSET 4
-	push %eax			/* new kernel esp */
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi $__ESPFIX_SS
+	pushl_cfi %eax			/* new kernel esp */
 	/* Disable interrupts, but do not irqtrace this section: we
 	 * will soon execute iret and the tracer was already set to
 	 * the irqstate after the iret */
@@ -666,11 +628,9 @@ work_notifysig:				# deal with pending signals and
 
 	ALIGN
 work_notifysig_v86:
-	pushl %ecx			# save ti_flags for do_notify_resume
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ecx			# save ti_flags for do_notify_resume
 	call save_v86_state		# %eax contains pt_regs pointer
-	popl %ecx
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %ecx
 	movl %eax, %esp
 #else
 	movl %esp, %eax
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
@@ -795,10 +763,8 @@ ptregs_clone:
 	mov GDT_ESPFIX_SS + 7, %ah /* bits 24..31 */
 	shl $16, %eax
 	addl %esp, %eax			/* the adjusted stack pointer */
-	pushl $__KERNEL_DS
-	CFI_ADJUST_CFA_OFFSET 4
-	pushl %eax
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi $__KERNEL_DS
+	pushl_cfi %eax
 	lss (%esp), %esp		/* switch to the normal stack segment */
 	CFI_ADJUST_CFA_OFFSET -8
 .endm
@@ -835,8 +801,7 @@ vector=FIRST_EXTERNAL_VECTOR
       .if vector <> FIRST_EXTERNAL_VECTOR
 	CFI_ADJUST_CFA_OFFSET -4
       .endif
-1:	pushl $(~vector+0x80)	/* Note: always in signed byte range */
-	CFI_ADJUST_CFA_OFFSET 4
+1:	pushl_cfi $(~vector+0x80)	/* Note: always in signed byte range */
       .if ((vector-FIRST_EXTERNAL_VECTOR)%7) <> 6
 	jmp 2f
       .endif
@@ -876,8 +841,7 @@ ENDPROC(common_interrupt)
 #define BUILD_INTERRUPT3(name, nr, fn)	\
 ENTRY(name)				\
 	RING0_INT_FRAME;		\
-	pushl $~(nr);			\
-	CFI_ADJUST_CFA_OFFSET 4;	\
+	pushl_cfi $~(nr);		\
 	SAVE_ALL;			\
 	TRACE_IRQS_OFF			\
 	movl %esp,%eax;			\
@@ -893,21 +857,18 @@ ENDPROC(name)
 
 ENTRY(coprocessor_error)
 	RING0_INT_FRAME
-	pushl $0
-	CFI_ADJUST_CFA_OFFSET 4
-	pushl $do_coprocessor_error
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi $0
+	pushl_cfi $do_coprocessor_error
 	jmp error_code
 	CFI_ENDPROC
 END(coprocessor_error)
 
 ENTRY(simd_coprocessor_error)
 	RING0_INT_FRAME
-	pushl $0
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi $0
 #ifdef CONFIG_X86_INVD_BUG
 	/* AMD 486 bug: invd from userspace calls exception 19 instead of #GP */
-661:	pushl $do_general_protection
+661:	pushl_cfi $do_general_protection
 662:
 .section .altinstructions,"a"
 	.balign 4
@@ -922,19 +883,16 @@ ENTRY(simd_coprocessor_error)
 664:
 .previous
 #else
-	pushl $do_simd_coprocessor_error
+	pushl_cfi $do_simd_coprocessor_error
 #endif
-	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
 END(simd_coprocessor_error)
 
 ENTRY(device_not_available)
 	RING0_INT_FRAME
-	pushl $-1			# mark this as an int
-	CFI_ADJUST_CFA_OFFSET 4
-	pushl $do_device_not_available
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi $-1			# mark this as an int
+	pushl_cfi $do_device_not_available
 	jmp error_code
 	CFI_ENDPROC
 END(device_not_available)
@@ -956,82 +914,68 @@ END(native_irq_enable_sysexit)
 
 ENTRY(overflow)
 	RING0_INT_FRAME
-	pushl $0
-	CFI_ADJUST_CFA_OFFSET 4
-	pushl $do_overflow
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi $0
+	pushl_cfi $do_overflow
 	jmp error_code
 	CFI_ENDPROC
 END(overflow)
 
 ENTRY(bounds)
 	RING0_INT_FRAME
-	pushl $0
-	CFI_ADJUST_CFA_OFFSET 4
-	pushl $do_bounds
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi $0
+	pushl_cfi $do_bounds
 	jmp error_code
 	CFI_ENDPROC
 END(bounds)
 
 ENTRY(invalid_op)
 	RING0_INT_FRAME
-	pushl $0
-	CFI_ADJUST_CFA_OFFSET 4
-	pushl $do_invalid_op
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi $0
+	pushl_cfi $do_invalid_op
 	jmp error_code
 	CFI_ENDPROC
 END(invalid_op)
 
 ENTRY(coprocessor_segment_overrun)
 	RING0_INT_FRAME
-	pushl $0
-	CFI_ADJUST_CFA_OFFSET 4
-	pushl $do_coprocessor_segment_overrun
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi $0
+	pushl_cfi $do_coprocessor_segment_overrun
 	jmp error_code
 	CFI_ENDPROC
 END(coprocessor_segment_overrun)
 
 ENTRY(invalid_TSS)
 	RING0_EC_FRAME
-	pushl $do_invalid_TSS
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi $do_invalid_TSS
 	jmp error_code
 	CFI_ENDPROC
 END(invalid_TSS)
 
 ENTRY(segment_not_present)
 	RING0_EC_FRAME
-	pushl $do_segment_not_present
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi $do_segment_not_present
 	jmp error_code
 	CFI_ENDPROC
 END(segment_not_present)
 
 ENTRY(stack_segment)
 	RING0_EC_FRAME
-	pushl $do_stack_segment
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi $do_stack_segment
 	jmp error_code
 	CFI_ENDPROC
 END(stack_segment)
 
 ENTRY(alignment_check)
 	RING0_EC_FRAME
-	pushl $do_alignment_check
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi $do_alignment_check
 	jmp error_code
 	CFI_ENDPROC
 END(alignment_check)
 
 ENTRY(divide_error)
 	RING0_INT_FRAME
-	pushl $0			# no error code
-	CFI_ADJUST_CFA_OFFSET 4
-	pushl $do_divide_error
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi $0			# no error code
+	pushl_cfi $do_divide_error
 	jmp error_code
 	CFI_ENDPROC
 END(divide_error)
@@ -1039,10 +983,8 @@ END(divide_error)
 #ifdef CONFIG_X86_MCE
 ENTRY(machine_check)
 	RING0_INT_FRAME
-	pushl $0
-	CFI_ADJUST_CFA_OFFSET 4
-	pushl machine_check_vector
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi $0
+	pushl_cfi machine_check_vector
 	jmp error_code
 	CFI_ENDPROC
 END(machine_check)
@@ -1050,10 +992,8 @@ END(machine_check)
 
 ENTRY(spurious_interrupt_bug)
 	RING0_INT_FRAME
-	pushl $0
-	CFI_ADJUST_CFA_OFFSET 4
-	pushl $do_spurious_interrupt_bug
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi $0
+	pushl_cfi $do_spurious_interrupt_bug
 	jmp error_code
 	CFI_ENDPROC
 END(spurious_interrupt_bug)
@@ -1084,8 +1024,7 @@ ENTRY(xen_sysenter_target)
 
 ENTRY(xen_hypervisor_callback)
 	CFI_STARTPROC
-	pushl $0
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi $0
 	SAVE_ALL
 	TRACE_IRQS_OFF
 
@@ -1121,23 +1060,20 @@ ENDPROC(xen_hypervisor_callback)
 # We distinguish between categories by maintaining a status value in EAX.
 ENTRY(xen_failsafe_callback)
 	CFI_STARTPROC
-	pushl %eax
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %eax
 	movl $1,%eax
 1:	mov 4(%esp),%ds
 2:	mov 8(%esp),%es
 3:	mov 12(%esp),%fs
 4:	mov 16(%esp),%gs
 	testl %eax,%eax
-	popl %eax
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %eax
 	lea 16(%esp),%esp
 	CFI_ADJUST_CFA_OFFSET -16
 	jz 5f
 	addl $16,%esp
 	jmp iret_exc		# EAX != 0 => Category 2 (Bad IRET)
-5:	pushl $0		# EAX == 0 => Category 1 (Bad segment)
-	CFI_ADJUST_CFA_OFFSET 4
+5:	pushl_cfi $0		# EAX == 0 => Category 1 (Bad segment)
 	SAVE_ALL
 	jmp ret_from_exception
 	CFI_ENDPROC
@@ -1287,40 +1223,29 @@ syscall_table_size=(.-sys_call_table)
 
 ENTRY(page_fault)
 	RING0_EC_FRAME
-	pushl $do_page_fault
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi $do_page_fault
 	ALIGN
 error_code:
 	/* the function address is in %gs's slot on the stack */
-	pushl %fs
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %fs
 	/*CFI_REL_OFFSET fs, 0*/
-	pushl %es
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %es
 	/*CFI_REL_OFFSET es, 0*/
-	pushl %ds
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ds
 	/*CFI_REL_OFFSET ds, 0*/
-	pushl %eax
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %eax
 	CFI_REL_OFFSET eax, 0
-	pushl %ebp
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ebp
 	CFI_REL_OFFSET ebp, 0
-	pushl %edi
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %edi
 	CFI_REL_OFFSET edi, 0
-	pushl %esi
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %esi
 	CFI_REL_OFFSET esi, 0
-	pushl %edx
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %edx
 	CFI_REL_OFFSET edx, 0
-	pushl %ecx
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ecx
 	CFI_REL_OFFSET ecx, 0
-	pushl %ebx
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ebx
 	CFI_REL_OFFSET ebx, 0
 	cld
 	movl $(__KERNEL_PERCPU), %ecx
@@ -1362,12 +1287,9 @@ END(page_fault)
 	movl TSS_sysenter_sp0 + \offset(%esp), %esp
 	CFI_DEF_CFA esp, 0
 	CFI_UNDEFINED eip
-	pushfl
-	CFI_ADJUST_CFA_OFFSET 4
-	pushl $__KERNEL_CS
-	CFI_ADJUST_CFA_OFFSET 4
-	pushl $sysenter_past_esp
-	CFI_ADJUST_CFA_OFFSET 4
+	pushfl_cfi
+	pushl_cfi $__KERNEL_CS
+	pushl_cfi $sysenter_past_esp
 	CFI_REL_OFFSET eip, 0
 .endm
 
@@ -1377,8 +1299,7 @@ ENTRY(debug)
 	jne debug_stack_correct
 	FIX_STACK 12, debug_stack_correct, debug_esp_fix_insn
 debug_stack_correct:
-	pushl $-1			# mark this as an int
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi $-1			# mark this as an int
 	SAVE_ALL
 	TRACE_IRQS_OFF
 	xorl %edx,%edx			# error code 0
@@ -1398,32 +1319,27 @@ END(debug)
  */
 ENTRY(nmi)
 	RING0_INT_FRAME
-	pushl %eax
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %eax
 	movl %ss, %eax
 	cmpw $__ESPFIX_SS, %ax
-	popl %eax
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %eax
 	je nmi_espfix_stack
 	cmpl $ia32_sysenter_target,(%esp)
 	je nmi_stack_fixup
-	pushl %eax
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %eax
 	movl %esp,%eax
 	/* Do not access memory above the end of our stack page,
 	 * it might not exist.
 	 */
 	andl $(THREAD_SIZE-1),%eax
 	cmpl $(THREAD_SIZE-20),%eax
-	popl %eax
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %eax
 	jae nmi_stack_correct
 	cmpl $ia32_sysenter_target,12(%esp)
 	je nmi_debug_stack_check
 nmi_stack_correct:
 	/* We have a RING0_INT_FRAME here */
-	pushl %eax
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %eax
 	SAVE_ALL
 	xorl %edx,%edx		# zero error code
 	movl %esp,%eax		# pt_regs pointer
@@ -1452,18 +1368,14 @@ nmi_espfix_stack:
 	 *
 	 * create the pointer to lss back
 	 */
-	pushl %ss
-	CFI_ADJUST_CFA_OFFSET 4
-	pushl %esp
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ss
+	pushl_cfi %esp
 	addl $4, (%esp)
 	/* copy the iret frame of 12 bytes */
 	.rept 3
-	pushl 16(%esp)
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi 16(%esp)
 	.endr
-	pushl %eax
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %eax
 	SAVE_ALL
 	FIXUP_ESPFIX_STACK		# %eax == %esp
 	xorl %edx,%edx			# zero error code
@@ -1477,8 +1389,7 @@ END(nmi)
 
 ENTRY(int3)
 	RING0_INT_FRAME
-	pushl $-1			# mark this as an int
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi $-1			# mark this as an int
 	SAVE_ALL
 	TRACE_IRQS_OFF
 	xorl %edx,%edx		# zero error code
@@ -1490,8 +1401,7 @@ END(int3)
 
 ENTRY(general_protection)
 	RING0_EC_FRAME
-	pushl $do_general_protection
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi $do_general_protection
 	jmp error_code
 	CFI_ENDPROC
 END(general_protection)
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 17be5ec..8851a2b 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -213,23 +213,17 @@ ENDPROC(native_usergs_sysret64)
 	.macro FAKE_STACK_FRAME child_rip
 	/* push in order ss, rsp, eflags, cs, rip */
 	xorl %eax, %eax
-	pushq $__KERNEL_DS /* ss */
-	CFI_ADJUST_CFA_OFFSET	8
+	pushq_cfi $__KERNEL_DS /* ss */
 	/*CFI_REL_OFFSET	ss,0*/
-	pushq %rax /* rsp */
-	CFI_ADJUST_CFA_OFFSET	8
+	pushq_cfi %rax /* rsp */
 	CFI_REL_OFFSET	rsp,0
-	pushq $X86_EFLAGS_IF /* eflags - interrupts on */
-	CFI_ADJUST_CFA_OFFSET	8
+	pushq_cfi $X86_EFLAGS_IF /* eflags - interrupts on */
 	/*CFI_REL_OFFSET	rflags,0*/
-	pushq $__KERNEL_CS /* cs */
-	CFI_ADJUST_CFA_OFFSET	8
+	pushq_cfi $__KERNEL_CS /* cs */
 	/*CFI_REL_OFFSET	cs,0*/
-	pushq \child_rip /* rip */
-	CFI_ADJUST_CFA_OFFSET	8
+	pushq_cfi \child_rip /* rip */
 	CFI_REL_OFFSET	rip,0
-	pushq	%rax /* orig rax */
-	CFI_ADJUST_CFA_OFFSET	8
+	pushq_cfi %rax /* orig rax */
 	.endm
 
 	.macro UNFAKE_STACK_FRAME
@@ -398,10 +392,8 @@ ENTRY(ret_from_fork)
 
 	LOCK ; btr $TIF_FORK,TI_flags(%r8)
 
-	push kernel_eflags(%rip)
-	CFI_ADJUST_CFA_OFFSET 8
-	popf					# reset kernel eflags
-	CFI_ADJUST_CFA_OFFSET -8
+	pushq_cfi kernel_eflags(%rip)
+	popfq_cfi				# reset kernel eflags
 
 	call schedule_tail			# rdi: 'prev' task parameter
 
@@ -521,11 +513,9 @@ sysret_careful:
 	jnc sysret_signal
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
-	pushq %rdi
-	CFI_ADJUST_CFA_OFFSET 8
+	pushq_cfi %rdi
 	call schedule
-	popq  %rdi
-	CFI_ADJUST_CFA_OFFSET -8
+	popq_cfi %rdi
 	jmp sysret_check
 
 	/* Handle a signal */
@@ -634,11 +624,9 @@ int_careful:
 	jnc  int_very_careful
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
-	pushq %rdi
-	CFI_ADJUST_CFA_OFFSET 8
+	pushq_cfi %rdi
 	call schedule
-	popq %rdi
-	CFI_ADJUST_CFA_OFFSET -8
+	popq_cfi %rdi
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	jmp int_with_check
@@ -652,12 +640,10 @@ int_check_syscall_exit_work:
 	/* Check for syscall exit trace */
 	testl $_TIF_WORK_SYSCALL_EXIT,%edx
 	jz int_signal
-	pushq %rdi
-	CFI_ADJUST_CFA_OFFSET 8
+	pushq_cfi %rdi
 	leaq 8(%rsp),%rdi	# &ptregs -> arg1
 	call syscall_trace_leave
-	popq %rdi
-	CFI_ADJUST_CFA_OFFSET -8
+	popq_cfi %rdi
 	andl $~(_TIF_WORK_SYSCALL_EXIT|_TIF_SYSCALL_EMU),%edi
 	jmp int_restore_rest
 
@@ -714,9 +700,8 @@ END(ptregscall_common)
 
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
@@ -735,7 +720,7 @@ END(stub_execve)
 ENTRY(stub_rt_sigreturn)
 	CFI_STARTPROC
 	addq $8, %rsp
-	CFI_ADJUST_CFA_OFFSET	-8
+	PARTIAL_FRAME 0
 	SAVE_REST
 	movq %rsp,%rdi
 	FIXUP_TOP_OF_STACK %r11
@@ -766,8 +751,7 @@ vector=FIRST_EXTERNAL_VECTOR
       .if vector <> FIRST_EXTERNAL_VECTOR
 	CFI_ADJUST_CFA_OFFSET -8
       .endif
-1:	pushq $(~vector+0x80)	/* Note: always in signed byte range */
-	CFI_ADJUST_CFA_OFFSET 8
+1:	pushq_cfi $(~vector+0x80)	/* Note: always in signed byte range */
       .if ((vector-FIRST_EXTERNAL_VECTOR)%7) <> 6
 	jmp 2f
       .endif
@@ -796,8 +780,8 @@ END(interrupt)
 
 /* 0(%rsp): ~(interrupt number) */
 	.macro interrupt func
-	subq $10*8, %rsp
-	CFI_ADJUST_CFA_OFFSET 10*8
+	subq $ORIG_RAX-ARGOFFSET+8, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-ARGOFFSET+8
 	call save_args
 	PARTIAL_FRAME 0
 	call \func
@@ -822,6 +806,7 @@ ret_from_intr:
 	TRACE_IRQS_OFF
 	decl PER_CPU_VAR(irq_count)
 	leaveq
+	CFI_RESTORE		rbp
 	CFI_DEF_CFA_REGISTER	rsp
 	CFI_ADJUST_CFA_OFFSET	-8
 exit_intr:
@@ -903,11 +888,9 @@ retint_careful:
 	jnc   retint_signal
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
-	pushq %rdi
-	CFI_ADJUST_CFA_OFFSET	8
+	pushq_cfi %rdi
 	call  schedule
-	popq %rdi
-	CFI_ADJUST_CFA_OFFSET	-8
+	popq_cfi %rdi
 	GET_THREAD_INFO(%rcx)
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
@@ -956,8 +939,7 @@ END(common_interrupt)
 .macro apicinterrupt num sym do_sym
 ENTRY(\sym)
 	INTR_FRAME
-	pushq $~(\num)
-	CFI_ADJUST_CFA_OFFSET 8
+	pushq_cfi $~(\num)
 	interrupt \do_sym
 	jmp ret_from_intr
 	CFI_ENDPROC
@@ -1036,8 +1018,8 @@ ENTRY(\sym)
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
-	subq $15*8,%rsp
-	CFI_ADJUST_CFA_OFFSET 15*8
+	subq $ORIG_RAX-R15, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call error_entry
 	DEFAULT_FRAME 0
 	movq %rsp,%rdi		/* pt_regs pointer */
@@ -1052,9 +1034,9 @@ END(\sym)
 ENTRY(\sym)
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	pushq $-1		/* ORIG_RAX: no syscall to restart */
-	CFI_ADJUST_CFA_OFFSET 8
-	subq $15*8, %rsp
+	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
+	subq $ORIG_RAX-R15, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
 	TRACE_IRQS_OFF
 	movq %rsp,%rdi		/* pt_regs pointer */
@@ -1070,9 +1052,9 @@ END(\sym)
 ENTRY(\sym)
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	pushq $-1		/* ORIG_RAX: no syscall to restart */
-	CFI_ADJUST_CFA_OFFSET 8
-	subq $15*8, %rsp
+	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
+	subq $ORIG_RAX-R15, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
 	TRACE_IRQS_OFF
 	movq %rsp,%rdi		/* pt_regs pointer */
@@ -1089,8 +1071,8 @@ END(\sym)
 ENTRY(\sym)
 	XCPT_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	subq $15*8,%rsp
-	CFI_ADJUST_CFA_OFFSET 15*8
+	subq $ORIG_RAX-R15, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call error_entry
 	DEFAULT_FRAME 0
 	movq %rsp,%rdi			/* pt_regs pointer */
@@ -1107,8 +1089,8 @@ END(\sym)
 ENTRY(\sym)
 	XCPT_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	subq $15*8,%rsp
-	CFI_ADJUST_CFA_OFFSET 15*8
+	subq $ORIG_RAX-R15, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
 	DEFAULT_FRAME 0
 	TRACE_IRQS_OFF
@@ -1139,16 +1121,14 @@ zeroentry simd_coprocessor_error do_simd_coprocessor_error
 	/* edi:  new selector */
 ENTRY(native_load_gs_index)
 	CFI_STARTPROC
-	pushf
-	CFI_ADJUST_CFA_OFFSET 8
+	pushfq_cfi
 	DISABLE_INTERRUPTS(CLBR_ANY & ~CLBR_RDI)
 	SWAPGS
 gs_change:
 	movl %edi,%gs
 2:	mfence		/* workaround */
 	SWAPGS
-	popf
-	CFI_ADJUST_CFA_OFFSET -8
+	popfq_cfi
 	ret
 	CFI_ENDPROC
 END(native_load_gs_index)
@@ -1215,8 +1195,7 @@ END(kernel_execve)
 /* Call softirq on interrupt stack. Interrupts are off. */
 ENTRY(call_softirq)
 	CFI_STARTPROC
-	push %rbp
-	CFI_ADJUST_CFA_OFFSET	8
+	pushq_cfi %rbp
 	CFI_REL_OFFSET rbp,0
 	mov  %rsp,%rbp
 	CFI_DEF_CFA_REGISTER rbp
@@ -1225,6 +1204,7 @@ ENTRY(call_softirq)
 	push  %rbp			# backlink for old unwinder
 	call __do_softirq
 	leaveq
+	CFI_RESTORE		rbp
 	CFI_DEF_CFA_REGISTER	rsp
 	CFI_ADJUST_CFA_OFFSET   -8
 	decl PER_CPU_VAR(irq_count)
@@ -1368,7 +1348,7 @@ paranoidzeroentry machine_check *machine_check_vector(%rip)
 
 	/* ebx:	no swapgs flag */
 ENTRY(paranoid_exit)
-	INTR_FRAME
+	DEFAULT_FRAME
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	testl %ebx,%ebx				/* swapgs needed? */
@@ -1445,7 +1425,6 @@ error_swapgs:
 error_sti:
 	TRACE_IRQS_OFF
 	ret
-	CFI_ENDPROC
 
 /*
  * There are two places in the kernel that can potentially fault with
@@ -1470,6 +1449,7 @@ bstep_iret:
 	/* Fix truncated RIP */
 	movq %rcx,RIP+8(%rsp)
 	jmp error_swapgs
+	CFI_ENDPROC
 END(error_entry)
 
 
@@ -1498,8 +1478,8 @@ ENTRY(nmi)
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq_cfi $-1
-	subq $15*8, %rsp
-	CFI_ADJUST_CFA_OFFSET 15*8
+	subq $ORIG_RAX-R15, %rsp
+	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
 	DEFAULT_FRAME 0
 	/* paranoidentry do_nmi, 0; without TRACE_IRQS_OFF */
