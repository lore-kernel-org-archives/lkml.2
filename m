Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab0CZKLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 06:11:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:40771 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751165Ab0CZKLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 06:11:38 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18ZUx1hFy4Zb0YjArgxgtrZ3GhLPi5hp/VeLwDVBN
	GVO0AxucrWUkeI
Subject: Re: [BUG] perf: hard lockup when using perf-sched
From: Mike Galbraith <efault@gmx.de>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <1269509241.8438.30.camel@marge.simson.net>
References: <4BA082EC.8030101@cn.fujitsu.com>
	 <4BA9A885.9050105@cn.fujitsu.com>
	 <1269415964.6530.25.camel@marge.simson.net>
	 <1269418671.6465.6.camel@marge.simson.net>
	 <4BAB1924.4060304@cn.fujitsu.com>
	 <1269509241.8438.30.camel@marge.simson.net>
Content-Type: text/plain
Date: Fri, 26 Mar 2010 11:11:33 +0100
Message-Id: <1269598293.6174.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.47999999999999998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-25 at 10:27 +0100, Mike Galbraith wrote:
> On Thu, 2010-03-25 at 16:04 +0800, Li Zefan wrote:
> > Mike Galbraith wrote:
> > > On Wed, 2010-03-24 at 08:32 +0100, Mike Galbraith wrote:
> > > 
> > >> I just saw this, hunted down your testcase and tried it here.  Looks
> > >> like perf_output_lock() wedged box.
> > > 
> > > (turns on frame pointers, and adds noinline)
> > > 
> > 
> > Thanks! Then who's going to fix this...
> 
> Well, that kinda depends on whether I figure out how the heck it's all
> supposed to work before somebody else whacks it or not.

This seems to work, in contrast to everything I tried yesterday.  Not
exactly a thing of beauty, but at least it's an option, so...

perf: fix perf sched record forkbomb deadlock

perf sched record can deadlock a box should the holder of handle->data->lock
take an interrupt, and then attempt to acquire an rq lock held by a CPU trying
to acquire the same lock.  Disable interrupts.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Reported-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <new-submission>

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 574ee58..2ba2e9f 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3378,15 +3378,23 @@ static void perf_event_task_output(struct perf_event *event,
 				     struct perf_task_event *task_event)
 {
 	struct perf_output_handle handle;
-	int size;
 	struct task_struct *task = task_event->task;
-	int ret;
+	unsigned long flags;
+	int size, ret;
+
+	/*
+	 * If this CPU attempts to acquire an rq lock held by a CPU spinning
+	 * in perf_output_lock() from interrupt context, it's game over.
+	 */
+	local_irq_save(flags);
 
 	size  = task_event->event_id.header.size;
 	ret = perf_output_begin(&handle, event, size, 0, 0);
 
-	if (ret)
+	if (ret) {
+		local_irq_restore(flags);
 		return;
+	}
 
 	task_event->event_id.pid = perf_event_pid(event, task);
 	task_event->event_id.ppid = perf_event_pid(event, current);
@@ -3397,6 +3405,7 @@ static void perf_event_task_output(struct perf_event *event,
 	perf_output_put(&handle, task_event->event_id);
 
 	perf_output_end(&handle);
+	local_irq_restore(flags);
 }
 
 static int perf_event_task_match(struct perf_event *event)


