Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab0ICH77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 03:59:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43218 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab0ICH7z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 03:59:55 -0400
Subject: Re: [RFC][PATCH 3/3] sched: On-demand tg_shares_up()
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>
In-Reply-To: <AANLkTi=w8MUhf3_=ADzPX1gPycYrQkGywQSAm6cLeidE@mail.gmail.com>
References: <20100828223025.054328145@chello.nl>
	 <20100828223547.082406153@chello.nl>
	 <AANLkTi=w8MUhf3_=ADzPX1gPycYrQkGywQSAm6cLeidE@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Sep 2010 09:59:36 +0200
Message-ID: <1283500776.1783.136.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-03 at 02:52 +0100, Paul Turner wrote:
> > +static void update_shares(int cpu)
> > +{
> > +       struct cfs_rq *cfs_rq;
> > +       struct rq *rq = cpu_rq(cpu);
> > +
> > +       rcu_read_lock();
> > +       for_each_leaf_cfs_rq(rq, cfs_rq) {
> > +               struct task_group *tg = cfs_rq->tg;
> > +
> > +               do {
> > +                       tg_shares_up(tg, cpu);
> > +                       tg = tg->parent;
> > +               } while (tg);
> > +       }
> 
> This will multiply visit taskgroups:
> 
> In the case of a-b-task, both {a} and {b} will be on the leaf cfs_rq
> list.  Resulting in a being visited both as b's parent and as a leaf
> entity.
> 
> Rather than juggling to avoid this, it seems easier to maintain an
> ordering on rq->leaf_cfs_rq_list.
> 
> That is:
> 
> When an entity is added:
> a) If it has a parent, insert it immediately before the parent in the list.
> b) Otherwise it is attached to the root, attach it to the tail of
> rq->leaf_cfs_rq_list
> 
> This can actually be simplified to: if no parent insert at the tail,
> otherwise insert at the head, since we know the parent will always
> have been processed prior to the child.

Except we enqueue things bottom up, so: A-B-C-task would end up as:

add(C) - has parent on head: C
add(B) - has parent on head: B-C
add(A) - has no parent, on tail: B-C-A

Whereas we'd wanted: C-B-A

Which also means your rule (a) doens't work, can't enqueue it before the
parent if the parent itself isn't yet enqueued.

> Traversing the list in order should then ensure that all child
> entities have been processed for the 'next' entity at any given time
> and that its update is coherent. 

Right. I'm sure we can get something like this to work, just need to
come up with something that actually works, and a cold has currently
stopped everything but the very basic brain functions :/
