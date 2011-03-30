Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965169Ab1C3Va5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:30:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:48428 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965027Ab1C3VIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133654"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: avagin@openvz.org, akpm@linux-foundation.org, ak@linux.intel.com,
        hpa@zytor.com, torvalds@linux-foundation.org, mingo@elte.hu,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [188/275] x86/mm: Handle mm_fault_error() in kernel space
Message-Id: <20110330210711.A34603E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <201103092322.p29NMNPH001682@imap1.linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/fault.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6.35.y/arch/x86/mm/fault.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/mm/fault.c	2011-03-29 22:50:46.520068086 -0700
+++ linux-2.6.35.y/arch/x86/mm/fault.c	2011-03-29 23:03:02.185244254 -0700
@@ -831,6 +831,13 @@
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
