Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab0HMVtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 17:49:22 -0400
Received: from kroah.org ([198.145.64.141]:51683 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153Ab0HMVtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 17:49:05 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug 13 14:46:46 2010
Message-Id: <20100813214646.299156413@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 13 Aug 2010 14:42:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [3/3] x86: dont send SIGBUS for kernel page faults
In-Reply-To: <20100813214704.GA18960@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

Based on commit 96054569190bdec375fe824e48ca1f4e3b53dd36 upstream,
authored by Linus Torvalds.

This is my backport to the .27 kernel tree, hopefully preserving
the same functionality.

Original commit message:
	It's wrong for several reasons, but the most direct one is that the
	fault may be for the stack accesses to set up a previous SIGBUS.  When
	we have a kernel exception, the kernel exception handler does all the
	fixups, not some user-level signal handler.

	Even apart from the nested SIGBUS issue, it's also wrong to give out
	kernel fault addresses in the signal handler info block, or to send a
	SIGBUS when a system call already returns EFAULT.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/fault.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -589,6 +589,7 @@ void __kprobes do_page_fault(struct pt_r
 	unsigned long address;
 	int write, si_code;
 	int fault;
+	int should_exit_no_context = 0;
 #ifdef CONFIG_X86_64
 	unsigned long flags;
 #endif
@@ -876,6 +877,9 @@ no_context:
 	oops_end(flags, regs, SIGKILL);
 #endif
 
+	if (should_exit_no_context)
+		return;
+
 /*
  * We ran out of memory, or some other thing happened to us that made
  * us unable to handle the page fault gracefully.
@@ -901,8 +905,11 @@ do_sigbus:
 	up_read(&mm->mmap_sem);
 
 	/* Kernel mode? Handle exceptions or die */
-	if (!(error_code & PF_USER))
+	if (!(error_code & PF_USER)) {
+		should_exit_no_context = 1;
 		goto no_context;
+	}
+
 #ifdef CONFIG_X86_32
 	/* User space => ok to do another page fault */
 	if (is_prefetch(regs, address, error_code))


