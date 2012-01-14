Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab2ANRm7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 12:42:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755928Ab2ANRm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 12:42:58 -0500
Date: Sat, 14 Jan 2012 18:36:48 +0100
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
Message-ID: <20120114173648.GA32543@redhat.com>
References: <20111222153004.GA30522@redhat.com> <20120104193614.GF9511@google.com> <20120106152356.GA23995@redhat.com> <20120106182535.GJ9511@google.com> <20120111160730.GA24556@redhat.com> <20120112003102.GB9511@google.com> <20120112170728.GA25717@redhat.com> <20120112175725.GD9511@google.com> <20120113152010.GA19215@redhat.com> <20120113182750.GD18166@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120113182750.GD18166@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13, Mandeep Singh Baines wrote:
>
> Oleg Nesterov (oleg@redhat.com) wrote:
>
> > Yes, I thought about this too. Suppose we remove this assignment,
> > then we can simply do
> >
> > 	#define while_each_thread(g, t) \
> > 		while (t->group_leader == g->group_leader && (t = next_thread(t)) != g)
> >
> > with the same effect. (to remind, currently I ignore the barriers/etc).
> >
>
> Nice! I think this works.
>
> > But this can _only_ help if we start at the group leader!
>
> But I don't think this solution requires we start at the group leader.
>
> My thinking:
>
> Case 1: g is the exec thread
> ...
> Case 2: g is the group leader
> ...
> Case 3: g is some other thread
>
> In this case, g MUST be current

Why? This is not true. But I guess this doesn't matter, I think I am
starting to understand why our discussion was a bit confusing.

The problem is _not_ exec/de_thread by itself. The problem is that
while_each_thread(g, t) can race with removing 'g' from the list.
IOW, list_for_each_rcu-like things assume that the head of the list
is "stable" but this is not true.

And note that de_thread() does not matter in this sense, only
__unhash_process()->list_del_rcu(&p->thread_group) does matter.

Now. If 'g' is the group leader, we should only worry about exec,
otherwise it can't disappear before other threads.

But if it is not the group leader, it can simply exit and
while_each_thread(g, t) can never stop by the same reason.

And we can't detect this case. OK, OK, we can, let me remind
about http://marc.info/?l=linux-kernel&m=127714242731448 and the
whole discussion. But this makes while_each_thread() more complex
and this doesn't fork for zap_threads-like users which must not
miss the "interesing" threads.

Finally. If we restrict the lockless while_each_thread() so that
is starts at the group leader, then we can rely on de_thread()
which changes the leadership and try to detect this case.

See?

> > May be we should enforce this rule (for the lockless case), I dunno...
> > In that case I'd prefer to add the new while_each_thread_rcu() helper.
> > But! in this case we do not need to change de_thread(), we can simply do
> >
> > 	#define while_each_thread_rcu(t) \
> > 		while (({ t = next_thread(t); !thread_group_leader(t); }))
> >
>
> Won't this terminate just before visiting the exec thread?

Sure. But this is fine for zap_threads() or current_is_single_threaded(),
the execing thread already has another ->mm. Just we shouldn't hang
forever if we race with exec (we start at the group leader).

And I hope this is fine in general (to remind, in the lockless case).
If we race with exec we see either the old or the new leader with the
same pid/signal/etc (at least).

Hmm. On a second thought, perhaps I thought to much about zap_threads(),
perhaps it would be better to find all threads we can...

I dunno. But I am starting to like the ->group_leader more. Hmm, and
with thread_group_leader() check we should ensure we do not visit the
old leader twice.

Thanks Mandeep.

I'll try to recheck my thinking once again, what do you think? Anything
else we could miss?

Oleg.

