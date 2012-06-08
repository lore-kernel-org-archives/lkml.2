Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab2FHN36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 09:29:58 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:60297 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab2FHN35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 09:29:57 -0400
X-Nat-Received: from [202.181.97.72]:52987 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1339162181.22955
To: linux-kernel@vger.kernel.org
Cc: oleg@redhat.com, rusty@rustcorp.com.au, arjan@linux.intel.com,
        tj@kernel.org, akpm@linux-foundation.org
Subject: [PATCH] kmod: avoid deadlock from recursive kmod call
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201202090049.FIE64562.tFLFQFSVOHOMJO@I-love.SAKURA.ne.jp>
	<20120208163349.GA18478@redhat.com>
	<201202092058.DAJ60973.VOSOFHQFtLFJMO@I-love.SAKURA.ne.jp>
	<201202101956.GFB43786.MLFHQJOFFtOSOV@I-love.SAKURA.ne.jp>
	<20120531130856.c0a5f913.akpm@linux-foundation.org>
In-Reply-To: <20120531130856.c0a5f913.akpm@linux-foundation.org>
Message-Id: <201206082229.BFC64035.HQOSLtMFFVOJFO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 8 Jun 2012 22:29:39 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 08062012 #8157230, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 75ab995a2b57e183ed9772221dc62ff3a22ad92a Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Fri, 8 Jun 2012 21:33:55 +0900
Subject: [PATCH] kmod: avoid deadlock from recursive kmod call

The system deadlocks (at least since 2.6.10) when
call_usermodehelper(UMH_WAIT_EXEC) request triggered
call_usermodehelper(UMH_WAIT_PROC) request.

This is because "khelper thread is waiting for the worker thread at
wait_for_completion() in do_fork() since the worker thread was created
with CLONE_VFORK flag" and "the worker thread cannot call complete()
because do_execve() is blocked at UMH_WAIT_PROC request" and "the khelper
thread cannot start processing UMH_WAIT_PROC request because the khelper
thread is waiting for the worker thread at wait_for_completion() in
do_fork()".

The easiest example to observe this deadlock is to use a corrupted
/sbin/hotplug binary (like shown below).

  # : > /tmp/dummy
  # chmod 755 /tmp/dummy
  # echo /tmp/dummy > /proc/sys/kernel/hotplug
  # modprobe whatever

call_usermodehelper("/tmp/dummy", UMH_WAIT_EXEC) is called from
kobject_uevent_env() in lib/kobject_uevent.c upon loading/unloading a module.
do_execve("/tmp/dummy") triggers a call to request_module("binfmt-0000") from
search_binary_handler() which in turn calls call_usermodehelper(UMH_WAIT_PROC).

In order to avoid deadlock, as a for-now and easy-to-backport solution, do not
try to call wait_for_completion() in call_usermodehelper_exec() if the worker
thread was created by khelper thread with CLONE_VFORK flag.
Future and fundamental solution might be replacing singleton khelper thread
with some workqueue so that recursive calls up to max_active dependency loop
can be handled without deadlock.

[akpm@linux-foundation.org: add comment to kmod_thread_locker]
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/kmod.c |   31 +++++++++++++++++++++++++++++--
 1 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index ff2c7cb..5bf7a5e 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -45,6 +45,13 @@ extern int max_threads;
 
 static struct workqueue_struct *khelper_wq;
 
+/*
+ * kmod_thread_locker is used for deadlock avoidance.  There is no explicit
+ * locking to protect this global - it is private to the singleton khelper
+ * thread and should only ever be modified by that thread.
+ */
+static const struct task_struct *kmod_thread_locker;
+
 #define CAP_BSET	(void *)1
 #define CAP_PI		(void *)2
 
@@ -221,6 +228,13 @@ fail:
 	return 0;
 }
 
+static int call_helper(void *data)
+{
+	/* Worker thread started blocking khelper thread. */
+	kmod_thread_locker = current;
+	return ____call_usermodehelper(data);
+}
+
 static void call_usermodehelper_freeinfo(struct subprocess_info *info)
 {
 	if (info->cleanup)
@@ -295,9 +309,12 @@ static void __call_usermodehelper(struct work_struct *work)
 	if (wait == UMH_WAIT_PROC)
 		pid = kernel_thread(wait_for_helper, sub_info,
 				    CLONE_FS | CLONE_FILES | SIGCHLD);
-	else
-		pid = kernel_thread(____call_usermodehelper, sub_info,
+	else {
+		pid = kernel_thread(call_helper, sub_info,
 				    CLONE_VFORK | SIGCHLD);
+		/* Worker thread stopped blocking khelper thread. */
+		kmod_thread_locker = NULL;
+	}
 
 	switch (wait) {
 	case UMH_NO_WAIT:
@@ -548,6 +565,16 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
 		retval = -EBUSY;
 		goto out;
 	}
+	/*
+	 * Worker thread must not wait for khelper thread at below
+	 * wait_for_completion() if the thread was created with CLONE_VFORK
+	 * flag, for khelper thread is already waiting for the thread at
+	 * wait_for_completion() in do_fork().
+	 */
+	if (wait != UMH_NO_WAIT && current == kmod_thread_locker) {
+		retval = -EBUSY;
+		goto out;
+	}
 
 	sub_info->complete = &done;
 	sub_info->wait = wait;
-- 
1.7.1
