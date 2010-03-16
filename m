Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab0CPTk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 15:40:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535Ab0CPTkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 15:40:24 -0400
Date: Tue, 16 Mar 2010 20:38:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org,
       David Howells <dhowells@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>
Subject: [PATCH 2/4] coredump: cleanup "ispipe" code
Message-ID: <20100316193853.GC31632@redhat.com>
References: <20100315122908.GB16175@hmsreliant.think-freely.org> <20100315194609.GA10896@redhat.com> <20100316193750.GA31632@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316193750.GA31632@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- kill "int dump_count", argv_split(argcp) accepts argcp == NULL.

- move "int dump_count" under " if (ispipe)" branch, fail_dropcount
  can check ispipe.

- move "char **helper_argv" as well, change the code to do argv_free()
  right after call_usermodehelper_fns().

- If call_usermodehelper_fns() fails goto close_fail label instead
  of closing the file by hand.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 fs/exec.c |   39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

--- 34-rc1/fs/exec.c~2_IFIFO	2010-03-16 18:06:12.000000000 +0100
+++ 34-rc1/fs/exec.c	2010-03-16 18:09:13.000000000 +0100
@@ -1838,10 +1838,7 @@ void do_coredump(long signr, int exit_co
 	struct cred *cred;
 	int retval = 0;
 	int flag = 0;
-	int ispipe = 0;
-	char **helper_argv = NULL;
-	int helper_argc = 0;
-	int dump_count = 0;
+	int ispipe;
 	static atomic_t core_dump_count = ATOMIC_INIT(0);
 	struct coredump_params cprm = {
 		.signr = signr,
@@ -1911,6 +1908,9 @@ void do_coredump(long signr, int exit_co
 	unlock_kernel();
 
  	if (ispipe) {
+		int dump_count;
+		char **helper_argv;
+
 		if (cprm.limit == 1) {
 			/*
 			 * Normally core limits are irrelevant to pipes, since
@@ -1932,6 +1932,7 @@ void do_coredump(long signr, int exit_co
 			printk(KERN_WARNING "Aborting core\n");
 			goto fail_unlock;
 		}
+		cprm.limit = RLIM_INFINITY;
 
 		dump_count = atomic_inc_return(&core_dump_count);
 		if (core_pipe_limit && (core_pipe_limit < dump_count)) {
@@ -1941,26 +1942,21 @@ void do_coredump(long signr, int exit_co
 			goto fail_dropcount;
 		}
 
-		helper_argv = argv_split(GFP_KERNEL, corename+1, &helper_argc);
+		helper_argv = argv_split(GFP_KERNEL, corename+1, NULL);
 		if (!helper_argv) {
 			printk(KERN_WARNING "%s failed to allocate memory\n",
 			       __func__);
 			goto fail_dropcount;
 		}
 
-		cprm.limit = RLIM_INFINITY;
-
-		/* SIGPIPE can happen, but it's just never processed */
-		cprm.file = NULL;
-		if (call_usermodehelper_fns(helper_argv[0], helper_argv, NULL,
-					    UMH_WAIT_EXEC, umh_pipe_setup,
-					    NULL, &cprm)) {
-			if (cprm.file)
-				filp_close(cprm.file, NULL);
-
+		retval = call_usermodehelper_fns(helper_argv[0], helper_argv,
+					NULL, UMH_WAIT_EXEC, umh_pipe_setup,
+					NULL, &cprm);
+		argv_free(helper_argv);
+		if (retval) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
 			       corename);
-			goto fail_dropcount;
+			goto close_fail;
  		}
 	} else {
 		struct inode *inode;
@@ -2000,17 +1996,16 @@ void do_coredump(long signr, int exit_co
 	retval = binfmt->core_dump(&cprm);
 	if (retval)
 		current->signal->group_exit_code |= 0x80;
-close_fail:
+
 	if (ispipe && core_pipe_limit)
 		wait_for_dump_helpers(cprm.file);
-	filp_close(cprm.file, NULL);
+close_fail:
+	if (cprm.file)
+		filp_close(cprm.file, NULL);
 fail_dropcount:
-	if (dump_count)
+	if (ispipe)
 		atomic_dec(&core_dump_count);
 fail_unlock:
-	if (helper_argv)
-		argv_free(helper_argv);
-
 	revert_creds(old_cred);
 	put_cred(cred);
 	coredump_finish(mm);

