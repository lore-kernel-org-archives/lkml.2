Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab1BYSBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:01:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756371Ab1BYSBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:01:44 -0500
Date: Fri, 25 Feb 2011 18:52:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>, Milton Miller <miltonm@bga.com>
Subject: [PATCH 2/5] exec: introduce "bool compat" argument
Message-ID: <20110225175249.GC19059@redhat.com>
References: <20101130200129.GG11905@redhat.com> <compat-not-unlikely@mdm.bga.com> <20101201182747.GB6143@redhat.com> <20110225175202.GA19059@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225175202.GA19059@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes, preparation to simplify the review.

And the new (and currently unused) "bool compat" argument to
get_arg_ptr(), count(), and copy_strings().

Add this argument to do_execve() as well, and rename it to
do_execve_common().

Reintroduce do_execve() as a trivial wrapper() on top of
do_execve_common(compat => false).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 fs/exec.c |   33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

--- 38/fs/exec.c~2_is_compat_arg	2011-02-25 18:04:50.000000000 +0100
+++ 38/fs/exec.c	2011-02-25 18:05:05.000000000 +0100
@@ -396,7 +396,7 @@ err:
 }
 
 static const char __user *
-get_arg_ptr(const char __user * const __user *argv, int argc)
+get_arg_ptr(const char __user * const __user *argv, int argc, bool compat)
 {
 	const char __user *ptr;
 
@@ -409,13 +409,13 @@ get_arg_ptr(const char __user * const __
 /*
  * count() counts the number of strings in array ARGV.
  */
-static int count(const char __user * const __user * argv, int max)
+static int count(const char __user * const __user *argv, int max, bool compat)
 {
 	int i = 0;
 
 	if (argv != NULL) {
 		for (;;) {
-			const char __user *p = get_arg_ptr(argv, i);
+			const char __user *p = get_arg_ptr(argv, i, compat);
 
 			if (!p)
 				break;
@@ -440,7 +440,7 @@ static int count(const char __user * con
  * ensures the destination page is created and not swapped out.
  */
 static int copy_strings(int argc, const char __user *const __user *argv,
-			struct linux_binprm *bprm)
+			struct linux_binprm *bprm, bool compat)
 {
 	struct page *kmapped_page = NULL;
 	char *kaddr = NULL;
@@ -453,7 +453,7 @@ static int copy_strings(int argc, const 
 		unsigned long pos;
 
 		ret = -EFAULT;
-		str = get_arg_ptr(argv, argc);
+		str = get_arg_ptr(argv, argc, compat);
 		if (IS_ERR(str))
 			goto out;
 
@@ -536,7 +536,8 @@ int copy_strings_kernel(int argc, const 
 	int r;
 	mm_segment_t oldfs = get_fs();
 	set_fs(KERNEL_DS);
-	r = copy_strings(argc, (const char __user *const  __user *)argv, bprm);
+	r = copy_strings(argc, (const char __user *const  __user *)argv,
+				bprm, false);
 	set_fs(oldfs);
 	return r;
 }
@@ -1387,10 +1388,10 @@ EXPORT_SYMBOL(search_binary_handler);
 /*
  * sys_execve() executes a new program.
  */
-int do_execve(const char * filename,
+static int do_execve_common(const char *filename,
 	const char __user *const __user *argv,
 	const char __user *const __user *envp,
-	struct pt_regs * regs)
+	struct pt_regs *regs, bool compat)
 {
 	struct linux_binprm *bprm;
 	struct file *file;
@@ -1432,11 +1433,11 @@ int do_execve(const char * filename,
 	if (retval)
 		goto out_file;
 
-	bprm->argc = count(argv, MAX_ARG_STRINGS);
+	bprm->argc = count(argv, MAX_ARG_STRINGS, compat);
 	if ((retval = bprm->argc) < 0)
 		goto out;
 
-	bprm->envc = count(envp, MAX_ARG_STRINGS);
+	bprm->envc = count(envp, MAX_ARG_STRINGS, compat);
 	if ((retval = bprm->envc) < 0)
 		goto out;
 
@@ -1449,11 +1450,11 @@ int do_execve(const char * filename,
 		goto out;
 
 	bprm->exec = bprm->p;
-	retval = copy_strings(bprm->envc, envp, bprm);
+	retval = copy_strings(bprm->envc, envp, bprm, compat);
 	if (retval < 0)
 		goto out;
 
-	retval = copy_strings(bprm->argc, argv, bprm);
+	retval = copy_strings(bprm->argc, argv, bprm, compat);
 	if (retval < 0)
 		goto out;
 
@@ -1497,6 +1498,14 @@ out_ret:
 	return retval;
 }
 
+int do_execve(const char *filename,
+	const char __user *const __user *argv,
+	const char __user *const __user *envp,
+	struct pt_regs *regs)
+{
+	return do_execve_common(filename, argv, envp, regs, false);
+}
+
 void set_binfmt(struct linux_binfmt *new)
 {
 	struct mm_struct *mm = current->mm;

