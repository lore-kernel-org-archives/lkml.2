Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab1GEBYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 21:24:40 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:64613 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab1GEBYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 21:24:39 -0400
X-Nat-Received: from [202.181.97.72]:64822 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1309829055.13567
Message-Id: <201107050124.p651OExY025046@www262.sakura.ne.jp>
Subject: Re: [PATCH][Resend v2] Fix infinite loop in search_binary_handler()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: richard@nod.at
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 05 Jul 2011 10:24:14 +0900
References: <1309779003-8668-1-git-send-email-richard@nod.at> <201107041707.23165.richard@nod.at> <201107050703.EGJ13561.OFQHOOVMJtLFSF@I-love.SAKURA.ne.jp> <201107050017.30365.richard@nod.at>
In-Reply-To: <201107050017.30365.richard@nod.at>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 04072011 #5644808, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger wrote:
> With MAX_KMOD_CONCURRENT=3 it takes only a few seconds until 
> the modprobe storm ends.

OK. Many years ago, I got a few reports that the kernel panics after printing

  request_module: runaway loop modprobe binfmt-464c

line. This was because they installed by error a binary x86_32 kernel rpm on
x86_64 userland tools. So, this error is not specific to UML.

> How shall we proceed?
> Applying my ad-hoc patch 
> or lowering MAX_KMOD_CONCURRENT?

What about disallowing request_module() for ____call_usermodehelper() threads?

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a837b20..70b52de 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1289,6 +1289,7 @@ struct task_struct {
 	unsigned did_exec:1;
 	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
 				 * execve */
+	unsigned no_request_module:1; /* Disallow request_module() calls. */
 	unsigned in_iowait:1;
 
 
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 47613df..32ad87c 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -88,6 +88,8 @@ int __request_module(bool wait, const char *fmt, ...)
 #define MAX_KMOD_CONCURRENT 50	/* Completely arbitrary value - KAO */
 	static int kmod_loop_msg;
 
+	if (current->no_request_module)
+		return -ENOSYS;
 	va_start(args, fmt);
 	ret = vsnprintf(module_name, MODULE_NAME_LEN, fmt, args);
 	va_end(args);
@@ -177,6 +179,7 @@ static int ____call_usermodehelper(void *data)
 
 	commit_creds(new);
 
+	current->no_request_module = 1;
 	retval = kernel_execve(sub_info->path,
 			       (const char *const *)sub_info->argv,
 			       (const char *const *)sub_info->envp);
diff --git a/fs/exec.c b/fs/exec.c
index 6075a1e..b949387 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1387,6 +1387,7 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 				if (bprm->file)
 					fput(bprm->file);
 				bprm->file = NULL;
+				current->no_request_module = 0;
 				current->did_exec = 1;
 				proc_exec_connector(current);
 				return retval;
