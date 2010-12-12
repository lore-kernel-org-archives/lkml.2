Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab0LMAGA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:06:00 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36333 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab0LLXrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:18 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: oleg@redhat.com, kosaki.motohiro@jp.fujitsu.com,
        torvalds@linux-foundation.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [135/223] exec: copy-and-paste the fixes into compat_do_execve() paths
Message-Id: <20101212234717.784F3B27C0@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Oleg Nesterov <oleg@redhat.com>

commit 114279be2120a916e8a04feeb2ac976a10016f2f upstream.

Note: this patch targets 2.6.37 and tries to be as simple as possible.
That is why it adds more copy-and-paste horror into fs/compat.c and
uglifies fs/exec.c, this will be cleanuped later.

compat_copy_strings() plays with bprm->vma/mm directly and thus has
two problems: it lacks the RLIMIT_STACK check and argv/envp memory
is not visible to oom killer.

Export acct_arg_size() and get_arg_page(), change compat_copy_strings()
to use get_arg_page(), change compat_do_execve() to do acct_arg_size(0)
as do_execve() does.

Add the fatal_signal_pending/cond_resched checks into compat_count() and
compat_copy_strings(), this matches the code in fs/exec.c and certainly
makes sense.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/compat.c             |   28 +++++++++++++++-------------
 fs/exec.c               |    8 ++++----
 include/linux/binfmts.h |    4 ++++
 3 files changed, 23 insertions(+), 17 deletions(-)

Index: linux/fs/compat.c
===================================================================
--- linux.orig/fs/compat.c
+++ linux/fs/compat.c
@@ -1376,6 +1376,10 @@ static int compat_count(compat_uptr_t __
 			argv++;
 			if (i++ >= max)
 				return -E2BIG;
+
+			if (fatal_signal_pending(current))
+				return -ERESTARTNOHAND;
+			cond_resched();
 		}
 	}
 	return i;
@@ -1417,6 +1421,12 @@ static int compat_copy_strings(int argc,
 		while (len > 0) {
 			int offset, bytes_to_copy;
 
+			if (fatal_signal_pending(current)) {
+				ret = -ERESTARTNOHAND;
+				goto out;
+			}
+			cond_resched();
+
 			offset = pos % PAGE_SIZE;
 			if (offset == 0)
 				offset = PAGE_SIZE;
@@ -1433,18 +1443,8 @@ static int compat_copy_strings(int argc,
 			if (!kmapped_page || kpos != (pos & PAGE_MASK)) {
 				struct page *page;
 
-#ifdef CONFIG_STACK_GROWSUP
-				ret = expand_stack_downwards(bprm->vma, pos);
-				if (ret < 0) {
-					/* We've exceed the stack rlimit. */
-					ret = -E2BIG;
-					goto out;
-				}
-#endif
-				ret = get_user_pages(current, bprm->mm, pos,
-						     1, 1, 1, &page, NULL);
-				if (ret <= 0) {
-					/* We've exceed the stack rlimit. */
+				page = get_arg_page(bprm, pos, 1);
+				if (!page) {
 					ret = -E2BIG;
 					goto out;
 				}
@@ -1565,8 +1565,10 @@ int compat_do_execve(char * filename,
 	return retval;
 
 out:
-	if (bprm->mm)
+	if (bprm->mm) {
+		acct_arg_size(bprm, 0);
 		mmput(bprm->mm);
+	}
 
 out_file:
 	if (bprm->file) {
Index: linux/fs/exec.c
===================================================================
--- linux.orig/fs/exec.c
+++ linux/fs/exec.c
@@ -158,7 +158,7 @@ out:
 
 #ifdef CONFIG_MMU
 
-static void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
+void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
 {
 	struct mm_struct *mm = current->mm;
 	long diff = (long)(pages - bprm->vma_pages);
@@ -177,7 +177,7 @@ static void acct_arg_size(struct linux_b
 #endif
 }
 
-static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
+struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
 		int write)
 {
 	struct page *page;
@@ -291,11 +291,11 @@ static bool valid_arg_len(struct linux_b
 
 #else
 
-static inline void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
+void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
 {
 }
 
-static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
+struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
 		int write)
 {
 	struct page *page;
Index: linux/include/linux/binfmts.h
===================================================================
--- linux.orig/include/linux/binfmts.h
+++ linux/include/linux/binfmts.h
@@ -60,6 +60,10 @@ struct linux_binprm{
 	unsigned long loader, exec;
 };
 
+extern void acct_arg_size(struct linux_binprm *bprm, unsigned long pages);
+extern struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
+					int write);
+
 #define BINPRM_FLAGS_ENFORCE_NONDUMP_BIT 0
 #define BINPRM_FLAGS_ENFORCE_NONDUMP (1 << BINPRM_FLAGS_ENFORCE_NONDUMP_BIT)
 
