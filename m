Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030274Ab2CMAe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:34:59 -0400
Received: from mail.windriver.com ([147.11.1.11]:48706 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965080Ab2CMAYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:32 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 155/196] init, sched: Fix race between init and kthreadd
Date: Mon, 12 Mar 2012 20:21:08 -0400
Message-Id: <1331598109-31424-110-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit b433c3d4549ae74935b585115f076c6fb7bc48fe upstream.

Ilya reported that on a very slow machine he could reliably
reproduce a race between forking init and kthreadd. We first
fork init so that it  obtains pid-1, however since the scheduler
is already fully running at this point it can preempt and run
the init thread before we spawn and set kthreadd_task.

The init thread can then attempt spawning kthreads without
kthreadd being present which results in an OOPS.

Reported-by: Ilya Loginov <isloginov@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <1277736661.3561.110.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 init/main.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/init/main.c b/init/main.c
index 5c85402..df0e20b 100644
--- a/init/main.c
+++ b/init/main.c
@@ -421,18 +421,26 @@ static void __init setup_command_line(char *command_line)
  * gcc-3.4 accidentally inlines this function, so use noinline.
  */
 
+static __initdata DECLARE_COMPLETION(kthreadd_done);
+
 static noinline void __init_refok rest_init(void)
 	__releases(kernel_lock)
 {
 	int pid;
 
 	rcu_scheduler_starting();
+	/*
+	 * We need to spawn init first so that it obtains pid-1, however
+	 * the init task will end up wanting to create kthreads, which, if
+	 * we schedule it before we create kthreadd, will OOPS.
+	 */
 	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
 	numa_default_policy();
 	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
 	rcu_read_lock();
 	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
 	rcu_read_unlock();
+	complete(&kthreadd_done);
 	unlock_kernel();
 
 	/*
@@ -853,6 +861,10 @@ static noinline int init_post(void)
 
 static int __init kernel_init(void * unused)
 {
+	/*
+	 * Wait until kthreadd is all set-up.
+	 */
+	wait_for_completion(&kthreadd_done);
 	lock_kernel();
 
 	/*
-- 
1.7.9.3

