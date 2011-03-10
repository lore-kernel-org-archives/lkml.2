Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab1CJOWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 09:22:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:37864 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab1CJOWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 09:22:47 -0500
Date: Thu, 10 Mar 2011 14:21:53 GMT
From: tip-bot for Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, avagin@openvz.org,
        akpm@linux-foundation.org, stable@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable@kernel.org, tglx@linutronix.de, avagin@openvz.org,
        mingo@elte.hu
In-Reply-To: <201103092322.p29NMNPH001682@imap1.linux-foundation.org>
References: <201103092322.p29NMNPH001682@imap1.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mm: Handle mm_fault_error() in kernel space
Message-ID: <tip-f86268549f424f83b9eb0963989270e14fbfc3de@git.kernel.org>
Git-Commit-ID: f86268549f424f83b9eb0963989270e14fbfc3de
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 10 Mar 2011 14:21:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f86268549f424f83b9eb0963989270e14fbfc3de
Gitweb:     http://git.kernel.org/tip/f86268549f424f83b9eb0963989270e14fbfc3de
Author:     Andrey Vagin <avagin@openvz.org>
AuthorDate: Wed, 9 Mar 2011 15:22:23 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 10 Mar 2011 09:41:40 +0100

x86/mm: Handle mm_fault_error() in kernel space

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
Cc: <stable@kernel.org>
LKML-Reference: <201103092322.p29NMNPH001682@imap1.linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/fault.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 7d90ceb..ffc7be1 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -828,6 +828,13 @@ mm_fault_error(struct pt_regs *regs, unsigned long error_code,
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
 		if (fault & (VM_FAULT_SIGBUS|VM_FAULT_HWPOISON|
