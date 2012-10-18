Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658Ab2JRR4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:56:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932125Ab2JRR4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:56:44 -0400
Date: Thu, 18 Oct 2012 19:57:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] brw_mutex: big read-write mutex
Message-ID: <20121018175747.GA30691@redhat.com>
References: <20121015190958.GA4799@redhat.com> <20121015191018.GA4816@redhat.com> <CA+55aFwV-WOUx8MSr145f+HSrtmZ=nXHq0VLhtPyH=FNBFwmQg@mail.gmail.com> <20121017165902.GB9872@redhat.com> <20121017224430.GC2518@linux.vnet.ibm.com> <20121018162409.GA28504@redhat.com> <20121018163833.GK2518@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121018163833.GK2518@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18, Paul E. McKenney wrote:
>
> On Thu, Oct 18, 2012 at 06:24:09PM +0200, Oleg Nesterov wrote:
> >
> > I thought that you meant that without mb() brw_start_write() can
> > race with brw_end_read() and hang forever.
> >
> > But probably you meant that we need the barriers to ensure that,
> > say, if the reader does
> >
> > 	brw_start_read();
> > 	CONDITION = 1;
> > 	brw_end_read();
> >
> > then the writer must see CONDITION != 0 after brw_start_write() ?
> > (or vice-versa)
>
> Yes, this is exactly my concern.

Oh, thanks at lot Paul (as always).

> > In this case we need the barrier, yes. Obviously brw_start_write()
> > can return right after this_cpu_dec() and before wake_up_all().
> >
> > 2/2 doesn't need this guarantee but I agree, this doesn't look
> > sane in gerenal...
>
> Or name it something not containing "lock".  And clearly document
> the behavior and how it is to be used.  ;-)

this would be insane, I guess ;)

So. Ignoring the possible optimization you mentioned before,
brw_end_read() should do:

	smp_mb();
	this_cpu_dec();

	wake_up_all();

And yes, we need the full mb(). wmb() is enough to ensure that the
writer will see the memory modifications done by the reader. But we
also need to ensure that any LOAD inside start_read/end_read can not
be moved outside of the critical section.

But we should also ensure that "read" will see all modifications
which were done under start_write/end_write. This means that
brw_end_write() needs another synchronize_sched() before
atomic_dec_and_test(), or brw_start_read() needs mb() in the
fast-path.

Correct?



Ooooh. And I just noticed include/linux/percpu-rwsem.h which does
something similar. Certainly it was not in my tree when I started
this patch... percpu_down_write() doesn't allow multiple writers,
but the main problem it uses msleep(1). It should not, I think.

But. It seems that percpu_up_write() is equally wrong? Doesn't
it need synchronize_rcu() before "p->locked = false" ?

(add Mikulas)

Oleg.

