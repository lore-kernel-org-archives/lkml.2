Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab2CJRsy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 12:48:54 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:46543 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab2CJRss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 12:48:48 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 10 Mar 2012 23:16:00 +0530
Message-Id: <20120310174600.19949.43260.sendpatchset@srdronam.in.ibm.com>
In-Reply-To: <20120310174501.19949.50137.sendpatchset@srdronam.in.ibm.com>
References: <20120310174501.19949.50137.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH 5/7] x86/trivial: fix 'old_rsp' undefined build failure when including asm/compat.h
x-cbid: 12031007-9264-0000-0000-00000107AB08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Including asm/compat.h in arch/x86/kernel/signal.c and compiling on a i386
machine results in old_rsp undefined build errors.

old_rsp is defined under CONFIG_X86_64. Hence add a i386 specific
arch_compat_alloc_user_space that doesnt depend on old_rsp. Will be further
cleaned up when is_ia32_compat_task is introduced.

This is pure cleanup, no functional change intended.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 arch/x86/include/asm/compat.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index 355edc0..ba9e9dc 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -221,6 +221,7 @@ static inline compat_uptr_t ptr_to_compat(void __user *uptr)
 	return (u32)(unsigned long)uptr;
 }
 
+#ifdef CONFIG_x86_64
 static inline void __user *arch_compat_alloc_user_space(long len)
 {
 	compat_uptr_t sp;
@@ -234,6 +235,15 @@ static inline void __user *arch_compat_alloc_user_space(long len)
 
 	return (void __user *)round_down(sp - len, 16);
 }
+#else
+
+static inline void __user *arch_compat_alloc_user_space(long len)
+{
+	struct pt_regs *regs = task_pt_regs(current);
+		return (void __user *)regs->sp - len;
+}
+
+#endif
 
 static inline bool is_ia32_task(void)
 {


