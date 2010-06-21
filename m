Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671Ab0FUVi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 17:38:26 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57505 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758606Ab0FUViY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 17:38:24 -0400
Date: Mon, 21 Jun 2010 14:38:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
Message-ID: <20100621213820.GJ2354@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100618190251.GA17297@redhat.com>
 <20100618193403.GA17314@redhat.com>
 <20100618223354.GL2365@linux.vnet.ibm.com>
 <20100621170919.GA13826@redhat.com>
 <20100621205128.GI2354@linux.vnet.ibm.com>
 <m1mxuo2i8c.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1mxuo2i8c.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 02:22:59PM -0700, Eric W. Biederman wrote:
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
> 
> > On Mon, Jun 21, 2010 at 07:09:19PM +0200, Oleg Nesterov wrote:
> >> On 06/18, Paul E. McKenney wrote:
> >> >
> >> > On Fri, Jun 18, 2010 at 09:34:03PM +0200, Oleg Nesterov wrote:
> >> > >
> >> > > 	#define XXX(t)	({
> >> > > 		struct task_struct *__prev = t;
> >> > > 		t = next_thread(t);
> >> > > 		t != g && t != __prev;
> >> > > 	})
> >> > >
> >> > > 	#define while_each_thread(g, t) \
> >> > > 		while (XXX(t))
> >> >
> >> > Isn't the above vulnerable to a pthread_create() immediately following
> >> > the offending exec()?  Especially if the task doing the traversal is
> >> > preempted?
> >> 
> >> Yes, thanks!
> >> 
> >> > here are some techniques that might (or might not) help:
> >> 
> >> To simplify, let's consider the concrete example,
> >
> > Sounds very good!
> >
> >> 	rcu_read_lock();
> >> 
> >> 	g = t = returns_the_rcu_safe_task_struct_ptr();
> >
> > This returns a pointer to the task struct of the current thread?
> > Or might this return a pointer some other thread's task struct?
> >
> >> 	do {
> >> 		printk("%d\n", t->pid);
> >> 	} while_each_thread(g, t);
> >> 
> >> 	rcu_read_unlock();
> >> 
> >> Whatever we do, without tasklist/siglock this can obviously race
> >> with fork/exit/exec. It is OK to miss a thread, or print the pid
> >> of the already exited/released task.
> >> 
> >> But it should not loop forever (the subject), and it should not
> >> print the same pid twice (ignoring pid reuse, of course).
> >> 
> >> And, afaics, there are no problems with rcu magic per se, next_thread()
> >> always returns the task_struct we can safely dereference. The only
> >> problem is that while_each_thread() assumes that sooner or later
> >> next_thread() must reach the starting point, g.
> >> 
> >> (zap_threads() is different, it must not miss a thread with ->mm
> >>  we are going to dump, but it holds mmap_sem).
> >
> > Indeed, the tough part is figuring out when you are done given that things
> > can come and go at will.  Some additional tricks, in no particular order:
> >
> > 1.	Always start at the group leader.  Of course, the group leader
> > 	is probably permitted to leave any time it wants to, so this
> > 	is not sufficient in and of itself.
> 
> No.  The group leader must exist as long as the group exists.
> Modulo de_thread weirdness.  The group_leader can be a zombie but
> it can not go away completely.

Ah, OK -- now that you mention it, all the thinks that I can think of
that remove a thread from a group have the side effect of destroying
the old group (exec() and exit()).  Other things that create a new thread
group leave the old thread group intact.

Or am I forgetting some odd operation?

> > 2.	Maintain a separate task structure that flags the head of the
> > 	list.  This separate structure is freed one RCU grace period
> > 	following the disappearance of the current group leader.  This
> > 	should be quite robust, but "holy overhead, Batman!!!"  (Apologies
> > 	for the American pop culture reference, but nothing else seemed
> > 	appropriate.)
> 
> That is roughly what we have in the group leader right now.

But can't the group leader do an exec(), becoming the leader of a new
thread group without waiting for a grace period?  Or this possibility
already covered?

							Thanx, Paul
