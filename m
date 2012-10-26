Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab2JZAFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:05:48 -0400
Received: from mail.kernel.org ([198.145.19.201]:52452 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab2JZAFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:05:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        David Vrabel <david.vrabel@citrix.com>,
        Jan Beulich <JBeulich@suse.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 10/31] xen/x86: dont corrupt %eip when returning from a signal handler
Date: Thu, 25 Oct 2012 17:04:17 -0700
Message-Id: <20121026000216.011294070@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000214.941721299@linuxfoundation.org>
References: <20121026000214.941721299@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit a349e23d1cf746f8bdc603dcc61fae9ee4a695f6 upstream.

In 32 bit guests, if a userspace process has %eax == -ERESTARTSYS
(-512) or -ERESTARTNOINTR (-513) when it is interrupted by an event
/and/ the process has a pending signal then %eip (and %eax) are
corrupted when returning to the main process after handling the
signal.  The application may then crash with SIGSEGV or a SIGILL or it
may have subtly incorrect behaviour (depending on what instruction it
returned to).

The occurs because handle_signal() is incorrectly thinking that there
is a system call that needs to restarted so it adjusts %eip and %eax
to re-execute the system call instruction (even though user space had
not done a system call).

If %eax == -514 (-ERESTARTNOHAND (-514) or -ERESTART_RESTARTBLOCK
(-516) then handle_signal() only corrupted %eax (by setting it to
-EINTR).  This may cause the application to crash or have incorrect
behaviour.

handle_signal() assumes that regs->orig_ax >= 0 means a system call so
any kernel entry point that is not for a system call must push a
negative value for orig_ax.  For example, for physical interrupts on
bare metal the inverse of the vector is pushed and page_fault() sets
regs->orig_ax to -1, overwriting the hardware provided error code.

xen_hypervisor_callback() was incorrectly pushing 0 for orig_ax
instead of -1.

Classic Xen kernels pushed %eax which works as %eax cannot be both
non-negative and -RESTARTSYS (etc.), but using -1 is consistent with
other non-system call entry points and avoids some of the tests in
handle_signal().

There were similar bugs in xen_failsafe_callback() of both 32 and
64-bit guests. If the fault was corrected and the normal return path
was used then 0 was incorrectly pushed as the value for orig_ax.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Acked-by: Jan Beulich <JBeulich@suse.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/entry_32.S |    8 +++++---
 arch/x86/kernel/entry_64.S |    2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1029,7 +1029,7 @@ ENTRY(xen_sysenter_target)
 
 ENTRY(xen_hypervisor_callback)
 	CFI_STARTPROC
-	pushl_cfi $0
+	pushl_cfi $-1 /* orig_ax = -1 => not a system call */
 	SAVE_ALL
 	TRACE_IRQS_OFF
 
@@ -1071,14 +1071,16 @@ ENTRY(xen_failsafe_callback)
 2:	mov 8(%esp),%es
 3:	mov 12(%esp),%fs
 4:	mov 16(%esp),%gs
+	/* EAX == 0 => Category 1 (Bad segment)
+	   EAX != 0 => Category 2 (Bad IRET) */
 	testl %eax,%eax
 	popl_cfi %eax
 	lea 16(%esp),%esp
 	CFI_ADJUST_CFA_OFFSET -16
 	jz 5f
 	addl $16,%esp
-	jmp iret_exc		# EAX != 0 => Category 2 (Bad IRET)
-5:	pushl_cfi $0		# EAX == 0 => Category 1 (Bad segment)
+	jmp iret_exc
+5:	pushl_cfi $-1 /* orig_ax = -1 => not a system call */
 	SAVE_ALL
 	jmp ret_from_exception
 	CFI_ENDPROC
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1308,7 +1308,7 @@ ENTRY(xen_failsafe_callback)
 	CFI_RESTORE r11
 	addq $0x30,%rsp
 	CFI_ADJUST_CFA_OFFSET -0x30
-	pushq_cfi $0
+	pushq_cfi $-1 /* orig_ax = -1 => not a system call */
 	SAVE_ALL
 	jmp error_exit
 	CFI_ENDPROC


