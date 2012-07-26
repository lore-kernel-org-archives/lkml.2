Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab2GZIEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 04:04:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:54124 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab2GZIEb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 04:04:31 -0400
Message-ID: <1343289850.26034.79.camel@twins>
Subject: Re: [PATCH 1/1] kthread: disable preemption during complete()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Boonstoppel <pboonstoppel@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Andy Walls <awalls@md.metrocast.net>,
        Diwakar Tundlam <dtundlam@nvidia.com>, Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Date: Thu, 26 Jul 2012 10:04:10 +0200
In-Reply-To: <20120725224044.GC32378@google.com>
References: <5FBF8E85CA34454794F0F7ECBA79798F379D364859@HQMAIL04.nvidia.com>
	 <20120725000901.GA5304@google.com>
	 <5FBF8E85CA34454794F0F7ECBA79798F379D36485E@HQMAIL04.nvidia.com>
	 <20120725224044.GC32378@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-25 at 15:40 -0700, Tejun Heo wrote:
> (cc'ing Oleg and Peter)

Right, if you're playing games with preemption, always add the rt and
sched folks.. added mingo and tglx.

> On Wed, Jul 25, 2012 at 03:35:32PM -0700, Peter Boonstoppel wrote:
> > After a kthread is created it signals the requester using complete()
> > and enters TASK_UNINTERRUPTIBLE. However, since complete() wakes up
> > the requesting thread this can cause a preemption. The preemption will
> > not remove the task from the runqueue (for that schedule() has to be
> > invoked directly).
> > 
> > This is a problem if directly after kthread creation you try to do a
> > kthread_bind(), which will block in HZ steps until the thread is off
> > the runqueue.
> > 
> > This patch disables preemption during complete(), since we call
> > schedule() directly afterwards, so it will correctly enter
> > TASK_UNINTERRUPTIBLE. This speeds up kthread creation/binding during
> > cpu hotplug significantly.

tglx has patches that make the kthread create/destroy stuff from hotplug
go away.. that seems like the better approach.


> > Signed-off-by: Peter Boonstoppel <pboonstoppel@nvidia.com>
> > ---
> >  kernel/kthread.c |   11 +++++++++++
> >  1 files changed, 11 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/kthread.c b/kernel/kthread.c
> > index b579af5..757d8dd 100644
> > --- a/kernel/kthread.c
> > +++ b/kernel/kthread.c
> > @@ -16,6 +16,7 @@
> >  #include <linux/mutex.h>
> >  #include <linux/slab.h>
> >  #include <linux/freezer.h>
> > +#include <linux/preempt.h>
> >  #include <trace/events/sched.h>
> >  
> >  static DEFINE_SPINLOCK(kthread_create_lock);
> > @@ -113,7 +114,17 @@ static int kthread(void *_create)
> >  	/* OK, tell user we're spawned, wait for stop or wakeup */
> >  	__set_current_state(TASK_UNINTERRUPTIBLE);
> >  	create->result = current;
> > +
> > +	/*
> > +	 * Disable preemption so we enter TASK_UNINTERRUPTIBLE after
> > +	 * complete() instead of possibly being preempted. This speeds
> > +	 * up clients that do a kthread_bind() directly after
> > +	 * creation.
> > +	 */
> > +	preempt_disable();
> 
> Shouldn't this happen before setting current state to UNINTERRUPTIBLE?
> What prevents preemption happening right above preempt_disable()?

Nothing, it also doesn't matter that much, you could get preempted right
before preempt_disable() and end up in the same place.

The main thing is avoiding the wakeup preemption from the complete()
because we're going to sleep right after anyway.

The comment doesn't really make that clear.

> >  	complete(&create->done);
> > +	preempt_enable_no_resched();
> > +
> >  	schedule();

Other than that it seems fine, although I know tglx just loves new
preempt_enable_no_resched() sites ;-)
