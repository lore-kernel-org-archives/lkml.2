Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab1B1R26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 12:28:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:39459 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170Ab1B1R25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 12:28:57 -0500
Date: Mon, 28 Feb 2011 17:28:36 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@novell.com, heukelum@fastmail.fm, JBeulich@novell.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, JBeulich@novell.com, heukelum@fastmail.fm,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4D6BD35002000078000341DA@vpn.id2.novell.com>
References: <4D6BD35002000078000341DA@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Use {push,pop}_cfi in more places
Message-ID: <tip-60cf637a13932a4750da6746efd0199e8a4c341b@git.kernel.org>
Git-Commit-ID: 60cf637a13932a4750da6746efd0199e8a4c341b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 28 Feb 2011 17:28:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60cf637a13932a4750da6746efd0199e8a4c341b
Gitweb:     http://git.kernel.org/tip/60cf637a13932a4750da6746efd0199e8a4c341b
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Mon, 28 Feb 2011 15:54:40 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 28 Feb 2011 18:06:22 +0100

x86: Use {push,pop}_cfi in more places

Cleaning up and shortening code...

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
LKML-Reference: <4D6BD35002000078000341DA@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/ia32/ia32entry.S      |   27 ++++++-----------
 arch/x86/include/asm/frame.h   |    6 +--
 arch/x86/kernel/entry_32.S     |    3 +-
 arch/x86/lib/atomic64_386_32.S |    6 +--
 arch/x86/lib/atomic64_cx8_32.S |    6 +--
 arch/x86/lib/checksum_32.S     |   63 +++++++++++++--------------------------
 arch/x86/lib/semaphore_32.S    |   36 +++++++---------------
 7 files changed, 49 insertions(+), 98 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 518bb99..7c6aabd 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -126,26 +126,20 @@ ENTRY(ia32_sysenter_target)
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
  	movl	%ebp,%ebp		/* zero extension */
-	pushq	$__USER32_DS
-	CFI_ADJUST_CFA_OFFSET 8
+	pushq_cfi $__USER32_DS
 	/*CFI_REL_OFFSET ss,0*/
-	pushq	%rbp
-	CFI_ADJUST_CFA_OFFSET 8
+	pushq_cfi %rbp
 	CFI_REL_OFFSET rsp,0
-	pushfq
-	CFI_ADJUST_CFA_OFFSET 8
+	pushfq_cfi
 	/*CFI_REL_OFFSET rflags,0*/
 	movl	8*3-THREAD_SIZE+TI_sysenter_return(%rsp), %r10d
 	CFI_REGISTER rip,r10
-	pushq	$__USER32_CS
-	CFI_ADJUST_CFA_OFFSET 8
+	pushq_cfi $__USER32_CS
 	/*CFI_REL_OFFSET cs,0*/
 	movl	%eax, %eax
-	pushq	%r10
-	CFI_ADJUST_CFA_OFFSET 8
+	pushq_cfi %r10
 	CFI_REL_OFFSET rip,0
-	pushq	%rax
-	CFI_ADJUST_CFA_OFFSET 8
+	pushq_cfi %rax
 	cld
 	SAVE_ARGS 0,0,1
  	/* no need to do an access_ok check here because rbp has been
@@ -182,11 +176,9 @@ sysexit_from_sys_call:
 	xorq	%r9,%r9
 	xorq	%r10,%r10
 	xorq	%r11,%r11
-	popfq
-	CFI_ADJUST_CFA_OFFSET -8
+	popfq_cfi
 	/*CFI_RESTORE rflags*/
-	popq	%rcx				/* User %esp */
-	CFI_ADJUST_CFA_OFFSET -8
+	popq_cfi %rcx				/* User %esp */
 	CFI_REGISTER rsp,rcx
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS_SYSEXIT32
@@ -421,8 +413,7 @@ ENTRY(ia32_syscall)
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	movl %eax,%eax
-	pushq %rax
-	CFI_ADJUST_CFA_OFFSET 8
+	pushq_cfi %rax
 	cld
 	/* note the registers are not zero extended to the sf.
 	   this could be a problem. */
diff --git a/arch/x86/include/asm/frame.h b/arch/x86/include/asm/frame.h
index 06850a7..2c6fc9e 100644
--- a/arch/x86/include/asm/frame.h
+++ b/arch/x86/include/asm/frame.h
@@ -7,14 +7,12 @@
    frame pointer later */
 #ifdef CONFIG_FRAME_POINTER
 	.macro FRAME
