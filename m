Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab0F1U0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 16:26:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:45920 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849Ab0F1U03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 16:26:29 -0400
Date: Mon, 28 Jun 2010 20:24:46 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       peterz@infradead.org, isloginov@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
       peterz@infradead.org, tglx@linutronix.de, isloginov@gmail.com,
       mingo@elte.hu
In-Reply-To: <1277736661.3561.110.camel@laptop>
References: <1277736661.3561.110.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] init, sched: Fix race between init and kthreadd
Message-ID: <tip-b433c3d4549ae74935b585115f076c6fb7bc48fe@git.kernel.org>
Git-Commit-ID: b433c3d4549ae74935b585115f076c6fb7bc48fe
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 28 Jun 2010 20:24:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b433c3d4549ae74935b585115f076c6fb7bc48fe
Gitweb:     http://git.kernel.org/tip/b433c3d4549ae74935b585115f076c6fb7bc48fe
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 28 Jun 2010 16:51:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 28 Jun 2010 18:21:30 +0200

init, sched: Fix race between init and kthreadd

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
---
 init/main.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/init/main.c b/init/main.c
index 3bdb152..633442f 100644
--- a/init/main.c
+++ b/init/main.c
@@ -422,18 +422,26 @@ static void __init setup_command_line(char *command_line)
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
@@ -855,6 +863,10 @@ static noinline int init_post(void)
 
 static int __init kernel_init(void * unused)
 {
+	/*
+	 * Wait until kthreadd is all set-up.
+	 */
+	wait_for_completion(&kthreadd_done);
 	lock_kernel();
 
 	/*
