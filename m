Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967690Ab2EQUJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 16:09:11 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44617 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966020Ab2EQUJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 16:09:00 -0400
Date: Thu, 17 May 2012 13:08:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>
Subject: Re: [RFC][PATCH RT] rwsem_rt: Another (more sane) approach to mulit
 reader rt locks
Message-ID: <20120517200838.GL2567@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1337090625.14207.304.camel@gandalf.stny.rr.com>
 <20120517151838.GA8692@linux.vnet.ibm.com>
 <1337268779.4281.38.camel@twins>
 <20120517154755.GG2567@linux.vnet.ibm.com>
 <1337271467.4281.43.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337271467.4281.43.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051720-5806-0000-0000-000015522476
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 06:17:47PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-05-17 at 08:47 -0700, Paul E. McKenney wrote:
> > On Thu, May 17, 2012 at 05:32:59PM +0200, Peter Zijlstra wrote:
> > > On Thu, 2012-05-17 at 08:18 -0700, Paul E. McKenney wrote:
> > > > Some researchers at MIT RCU-ified this lock:
> > > > 
> > > > http://people.csail.mit.edu/nickolai/papers/clements-bonsai.pdf 
> > > 
> > > Ah, as have I [1].. and they seem to have gotten about as far as I have,
> > > which means almost there but not quite [2] :-)
> > 
> > I had forgotten about that -- that was the first call for call_srcu(),
> > if I remember correctly.
> > 
> > > The most interesting case is file maps and they simply ignored those.
> > > While I appreciate that from an academic pov, -- they can still write a
> > > paper on the other interesting bits -- I don't really like it from a
> > > practical point.
> > > 
> > > [1] https://lkml.org/lkml/2010/1/4/257
> > > [2] https://lkml.org/lkml/2010/1/4/532
> > 
> > Hmmm...  Do the recent dcache changes cover some of the things that
> > Linus called out?  Probably not, but some at least.
> 
> No, and the points viro made:
> 
>   https://lkml.org/lkml/2010/1/5/194
> 
> are still very much an issue, you really don't want to do fput() from an
> asynchronous context. Which means you have to do synchronize_rcu() or
> similar from munmap() which will be rather unpopular :/

I don't claim to understand all of the code, but I am also unafraid to
ask stupid questions.  ;-)

So, is it possible to do something like the following?

1.	Schedule a workqueue from an RCU callback, and to have that
	workqueue do the fput.

2.	Make things like unmount() do rcu_barrier() followed by
	flush_workqueue(), or probably multiple flush_workqueue()s.

3.	If someone concurrently does munmap() and a write to the
	to-be-unmapped region, then the write can legally happen.

4.	Acquire mmap_sem in the fault path, but only if the fault
	requires blocking, and recheck the situation under
	mmap_sem -- the hope being to prevent long-lived page
	faults from messing things up.

Fire away!  ;-)

> Since we should not use per-cpu data for either files or processes
> (there are simply too many of those around) the alternative is
> horrendously hideous things like:
> 
>   https://lkml.org/lkml/2010/1/6/136
> 
> which one cannot get away with either.
> 
> The whole thing is very vexing indeed since all of this is only needed
> for ill-behaved applications since a well-constructed application will
> never fault in a range it is concurrently unmapping.
> 
> Most annoying.

No argument there!!!

							Thanx, Paul

