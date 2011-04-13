Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab1DMQNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:13:49 -0400
Received: from kroah.org ([198.145.64.141]:53106 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932867Ab1DMQNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:41 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:49 2011
Message-Id: <20110413161049.864078543@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:10:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Oleg Nesterov <oleg@redhat.com>, Moritz Muehlenhoff <jmm@debian.org>
Subject: [69/71] exec: make argv/envp memory visible to oom-killer
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 3c77f845722158206a7209c45ccddc264d19319c upstream.

Brad Spengler published a local memory-allocation DoS that
evades the OOM-killer (though not the virtual memory RLIMIT):
http://www.grsecurity.net/~spender/64bit_dos.c

execve()->copy_strings() can allocate a lot of memory, but
this is not visible to oom-killer, nobody can see the nascent
bprm->mm and take it into account.

With this patch get_arg_page() increments current's MM_ANONPAGES
counter every time we allocate the new page for argv/envp. When
do_execve() succeds or fails, we change this counter back.

Technically this is not 100% correct, we can't know if the new
page is swapped out and turn MM_ANONPAGES into MM_SWAPENTS, but
I don't think this really matters and everything becomes correct
once exec changes ->mm or fails.

Reported-by: Brad Spengler <spender@grsecurity.net>
Reviewed-and-discussed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Moritz Muehlenhoff <jmm@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/exec.c               |   28 ++++++++++++++++++++++++++--
 include/linux/binfmts.h |    1 +
 2 files changed, 27 insertions(+), 2 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -158,6 +158,21 @@ out:
 
 #ifdef CONFIG_MMU
 
+static void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
+{
+	struct mm_struct *mm = current->mm;
+	long diff = (long)(pages - bprm->vma_pages);
+
+	if (!mm || !diff)
+		return;
+
+	bprm->vma_pages = pages;
+
+	down_write(&mm->mmap_sem);
+	mm->total_vm += diff;
+	up_write(&mm->mmap_sem);
+}
+
 static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
 		int write)
 {
@@ -180,6 +195,8 @@ static struct page *get_arg_page(struct
 		unsigned long size = bprm->vma->vm_end - bprm->vma->vm_start;
 		struct rlimit *rlim;
 
+		acct_arg_size(bprm, size / PAGE_SIZE);
+
 		/*
 		 * We've historically supported up to 32 pages (ARG_MAX)
 		 * of argument strings even with small stacks
@@ -273,6 +290,10 @@ static bool valid_arg_len(struct linux_b
 
 #else
 
+static inline void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
+{
+}
+
 static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
 		int write)
 {
@@ -991,6 +1012,7 @@ int flush_old_exec(struct linux_binprm *
 	/*
 	 * Release all of the old mmap stuff
 	 */
+	acct_arg_size(bprm, 0);
 	retval = exec_mmap(bprm->mm);
 	if (retval)
 		goto out;
@@ -1415,8 +1437,10 @@ int do_execve(char * filename,
 	return retval;
 
 out:
-	if (bprm->mm)
-		mmput (bprm->mm);
+	if (bprm->mm) {
+		acct_arg_size(bprm, 0);
+		mmput(bprm->mm);
+	}
 
 out_file:
 	if (bprm->file) {
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -29,6 +29,7 @@ struct linux_binprm{
 	char buf[BINPRM_BUF_SIZE];
 #ifdef CONFIG_MMU
 	struct vm_area_struct *vma;
+	unsigned long vma_pages;
 #else
 # define MAX_ARG_PAGES	32
 	struct page *page[MAX_ARG_PAGES];