-	pushl %ebp
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ebp
 	CFI_REL_OFFSET ebp,0
 	movl %esp,%ebp
 	.endm
 	.macro ENDFRAME
-	popl %ebp
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %ebp
 	CFI_RESTORE ebp
 	.endm
 #else
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 49bdedd..2878821 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1409,8 +1409,7 @@ END(general_protection)
 #ifdef CONFIG_KVM_GUEST
 ENTRY(async_page_fault)
 	RING0_EC_FRAME
-	pushl $do_async_page_fault
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi $do_async_page_fault
 	jmp error_code
 	CFI_ENDPROC
 END(apf_page_fault)
diff --git a/arch/x86/lib/atomic64_386_32.S b/arch/x86/lib/atomic64_386_32.S
index 2cda60a..e8e7e0d 100644
--- a/arch/x86/lib/atomic64_386_32.S
+++ b/arch/x86/lib/atomic64_386_32.S
@@ -15,14 +15,12 @@
 
 /* if you want SMP support, implement these with real spinlocks */
 .macro LOCK reg
-	pushfl
-	CFI_ADJUST_CFA_OFFSET 4
+	pushfl_cfi
 	cli
 .endm
 
 .macro UNLOCK reg
-	popfl
-	CFI_ADJUST_CFA_OFFSET -4
+	popfl_cfi
 .endm
 
 #define BEGIN(op) \
diff --git a/arch/x86/lib/atomic64_cx8_32.S b/arch/x86/lib/atomic64_cx8_32.S
index 71e080d..391a083 100644
--- a/arch/x86/lib/atomic64_cx8_32.S
+++ b/arch/x86/lib/atomic64_cx8_32.S
@@ -14,14 +14,12 @@
 #include <asm/dwarf2.h>
 
 .macro SAVE reg
-	pushl %\reg
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %\reg
 	CFI_REL_OFFSET \reg, 0
 .endm
 
 .macro RESTORE reg
-	popl %\reg
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %\reg
 	CFI_RESTORE \reg
 .endm
 
diff --git a/arch/x86/lib/checksum_32.S b/arch/x86/lib/checksum_32.S
index adbccd0..78d16a5 100644
--- a/arch/x86/lib/checksum_32.S
+++ b/arch/x86/lib/checksum_32.S
@@ -50,11 +50,9 @@ unsigned int csum_partial(const unsigned char * buff, int len, unsigned int sum)
 	   */		
 ENTRY(csum_partial)
 	CFI_STARTPROC
-	pushl %esi
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %esi
 	CFI_REL_OFFSET esi, 0
-	pushl %ebx
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ebx
 	CFI_REL_OFFSET ebx, 0
 	movl 20(%esp),%eax	# Function arg: unsigned int sum
 	movl 16(%esp),%ecx	# Function arg: int len
@@ -132,11 +130,9 @@ ENTRY(csum_partial)
 	jz 8f
 	roll $8, %eax
 8:
-	popl %ebx
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %ebx
 	CFI_RESTORE ebx
-	popl %esi
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %esi
 	CFI_RESTORE esi
 	ret
 	CFI_ENDPROC
@@ -148,11 +144,9 @@ ENDPROC(csum_partial)
 
 ENTRY(csum_partial)
 	CFI_STARTPROC
-	pushl %esi
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %esi
 	CFI_REL_OFFSET esi, 0
-	pushl %ebx
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ebx
 	CFI_REL_OFFSET ebx, 0
 	movl 20(%esp),%eax	# Function arg: unsigned int sum
 	movl 16(%esp),%ecx	# Function arg: int len
@@ -260,11 +254,9 @@ ENTRY(csum_partial)
 	jz 90f
 	roll $8, %eax
 90: 
-	popl %ebx
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %ebx
 	CFI_RESTORE ebx
-	popl %esi
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %esi
 	CFI_RESTORE esi
 	ret
 	CFI_ENDPROC
@@ -309,14 +301,11 @@ ENTRY(csum_partial_copy_generic)
 	CFI_STARTPROC
 	subl  $4,%esp	
 	CFI_ADJUST_CFA_OFFSET 4
-	pushl %edi
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %edi
 	CFI_REL_OFFSET edi, 0
