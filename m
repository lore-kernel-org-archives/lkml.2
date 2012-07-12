Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161124Ab2GLOkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 10:40:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45743 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932530Ab2GLOka convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 10:40:30 -0400
Message-ID: <1342104015.28010.11.camel@twins>
Subject: Re: [PATCH 12/16] sched: refactor update_shares_cpu() ->
 update_blocked_avgs()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Date: Thu, 12 Jul 2012 16:40:15 +0200
In-Reply-To: <CAPM31RJoLTCM+DPpPk7bsks6Nb8mLNba9CC+Et4vBnMM3rdENw@mail.gmail.com>
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
	 <20120628022415.30496.57167.stgit@kitami.mtv.corp.google.com>
	 <1341489508.19870.30.camel@laptop>
	 <CAPM31RJoLTCM+DPpPk7bsks6Nb8mLNba9CC+Et4vBnMM3rdENw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 17:11 -0700, Paul Turner wrote:
> >>       for_each_leaf_cfs_rq(rq, cfs_rq) {
> >> +             __update_blocked_averages_cpu(cfs_rq->tg, rq->cpu);
> >>
> >> +             /*
> >> +              * Periodically release the lock so that a cfs_rq with many
> >> +              * children cannot hold it for an arbitrary period of time.
> >> +              */
> >> +             if (num_updates++ % 20 == 0) {
> >> +                     raw_spin_unlock_irqrestore(&rq->lock, flags);
> >> +                     cpu_relax();
> >> +                     raw_spin_lock_irqsave(&rq->lock, flags);
> >
> > Gack.. that's not real pretty is it.. Esp. since we're still holding RCU
> > lock and are thus (mostly) still not preemptable.
> >
> > How much of a problem was this?, the changelog is silent on this.
> 
> So the holding of RCU about these operations is nothing new (and
> indeed they should be much faster than before).
> 
> As above, the bound is only for the crazy-large-numbers of cgroups
> case where we don't want to sit on with interrupts disabled forever.
> I suspect it wants to be larger, but picked a fairly conservative
> number to start with since I also think it's not a big performance
> factor either way.

How about you leave this ugly out for now (its unrelated to the rest of
the changes anyway).. and we can revisit this later?


