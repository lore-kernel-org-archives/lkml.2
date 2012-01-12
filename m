Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab2ALROJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 12:14:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754573Ab2ALROD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 12:14:03 -0500
Date: Thu, 12 Jan 2012 18:07:28 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Q: cgroup: Questions about possible issues in cgroup locking
Message-ID: <20120112170728.GA25717@redhat.com>
References: <20111221190102.GE13529@google.com> <20111221190817.GI17668@somewhere> <20111221192413.GF13529@google.com> <20111221200422.GJ17668@somewhere> <20111222153004.GA30522@redhat.com> <20120104193614.GF9511@google.com> <20120106152356.GA23995@redhat.com> <20120106182535.GJ9511@google.com> <20120111160730.GA24556@redhat.com> <20120112003102.GB9511@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120112003102.GB9511@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mandeep,

On 01/11, Mandeep Singh Baines wrote:
> > >
> > > #define while_each_thread(g, t, o) \
> > > 	while (t->group_leader == o && (t = next_thread(t)) != g)
> > >
> > > Where o should have the value of g->group_leader.
> >
> > I don't understand how this helps... and how this can work even
> > ignoring the barriers.
> >
> > OK, we have the main thream M and the sub-thread T, we are doing
> >
> > 	do {
> > 		do_something(t);
> > 	} while_each_thread(M, t, M);
> >
> > why we can't miss T if it does exec?
> >
>
> So for:
>
> struct task *M; /* assuming this is passed in to us */
> struct task *L = M->group_leader;

L == M

> do {
> 	do_something(T);
> } while_each_thread(M, T, L);
>
> Here is my thinking.
>
> If some thread K does exec, you won't miss it because:
>
> 1) Ignoring the group_leader check, you'll visit K just by following
>    next_thread(). That's the case today and is what you except
>    when iterating over an rcu_list.
> 2) (t->group_leader == o) will fail iff t is the exec thread.
>    Since we test t->group_leader before re-assigning it (t=next_thread()),
>    the test will fail only after visiting the exec thread. So you'll
>    visit the exec thread and then terminate the loop.

Still can't understand... Lets look at this trivial example again.

We start from the main thread M, it is ->group_leader. There is
another thread T in this thread group. We are doing

	OLD = M;

	t = M;
	do {
		do_smth(t);
	}
	while (t->group_leader == OLD && ((t = next_thread(t)) != M);

The first iteration does do_smth(M).

T calls de_thread() and, in particular, it does M->group_leader = T
(see "leader->group_leader = tsk" in de_thread).

after that t->group_leader == OLD fails. t == M, its group_leader == T.
do_smth(T) won't be called.

No?

Oleg.

