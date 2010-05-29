Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613Ab0E2QTy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 12:19:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41887 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757429Ab0E2QTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 12:19:51 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: James Bottomley <James.Bottomley@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Florian Mickler <florian@mickler.org>, Ingo Molnar <mingo@elte.hu>,
       Paul@smtp1.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1275129757.27810.13205.camel@twins>
References: <Pine.LNX.4.44L0.1005271344040.3239-100000@iolanthe.rowland.org>
	 <AANLkTimqvMuMpB5E3tj58OtlRc-7mVaec-9EHAegywg7@mail.gmail.com>
	 <1275032623.32462.30.camel@laptop> <201005290011.32543.rjw@sisk.pl>
	 <20100529110426.077cba47@schatten.dmk.lab>
	 <1275129757.27810.13205.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 29 May 2010 11:19:43 -0500
Message-ID: <1275149983.4503.138.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-29 at 12:42 +0200, Peter Zijlstra wrote:
> On Sat, 2010-05-29 at 11:04 +0200, Florian Mickler wrote:
> > On Sat, 29 May 2010 00:11:32 +0200
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > 
> > > Having reconsidered the suspend blockers idea I came to the conclusion that
> > > in fact it was a workaround for three different problems.
> > 
> > But it is also a change of paradigm. The scheduler should strive to
> > have the system idle as long as possible to conserve battery. And
> > everything that does not serve the purpose of the device has to be
> > considered as not worth running, except if there are other
> > purpose-fullfilling tasks to run anyway.
> 
> No the purpose of the scheduler is to run tasks when they are runnable.
> Not to second guess whatever caused them to become runnable.

I still think there is a semantic issue here ... see other email.

> If you start to randomly not run tasks, the inversion chaos that ensues
> is terrible.

As a sweeping statement, I disagree because you're explicitly saying we
can't solve the actual problem.  If you're saying the scheduler
shouldn't do this and something external has to make the tasks idle
somehow first, I agree.

>  You can apply the regular means of alleviating that and
> that entails adding *-inheritance to all blockable resources. The -rt
> patch set is doing that in part.

So as a mechanism for idling tasks, this looks possible.  I don't like
it from a theoretical viewpoint because it can't idle cpu bound tasks.
I'd like a solution that solved all of the problem, not just all except
stuff we think probably won't happen on a phone because experience tells
me that partial solutions eventually turn up gotchas down the road.

> You really need to make applications not want to run and block on their
> own volition (in a resource free point) and otherwise make them block on
> something forcefully and disregard any malfunctioning that would result
> from that, and in extreme cases terminate (releasing all resources).
> 
> But really Android shouldn't even need kernel support to do all this,
> since its hosted on this massive middle-ware that intercepts everything,
> called a Java Virtual Machine.

The timers for a polling main loop have to be stopped ... this isn't
possible with the current interface today, therefore we have to have
kernel changes in some form.

> Now, all I'm interested in is providing interfaces from the kernel where
> needed, so that userspace can be optimally frugal with power usage, and
> can monitor/contain badly behaving tasks.

So, that sounds like the goal of just about everyone on the thread.

> If Android is so set in its ways that they don't want to adopt (like
> saying Android requires suspend for power management) then they can go
> their own merry way and I'm not interested anymore (it would be a shame
> though).

They haven't actually said this.  They've said they've implemented
opportunistic suspend because it solves two problems: power savings for
devices whose C states don't go as low as S3 and forced idling of tasks.
Their main goal is extending battery life per charge, and what I've
heard them say is any solution that does this is fine ... as long as the
life per charge is as good as (or preferably better than) their current
implementation ... I don't think that's unreasonable, and I think it
might be achievable with some of the ideas in this thread.

James


