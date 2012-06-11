Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab2FKEXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 00:23:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54953 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab2FKEXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 00:23:12 -0400
Date: Sun, 10 Jun 2012 21:22:50 -0700
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-7fbb98c5cb07563d3ee08714073a8e5452a96be2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        brgerst@gmail.com, torvalds@linux-foundation.org, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de, avi@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, torvalds@linux-foundation.org, brgerst@gmail.com,
        srostedt@redhat.com, tglx@linutronix.de, avi@redhat.com
In-Reply-To: <1337763411.13348.140.camel@gandalf.stny.rr.com>
References: <4FBB8C40.6080304@redhat.com>
	<1337763411.13348.140.camel@gandalf.stny.rr.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86:
  Save cr2 in NMI in case NMIs take a page fault
Git-Commit-ID: 7fbb98c5cb07563d3ee08714073a8e5452a96be2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 10 Jun 2012 21:22:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7fbb98c5cb07563d3ee08714073a8e5452a96be2
Gitweb:     http://git.kernel.org/tip/7fbb98c5cb07563d3ee08714073a8e5452a96be2
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Thu, 7 Jun 2012 10:21:21 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 7 Jun 2012 10:21:21 -0400

x86: Save cr2 in NMI in case NMIs take a page fault

Avi Kivity reported that page faults in NMIs could cause havic if
the NMI preempted another page fault handler:

   The recent changes to NMI allow exceptions to take place in NMI
   handlers, but I think that a #PF (say, due to access to vmalloc space)
   is still problematic.  Consider the sequence

    #PF  (cr2 set by processor)
      NMI
        ...
        #PF (cr2 clobbered)
          do_page_fault()
          IRET
        ...
        IRET
      do_page_fault()
        address = read_cr2()

   The last line reads the overwritten cr2 value.

Originally I wrote a patch to solve this by saving the cr2 on the stack.
Brian Gerst suggested to save it in the r12 register as both r12 and rbx
are saved by the do_nmi handler as required by the C standard. But rbx
is already used for saving if swapgs needs to be run on exit of the NMI
handler.

Link: http://lkml.kernel.org/r/4FBB8C40.6080304@redhat.com
Link: http://lkml.kernel.org/r/1337763411.13348.140.camel@gandalf.stny.rr.com

Reported-by: Avi Kivity <avi@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Suggested-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_64.S |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 7d65133..111f6bb 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1758,10 +1758,30 @@ end_repeat_nmi:
 	 */
 	call save_paranoid
 	DEFAULT_FRAME 0
+
+	/*
+	 * Save off the CR2 register. If we take a page fault in the NMI then
+	 * it could corrupt the CR2 value. If the NMI preempts a page fault
+	 * handler before it was able to read the CR2 register, and then the
+	 * NMI itself takes a page fault, the page fault that was preempted
+	 * will read the information from the NMI page fault and not the
+	 * origin fault. Save it off and restore it if it changes.
+	 * Use the r12 callee-saved register.
+	 */
+	movq %cr2, %r12
+
 	/* paranoidentry do_nmi, 0; without TRACE_IRQS_OFF */
 	movq %rsp,%rdi
 	movq $-1,%rsi
 	call do_nmi
+
+	/* Did the NMI take a page fault? Restore cr2 if it did */
+	movq %cr2, %rcx
+	cmpq %rcx, %r12
+	je 1f
+	movq %r12, %cr2
+1:
+	
 	testl %ebx,%ebx				/* swapgs needed? */
 	jnz nmi_restore
 nmi_swapgs:
