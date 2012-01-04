Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab2ADNIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 08:08:17 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:55776 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922Ab2ADNIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 08:08:15 -0500
X-Nat-Received: from [202.181.97.72]:65143 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1325682493.20154
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] kmod: Avoid deadlock by recursive kmod call.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201112270701.pBR713wO005588@www262.sakura.ne.jp>
	<201201040743.q047h9OD055670@www262.sakura.ne.jp>
In-Reply-To: <201201040743.q047h9OD055670@www262.sakura.ne.jp>
Message-Id: <201201042208.JHG52695.OLStHFQOFFMVJO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 4 Jan 2012 22:08:09 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 04012012 #6389880, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> I noticed that the system deadlocks if do_execve() request by kmod() triggered
> recursive do_execve() request.
> 
> An example operation for triggering this deadlock:
> 
>   # : > /tmp/dummy
>   # chmod 755 /tmp/dummy
>   # echo /tmp/dummy > /proc/sys/kernel/hotplug
>   # modprobe whatever
> 
> Although this patch works for me, I'm not sure that this is a correct fix.
> Also, my analysis in the patch description may be wrong. Please check.

Well, we should not unconditionally prevent all vfork()ed threads from using
request_module() at search_binary_handler(). We should prevent only kernel
threads created by __call_usermodehelper(). Updated to filter only kmod threads.
--------------------
[PATCH v2] kmod: Avoid deadlock by recursive kmod call.

call_usermodehelper(UMH_WAIT_EXEC or UMH_WAIT_PROC) request depends on an
assumption that do_execve() will not trigger recursive
call_usermodehelper(UMH_WAIT_EXEC or UMH_WAIT_PROC) request, for
"khelper cannot start processing recursive call_usermodehelper() request until
do_execve() of original call_usermodehelper() request completes" but
"do_execve() of original call_usermodehelper() cannot be completed until
recursive call_usermodehelper() request completes".

There are several callers that break this assumption and lead to deadlock.
We need to make sure that do_execve() request by kmod thread does not trigger
recursive call_usermodehelper(UMH_WAIT_PROC or UMH_WAIT_EXEC).

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 include/linux/sched.h |    3 +++
 kernel/kmod.c         |   18 +++++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

--- linux-3.1.7.orig/include/linux/sched.h
+++ linux-3.1.7/include/linux/sched.h
@@ -1305,6 +1305,9 @@ struct task_struct {
 	unsigned sched_reset_on_fork:1;
 	unsigned sched_contributes_to_load:1;
 
+	/* Prevent recursive kmod request. */
+	unsigned kmod_thread:1;
+
 	pid_t pid;
 	pid_t tgid;
 
--- linux-3.1.7.orig/kernel/kmod.c
+++ linux-3.1.7/kernel/kmod.c
@@ -189,6 +189,13 @@ fail:
 	do_exit(0);
 }
 
+static int call_helper(void *data)
+{
+	/* Do not trigger recursive kmod call. */
+	current->kmod_thread = 1;
+	return ____call_usermodehelper(data);
+}
+
 void call_usermodehelper_freeinfo(struct subprocess_info *info)
 {
 	if (info->cleanup)
@@ -252,7 +259,7 @@ static void __call_usermodehelper(struct
 		pid = kernel_thread(wait_for_helper, sub_info,
 				    CLONE_FS | CLONE_FILES | SIGCHLD);
 	else
-		pid = kernel_thread(____call_usermodehelper, sub_info,
+		pid = kernel_thread(call_helper, sub_info,
 				    CLONE_VFORK | SIGCHLD);
 
 	switch (wait) {
@@ -428,6 +435,15 @@ int call_usermodehelper_exec(struct subp
 		retval = -EBUSY;
 		goto out;
 	}
+	/*
+	 * We can't call wait_for_completion() if current thread was created by
+	 * call_helper(), or we will deadlock when current thread calls
+	 * request_module() from search_binary_handler().
+	 */
+	if (wait != UMH_NO_WAIT && current->kmod_thread) {
+		retval = -EBUSY;
+		goto out;
+	}
 
 	sub_info->complete = &done;
 	sub_info->wait = wait;
