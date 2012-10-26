Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab2JZAGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:06:13 -0400
Received: from mail.kernel.org ([198.145.19.201]:52581 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab2JZAGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:06:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Al Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 23/31] sparc64: fix ptrace interaction with force_successful_syscall_return()
Date: Thu, 25 Oct 2012 17:04:30 -0700
Message-Id: <20121026000217.310763915@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000214.941721299@linuxfoundation.org>
References: <20121026000214.941721299@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 55c2770e413e96871147b9406a9c41fe9bc5209c ]

we want syscall_trace_leave() called on exit from any syscall;
skipping its call in case we'd done force_successful_syscall_return()
is broken...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/kernel/syscalls.S |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

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


