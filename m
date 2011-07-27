Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab1G0V5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:57:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:13692 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755692Ab1G0VtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32274717"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: minipli@googlemail.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [57/99] exec: delay address limit change until point of no return
Message-Id: <20110727214856.576F72403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Mathias Krause <minipli@googlemail.com>

commit dac853ae89043f1b7752875300faf614de43c74b upstream.

Unconditionally changing the address limit to USER_DS and not restoring
it to its old value in the error path is wrong because it prevents us
using kernel memory on repeated calls to this function.  This, in fact,
breaks the fallback of hard coded paths to the init program from being
ever successful if the first candidate fails to load.

With this patch applied switching to USER_DS is delayed until the point
of no return is reached which makes it possible to have a multi-arch
rootfs with one arch specific init binary for each of the (hard coded)
probed paths.

Since the address limit is already set to USER_DS when start_thread()
will be invoked, this redundancy can be safely removed.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>


---
 arch/x86/kernel/process_32.c |    1 -
 arch/x86/kernel/process_64.c |    1 -
 fs/exec.c                    |    5 +----
 3 files changed, 1 insertion(+), 6 deletions(-)

Index: linux-2.6.35.y/arch/x86/kernel/process_32.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/process_32.c
+++ linux-2.6.35.y/arch/x86/kernel/process_32.c
@@ -245,7 +245,6 @@ start_thread(struct pt_regs *regs, unsig
 {
 	set_user_gs(regs, 0);
 	regs->fs		= 0;
-	set_fs(USER_DS);
 	regs->ds		= __USER_DS;
 	regs->es		= __USER_DS;
 	regs->ss		= __USER_DS;
Index: linux-2.6.35.y/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/process_64.c
+++ linux-2.6.35.y/arch/x86/kernel/process_64.c
@@ -337,7 +337,6 @@ start_thread_common(struct pt_regs *regs
 	regs->cs		= _cs;
 	regs->ss		= _ss;
 	regs->flags		= X86_EFLAGS_IF;
-	set_fs(USER_DS);
 	/*
 	 * Free the old FP and other extended state
 	 */
Index: linux-2.6.35.y/fs/exec.c
===================================================================
--- linux-2.6.35.y.orig/fs/exec.c
+++ linux-2.6.35.y/fs/exec.c
@@ -1024,6 +1024,7 @@ int flush_old_exec(struct linux_binprm *
 
 	bprm->mm = NULL;		/* We're using it now */
 
+	set_fs(USER_DS);
 	current->flags &= ~PF_RANDOMIZE;
 	flush_thread();
 	current->personality &= ~bprm->per_clear;
@@ -1288,10 +1289,6 @@ int search_binary_handler(struct linux_b
 	if (retval)
 		return retval;
 
-	/* kernel module loader fixup */
-	/* so we don't try to load run modprobe in kernel space. */
-	set_fs(USER_DS);
-
 	retval = audit_bprm(bprm);
 	if (retval)
 		return retval;
