Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831Ab0FVOgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 10:36:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194Ab0FVOgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 10:36:13 -0400
Date: Tue, 22 Jun 2010 16:34:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Roland McGrath <roland@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
Message-ID: <20100622143402.GA5463@redhat.com>
References: <20100618190251.GA17297@redhat.com> <20100618193403.GA17314@redhat.com> <20100618223354.GL2365@linux.vnet.ibm.com> <20100621170919.GA13826@redhat.com> <20100621174455.GA14886@redhat.com> <20100621190212.C8630400C5@magilla.sf.frob.com> <20100621200633.GA21099@redhat.com> <m1vd9c2idi.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1vd9c2idi.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> >> If
> >> that's so, then just changing it to avoid the situation seems like it
> >> would be less invasive overall.
> >
> > How? We should change ->group_leader uner write_lock_irq(tasklist),
> > synchronize_rcu() is not an option. We can't do call_rcu(release_task),
> > we can't take tasklist for writing in the softirq context. But even
> > if we could, this can't help in fact or I missed something.
>
> We already do: call_rcu(&p->rcu, delayed_put_task_struct); in release_task.
> We don't call release_task until after we have removed it as leader and
> dropped the write lock.

Yes. I meant that while this is needed to ensure that next_thread/etc
returns the rcu-safe data, this (or more rcu_call's) can help to fix
while_each_thread.

I think I was unclear. de_thread() changes ->group_leader, but this does
not matter at all. I mentioned this only because we discussed the possibility
to check ->group_leader in while_each_thread.

What does matter is the single line in __unhash_process()

	list_del_rcu(&p->thread_group);

this breaks while_each_thread().

IOW. Why list_for_each_rcu(head) actually works? It works because this
head itself can't be removed from list.

while_each_thread(g, t) is almost equal to list_for_each_rcu() and it
can only work if g can't be removed from list (OK, strictly speaking
until other sub-threads go away, but this doesn't matter).

However, g can be removed if a) it is not ->group_leader and exits,
or b) its subthread execs.

> At first glance it sounds like the group leader is safe as a stopping
> point for a rcu while_each_thread, and I expect the fact that
> de_thread takes everything down to a single thread, could have nice
> properties here.  If pid_alive were only to fail on the group leader
> when de_thread is called I think we could legitimately say that an event
> we won't worry about.  It is close enough to a new thread being created
> anyway.

Not sure I understand exactly... I mean, I don't understand whether
you agree or not with the fix which adds pid_alive() check into
next_thread_careful().

Oleg.

