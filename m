Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793Ab2ALAbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 19:31:19 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37290 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab2ALAbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 19:31:17 -0500
Date: Wed, 11 Jan 2012 16:31:02 -0800
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
Message-ID: <20120112003102.GB9511@google.com>
References: <20111221175632.GF17668@somewhere>
 <20111221190102.GE13529@google.com>
 <20111221190817.GI17668@somewhere>
 <20111221192413.GF13529@google.com>
 <20111221200422.GJ17668@somewhere>
 <20111222153004.GA30522@redhat.com>
 <20120104193614.GF9511@google.com>
 <20120106152356.GA23995@redhat.com>
 <20120106182535.GJ9511@google.com>
 <20120111160730.GA24556@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120111160730.GA24556@redhat.com>
X-Operating-System: Linux/2.6.38.8-gg621 (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

Oleg Nesterov (oleg@redhat.com) wrote:
> On 01/06, Mandeep Singh Baines wrote:
> >
> > Oleg Nesterov (oleg@redhat.com) wrote:
> > >
> > > > > in particular, http://marc.info/?l=linux-kernel&m=127714242731448
> > > > > I think this should work, but then we should do something with the
> > > > > users like zap_threads().
> > > > >
> > > >
> > > > With that patch, won't you potentially miss the exec thread if an exec
> > > > occurs while you're iterating over the list? Is that OK?
> > >
> > > Of course it is not OK ;) Note the "we should do something with" above.
> > >
> >
> > So requirements should be something like this:
> 
> (I assume, you mean the lockless case)
> 

Correct.

> > * Any task alive for the duration of the iteration MUST be visited
> > * No task should be visited more than once
> > * Any task born or exiting after starting the iteration MAY be skipped
> > * You can start at any task in the thread group
> 
> Well yes, but it is not easy to exactly define what after/before
> means in this case.
> 
> > Would something like this work:
> >
> > #define while_each_thread(g, t, o) \
> > 	while (t->group_leader == o && (t = next_thread(t)) != g)
> >
> > Where o should have the value of g->group_leader.
> 
> I don't understand how this helps... and how this can work even
> ignoring the barriers.
> 
> OK, we have the main thream M and the sub-thread T, we are doing
> 
> 	do {
> 		do_something(t);
> 	} while_each_thread(M, t, M);
> 
> why we can't miss T if it does exec?
> 

So for:

struct task *M; /* assuming this is passed in to us */
struct task *L = M->group_leader;
struct task *I = M;

do {
	do_something(T);
} while_each_thread(M, T, L);

Here is my thinking.

If some thread K does exec, you won't miss it because:

1) Ignoring the group_leader check, you'll visit K just by following
   next_thread(). That's the case today and is what you except
   when iterating over an rcu_list.
2) (t->group_leader == o) will fail iff t is the exec thread.
   Since we test t->group_leader before re-assigning it (t=next_thread()),
   the test will fail only after visiting the exec thread. So you'll
   visit the exec thread and then terminate the loop.

I realize its a klutzy interface (requires 3 variables) but it seems
correct (ignoring barriers) and meets all the requirements. I'm hoping
it inspires a solution which is less klutzy and meet its all the
requirements.

Regards,
Mandeep

> Oleg.
> 
