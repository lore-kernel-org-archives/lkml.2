Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab1I3DsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 23:48:21 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56009 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757278Ab1I3DsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 23:48:19 -0400
Date: Thu, 29 Sep 2011 20:48:15 -0700
From: Tejun Heo <htejun@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched/kthread: Complain loudly when others violate our
 flags
Message-ID: <20110930034815.GF10425@mtj.dyndns.org>
References: <1317158254.26514.55.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317158254.26514.55.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Steven.

Sorry about the delay, coming back from a rather long vacation.

On Tue, Sep 27, 2011 at 05:17:34PM -0400, Steven Rostedt wrote:
> I looked at the task that it tried to migrate, and it happened to be the
> kworker thread! Then I went into kernel/workqueue.c and found this
> nonsense:
> 
> 	if (bind && !on_unbound_cpu)
> 		kthread_bind(worker->task, gcwq->cpu);
> 	else {
> 		worker->task->flags |= PF_THREAD_BOUND;
> 		if (on_unbound_cpu)
> 			worker->flags |= WORKER_UNBOUND;
> 	}
> 
> Nothing but the scheduler and kthread_bind() has the right to set the
> PF_THREAD_BOUND flag. Especially when the thread IS NOT BOUNDED!!!!!!
> 
> I don't go around and stick my hand down your pants to play with your
> flags! Don't stick your hand in ours and play with our flags!
> 
> WTF is the workqueue code setting the PF_THREAD_BOUND flag manually?
> Talk about fragile coupling! You just made this flag meaningless. Don't
> do that.

IIRC, this was because there was no way to set PF_THREAD_BOUND once a
kthread starts to run and workers can stay active across CPU bring
down/up cycle.  Per-cpu kthreads need PF_THREAD_BOUND to prevent cpu
affinity manipulation by third party for correctness.

> Sorry but I just wasted two whole days because of this nonsense and I'm
> not particularly happy about it.

Sorry that it wasted your time and made you unhappy but wouldn't
grepping for its usage a logical thing if you wanted to add to what it
meant?  PF_THREAD_BOUND meaning the task's affinity or cpuset can't be
manipulated by third party seems like a valid interpretation.

Simply removing it would allow breaking workqueue from userland by
manipulating affinity.  How about testing PF_WQ_WORKER in
set_cpus_allowed_ptr() (and maybe cpuset, I'm not sure)?

Thanks.

-- 
tejun
