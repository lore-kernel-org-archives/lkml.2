Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886Ab0GIQfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 12:35:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52954 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757452Ab0GIQfT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 12:35:19 -0400
Subject: Re: periods and deadlines in SCHED_DEADLINE
From: Peter Zijlstra <peterz@infradead.org>
To: Bjoern Brandenburg <bbb@email.unc.edu>
Cc: Raistlin <raistlin@linux.it>, linux-kernel <linux-kernel@vger.kernel.org>,
       Song Yuan <song.yuan@ericsson.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicola Manica <nicola.manica@disi.unitn.it>,
       Luca Abeni <lucabe72@email.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Harald Gustafsson <harald.gustafsson@ericsson.com>, bastoni@cs.unc.edu,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <51F8E441-58D7-45E1-B7A0-7A717EDF08B5@email.unc.edu>
References: <1278682707.6083.227.camel@Palantir>
	 <1278685133.1900.201.camel@laptop>
	 <51F8E441-58D7-45E1-B7A0-7A717EDF08B5@email.unc.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 09 Jul 2010 18:35:04 +0200
Message-ID: <1278693304.1900.266.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 16:51 +0200, Bjoern Brandenburg wrote:
> On Jul 9, 2010, at 4:18 PM, Peter Zijlstra wrote:
> 
> > On Fri, 2010-07-09 at 15:38 +0200, Raistlin wrote:
> > 
> >> - using periods for calculating the tasks' bandwidth and then using   
> >>   deadlines for scheduling the tasks is going to work, but the
> >>   admission control test that you would need for ensuring anybody
> >>   will make its deadline is waaay more complex than Sum_i(BW_i)<1, even
> >>   for uniprocessors/partitionig. That one instead would gives you just
> >>   a very basic guarantee that the design in not completely broken
> >>   (formally, I think I should say it is only a necessary
> >>   condition :-)).
> > 
> > Happen to have a paper handy that explains all this in a concise way? 
> > 
> 
> Sounds confusing, but this is actually not that complicated.

Indeed, reading the referenced paper did clear things up, thanks!

I think the easiest path for now would indeed be to split between hard
and soft rt tasks, and limit hard to d==p, and later worry about
supporting d<p for hard.

It will very much depend on how we're going to go about doing things
with that 'load-balancer' thingy anyway.

The idea is that we approximate G-EDF by moving tasks around, but Dario
told me the admission tests are still assuming P-EDF.

Add to that the interesting problems of task affinity and we might soon
all have a head-ache ;-)

One thing we can do is limit the task affinity to either 1 cpu or all
cpus in the load-balance domain. Since there don't yet exist any
applications we can disallow things to make life easier.

If we only allow pinned tasks and free tasks, splitting the admission
test in two would suffice I think, if keep one per-cpu utilization
measure and use the maximum of these over all cpus to start the global
utilization measure, things ought to work out.

If we do hard and soft independenty, we would need to split those into 2
again, resulting in 4 sets of measures.




