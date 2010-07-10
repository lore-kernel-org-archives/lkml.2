Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab0GJK2V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 06:28:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33394 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab0GJK2U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 06:28:20 -0400
Subject: Re: periods and deadlines in SCHED_DEADLINE
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Bjoern Brandenburg <bbb@email.unc.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Song Yuan <song.yuan@ericsson.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicola Manica <nicola.manica@disi.unitn.it>,
       Luca Abeni <lucabe72@email.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Harald Gustafsson <harald.gustafsson@ericsson.com>, bastoni@cs.unc.edu,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <1278752489.4390.97.camel@Palantir>
References: <1278682707.6083.227.camel@Palantir>
	 <1278685133.1900.201.camel@laptop>
	 <51F8E441-58D7-45E1-B7A0-7A717EDF08B5@email.unc.edu>
	 <1278693304.1900.266.camel@laptop>  <1278752489.4390.97.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 10 Jul 2010 12:28:04 +0200
Message-ID: <1278757684.1998.26.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-07-10 at 11:01 +0200, Raistlin wrote:
> On Fri, 2010-07-09 at 18:35 +0200, Peter Zijlstra wrote:
> > I think the easiest path for now would indeed be to split between hard
> > and soft rt tasks, and limit hard to d==p, and later worry about
> > supporting d<p for hard.
> > 
> Mmm... I see... Are you thinking of another scheduling class? Or maybe
> just another queue with "higher priority" inside the same scheduling
> class (sched_dl.c)?

Inside the same class, since as you say that would allow sharing lots of
things, also conceptually it makes sense as the admission tests would
really have to share a lot of data between them anyway.

> Maybe having two policies inside the same class (maybe handled in
> separate queues/rb-trees) might save a lot of code duplication.
> If we want to go like this, suggestions on the name(s) of the new (or of
> both) policy(-ies) are more than welcome. :-D

Right, so that's a good point, I'm wondering if we should use two
separate policies or use the one policy, SCHED_DEADLINE, and use flags
to distinguish between these two uses.

Anyway, that part is the easy part to implement and shouldn't take more
than a few minutes to flip between one and the other.

> > The idea is that we approximate G-EDF by moving tasks around, but Dario
> > told me the admission tests are still assuming P-EDF.
> > 
> Yep, as said above, that's what we've done since now. Regarding
> "partitioned admission", let me try to explain this.
> 
> You asked me to use sched_dl_runtime_us/sched_dl_period_us to let people
> decide how much bandwidth should be devoted to EDF tasks. This obviously
> yields to _only_one_ bandwidth value that is then utilized as the
> utilization cap on *each* CPU, mainly for consistency reasons with
> sched_rt_{runtime,period}_us. At that time I was using such value as the
> "overall EDF bandwidth", but I changed to your suggested semantic.

But if you have a per-cpu bandwidth, and the number of cpus, you also
have the total amount of bandwidth available to G-EDF, no?

> With global scheduling in place, we have this new situation. A task is
> forked on a CPU (say 0), and I allow that if there's enough bandwidth
> for it on that processor (and obviously, if yes, I also consume such
> amount of bw). When the task is dynamically migrated to CPU 1 I have two
> choices:
>  (a) I move the bandwidth it occupies from 0 to 1 or,
>  (b) I leave it (the bw, not the task) where it is, on 0.

Well, typically G-EDF doesn't really care about what cpu runs what, as
long as the admission thing is respected and we maintain the
smp-invariant of running the n<=m highest 'prio' tasks on m cpus.

So it really doesn't matter how we specify the group budget, one global
clock or one clock per cpu, if we have the number of cpus involved we
can convert between those.

   (c) use a 'global' bw pool and be blissfully ignorant of the
       per-cpu things?

> If we want something better I cannot think on anything that doesn't
> include having a global (per-domain should be fine as well) mechanism
> for bandwidth accounting...

Right, per root_domain bandwidth accounting for admission should be
perfectly fine.

> > Add to that the interesting problems of task affinity and we might soon
> > all have a head-ache ;-)
> > 
> We right now support affinity, i.e., tasks will be pushed/pulled to/by
> CPUs where they can run. I'm not aware of any academic work that
> analyzes such a situation, but this doesn't mean we can't figure
> something out... Just to give people an example of "why real-time
> scheduling theory still matters"!! ;-P ;-P

Hehe, I wouldn't at all mind dis-allowing random affinity masks and only
deal with 1 cpu or 'all' cpus for now.

But yeah, if someone can come up with something clever, I'm all ears ;-)

> > One thing we can do is limit the task affinity to either 1 cpu or all
> > cpus in the load-balance domain. Since there don't yet exist any
> > applications we can disallow things to make life easier.
> > 
> > If we only allow pinned tasks and free tasks, splitting the admission
> > test in two would suffice I think, if keep one per-cpu utilization
> > measure and use the maximum of these over all cpus to start the global
> > utilization measure, things ought to work out.
> >
> Ok, that seems possible to me, but since I have to write the code you
> must tell me what you want the semantic of (syswide and per-group)
> sched_dl_{runtime,period} to become and how should I treat them! :-)

Right, so for the system-wide and group bandwidth limits I think we
should present them as if there's one clock, and let the scheduler sort
out how many cpus are available to make it happen.

So we specify bandwidth as if we were looking at our watch, and say,
this here group can consume 30 seconds every 2 minutes. If the
load-balance domains happen to be larger than 1 cpu, hooray we can run
more tasks and the total available bandwidth simply gets multiplied by
the number of available cpus.

Makes sense?



