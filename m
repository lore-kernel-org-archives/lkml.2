Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab1DYUcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:32:23 -0400
Received: from 1wt.eu ([62.212.114.60]:34589 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932450Ab1DYUZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:25 -0400
Message-Id: <20110425200239.902703276@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:05:11 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Moritz Muehlenhoff <jmm@debian.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 159/173] exec: make argv/envp memory visible to oom-killer
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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

Index: longterm-2.6.27/fs/exec.c
===================================================================
--- longterm-2.6.27.orig/fs/exec.c	2011-02-09 22:45:33.000000000 +0100
+++ longterm-2.6.27/fs/exec.c	2011-04-25 17:22:50.655279537 +0200
@@ -168,6 +168,21 @@
 
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
@@ -190,6 +205,8 @@
 		unsigned long size = bprm->vma->vm_end - bprm->vma->vm_start;
 		struct rlimit *rlim;
 
+		acct_arg_size(bprm, size / PAGE_SIZE);
+
 		/*
 		 * We've historically supported up to 32 pages (ARG_MAX)
 		 * of argument strings even with small stacks
@@ -291,6 +308,10 @@
 
 #else
 
+static inline void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
+{
+}
+
 static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
 		int write)
 {
@@ -995,6 +1016,7 @@
 	/*
 	 * Release all of the old mmap stuff
 	 */
+	acct_arg_size(bprm, 0);
 	retval = exec_mmap(bprm->mm);
 	if (retval)
 		goto out;
@@ -1378,8 +1400,10 @@
 		security_bprm_free(bprm);
 
 out_mm:
-	if (bprm->mm)
+	if (bprm->mm) {
+		acct_arg_size(bprm, 0);
 		mmput (bprm->mm);
+	}
 
 out_file:
 	if (bprm->file) {
Index: longterm-2.6.27/include/linux/binfmts.h
===================================================================
--- longterm-2.6.27.orig/include/linux/binfmts.h	2011-01-23 10:52:34.000000000 +0100
+++ longterm-2.6.27/include/linux/binfmts.h	2011-04-25 17:22:24.856278432 +0200
@@ -28,6 +28,7 @@
 	char buf[BINPRM_BUF_SIZE];
 #ifdef CONFIG_MMU
 	struct vm_area_struct *vma;
+	unsigned long vma_pages;
 #else
 # define MAX_ARG_PAGES	32
 	struct page *page[MAX_ARG_PAGES];


