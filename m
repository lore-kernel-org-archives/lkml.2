Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab0EXXPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:15:06 -0400
Received: from kroah.org ([198.145.64.141]:36407 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758964Ab0EXXJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:09:22 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:03:50 2010
Message-Id: <20100524230350.236716124@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 15:59:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [10/34] [S390] ptrace: fix return value of do_syscall_trace_enter()
In-Reply-To: <20100524230418.GA12770@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

commit 545c174d1f093a462b4bb9131b23d5ea72a600e1 upstream.

strace may change the system call number, so regs->gprs[2] must not
be read before tracehook_report_syscall_entry(). This fixes a bug
where "strace -f" will hang after a vfork().

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/s390/kernel/ptrace.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -632,7 +632,7 @@ long compat_arch_ptrace(struct task_stru
 
 asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 {
-	long ret;
+	long ret = 0;
 
 	/* Do the secure computing check first. */
 	secure_computing(regs->gprs[2]);
@@ -641,7 +641,6 @@ asmlinkage long do_syscall_trace_enter(s
 	 * The sysc_tracesys code in entry.S stored the system
 	 * call number to gprs[2].
 	 */
-	ret = regs->gprs[2];
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
 	    (tracehook_report_syscall_entry(regs) ||
 	     regs->gprs[2] >= NR_syscalls)) {
@@ -663,7 +662,7 @@ asmlinkage long do_syscall_trace_enter(s
 				    regs->gprs[2], regs->orig_gpr2,
 				    regs->gprs[3], regs->gprs[4],
 				    regs->gprs[5]);
-	return ret;
+	return ret ?: regs->gprs[2];
 }
 
 asmlinkage void do_syscall_trace_exit(struct pt_regs *regs)


