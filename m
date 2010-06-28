Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab0F1Lxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 07:53:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:36730 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab0F1Lxd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 07:53:33 -0400
Subject: [PATCH] init: Fix race between init and kthreadd -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Ilya Loginov <isloginov@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1277715689.1875.1104.camel@laptop>
References: <20100624001148.61e9da1c.isloginov@gmail.com>
	 <1277385096.1875.974.camel@laptop>
	 <20100624172334.ca7e9bef.isloginov@gmail.com>
	 <1277715689.1875.1104.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 28 Jun 2010 13:53:17 +0200
Message-ID: <1277725997.3561.6.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-28 at 11:01 +0200, Peter Zijlstra wrote:

>  static int __init kernel_init(void * unused)
>  {
> +	/*
> +	 * Synchronize against setting kthreadd_task in rest_init().
> +	 * Using a mutex would have been a lot nicer, but since its a very
> +	 * rare race don't bother wasting the space overhead.
> +	 */
> +	while (!kthreadd_task)
> +		yield();
> +
>  	lock_kernel();


I just realized its all __init code so its all 'free' anyway, how about
the nicer version:

---
Subject: init: Fix race between init and kthreadd -v2

Ilya reported that on a very slow machine he could reliably reproduce a
race between forking init and kthreadd. We first fork init so that it 
obtains pid-1, however since the scheduler is already fully running at
this point it can preempt and run the init thread before we spawn and
set kthreadd_task.

The init thread can then attempt spawning kthreads without kthreadd
being present which results in an OOPS.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 init/main.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/init/main.c b/init/main.c
index e2a2bf3..8f2acf5 100644
--- a/init/main.c
+++ b/init/main.c
@@ -420,18 +420,27 @@ static void __init setup_command_line(char *command_line)
  * gcc-3.4 accidentally inlines this function, so use noinline.
  */
 
+static __initdata DEFINE_MUTEX(kthreadd_lock);
+
 static noinline void __init_refok rest_init(void)
 	__releases(kernel_lock)
 {
 	int pid;
 
 	rcu_scheduler_starting();
+	/*
+	 * We need to spawn init first so that it obtains pid-1, however
+	 * the init task will end up wanting to create kthreads, which
+	 * if we schedule it before we create kthreadd, will OOPS.
+	 */
+	mutex_lock(&kthreadd_lock);
 	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
 	numa_default_policy();
 	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
 	rcu_read_lock();
 	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
 	rcu_read_unlock();
+	mutex_unlock(&kthreadd_lock);
 	unlock_kernel();
 
 	/*
@@ -847,6 +856,13 @@ static noinline int init_post(void)
 
 static int __init kernel_init(void * unused)
 {
+	/*
+	 * We spawned this thread while holding this lock, ensure the
+	 * locked section in rest_init() is complete before proceeding.
+	 */
+	mutex_lock(&kthreadd_lock);
+	mutex_unlock(&kthreadd_lock);
+
 	lock_kernel();
 
 	/*

