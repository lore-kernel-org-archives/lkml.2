Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965928Ab2EODA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 23:00:57 -0400
Received: from mail.windriver.com ([147.11.1.11]:49458 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964807Ab2EOCQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:56 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 069/179] exec: delay address limit change until point of no return
Date: Mon, 14 May 2012 22:12:45 -0400
Message-ID: <1337048075-6132-70-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Krause <minipli@googlemail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/process_32.c |    1 -
 arch/x86/kernel/process_64.c |    1 -
 fs/exec.c                    |    5 +----
 3 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index f6c6266..219141c 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -253,7 +253,6 @@ start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
 {
 	set_user_gs(regs, 0);
 	regs->fs		= 0;
-	set_fs(USER_DS);
 	regs->ds		= __USER_DS;
 	regs->es		= __USER_DS;
 	regs->ss		= __USER_DS;
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 17cb329..0a18514 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -345,7 +345,6 @@ start_thread_common(struct pt_regs *regs, unsigned long new_ip,
 	regs->cs		= _cs;
 	regs->ss		= _ss;
 	regs->flags		= X86_EFLAGS_IF;
-	set_fs(USER_DS);
 	/*
 	 * Free the old FP and other extended state
 	 */
diff --git a/fs/exec.c b/fs/exec.c
index 11cfcce..4afb996 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1020,6 +1020,7 @@ int flush_old_exec(struct linux_binprm * bprm)
 
 	bprm->mm = NULL;		/* We're using it now */
 
+	set_fs(USER_DS);
 	current->flags &= ~PF_RANDOMIZE;
 	flush_thread();
 	current->personality &= ~bprm->per_clear;
@@ -1284,10 +1285,6 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 	if (retval)
 		return retval;
 
-	/* kernel module loader fixup */
-	/* so we don't try to load run modprobe in kernel space. */
-	set_fs(USER_DS);
-
 	retval = audit_bprm(bprm);
 	if (retval)
 		return retval;
-- 
1.7.9.6

