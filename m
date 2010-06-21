Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087Ab0FURMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 13:12:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818Ab0FURMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 13:12:05 -0400
Date: Mon, 21 Jun 2010 19:09:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
Message-ID: <20100621170919.GA13826@redhat.com>
References: <20100618190251.GA17297@redhat.com> <20100618193403.GA17314@redhat.com> <20100618223354.GL2365@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100618223354.GL2365@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18, Paul E. McKenney wrote:
>
> On Fri, Jun 18, 2010 at 09:34:03PM +0200, Oleg Nesterov wrote:
> >
> > 	#define XXX(t)	({
> > 		struct task_struct *__prev = t;
> > 		t = next_thread(t);
> > 		t != g && t != __prev;
> > 	})
> >
> > 	#define while_each_thread(g, t) \
> > 		while (XXX(t))
>
> Isn't the above vulnerable to a pthread_create() immediately following
> the offending exec()?  Especially if the task doing the traversal is
> preempted?

Yes, thanks!

> here are some techniques that might (or might not) help:

To simplify, let's consider the concrete example,

	rcu_read_lock();

	g = t = returns_the_rcu_safe_task_struct_ptr();

	do {
		printk("%d\n", t->pid);
	} while_each_thread(g, t);

	rcu_read_unlock();

Whatever we do, without tasklist/siglock this can obviously race
with fork/exit/exec. It is OK to miss a thread, or print the pid
of the already exited/released task.

But it should not loop forever (the subject), and it should not
print the same pid twice (ignoring pid reuse, of course).

And, afaics, there are no problems with rcu magic per se, next_thread()
always returns the task_struct we can safely dereference. The only
problem is that while_each_thread() assumes that sooner or later
next_thread() must reach the starting point, g.

(zap_threads() is different, it must not miss a thread with ->mm
 we are going to dump, but it holds mmap_sem).

> o	Check ACCESS_ONCE(p->group_leader == g),

	but this assumeas that while_each_thread(g, t) always
	uses g == group_leader. zap_other_threads(), for example,
	starts with g == current and not necessarily the leader.

> if false, restart
> 	the traversal.

I am not sure we should restart (don't pid the same pid twice),
probably we should break the loop.

So, I am thinking about the first attempt

	#define while_each_thread(g, t) \
		while ((t = next_thread(t)) != g && pid_alive(g))

again. But this means while_each_thread() can miss more threads
than it currently can under the same conditions. Correct, but
not good.

And,

> 	This of course might
> 	require careful attention of the order of updates to ->group_leader
> 	and the list pointers.

Yes. At least the code above needs barriers, and I am not sure
it can be really correct without more complications.

> o	Maintain an ->oldnext field that tracks the old pointer to
> 	the next task for one RCU grace period after a de_thread()
> 	operation.  When the grace period expires (presumably via
> 	call_rcu()), the ->oldnext field is set to NULL.

Well, another field in task_struct...

> o	Do the de_thread() incrementally.  So if the list is tasks A,
> 	B, and C, in that order, and if we are de-thread()ing B,
> 	then make A's pointer refer to C,

This breaks while_each_thread() under tasklist/siglock. It must
see all unhashed tasks.

Oh. I'll try to think more, but I also hope someone else can suggest
a simple solution.

> > Please tell me I am wrong!
>
> It would take a braver man than me to say that Oleg Nesterov is wrong!

Hmm. Given that you proved I was wrong in the first lines of your
email, I do not know what to think ;)

Oleg.

