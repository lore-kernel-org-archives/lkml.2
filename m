Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab0GJScu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 14:32:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:34244 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab0GJScs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 14:32:48 -0400
Subject: Re: periods and deadlines in SCHED_DEADLINE
From: Peter Zijlstra <peterz@infradead.org>
To: Harald Gustafsson <hgu1972@gmail.com>
Cc: Raistlin <raistlin@linux.it>, linux-kernel <linux-kernel@vger.kernel.org>,
       Song Yuan <song.yuan@ericsson.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicola Manica <nicola.manica@disi.unitn.it>,
       Luca Abeni <lucabe72@email.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Harald Gustafsson <harald.gustafsson@ericsson.com>,
       Bjoern Brandenburg <bbb@email.unc.edu>, bastoni@cs.unc.edu,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <AANLkTilufL0jgoqQLKjxbu0egN2l6lCkF9JPCxBfV3Gz@mail.gmail.com>
References: <1278682707.6083.227.camel@Palantir>
	 <1278685800.1900.212.camel@laptop>
	 <AANLkTilufL0jgoqQLKjxbu0egN2l6lCkF9JPCxBfV3Gz@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 10 Jul 2010 20:31:50 +0200
Message-ID: <1278786710.1998.63.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-07-10 at 19:19 +0200, Harald Gustafsson wrote:
> 2010/7/9 Peter Zijlstra <peterz@infradead.org>:
> > One thing we could do, although this would make the proposed scheduler a
> > wee bit more complex, is split between hard and soft realtime. Only
> > accept P==rel_D for hard, and schedule the soft tasks in the hard slack
> > or something like that.
> >
> > That way we can later extend the hard admission tests to accept more.
> 
> Sorry for jumping in a bit late. I'm not that happy with this
> suggestion if I understand you correctly. The main reason for having
> deadlines shorter than the periods is for tasks that need a short
> response time and likely are most important for the system to be
> scheduled as fast as possible. Hence if they get scheduled after the
> tasks with deadline=period then that defeat the purpose with having a
> short deadline. Quite often these tasks are short and hence only need
> a low bandwidth, i.e. long period between activations relative to
> deadline and runtime.

> Did I get your proposal correct? Do you agree that tasks that need to
> set a deadline < period usually do that since they need to be
> scheduled in quickly?

Sure, but 'quickly' doesn't convey whether its soft or hard RT you're
interested in. The soft scheme would still have a bound on the tardiness
and is quite sufficient for a large number of workloads (but of course
there are plenty hard workloads too).

> But also other use cases exist with longer running tasks (e.g. around
> 5-10 ms) per period (e.g. around 20 ms). You might have several of
> such tasks running, but as a system designer you know that their
> activation phase will allow them to be scheduled interleaved. This can
> be for example you know that the interrupt pattern waking the tasks
> are interleaved. The admission test would be even more complex if we
> also need to take into account the phases of task periods. Hence I
> think some of these things need to be left for the system designer
> without being hindered by an admission into the highest hard deadline
> scheduling policy. As you might have understood I'm mostly talking
> about embedded system, which have some tasks that are central parts of
> the running system but which also might in parallel run more generic
> software.

That is a very delicate point, the whole reason SCHED_FIFO and friends
suck so much is that they don't provide any kind of isolation, and thus,
as an Operating-System abstraction they're an utter failure.

If you take out admission control you end up with a similar situation.

In general the sporadic task model schedulers don't need to be
privileged because it does provide isolation. But the moment you allow
by-passing the admission control everything goes out the window. So even
a simple privileged flag telling the admission control to stuff it would
render the whole system unusable, you'd have to start failing everything
not having that flag, simply because the admission control is rendered
useless.

So I would like to take the stand that the mainline scheduler will not
allow such a knob and people will have to help out with improving the
admission controller.

Embedded people can of course easily hack in whatever they well fancy,
and adding the 'yes_I_really_want_this_anyway' flag or even taking out
admission control all together is something the GPL allows them to do.


