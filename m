Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab2AXEdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 23:33:01 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:59978 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab2AXEc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 23:32:59 -0500
X-Nat-Received: from [202.181.97.72]:62626 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1327379560.12333
Message-Id: <201201240432.q0O4WeMu031016@www262.sakura.ne.jp>
Subject: [PATCH v4] kmod: Avoid deadlock by recursive kmod call.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: akpm@linux-foundation.org, arjan@linux.intel.com, richard@nod.at,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 24 Jan 2012 13:32:40 +0900
References: <201112270701.pBR713wO005588@www262.sakura.ne.jp> <201201040743.q047h9OD055670@www262.sakura.ne.jp> <201201042208.JHG52695.OLStHFQOFFMVJO@I-love.SAKURA.ne.jp> <201201062139.JFC73472.SMQFOFOFHLVOtJ@I-love.SAKURA.ne.jp> <20120118164558.a10d7821.akpm@linux-foundation.org> <201201190207.q0J27Mr5099912@www262.sakura.ne.jp>
In-Reply-To: <201201190207.q0J27Mr5099912@www262.sakura.ne.jp>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 24012012 #6663763, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Andrew Morton wrote:
> > > --- linux-3.2.orig/fs/exec.c
> > > +++ linux-3.2/fs/exec.c
> > > @@ -1406,6 +1406,7 @@ int search_binary_handler(struct linux_b
> > >  					fput(bprm->file);
> > >  				bprm->file = NULL;
> > >  				current->did_exec = 1;
> > > +				current->kmod_thread = 0;
> > >  				proc_exec_connector(current);
> > >  				return retval;
> > >  			}
> > 
> > Special-casing this assignment down in this particular client of kmod
> > looks bad.  We need to find somewhere else to do this.  Perferably
> > within the kmod code itself, or possibly over in exec.c or fork.c.
> > 
> Well, kmod code is no longer called if do_execve() succeeded.
> 
> In "[PATCH v2] kmod: Avoid deadlock by recursive kmod call"
> ( https://lkml.org/lkml/2012/1/4/111 ), I forgot to do
> 
> 	current->kmod_thread = 0;
> 
> when do_execve() succeeded. Not clearing this flag might overkill functionality
> of /sbin/hotplug and its descendants. If we want to clear this flag, I think we
> cannot help doing it in fork.c or exec.c (or do like patch B which does not
> need this flag).

I found another approach which mixed patch A and patch B.
Since __call_usermodehelper() is exclusively called (am I right?), we don't
need to use per "struct task_struct" flag.
----------------------------------------
[PATCH v4] kmod: Avoid deadlock by recursive kmod call.

The system deadlocks (at least since 2.6.10) when
call_usermodehelper(UMH_WAIT_EXEC) request triggered
call_usermodehelper(UMH_WAIT_PROC) request.

This is because "khelper thread is waiting for the worker thread at
wait_for_completion() in do_fork() since the worker thread was created with
CLONE_VFORK flag" and "the worker thread cannot call complete() because
do_execve() is blocked at UMH_WAIT_PROC request" and "the khelper thread cannot
start processing UMH_WAIT_PROC request because the khelper thread is waiting
for the worker thread at wait_for_completion() in do_fork()".

In order to avoid deadlock, do not try to call wait_for_completion() in
call_usermodehelper_exec() if the worker thread was created by khelper thread
with CLONE_VFORK flag.

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

There are various hooks called during do_execve() operation (e.g.
security_bprm_check(), audit_bprm(), "struct linux_binfmt"->load_binary()).
If one of such hooks triggers UMH_WAIT_EXEC, this deadlock will happen even if
/sbin/hotplug is not corrupted.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 kernel/kmod.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

--- linux-3.2.1.orig/kernel/kmod.c
+++ linux-3.2.1/kernel/kmod.c
@@ -43,6 +43,7 @@
 extern int max_threads;
 
 static struct workqueue_struct *khelper_wq;
+static const struct task_struct *kmod_thread_locker;
 
 #define CAP_BSET	(void *)1
 #define CAP_PI		(void *)2
@@ -189,6 +190,13 @@ fail:
 	do_exit(0);
 }
 
+static int call_helper(void *data)
+{
+	/* Worker thread started blocking khelper thread. */
+	kmod_thread_locker = current;
+	return ____call_usermodehelper(data);
+}
+
 void call_usermodehelper_freeinfo(struct subprocess_info *info)
 {
 	if (info->cleanup)
@@ -251,9 +259,12 @@ static void __call_usermodehelper(struct
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
@@ -428,6 +439,16 @@ int call_usermodehelper_exec(struct subp
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
