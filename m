Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540Ab2CMAWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:22:18 -0400
Received: from mail.windriver.com ([147.11.1.11]:47526 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758494Ab2CMAWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:13 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 054/196] exec: copy-and-paste the fixes into compat_do_execve() paths
Date: Mon, 12 Mar 2012 20:19:27 -0400
Message-Id: <1331598109-31424-9-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/compat.c             |   28 +++++++++++++++-------------
 fs/exec.c               |    8 ++++----
 include/linux/binfmts.h |    4 ++++
 3 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 6490d21..633e63c 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1376,6 +1376,10 @@ static int compat_count(compat_uptr_t __user *argv, int max)
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
@@ -1417,6 +1421,12 @@ static int compat_copy_strings(int argc, compat_uptr_t __user *argv,
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
@@ -1433,18 +1443,8 @@ static int compat_copy_strings(int argc, compat_uptr_t __user *argv,
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
diff --git a/fs/exec.c b/fs/exec.c
index b5cf64a..11cfcce 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -158,7 +158,7 @@ out:
 
 #ifdef CONFIG_MMU
 
-static void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
+void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
 {
 	struct mm_struct *mm = current->mm;
 	long diff = (long)(pages - bprm->vma_pages);
@@ -173,7 +173,7 @@ static void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
 	up_write(&mm->mmap_sem);
 }
 
-static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
+struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
 		int write)
 {
 	struct page *page;
@@ -291,11 +291,11 @@ static bool valid_arg_len(struct linux_binprm *bprm, long len)
 
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
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 39798c6..074b620 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -60,6 +60,10 @@ struct linux_binprm{
 	unsigned long loader, exec;
 };
 
+extern void acct_arg_size(struct linux_binprm *bprm, unsigned long pages);
+extern struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
+					int write);
+
 #define BINPRM_FLAGS_ENFORCE_NONDUMP_BIT 0
 #define BINPRM_FLAGS_ENFORCE_NONDUMP (1 << BINPRM_FLAGS_ENFORCE_NONDUMP_BIT)
 
-- 
1.7.9.3

