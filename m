Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab2HTQQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:16:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:56429 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab2HTQQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:16:53 -0400
Message-ID: <1345479400.23018.73.camel@twins>
Subject: Re: Add rq->nr_uninterruptible count to dest cpu's rq while CPU
 goes down.
From: Peter Zijlstra <peterz@infradead.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        paulmck <paulmck@linux.vnet.ibm.com>
Date: Mon, 20 Aug 2012 18:16:40 +0200
In-Reply-To: <CADZ9YHik4-DiEVB5azyXe8Y7GOsqobcNbUprXvqOyWmLLRZoGQ@mail.gmail.com>
References: <1345124749.31092.2.camel@localhost.localdomain>
	 <1345125384.29668.30.camel@twins>
	 <CADZ9YHjPjExzuJWjziiezBch03Am0imQzDG4EDfG-NTWfz4V8A@mail.gmail.com>
	 <1345128138.29668.42.camel@twins>
	 <CADZ9YHjzNVz6nSqbnTgVYfwi2hz0KYuXC89GHw6UjL2GyGZ64A@mail.gmail.com>
	 <1345139199.29668.46.camel@twins>
	 <CADZ9YHgNhTGWicX0kFfrNoL17JkxfZcXryqqa-wHLVLh05SvAg@mail.gmail.com>
	 <1345454817.23018.27.camel@twins>
	 <CADZ9YHik4-DiEVB5azyXe8Y7GOsqobcNbUprXvqOyWmLLRZoGQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-20 at 22:10 +0600, Rakib Mullick wrote:
> >
> First of all, you've misspelled my name, it's Rakib not Rabik.

Damn, sorry!, lysdexic that.. 

> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index 4376c9f..06d23c6 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -5338,27 +5338,17 @@ void idle_task_exit(void)
> >  }
> >
> >  /*
> > - * While a dead CPU has no uninterruptible tasks queued at this point,
> > - * it might still have a nonzero ->nr_uninterruptible counter, because
> > - * for performance reasons the counter is not stricly tracking tasks to
> > - * their home CPUs. So we just add the counter to another CPU's counter,
> > - * to keep the global sum constant after CPU-down:
> > - */
> > -static void migrate_nr_uninterruptible(struct rq *rq_src)
> > -{
> > -     struct rq *rq_dest = cpu_rq(cpumask_any(cpu_active_mask));
> > -
> > -     rq_dest->nr_uninterruptible += rq_src->nr_uninterruptible;
> > -     rq_src->nr_uninterruptible = 0;
> > -}
> > -
> > -/*
> > - * remove the tasks which were accounted by rq from calc_load_tasks.
> > + * Since this CPU is going 'away' for a while, fold any nr_active delta
> > + * we might have. Assumes we're called after migrate_tasks() so that the
> > + * nr_active count is stable.
> > + *
> But after migrate_tasks(), it's likely that rq->nr_running will be 1.
> Then, nr_active will be screwed. No? 

Gah indeed. let me try that again.
