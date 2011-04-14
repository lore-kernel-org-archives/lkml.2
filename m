Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933885Ab1DNSVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:21:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933271Ab1DNSVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 14:21:03 -0400
Date: Thu, 14 Apr 2011 20:19:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, stable-review@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [34-longterm 136/209] exec: make argv/envp memory visible to
	oom-killer
Message-ID: <20110414181936.GA22589@redhat.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com> <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com> <1302803767-9715-23-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302803767-9715-23-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14, Paul Gortmaker wrote:
>
>   =====================================================================
>   | This is a commit scheduled for the next v2.6.34 longterm release. |
>   | If you see a problem with using this for longterm, please comment.|
>   =====================================================================
> ...
>
> With this patch get_arg_page() increments current's MM_ANONPAGES
> counter every time we allocate the new page for argv/envp. When
> do_execve() succeds or fails, we change this counter back.

This only works starting from 2.6.36.

before 2.6.36 kernel, oom-killer's badness() uses mm->total_vm. Please
see the patch for pre2.6.36 kernel below.

Oleg.

--------------------------------------------------------------------
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

Compared to upstream:

	before 2.6.36 kernel, oom-killer's badness() takes
	mm->total_vm into account and nothing else. So
	acct_arg_size() has to play with this counter too.

Reported-by: Brad Spengler <spender@grsecurity.net>
Reviewed-and-discussed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

---

 include/linux/binfmts.h |    1 +
 fs/exec.c               |   28 ++++++++++++++++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

--- 2.6.35/include/linux/binfmts.h~1_acct_exec_mem	2010-03-11 13:11:50.000000000 +0100
+++ 2.6.35/include/linux/binfmts.h	2010-12-13 12:01:22.000000000 +0100
@@ -29,6 +29,7 @@ struct linux_binprm{
 	char buf[BINPRM_BUF_SIZE];
 #ifdef CONFIG_MMU
 	struct vm_area_struct *vma;
+	unsigned long vma_pages;
 #else
 # define MAX_ARG_PAGES	32
 	struct page *page[MAX_ARG_PAGES];
--- 2.6.35/fs/exec.c~1_acct_exec_mem	2010-05-28 13:41:40.000000000 +0200
+++ 2.6.35/fs/exec.c	2010-12-13 12:00:51.000000000 +0100
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
@@ -270,6 +287,10 @@ static bool valid_arg_len(struct linux_b
 
 #else
 
+static inline void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
+{
+}
+
 static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
 		int write)
 {
@@ -977,6 +998,7 @@ int flush_old_exec(struct linux_binprm *
 	/*
 	 * Release all of the old mmap stuff
 	 */
+	acct_arg_size(bprm, 0);
 	retval = exec_mmap(bprm->mm);
 	if (retval)
 		goto out;
@@ -1401,8 +1423,10 @@ int do_execve(char * filename,
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

