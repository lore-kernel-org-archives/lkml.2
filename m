Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab0JVIOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 04:14:44 -0400
Received: from fep15.mx.upcmail.net ([62.179.121.35]:53520 "EHLO
	fep15.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab0JVIOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 04:14:42 -0400
X-SourceIP: 80.56.199.130
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
 trace_sched_wakeup.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jason Baron <jbaron@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, tj@kernel.org
In-Reply-To: <20101022014441.GA1948@redhat.com>
References: <1287508282.16971.386.camel@gandalf.stny.rr.com>
	 <20101019184111.GA17266@elte.hu> <20101020154045.GA18353@elte.hu>
	 <1287659656.16971.573.camel@gandalf.stny.rr.com>
	 <20101021112614.GB26984@elte.hu>  <20101022014441.GA1948@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Oct 2010 10:14:31 +0200
Message-ID: <1287735271.15336.18.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=O+FWVpunvrlG1gSnSO6WiIQ7o0MJ4laHqrEcUJ8XjIg= c=1 sm=0 a=LuwKl7ggZIAA:10 a=IkcTkHD0fZMA:10 a=Ux9TcuoMXH1ZqVfFiIQA:9 a=CaMxNW5FABa0TKShFKkA:7 a=33iUFdCBONMFPQR9djOxYduFjRwA:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-21 at 21:44 -0400, Jason Baron wrote:

> I finally found that we actually continue to run after the above
> apparent 'hang'. That is, we continue to make progress updating the jump
> labels. And doing a dump of all the system tasks at the time of the hang
> showed the processes in various places besides the stop machine threads.
> Thus, I thought that perhaps, for some reason the stop machine threads
> weren't being scheduled.
> 
> Thus, I tried commenting out the special scheduling that is set up for
> stop machine threads, and that fixed the hang. I haven't yet looked into
> what might be going wrong with that scheduling...but maybe somebody else
> knows...

Hrmm, so are you saying rq->stop was runnable but not running?

That would imply broken wakeup-preemption, does something like the below
cure that?


---
 kernel/sched_stoptask.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_stoptask.c b/kernel/sched_stoptask.c
index 45bddc0..50ad10f 100644
--- a/kernel/sched_stoptask.c
+++ b/kernel/sched_stoptask.c
@@ -35,6 +35,7 @@ static struct task_struct *pick_next_task_stop(struct rq *rq)
 static void
 enqueue_task_stop(struct rq *rq, struct task_struct *p, int flags)
 {
+	resched_cpu(cpu_of(rq));
 }
 
 static void


