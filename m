Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682Ab2AMS2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 13:28:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45623 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483Ab2AMS2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 13:28:06 -0500
Date: Fri, 13 Jan 2012 10:27:50 -0800
From: Mandeep Singh Baines <msb@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Q: cgroup: Questions about possible issues in cgroup locking
Message-ID: <20120113182750.GD18166@google.com>
References: <20111221200422.GJ17668@somewhere>
 <20111222153004.GA30522@redhat.com>
 <20120104193614.GF9511@google.com>
 <20120106152356.GA23995@redhat.com>
 <20120106182535.GJ9511@google.com>
 <20120111160730.GA24556@redhat.com>
 <20120112003102.GB9511@google.com>
 <20120112170728.GA25717@redhat.com>
 <20120112175725.GD9511@google.com>
 <20120113152010.GA19215@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120113152010.GA19215@redhat.com>
X-Operating-System: Linux/2.6.38.8-gg683 (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov (oleg@redhat.com) wrote:
> On 01/12, Mandeep Singh Baines wrote:
> >
> > Oleg Nesterov (oleg@redhat.com) wrote:
> > >
> > > Still can't understand... Lets look at this trivial example again.
> > >
> > > We start from the main thread M, it is ->group_leader. There is
> > > another thread T in this thread group. We are doing
> > >
> > > 	OLD = M;
> > >
> > > 	t = M;
> > > 	do {
> > > 		do_smth(t);
> > > 	}
> > > 	while (t->group_leader == OLD && ((t = next_thread(t)) != M);
> > >
> > > The first iteration does do_smth(M).
> > >
> > > T calls de_thread() and, in particular, it does M->group_leader = T
> > > (see "leader->group_leader = tsk" in de_thread).
> > >
> > > after that t->group_leader == OLD fails. t == M, its group_leader == T.
> > > do_smth(T) won't be called.
> > >
> > > No?
> > >
> >
> > I think we can handle this by removing the assignment. So in de_thread():
> >
> > -		leader->group_leader = tsk;
> 
> Ah, so that was you plan. I was confused by the 3rd argument, why
> it is needed?
> 

Good question. On second thought, I don't think its needed as shown
in you're solution below.

> Yes, I thought about this too. Suppose we remove this assignment,
> then we can simply do
> 
> 	#define while_each_thread(g, t) \
> 		while (t->group_leader == g->group_leader && (t = next_thread(t)) != g)
> 
> with the same effect. (to remind, currently I ignore the barriers/etc).
> 

Nice! I think this works.

> But this can _only_ help if we start at the group leader!

But I don't think this solution requires we start at the group leader.

My thinking:

Case 1: g is the exec thread

The only condition under which g->group_leader would change is if g is the
exec thread. If you are the exec the only requirement is that you visit the
exec thread. Visiting any other threads is optional. Since g is the exec
thread, you've already visited it and can safely stop once
g->group_leader is re-assigned to g.

Case 2: g is the group leader

If g is the group leader and a subthread execs, you'll terminate just
after visiting the exec thread.

Case 3: g is some other thread

In this case, g MUST be current so you don't really need to worry
about de_thread() since current can't be de_threaded.

> 
> May be we should enforce this rule (for the lockless case), I dunno...
> In that case I'd prefer to add the new while_each_thread_rcu() helper.
> But! in this case we do not need to change de_thread(), we can simply do
> 
> 	#define while_each_thread_rcu(t) \
> 		while (({ t = next_thread(t); !thread_group_leader(t); }))
> 

Won't this terminate just before visiting the exec thread?

> The definition above was one of the possibilities I considered, but
> I wasn't able to convince myself this is the best option.
> 
> See? Or do you think I missed something?
> 
> Just in case... note that while_each_thread_rcu() doesn't use 'g'
> at all. May be it makes sense to keep the old "t != g &&", but this
> is minor.
> 
> Oleg.
> 

Regards,
Mandeep
