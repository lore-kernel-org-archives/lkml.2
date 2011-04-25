Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab1DYUas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:30:48 -0400
Received: from 1wt.eu ([62.212.114.60]:34605 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932465Ab1DYUZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:29 -0400
Message-Id: <20110425200239.945072239@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:05:12 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Moritz Muehlenhoff <jmm@debian.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 160/173] exec: copy-and-paste the fixes into compat_do_execve() paths
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Moritz Muehlenhoff <jmm@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/compat.c             |   28 +++++++++++++++-------------
 fs/exec.c               |    8 ++++----
 include/linux/binfmts.h |    4 ++++
 3 files changed, 23 insertions(+), 17 deletions(-)

Index: longterm-2.6.27/fs/compat.c
===================================================================
--- longterm-2.6.27.orig/fs/compat.c	2011-01-23 10:52:28.000000000 +0100
+++ longterm-2.6.27/fs/compat.c	2011-04-25 17:24:25.210282944 +0200
@@ -1241,6 +1241,10 @@
 			argv++;
 			if(++i > max)
 				return -E2BIG;
+
+			if (fatal_signal_pending(current))
+				return -ERESTARTNOHAND;
+			cond_resched();
 		}
 	}
 	return i;
@@ -1282,6 +1286,12 @@
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
@@ -1298,18 +1308,8 @@
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
@@ -1425,8 +1425,10 @@
 		security_bprm_free(bprm);
 
 out_mm:
-	if (bprm->mm)
+	if (bprm->mm) {
+		acct_arg_size(bprm, 0);
 		mmput(bprm->mm);
+	}
 
 out_file:
 	if (bprm->file) {
Index: longterm-2.6.27/fs/exec.c
===================================================================
--- longterm-2.6.27.orig/fs/exec.c	2011-04-25 17:22:50.000000000 +0200
+++ longterm-2.6.27/fs/exec.c	2011-04-25 17:23:56.746278475 +0200
@@ -168,7 +168,7 @@
 
 #ifdef CONFIG_MMU
 
-static void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
+void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
 {
 	struct mm_struct *mm = current->mm;
 	long diff = (long)(pages - bprm->vma_pages);
@@ -183,7 +183,7 @@
 	up_write(&mm->mmap_sem);
 }
 
-static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
+struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
 		int write)
 {
 	struct page *page;
@@ -308,11 +308,11 @@
 
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
Index: longterm-2.6.27/include/linux/binfmts.h
===================================================================
--- longterm-2.6.27.orig/include/linux/binfmts.h	2011-04-25 17:22:24.000000000 +0200
+++ longterm-2.6.27/include/linux/binfmts.h	2011-04-25 17:23:56.751278452 +0200
@@ -53,6 +53,10 @@
 	unsigned long loader, exec;
 };
 
+extern void acct_arg_size(struct linux_binprm *bprm, unsigned long pages);
+extern struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
+					int write);
+
 #define BINPRM_FLAGS_ENFORCE_NONDUMP_BIT 0
 #define BINPRM_FLAGS_ENFORCE_NONDUMP (1 << BINPRM_FLAGS_ENFORCE_NONDUMP_BIT)
 


