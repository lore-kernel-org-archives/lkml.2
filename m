Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011Ab0FURqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 13:46:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932848Ab0FURqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 13:46:53 -0400
Date: Mon, 21 Jun 2010 19:44:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
Message-ID: <20100621174455.GA14886@redhat.com>
References: <20100618190251.GA17297@redhat.com> <20100618193403.GA17314@redhat.com> <20100618223354.GL2365@linux.vnet.ibm.com> <20100621170919.GA13826@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100621170919.GA13826@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21, Oleg Nesterov wrote:
>
> So, I am thinking about the first attempt
>
> 	#define while_each_thread(g, t) \
> 		while ((t = next_thread(t)) != g && pid_alive(g))
>
> again. But this means while_each_thread() can miss more threads
> than it currently can under the same conditions. Correct, but
> not good.

Not good, but correct ;) Probably it makes sense to fix the problem
anyway, then think about the more optimal fix.

	static inline struct task_struct *
	next_thread_careful(const struct task_struct *g, const struct task_struct *t)
	{
		t = next_thread(t);
		/*
		 * this pairs with the implicit barrier between detach_pid()
		 * and list_del_rcu(g->thread_group) in __unhash_process(g).
		 */
		smp_rmb();
		if (likely(pid_alive(g)))
			return t;
		else
			return g;
	}

	#define while_each_thread(g, t) \
		while ((t = next_thread_careful(t)) != g)

I think this should work. detach_pid() does unlock + lock at least
once and thus we have the barrier (this worth a comment or we
can add the explicit wmb() in __unhash_process).

Paul, Roland, do you see any problems from the correctness pov,
or a better fix for now?

Perhaps it also makes sense to keep the old variant renamed to
while_each_thread_locked(), I dunno.

Oleg.

