Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402Ab2JSVoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 17:44:09 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:57050 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab2JSVoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 17:44:07 -0400
Date: Fri, 19 Oct 2012 12:28:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] brw_mutex: big read-write mutex
Message-ID: <20121019192838.GM2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121015190958.GA4799@redhat.com>
 <20121015191018.GA4816@redhat.com>
 <CA+55aFwV-WOUx8MSr145f+HSrtmZ=nXHq0VLhtPyH=FNBFwmQg@mail.gmail.com>
 <20121017165902.GB9872@redhat.com>
 <20121017224430.GC2518@linux.vnet.ibm.com>
 <20121018162409.GA28504@redhat.com>
 <20121018163833.GK2518@linux.vnet.ibm.com>
 <20121018175747.GA30691@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121018175747.GA30691@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101921-5406-0000-0000-00000144A4E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 07:57:47PM +0200, Oleg Nesterov wrote:
> On 10/18, Paul E. McKenney wrote:
> >
> > On Thu, Oct 18, 2012 at 06:24:09PM +0200, Oleg Nesterov wrote:
> > >
> > > I thought that you meant that without mb() brw_start_write() can
> > > race with brw_end_read() and hang forever.
> > >
> > > But probably you meant that we need the barriers to ensure that,
> > > say, if the reader does
> > >
> > > 	brw_start_read();
> > > 	CONDITION = 1;
> > > 	brw_end_read();
> > >
> > > then the writer must see CONDITION != 0 after brw_start_write() ?
> > > (or vice-versa)
> >
> > Yes, this is exactly my concern.
> 
> Oh, thanks at lot Paul (as always).

Glad it helped.  ;-)

> > > In this case we need the barrier, yes. Obviously brw_start_write()
> > > can return right after this_cpu_dec() and before wake_up_all().
> > >
> > > 2/2 doesn't need this guarantee but I agree, this doesn't look
> > > sane in gerenal...
> >
> > Or name it something not containing "lock".  And clearly document
> > the behavior and how it is to be used.  ;-)
> 
> this would be insane, I guess ;)

Well, I suppose you could call it a "phase" : brw_start_phase_1() and
so on.

> So. Ignoring the possible optimization you mentioned before,
> brw_end_read() should do:
> 
> 	smp_mb();
> 	this_cpu_dec();
> 
> 	wake_up_all();
> 
> And yes, we need the full mb(). wmb() is enough to ensure that the
> writer will see the memory modifications done by the reader. But we
> also need to ensure that any LOAD inside start_read/end_read can not
> be moved outside of the critical section.
> 
> But we should also ensure that "read" will see all modifications
> which were done under start_write/end_write. This means that
> brw_end_write() needs another synchronize_sched() before
> atomic_dec_and_test(), or brw_start_read() needs mb() in the
> fast-path.
> 
> Correct?

Good point, I missed the need for synchronize_sched() to avoid
readers sleeping through the next write cycle due to racing with
an exiting writer.  But yes, this sounds correct.

> Ooooh. And I just noticed include/linux/percpu-rwsem.h which does
> something similar. Certainly it was not in my tree when I started
> this patch... percpu_down_write() doesn't allow multiple writers,
> but the main problem it uses msleep(1). It should not, I think.
> 
> But. It seems that percpu_up_write() is equally wrong? Doesn't
> it need synchronize_rcu() before "p->locked = false" ?
> 
> (add Mikulas)

Mikulas said something about doing an updated patch, so I figured I
would look at his next version.

							Thanx, Paul

