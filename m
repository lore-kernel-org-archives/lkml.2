Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab2BOUOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:14:34 -0500
Received: from www.linutronix.de ([62.245.132.108]:54875 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab2BOUOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:14:32 -0500
Date: Wed, 15 Feb 2012 21:14:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] hrtimers: Special-case zero length sleeps
In-Reply-To: <20120215145225.GA21448@srcf.ucam.org>
Message-ID: <alpine.LFD.2.02.1202152059230.2794@ionos>
References: <1317308372-6810-1-git-send-email-mjg@redhat.com> <alpine.LFD.2.02.1202151537500.2794@ionos> <20120215145225.GA21448@srcf.ucam.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Feb 2012, Matthew Garrett wrote:

> On Wed, Feb 15, 2012 at 03:40:24PM +0100, Thomas Gleixner wrote:
> > > +	 * be scheduled. Special case that to avoid actually putting them
> > > +	 * to sleep for the duration of the slack.
> > > +	 */
> > > +	if (rqtp->tv_sec == 0 && rqtp->tv_nsec == 0)
> > > +		slack = 0;
> > 
> > That's pretty pointless. You can simply return 0 here as
> > do_nanosleep() will not call the scheduler on an already expired
> > timer, which is always true for a relative timer with delta 0.
> 
> I'm actually starting to wonder about the applications doing this. We 
> default to adding a small amount of slack even if the application has 
> done sleep(0), which will mean that the timer hasn't expired at this 
> point. Do we then go through the scheduler differently? Are these 

When the slack is large enough that the timer is actually not expired
right away, which is usually the case, then we end up in schedule()
and the task gets scheduled out until the timer fires. With your
approach of making the slack 0 for sleep(0) calls the code does not
call schedule() because the timer is definitely expired.

> applications actually relying on an invalid assumption?

Oh yes. sleep(0) has no guarantee about its behaviour at all. The only
guarantee of sleep() is that it wont return before the requested time
has elapsed, but there is no upper bound when it returns after the
sleep time is over. So it's perfectly fine from the standards POV that
sleep(0) actually sleeps and puts the tasks for some random time away.
It's also correct when it returns right away w/o going through
schedule(). The fact that sleep(0) ended up in schedule() even when
the timer was already and the task state therefor was RUNNING on some
unix implementations does not change that at all.

Just for the extended fun of it: The pre hrtimer implementation in
Linux put the task on sleep as well up to the next jiffies boundary,
so anything which used sleep(0) on a pre hrtimer kernel was going to
sleep. That's also the case today when high resolution timers are
disabled (compile or runtime).

So anything which relies on sleep(0) as a fast scheduling point is and
has been broken forever.

Thanks,

	tglx
