Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859Ab2EUSLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:11:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805Ab2EUSLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:11:15 -0400
Date: Mon, 21 May 2012 19:34:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>, tj@kernel.org
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        akpm@linux-foundation.org, bharrosh@panasas.com,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: UMH_WAIT_EXEC->UMH_WAIT_PROC deadlock
Message-ID: <20120521173453.GB31803@redhat.com>
References: <4F6A93F5.1070202@panasas.com> <201203241028.IGJ09825.MtOVFHFJQSLOFO@I-love.SAKURA.ne.jp> <4F6D35F0.2020808@panasas.com> <20120323200028.fadf49f8.akpm@linux-foundation.org> <20120324145308.GA10023@redhat.com> <201205191121.BIF57837.FHFOtMOLJQSOFV@I-love.SAKURA.ne.jp> <87fwau4aag.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fwau4aag.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21, Rusty Russell wrote:
>
> I rather like Oleg's "use system wq" patch.  Seems like a net
> simplification.

OK. Lets discuss this patch (attached below).

Obviously, I like it too ;) And yes, it looks like a cleanup to me.

But. This change can obviously increase the number of
__call_usermodehelper()'s running in parallel, and in particular increase
the number of workqueue threads.

Is it OK?

Another issue is that Tejun dislikes the usage of system_unbound_wq.
I guess, because WQ_UNBOUND implies WQ_HIGHPRI. Btw, I do not really
understand why. And, otoh, I don't think that __call_usermodehelper()
should be bound to any CPU, this would look a bit strange to me.

So, Tejun, what do you think about this patch? Which system_ wq it
should use if you think it makes sense?

Oleg.


------------------------------------------------------------------------
[PATCH] kmod: kill khelper_wq, fix UMH_WAIT_EXEC->UMH_WAIT_PROC deadlock

A UMH_WAIT_EXEC request can trigger the reqursive UMH_WAIT_PROC
if kernel_execve(sub_info->path) needs request_module() to load
the binfmt module.

This leads to deadlock. The worker thread sleeps waiting for
CLONE_VFORK completion, its child queues another sub_info->work
and waits for it, but since khelper_wq->max_active == 1 no other
work can run.

Quiting Tetsuo:

	The easiest example to observe this deadlock is to use
	a corrupted /sbin/hotplug binary (like shown below).

	# : > /tmp/dummy
	# chmod 755 /tmp/dummy
	# echo /tmp/dummy > /proc/sys/kernel/hotplug
	# modprobe whatever

Kill khelper_wq and use the system wq instead. Workqueues were
greatly improved, I do not think kmod needs the dedicated wq.

In the scenario above, UMH_WAIT_EXEC succeeds with this patch
assuming that the number of UMH_WAIT_EXEC requests in flight
doesn't exceed max_active.

Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/kmod.h |    2 --
 init/main.c          |    1 -
 kernel/kmod.c        |   14 +++-----------
 3 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index 9efeae6..eced4e3 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -110,8 +110,6 @@ call_usermodehelper(char *path, char **argv, char **envp, int wait)
 
 extern struct ctl_table usermodehelper_table[];
 
-extern void usermodehelper_init(void);
-
 extern int usermodehelper_disable(void);
 extern void usermodehelper_enable(void);
 extern bool usermodehelper_is_disabled(void);
diff --git a/init/main.c b/init/main.c
index ff49a6d..f538aa5 100644
--- a/init/main.c
+++ b/init/main.c
@@ -722,7 +722,6 @@ static void __init do_initcalls(void)
 static void __init do_basic_setup(void)
 {
 	cpuset_init_smp();
-	usermodehelper_init();
 	shmem_init();
 	driver_init();
 	init_irq_proc();
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 3a69031..d1712c0 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -43,8 +43,6 @@
 
 extern int max_threads;
 
-static struct workqueue_struct *khelper_wq;
-
 #define CAP_BSET	(void *)1
 #define CAP_PI		(void *)2
 
@@ -285,7 +283,7 @@ static int wait_for_helper(void *data)
 	return 0;
 }
 
-/* This is run by khelper thread  */
+/* This is run by workqueue thread  */
 static void __call_usermodehelper(struct work_struct *work)
 {
 	struct subprocess_info *sub_info =
@@ -494,7 +492,7 @@ pr_crit("UMH: call %16s:%-4d inf=%p w=%d %s\n",
 	if (sub_info->path[0] == '\0')
 		goto out;
 
-	if (!khelper_wq || usermodehelper_disabled) {
+	if (!system_unbound_wq || usermodehelper_disabled) {
 		retval = -EBUSY;
 		goto out;
 	}
@@ -502,7 +500,7 @@ pr_crit("UMH: call %16s:%-4d inf=%p w=%d %s\n",
 	sub_info->complete = &done;
 	sub_info->wait = wait;
 
-	queue_work(khelper_wq, &sub_info->work);
+	queue_work(system_unbound_wq, &sub_info->work);
 	if (wait == UMH_NO_WAIT)	/* task has freed sub_info */
 		goto unlock;
 
@@ -605,9 +603,3 @@ struct ctl_table usermodehelper_table[] = {
 	},
 	{ }
 };
-
-void __init usermodehelper_init(void)
-{
-	khelper_wq = create_singlethread_workqueue("khelper");
-	BUG_ON(!khelper_wq);
-}
-- 
1.5.5.1


