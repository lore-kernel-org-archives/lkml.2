Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab1G0QxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:53:15 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:49096 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752667Ab1G0QxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:53:13 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: b3gAQx8VM1nLhiT9hZjvhYMhVzzgARDJkpme1gvtSkqUoyg
 9yiXJI72LuQ5AMNkkZsSL79u7w5JjvmWn6I_kDo.AZ4VAc07J9R0m_q5ZtvP
 cEO_q10ROt11A6EcxdmpXi2l1dbgsivk1XG5Qz2NeO_aNwcQrMFAWDOHXXl7
 VFh86Ux_q4Dhio0lOMAd26L4ewI2h5VspJD6rlLJ9iURsoiIl2q5IhdgL_j6
 P80khfw0zkljfA3hARMuzo8ziruk5flMyS7EWwX5AOJ6SCCRCIz6ytDKQOmJ
 KT0MJ6w6bdrgC9ApyEGBEQoROMF0HeH5E6RJh3WWkDJZDsY9j
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 27 Jul 2011 11:53:09 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Zijlstra <peterz@infradead.org>
cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: per-cpu operation madness vs validation
In-Reply-To: <1311783617.5890.179.camel@twins>
Message-ID: <alpine.DEB.2.00.1107271148550.13058@router.home>
References: <1311714410.24752.404.camel@twins>  <alpine.DEB.2.00.1107261624210.10273@router.home>  <1311768693.24752.488.camel@twins> <1311771677.24752.495.camel@twins>  <alpine.DEB.2.00.1107270916240.9418@router.home> <1311783617.5890.179.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jul 2011, Peter Zijlstra wrote:

> > regardless of the execution context. The primary initial motivation was
> > incrementing per cpu counters without having to disabling interrupts
> > and/or preemption and it grew from there.
>
> I think you need to look at 20b876918c065818b3574a426d418f68b4f8ad19 and
> try again. You removed get_cpu_var()/put_cpu_var() and replaced it with
> naked preempt_disable()/preempt_enable(). That's loosing information
> right there.

It avoided storing the cpu variable.

> Also, I think if you do s/__this_cpu/this_cpu/ on that function you can
> simply drop the preempt_enable/disable things.

Ok that would be good. Could you do a patch like that?

> > The atomic per cpu operations (like the this_cpu_cmpxchg) allow the
> > construction of cheap sections that would satisfy your goals too (with
> > some work and the use of transaction ids instead of locking). See the slub
> > fastpath f.e.
>
> The slub fastpath is a shining example of crap. Its horrid code and
> there was nothing wrong with actually disabling preemption over it, even
> for -rt. Sure you made it go faster, but thats not the point.

The faster is the main point. Serialization overhead is a major cause of
slowdown. Sure it may look unusual to you but over time this will clear
up and become easier to use.

> Most of the slub problems with -rt are in the slow path where you still
> have per-cpu assumptions and keep preempt/irqs disabled.

There are patches pending that continue to remove these things from the
slowpath. With the proposed changes pending for 3.1 we will have a free
slowpath that does not require irq disable or preempt disable.

> I don't think it is possible, nor desirable, to wreck all per-cpu usage
> in the kernel that way.

What in the world are you talking about? No major change to basic
get_cpu/put_cpu and friends is necessary. The __this_cpu ops is a new
thing true but it also replaces open coded increments in preempt sections
that then have per cpu increments in non preempt sections.
