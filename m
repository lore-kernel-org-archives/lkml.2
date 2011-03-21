Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394Ab1CVACF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 20:02:05 -0400
Received: from kroah.org ([198.145.64.141]:48929 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754882Ab1CUXNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:13:34 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:10:51 2011
Message-Id: <20110321231051.357519073@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:09:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andrey Vagin <avagin@openvz.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [06/44] x86/mm: Handle mm_fault_error() in kernel space
In-Reply-To: <20110321231105.GA1744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Andrey Vagin <avagin@openvz.org>

commit f86268549f424f83b9eb0963989270e14fbfc3de upstream.

mm_fault_error() should not execute oom-killer, if page fault
occurs in kernel space.  E.g. in copy_from_user()/copy_to_user().

This would happen if we find ourselves in OOM on a
copy_to_user(), or a copy_from_user() which faults.

Without this patch, the kernels hangs up in copy_from_user(),
because OOM killer sends SIG_KILL to current process, but it
can't handle a signal while in syscall, then the kernel returns
to copy_from_user(), reexcute current command and provokes
page_fault again.

With this patch the kernel return -EFAULT from copy_from_user().

The code, which checks that page fault occurred in kernel space,
has been copied from do_sigbus().

This situation is handled by the same way on powerpc, xtensa,
tile, ...

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <201103092322.p29NMNPH001682@imap1.linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/fault.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -830,6 +830,13 @@ mm_fault_error(struct pt_regs *regs, uns
 	       unsigned long address, unsigned int fault)
 {
 	if (fault & VM_FAULT_OOM) {
+		/* Kernel mode? Handle exceptions or die: */
+		if (!(error_code & PF_USER)) {
+			up_read(&current->mm->mmap_sem);
+			no_context(regs, error_code, address);
+			return;
+		}
+
 		out_of_memory(regs, error_code, address);
 	} else {
 		if (fault & (VM_FAULT_SIGBUS|VM_FAULT_HWPOISON))


