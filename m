Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562Ab0FUUvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:51:36 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40299 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758494Ab0FUUve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:51:34 -0400
Date: Mon, 21 Jun 2010 13:51:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
Message-ID: <20100621205128.GI2354@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100618190251.GA17297@redhat.com>
 <20100618193403.GA17314@redhat.com>
 <20100618223354.GL2365@linux.vnet.ibm.com>
 <20100621170919.GA13826@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100621170919.GA13826@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 07:09:19PM +0200, Oleg Nesterov wrote:
> On 06/18, Paul E. McKenney wrote:
> >
> > On Fri, Jun 18, 2010 at 09:34:03PM +0200, Oleg Nesterov wrote:
> > >
> > > 	#define XXX(t)	({
> > > 		struct task_struct *__prev = t;
> > > 		t = next_thread(t);
> > > 		t != g && t != __prev;
> > > 	})
> > >
> > > 	#define while_each_thread(g, t) \
> > > 		while (XXX(t))
> >
> > Isn't the above vulnerable to a pthread_create() immediately following
> > the offending exec()?  Especially if the task doing the traversal is
> > preempted?
> 
> Yes, thanks!
> 
> > here are some techniques that might (or might not) help:
> 
> To simplify, let's consider the concrete example,

Sounds very good!

> 	rcu_read_lock();
> 
> 	g = t = returns_the_rcu_safe_task_struct_ptr();

This returns a pointer to the task struct of the current thread?
Or might this return a pointer some other thread's task struct?

> 	do {
> 		printk("%d\n", t->pid);
> 	} while_each_thread(g, t);
> 
> 	rcu_read_unlock();
> 
> Whatever we do, without tasklist/siglock this can obviously race
> with fork/exit/exec. It is OK to miss a thread, or print the pid
> of the already exited/released task.
> 
> But it should not loop forever (the subject), and it should not
> print the same pid twice (ignoring pid reuse, of course).
> 
> And, afaics, there are no problems with rcu magic per se, next_thread()
> always returns the task_struct we can safely dereference. The only
> problem is that while_each_thread() assumes that sooner or later
> next_thread() must reach the starting point, g.
> 
> (zap_threads() is different, it must not miss a thread with ->mm
>  we are going to dump, but it holds mmap_sem).

Indeed, the tough part is figuring out when you are done given that things
can come and go at will.  Some additional tricks, in no particular order:

1.	Always start at the group leader.  Of course, the group leader
	is probably permitted to leave any time it wants to, so this
	is not sufficient in and of itself.

2.	Maintain a separate task structure that flags the head of the
	list.  This separate structure is freed one RCU grace period
	following the disappearance of the current group leader.  This
	should be quite robust, but "holy overhead, Batman!!!"  (Apologies
	for the American pop culture reference, but nothing else seemed
	appropriate.)

3.	Like #2, but reduce the storage overhead by using a structure
	containing only the pointers and perhaps a few additional fields.
	Set one of the bottom bits of one of the pointers to flag the fact
	that this is a special structure, allowing the reader to take
	note and do any additional checks required.

	Of course, it is possible for a reader to be diverted onto a
	new thread group, so it is then also possible that it needs
	to return back to the previous thread group.  The smaller structure
	corresponding to the smaller structure might contain the
	pointers required for it to make this transition.

	Please note that a given thread group will have several of
	these structures if several thread-group depart in quick
	succession.  The smaller structure would need to contain
	enough information to allow the reader to thread back to
	whatever group-leader task it started from.  Which will likely
	make managing the lifetimes of these smaller structures
	"interesting"...  Though this could be eased by maintaining
	forward links as well as backwards links.  Then when the
	grace period expired, the corresponding backwards links could
	be NULLed -- and a second grace period would likely be needed.

	It is tempting to leave these special structs out of any
	thread groups that have not yet had a leader depart, but this
	is probably vulnerable to looping.  (It might be possible to
	avoid this, but additional checks are required.)

There are other approaches, but it is probably time for you to teach me
more about the requirements you face.

> > o	Check ACCESS_ONCE(p->group_leader == g),
> 
> 	but this assumeas that while_each_thread(g, t) always
> 	uses g == group_leader. zap_other_threads(), for example,
> 	starts with g == current and not necessarily the leader.
> 
> > if false, restart
> > 	the traversal.
> 
> I am not sure we should restart (don't pid the same pid twice),
> probably we should break the loop.
> 
> So, I am thinking about the first attempt
> 
> 	#define while_each_thread(g, t) \
> 		while ((t = next_thread(t)) != g && pid_alive(g))
> 
> again. But this means while_each_thread() can miss more threads
> than it currently can under the same conditions. Correct, but
> not good.

OK, so we really want to complete the scan through the thread group, or
at least avoid introducing additional tendency to not complete the scan.
Good to know.  ;-)

> And,
> 
> > 	This of course might
> > 	require careful attention of the order of updates to ->group_leader
> > 	and the list pointers.
> 
> Yes. At least the code above needs barriers, and I am not sure
> it can be really correct without more complications.

Agreed!

> > o	Maintain an ->oldnext field that tracks the old pointer to
> > 	the next task for one RCU grace period after a de_thread()
> > 	operation.  When the grace period expires (presumably via
> > 	call_rcu()), the ->oldnext field is set to NULL.
> 
> Well, another field in task_struct...

Yeah, would be good to avoid this.  Not sure it can be avoided, though.

> > o	Do the de_thread() incrementally.  So if the list is tasks A,
> > 	B, and C, in that order, and if we are de-thread()ing B,
> > 	then make A's pointer refer to C,
> 
> This breaks while_each_thread() under tasklist/siglock. It must
> see all unhashed tasks.

Could de_thread() hold those locks in order to avoid that breakage?

> Oh. I'll try to think more, but I also hope someone else can suggest
> a simple solution.

;-)

> > > Please tell me I am wrong!
> >
> > It would take a braver man than me to say that Oleg Nesterov is wrong!
> 
> Hmm. Given that you proved I was wrong in the first lines of your
> email, I do not know what to think ;)

Ah, but I didn't prove you wrong.  Instead, I simply asked if you
were wrong.  You supplied the proof.  ;-)

							Thanx, Paul
