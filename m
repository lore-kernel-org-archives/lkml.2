Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab0FUUJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:09:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169Ab0FUUJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:09:11 -0400
Date: Mon, 21 Jun 2010 22:06:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
Message-ID: <20100621200633.GA21099@redhat.com>
References: <20100618190251.GA17297@redhat.com> <20100618193403.GA17314@redhat.com> <20100618223354.GL2365@linux.vnet.ibm.com> <20100621170919.GA13826@redhat.com> <20100621174455.GA14886@redhat.com> <20100621190212.C8630400C5@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100621190212.C8630400C5@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21, Roland McGrath wrote:
>
> > Paul, Roland, do you see any problems from the correctness pov,
> > or a better fix for now?
> >
> > Perhaps it also makes sense to keep the old variant renamed to
> > while_each_thread_locked(), I dunno.
>
> Did we verify that only de_thread() can create the situation where a
> while_each_thread-style loop without either lock can be confused?

I think yes, this is is the only case.

I mean, while_each_thread(group_leader, t). If g != group_leader, then
the lockless while_each_thread() has problems with the plain exit(g).

Afaics. The more I think about this, the more I feel confused ;)

But if we start from ->group_leader, then while_each_thread() must
stop eventually. Otherwise we should assume that the dead (unhashed)
tasks can create the circular list, obviously this is not possible.

> If
> that's so, then just changing it to avoid the situation seems like it
> would be less invasive overall.

How? We should change ->group_leader uner write_lock_irq(tasklist),
synchronize_rcu() is not an option. We can't do call_rcu(release_task),
we can't take tasklist for writing in the softirq context. But even
if we could, this can't help in fact or I missed something.

Oleg.

