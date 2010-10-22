Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479Ab0JVSJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:09:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755849Ab0JVSJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:09:46 -0400
Date: Fri, 22 Oct 2010 11:09:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v2.6.36-rc7] init: don't call flush_scheduled_work()
 from do_initcalls()
Message-Id: <20101022110925.ea1263f8.akpm@linux-foundation.org>
In-Reply-To: <4CC14ADA.9080706@kernel.org>
References: <4CB86F94.7080702@kernel.org>
	<20101021171203.37d0d6d6.akpm@linux-foundation.org>
	<4CC14ADA.9080706@kernel.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010 10:27:06 +0200 Tejun Heo <tj@kernel.org> wrote:

> > If you really don't like people sending you angry emails then I suppose
> > you could add some warning here if a scheduled work is pending, and
> > that the scheduled work's callback existed in init.text memory.  Which
> > would be a bit of a pain to implement.
> > 
> > Oh well.  The oops traces will make it fairly clear what happened.
> 
> I haven't pushed the patch to Linus yet.  I'll remove it for now and
> try to implement something which at least checks the text section of
> pending and running works.

mm..  I think we'd be OK to merge it.  Any such code is pretty badly
buggy and is probably also crashable with a well-timed rmmod.

It'll also be code which few people ever use, so any runtime checks
won't get us very good coverage.

Still, if it's not too hard to implement an "are there any scheduled
works which live in initmem" check then I guess that would be the
prudent approach.  A quite gross way of implementing that might be
something like


 init/main.c        |    3 +++
 kernel/workqueue.c |   11 ++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff -puN init/main.c~a init/main.c
--- a/init/main.c~a
+++ a/init/main.c
@@ -125,6 +125,7 @@ static char *ramdisk_execute_command;
 unsigned int setup_max_cpus = NR_CPUS;
 EXPORT_SYMBOL(setup_max_cpus);
 
+int scheduled_work_hack;
 
 /*
  * Setup routine for controlling SMP activation
@@ -780,7 +781,9 @@ static void __init do_initcalls(void)
 		do_one_initcall(*fn);
 
 	/* Make sure there is no pending stuff from the initcall sequence */
+	scheduled_work_hack++;
 	flush_scheduled_work();
+	scheduled_work_hack++;
 }
 
 /*
diff -puN kernel/workqueue.c~a kernel/workqueue.c
--- a/kernel/workqueue.c~a
+++ a/kernel/workqueue.c
@@ -41,6 +41,7 @@
 #include <linux/debug_locks.h>
 #include <linux/lockdep.h>
 #include <linux/idr.h>
+#include <asm/sections.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/workqueue.h>
@@ -1819,7 +1820,15 @@ __acquires(&gcwq->lock)
 	lock_map_acquire(&cwq->wq->lockdep_map);
 	lock_map_acquire(&lockdep_map);
 	trace_workqueue_execute_start(work);
-	f(work);
+	{
+		extern int scheduled_work_hack;
+
+		if (scheduled_work_hack &&
+		    (f >= (void *)__init_begin && f < (void *)__init_end))
+			eek();
+		else
+			f(work);
+	}
 	/*
 	 * While we must be careful to not use "work" after this, the trace
 	 * point will only record its address.
_

