Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab0F1JBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 05:01:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:35765 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685Ab0F1JBi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 05:01:38 -0400
Subject: [PATCH] init: Fix race between init and kthreadd
From: Peter Zijlstra <peterz@infradead.org>
To: Ilya Loginov <isloginov@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100624172334.ca7e9bef.isloginov@gmail.com>
References: <20100624001148.61e9da1c.isloginov@gmail.com>
	 <1277385096.1875.974.camel@laptop>
	 <20100624172334.ca7e9bef.isloginov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 28 Jun 2010 11:01:29 +0200
Message-ID: <1277715689.1875.1104.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 17:23 +0400, Ilya Loginov wrote:
> On Thu, 24 Jun 2010 15:11:36 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > However I suspect the ordering is like it is because we want init to
> > have pid 1, if we were to re-order like you suggest kthreadd will end up
> > with pid 1 and init with pid 2.
> 
> Strange, but init does not die after I did this. Fix me if I wrong, but it wants
> to have pid 1, and die in other case.

Does something like this work for you?

---
Subject: init: Fix race between init and kthreadd
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Jun 28 10:49:09 CEST 2010

Ilya reported that on a very slow machine he could reliably reproduce a
race between forking init and kthreadd. We first fork init so that it 
obtains pid-1, however since the scheduler is already fully running at
this point it can preempt and run the init thread before we spawn and
set kthreadd_task.

The init thread can then attempt spawning kthreads without kthreadd being
present which results in an OOPS.

Cure this in a crude way by having the init task spin-wait on 
kthreadd_task. Nicer solutions are more complex and have more overhead
which doesn't appear worth it.

Reported-by: Ilya Loginov <isloginov@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 init/main.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -426,6 +426,17 @@ static noinline void __init_refok rest_i
 	int pid;
 
 	rcu_scheduler_starting();
+	/*
+	 * Here we first fork the init thread and then the kthreadd so that
+	 * init ends up with pid-1.
+	 *
+	 * Since the scheduler is already fully active we can end up
+	 * running the init thread for long enough to start spawning kthreads
+	 * before this thread continues and spawns/sets kthreadd, which
+	 * would result in an OOPS.
+	 *
+	 * See the serialization against kthreadd_task in kernel_init().
+	 */
 	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
 	numa_default_policy();
 	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
@@ -847,6 +858,14 @@ static noinline int init_post(void)
 
 static int __init kernel_init(void * unused)
 {
+	/*
+	 * Synchronize against setting kthreadd_task in rest_init().
+	 * Using a mutex would have been a lot nicer, but since its a very
+	 * rare race don't bother wasting the space overhead.
+	 */
+	while (!kthreadd_task)
+		yield();
+
 	lock_kernel();
 
 	/*

