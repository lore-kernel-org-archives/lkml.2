Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab1CHQA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 11:00:28 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:36935 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754782Ab1CHQA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 11:00:27 -0500
From: Andrey Vagin <avagin@openvz.org>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm: handle mm_fault_error in kernel space (v2)
Date: Tue,  8 Mar 2011 18:59:25 +0300
Message-Id: <1299599965-28995-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mm_fault_error() should not execute oom-killer, if page fault occurs
in kernel space. E.g. in copy_from_user/copy_to_user.

This would happen if we find ourselves in OOM on a copy_to_user(),
or a copy_from_user() which faults.

Without this patch, the kernels hangs up in copy_from_user, because
OOM killer sends SIG_KILL to current process, but it can't handle a
signal while in syscall, then the kernel returns to copy_from_user,
reexcute current command and provokes page_fault again.

With this patch the kernel return -EFAULT from copy_from_user.

The code, which checks that page fault occurred in kernel space, has been
copied from do_sigbus.

This situation is handled by the same way on powerpc, xtensa, tile, ...

Signed-off-by: Andrey Vagin <avagin@openvz.org>
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
-- 
1.7.1

