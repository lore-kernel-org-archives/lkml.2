Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab2JRQXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 12:23:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757026Ab2JRQXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:23:36 -0400
Date: Thu, 18 Oct 2012 18:24:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] brw_mutex: big read-write mutex
Message-ID: <20121018162409.GA28504@redhat.com>
References: <20121015190958.GA4799@redhat.com> <20121015191018.GA4816@redhat.com> <CA+55aFwV-WOUx8MSr145f+HSrtmZ=nXHq0VLhtPyH=FNBFwmQg@mail.gmail.com> <20121017165902.GB9872@redhat.com> <20121017224430.GC2518@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121017224430.GC2518@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17, Paul E. McKenney wrote:
>
> On Wed, Oct 17, 2012 at 06:37:02PM +0200, Oleg Nesterov wrote:
> > On 10/16, Paul E. McKenney wrote:
> > >
> > > Suppose that the writer arrives and sees that the value of the counter
> > > is zero,
> >
> > after synchronize_sched(). So there are no readers (but perhaps there
> > are brw_end_read's in flight which already decremented read_ctr)
>
> But the preempt_disable() region only covers read acquisition.  So
> synchronize_sched() waits only for all the brw_start_read() calls to
> reach the preempt_enable()

Yes.

> -- it cannot wait for all the resulting
> readers to reach the corresponding brw_end_read().

Indeed.

> > > and thus never sleeps, and so is also not awakened?
> >
> > and why do we need wakeup in this case?
>
> To get the memory barriers required to keep the critical sections
> ordered -- to ensure that everyone sees the reader's critical section
> as ending before the writer's critical section starts.

And now I am starting to think I misunderstood your concern from
the very beginning.

I thought that you meant that without mb() brw_start_write() can
race with brw_end_read() and hang forever.

But probably you meant that we need the barriers to ensure that,
say, if the reader does

	brw_start_read();
	CONDITION = 1;
	brw_end_read();

then the writer must see CONDITION != 0 after brw_start_write() ?
(or vice-versa)


In this case we need the barrier, yes. Obviously brw_start_write()
can return right after this_cpu_dec() and before wake_up_all().

2/2 doesn't need this guarantee but I agree, this doesn't look
sane in gerenal...

Or I misunderstood you again?

Oleg.

