Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab1AXL77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 06:59:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab1AXL76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 06:59:58 -0500
Date: Mon, 24 Jan 2011 12:51:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
        acme@redhat.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        stern@rowland.harvard.edu, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        roland@redhat.com, tglx@linutronix.de, prasad@linux.vnet.ibm.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH] perf: perf_event_exit_task_context:
	s/rcu_dereference/rcu_dereference_raw/
Message-ID: <20110124115156.GA12215@redhat.com>
References: <20110119182207.GB12183@redhat.com> <tip-dbe08d82ce3967ccdf459f7951d02589cf967300@git.kernel.org> <20110121152939.GA28552@elte.hu> <20110121155323.GA2988@redhat.com> <20110121174547.GA8796@redhat.com> <20110121175345.GB8796@redhat.com> <20110121215016.GO17752@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110121215016.GO17752@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21, Paul E. McKenney wrote:
>
> On Fri, Jan 21, 2011 at 06:53:45PM +0100, Oleg Nesterov wrote:
> >
> > But rcu_dereference_raw() looks a bit confusing, and it is not
> > very convenient to use read_barrier_depends() directly.
> >
> > Paul, may be it makes sense to add the new trivial helper which
> > can be used instead?
> >
> > Yes, this is only cosmetic issue, I know ;)
>
> Cosmetic issues can be pretty important to the poor guy trying to read
> the code.  ;-)

Agreed!

> What keeps the structure that rcu_dereference_raw() returns a pointer
> to from going away?

It can't go away, current owns its ->perf_event_ctxp[] pointers. But
the pointer can be installed at any time by sys_perf_event_open().

Currently the code does

	ctx = current->perf_event_ctxp[ctxn];
	if (ctx)
		do_something(ctx);

and in theory we need smp_read_barrier_depends() in between.

> Best would be if a lockdep condition could be
> constructed from the answer to this question and added to the appropriate
> rcu_dereference() primitive.

In this case the condition is "true", so we can use rcu_dereference_raw().
The only problem, it looks confusing. Especially because you actually
need rcu_read_lock() if you look at not_current_task->perf_event_ctxp[].

Oleg.