-	pushl %esi
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %esi
 	CFI_REL_OFFSET esi, 0
-	pushl %ebx
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ebx
 	CFI_REL_OFFSET ebx, 0
 	movl ARGBASE+16(%esp),%eax	# sum
 	movl ARGBASE+12(%esp),%ecx	# len
@@ -426,17 +415,13 @@ DST(	movb %cl, (%edi)	)
 
 .previous
 
-	popl %ebx
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %ebx
 	CFI_RESTORE ebx
-	popl %esi
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %esi
 	CFI_RESTORE esi
-	popl %edi
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %edi
 	CFI_RESTORE edi
-	popl %ecx			# equivalent to addl $4,%esp
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %ecx			# equivalent to addl $4,%esp
 	ret	
 	CFI_ENDPROC
 ENDPROC(csum_partial_copy_generic)
@@ -459,14 +444,11 @@ ENDPROC(csum_partial_copy_generic)
 		
 ENTRY(csum_partial_copy_generic)
 	CFI_STARTPROC
-	pushl %ebx
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ebx
 	CFI_REL_OFFSET ebx, 0
-	pushl %edi
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %edi
 	CFI_REL_OFFSET edi, 0
-	pushl %esi
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %esi
 	CFI_REL_OFFSET esi, 0
 	movl ARGBASE+4(%esp),%esi	#src
 	movl ARGBASE+8(%esp),%edi	#dst	
@@ -527,14 +509,11 @@ DST(	movb %dl, (%edi)         )
 	jmp  7b			
 .previous				
 
-	popl %esi
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %esi
 	CFI_RESTORE esi
-	popl %edi
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %edi
 	CFI_RESTORE edi
-	popl %ebx
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %ebx
 	CFI_RESTORE ebx
 	ret
 	CFI_ENDPROC
diff --git a/arch/x86/lib/semaphore_32.S b/arch/x86/lib/semaphore_32.S
index 648fe47..48e44f7 100644
--- a/arch/x86/lib/semaphore_32.S
+++ b/arch/x86/lib/semaphore_32.S
@@ -74,29 +74,23 @@ ENTRY(__read_lock_failed)
 /* Fix up special calling conventions */
 ENTRY(call_rwsem_down_read_failed)
 	CFI_STARTPROC
-	push %ecx
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ecx
 	CFI_REL_OFFSET ecx,0
-	push %edx
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %edx
 	CFI_REL_OFFSET edx,0
 	call rwsem_down_read_failed
-	pop %edx
-	CFI_ADJUST_CFA_OFFSET -4
-	pop %ecx
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %edx
+	popl_cfi %ecx
 	ret
 	CFI_ENDPROC
 	ENDPROC(call_rwsem_down_read_failed)
 
 ENTRY(call_rwsem_down_write_failed)
 	CFI_STARTPROC
-	push %ecx
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ecx
 	CFI_REL_OFFSET ecx,0
 	calll rwsem_down_write_failed
-	pop %ecx
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %ecx
 	ret
 	CFI_ENDPROC
 	ENDPROC(call_rwsem_down_write_failed)
@@ -105,12 +99,10 @@ ENTRY(call_rwsem_wake)
 	CFI_STARTPROC
 	decw %dx    /* do nothing if still outstanding active readers */
 	jnz 1f
-	push %ecx
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ecx
 	CFI_REL_OFFSET ecx,0
 	call rwsem_wake
-	pop %ecx
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %ecx
 1:	ret
 	CFI_ENDPROC
 	ENDPROC(call_rwsem_wake)
@@ -118,17 +110,13 @@ ENTRY(call_rwsem_wake)
 /* Fix up special calling conventions */
 ENTRY(call_rwsem_downgrade_wake)
 	CFI_STARTPROC
-	push %ecx
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %ecx
 	CFI_REL_OFFSET ecx,0
-	push %edx
-	CFI_ADJUST_CFA_OFFSET 4
+	pushl_cfi %edx
 	CFI_REL_OFFSET edx,0
 	call rwsem_downgrade_wake
-	pop %edx
-	CFI_ADJUST_CFA_OFFSET -4
-	pop %ecx
-	CFI_ADJUST_CFA_OFFSET -4
+	popl_cfi %edx
+	popl_cfi %ecx
 	ret
 	CFI_ENDPROC
 	ENDPROC(call_rwsem_downgrade_wake)
