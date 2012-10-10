Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab2JJFLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 01:11:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35821 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab2JJFLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 01:11:12 -0400
Date: Wed, 10 Oct 2012 06:11:10 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Sparc
Message-ID: <20121010051110.GC2616@ZenIV.linux.org.uk>
References: <20121008.161806.2146082252793236167.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121008.161806.2146082252793236167.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 04:18:06PM -0400, David Miller wrote:
> 
> There is an attempt to fix a bad interaction between syscall tracing
> and force_successful_syscall() from Al Viro, but it needs to be redone
> as it introduced regressions and thus had to be reverted for now.
> 
> Al is working on an updated version.

See below.  Just in case: Linus, please DO NOT APPLY unless it goes through
sparc tree - this is modulo approval by davem.

sparc64: fix ptrace interaction with force_successful_syscall_return()
    
we want syscall_trace_leave() called on exit from any syscall;
skipping its call in case we'd done force_successful_syscall_return()
is broken...
    
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/arch/sparc/kernel/syscalls.S b/arch/sparc/kernel/syscalls.S
index 1d7e274..7f5f65d 100644
--- a/arch/sparc/kernel/syscalls.S
+++ b/arch/sparc/kernel/syscalls.S
@@ -212,24 +212,20 @@ linux_sparc_syscall:
 3:	stx	%o0, [%sp + PTREGS_OFF + PT_V9_I0]
 ret_sys_call:
 	ldx	[%sp + PTREGS_OFF + PT_V9_TSTATE], %g3
-	ldx	[%sp + PTREGS_OFF + PT_V9_TNPC], %l1 ! pc = npc
 	sra	%o0, 0, %o0
 	mov	%ulo(TSTATE_XCARRY | TSTATE_ICARRY), %g2
 	sllx	%g2, 32, %g2
 
-	/* Check if force_successful_syscall_return()
-	 * was invoked.
-	 */
-	ldub	[%g6 + TI_SYS_NOERROR], %l2
-	brnz,a,pn %l2, 80f
-	 stb	%g0, [%g6 + TI_SYS_NOERROR]
-
 	cmp	%o0, -ERESTART_RESTARTBLOCK
 	bgeu,pn	%xcc, 1f
-	 andcc	%l0, (_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT|_TIF_SYSCALL_TRACEPOINT), %l6
-80:
+	 andcc	%l0, (_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT|_TIF_SYSCALL_TRACEPOINT), %g0
+	ldx	[%sp + PTREGS_OFF + PT_V9_TNPC], %l1 ! pc = npc
+
+2:
+	stb	%g0, [%g6 + TI_SYS_NOERROR]
 	/* System call success, clear Carry condition code. */
 	andn	%g3, %g2, %g3
+3:
 	stx	%g3, [%sp + PTREGS_OFF + PT_V9_TSTATE]	
 	bne,pn	%icc, linux_syscall_trace2
 	 add	%l1, 0x4, %l2			! npc = npc+4
@@ -238,20 +234,20 @@ ret_sys_call:
 	 stx	%l2, [%sp + PTREGS_OFF + PT_V9_TNPC]
 
 1:
+	/* Check if force_successful_syscall_return()
+	 * was invoked.
+	 */
+	ldub	[%g6 + TI_SYS_NOERROR], %l2
+	brnz,pn %l2, 2b
+	 ldx	[%sp + PTREGS_OFF + PT_V9_TNPC], %l1 ! pc = npc
 	/* System call failure, set Carry condition code.
 	 * Also, get abs(errno) to return to the process.
 	 */
-	andcc	%l0, (_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT|_TIF_SYSCALL_TRACEPOINT), %l6	
 	sub	%g0, %o0, %o0
-	or	%g3, %g2, %g3
 	stx	%o0, [%sp + PTREGS_OFF + PT_V9_I0]
-	stx	%g3, [%sp + PTREGS_OFF + PT_V9_TSTATE]
-	bne,pn	%icc, linux_syscall_trace2
-	 add	%l1, 0x4, %l2			! npc = npc+4
-	stx	%l1, [%sp + PTREGS_OFF + PT_V9_TPC]
+	ba,pt	%xcc, 3b
+	 or	%g3, %g2, %g3
 
-	b,pt	%xcc, rtrap
-	 stx	%l2, [%sp + PTREGS_OFF + PT_V9_TNPC]
 linux_syscall_trace2:
 	call	syscall_trace_leave
 	 add	%sp, PTREGS_OFF, %o0
