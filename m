Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab1EFA0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:26:00 -0400
Received: from kroah.org ([198.145.64.141]:37285 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932455Ab1EFAZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:55 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:17 2011
Message-Id: <20110506002217.166675829@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [121/143] init, sched: Fix race between init and kthreadd
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 init/main.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/init/main.c
+++ b/init/main.c
@@ -407,16 +407,24 @@ static void __init setup_command_line(ch
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
 	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
+	complete(&kthreadd_done);
 	unlock_kernel();
 
 	/*
@@ -841,6 +849,10 @@ static noinline int init_post(void)
 
 static int __init kernel_init(void * unused)
 {
+	/*
+	 * Wait until kthreadd is all set-up.
+	 */
+	wait_for_completion(&kthreadd_done);
 	lock_kernel();
 
 	/*


