Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab2CEGio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 01:38:44 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57914 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab2CEGin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 01:38:43 -0500
Date: Mon, 5 Mar 2012 06:38:42 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] aout: move setup_arg_pages() prior to reading/mapping
 the binary
Message-ID: <20120305063842.GI23916@ZenIV.linux.org.uk>
References: <20120305063707.GH23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305063707.GH23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/x86/ia32/ia32_aout.c |   14 +++++++-------
 fs/binfmt_aout.c          |   14 +++++++-------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index fd84387..39e4909 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -315,6 +315,13 @@ static int load_aout_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	current->mm->free_area_cache = TASK_UNMAPPED_BASE;
 	current->mm->cached_hole_size = 0;
 
+	retval = setup_arg_pages(bprm, IA32_STACK_TOP, EXSTACK_DEFAULT);
+	if (retval < 0) {
+		/* Someone check-me: is this error path enough? */
+		send_sig(SIGKILL, current, 0);
+		return retval;
+	}
+
 	install_exec_creds(bprm);
 	current->flags &= ~PF_FORKNOEXEC;
 
@@ -410,13 +417,6 @@ beyond_if:
 
 	set_brk(current->mm->start_brk, current->mm->brk);
 
-	retval = setup_arg_pages(bprm, IA32_STACK_TOP, EXSTACK_DEFAULT);
-	if (retval < 0) {
-		/* Someone check-me: is this error path enough? */
-		send_sig(SIGKILL, current, 0);
-		return retval;
-	}
-
 	current->mm->start_stack =
 		(unsigned long)create_aout_tables((char __user *)bprm->p, bprm);
 	/* start thread */
diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index a6395bd..0b39e46 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -259,6 +259,13 @@ static int load_aout_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 	current->mm->free_area_cache = current->mm->mmap_base;
 	current->mm->cached_hole_size = 0;
 
+	retval = setup_arg_pages(bprm, STACK_TOP, EXSTACK_DEFAULT);
+	if (retval < 0) { 
+		/* Someone check-me: is this error path enough? */ 
+		send_sig(SIGKILL, current, 0); 
+		return retval;
+	}
+
 	install_exec_creds(bprm);
  	current->flags &= ~PF_FORKNOEXEC;
 
@@ -352,13 +359,6 @@ beyond_if:
 		return retval;
 	}
 
-	retval = setup_arg_pages(bprm, STACK_TOP, EXSTACK_DEFAULT);
-	if (retval < 0) { 
-		/* Someone check-me: is this error path enough? */ 
-		send_sig(SIGKILL, current, 0); 
-		return retval;
-	}
-
 	current->mm->start_stack =
 		(unsigned long) create_aout_tables((char __user *) bprm->p, bprm);
 #ifdef __alpha__
-- 
1.7.2.5


