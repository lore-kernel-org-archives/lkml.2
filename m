Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab1DUKeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 06:34:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:43949 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab1DUKeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 06:34:08 -0400
Date: Thu, 21 Apr 2011 12:33:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Saravana Kannan <skannan@codeaurora.org>
cc: Paul McKenney <paul.mckenney@linaro.org>,
        =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>, kernel@pengutronix.de,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Paul Mundt <lethal@linux-sh.org>,
        linux-sh <linux-sh@vger.kernel.org>
Subject: Re: [PATCH RFC] clk: add support for automatic parent handling
In-Reply-To: <4DAFD5AA.9020404@codeaurora.org>
Message-ID: <alpine.LFD.2.02.1104211147300.3323@ionos>
References: <alpine.LFD.2.00.1104192339180.2744@localhost6.localdomain6> <1303308457-7501-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LFD.2.02.1104201704350.3323@ionos> <20110420185922.GD31131@pengutronix.de> <alpine.LFD.2.02.1104202113250.3323@ionos>
 <4DAFD5AA.9020404@codeaurora.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011, Saravana Kannan wrote:
> On 04/20/2011 12:52 PM, Thomas Gleixner wrote:
> > So what's wrong with that code:
> > 
> > 1) struct clk is just a collection of function pointers and two locks
> > 
> >     It lacks:
> > 
> >     - a flag field for properties
> Agree. I would very much like it.
> 
> >     - a field for the parent
> 
> Agree.
> 
> >     - a field for the current clock rate
> 
> Meh! Not a big deal. Some clocks don't have the concept of setting their rate
> since they share a parent with another unrelated clock (Ah, looks like you
> talk about with the tree diagram). So, it might be easier to have the rate
> inside each implementation if they need it. I shouldn't add too much code.

No. Each clock has a rate, even if it's fixed and there is no point in
calling down the tree to figure that out.
 
> >     - a field for the base register
> 
> Definitely no. It's completely useless for clocks whose registers don't all
> line up with fixed offsets from the base register. Now I will have to put one
> register here and the rest of the registers in the internal data?
>
> >     - a struct for the offsets of the most common registers relative to
> >       base
> 
> Ok, you thought about rest of the registers. But, how can this fit in the
> common code? Each clock h/w implementation has totally different set of
> registers. Sometimes different even within the same SoC. This would be quite
> wasteful and doesn't even make sense to store at the top level. Also, storing
> offsets is a pain in the neck when the register space is not clean (happens
> more often than we would like :-().

Depends, there is a lot of sane hardware out there (not necessarily in
the ARM SoC world). We can do with a pointer if the need arises.
 
> >     optionally a set of common register accessor functions like I did
> >     for the generic irq chip.
> 
> Again, I don't see the point in having this in the common code. May be I'm
> missing something?

See my RFC patch of a generic irq chip implementation and how much
duplicated five line inline functions they removed.
 
> IMO, a better option instead of the base register and the offsets would be an
> option to have a priv_data pointer. I forgot the exact use case, but we
> thought that would have been helpful when we tried to port the msm clock
> driver in our tree on top of Jeremy's patches.

It works either way, but we should try to comeup with a sensible
common base struct for sane hardware.
 
> > 2) The "framework" API is just a set of low level primitive helper
> >     functions
> > 
> >     It lacks:
> > 
> >     - proper refcounting. clk_get() / clk_put() should do that at the
> >       framework level.
> 
> This has nothing to do with the patches Jeremy made. clk_get()/_put() is in
> clkdev. Also, I'm not sure if clk_get()/put() needs refcounting. That's like
> asking kalloc/kfree to have refcounting.

Ok. I missed the clkdev part.
 
> >     - the ability to propagate enable/disable/prepare/unprepare down
> >       through the parent tree
> 
> Agree. That would be nice. I think the main reason people were not pushing for
> it was to do things in manageable steps. It took a long time for people to
> agree on even the current framework Jeremy added.

Sad enough. But I'm not happy about that in any way. I know where it
ends if you try to please everyone and agree on everything.

> >     - proper mechanisms to sanity check clk_set_parent(),
> >       clk_set_rate() et. al.
> > 
> >       This is not a implementation detail inside a specific clock. It's
> >       a problem which is common at least on the tree level:
> > 
> >                      rootclk
> >                   /          \
> >                clk1          clk2
> >               /   \
> >             clk3  clk4
> > 	   /
> >           clk5
> > 
> >      So now you want to change the rate of clk1. Can you do that?
> > 
> >      No, but where is the sanity check which prevents that ?
> >
> >          In the clk1->set_rate() callback ?
> > 
> > 	Great, that's the wrong place.
> 
> Ah! Nice to see that this bothers you too. This has been a point of contention
> with in our internal team too. I keep pushing back on requests to make child
> clock's set rate propagate up to the patent when the parent has two unrelated
> child clocks going to different devices.
> 
> IMO, the set rate should only work on the parent clock and if there really in
> a need to change the child clock rates, then the users of those child clocks
> will have to co-ordinate it amongst themselves. Although, our use case is a
> bit simpler in that most of the time the child clocks are direct branches (no
> dividers) of the parent.

Still most of this should be handled in the common code. It's not a
unique problem to a single hardware implementation. It's just a given
problem due to the tree nature. And the current code completely lacks
a representation of that and therefor all needs to be done at the
implementation detail level.
 
> I'm not sure how realistic/common your example of switching parents for clk3
> is. May be it is -- I would interested in what people have to say.

I just used it to illustrate what common code should handle.
 
> So, between clk_set_divider(), clk_set_parent() and clk_set_rate(), I think we
> should be able to cover most clock trees as long as we don't propagate
> clk_set_rate() to parents with more than one children. In those case, the
> children should just implement clk_set_divider() (or not even that if there is
> no divider) and not allow clk_set_rate().

The problem starts exactly at the point where you have all that
propagation decision stuff in the chip implementation.

clk_set_rate(clk, rate)
{
	u64 parent_rate = 0;

        if (clk->users > 1)
	      	 return -EBUSY;

	if (!clk->set_rate)
	   	 return rate == clk->rate ? 0 : -EINVAL;

	ret = clk->set_rate(rate, &div, &parent_rate);
	if (!ret)
		return 0;

	if (ret != NEED_PARENT_CHANGE)
	   	return ret;

	if (WARN_ON(!clk->parent))
		return -EINVAL;

        ret = clk_set_rate(clk->parent, parent_rate);
        return ret ? ret : clk->set_rate(rate, NULL);
}

Something along that will cover the tree traversal and remove the
propagation from the chip implementations. 

> > So unless you fix this stuff you should not even think about
> > converting anything to this "framework". That's just waste of time and
> > effort. Aside of declaring it stable and useful ....
> 
> I think you haven't seen all the repetition of refcounting and each mach's
> implementation of some variant of clock ops. The current patch set from Jeremy

Yes, I have looked through the maze as I went through all irq stuff
recently. Jeremys stuff is a start, but I think we should start with
something a bit more complete than that minimal set. I know the pain
when you start with a minimal set and try to force people into
cleaning up their stuff over and over. :(

And we can identify stuff already, so it should be added now.

> will certainly help cut down some of that. If we get the "enable parent before
> you enable child, etc" in now, I don't think there will be much churn when we
> try to add code to enforce the tree restrictions you mention above.

Yes, that's needs to be done before we start churning the tree.
 
> > The least thing which we need now are half baken "abstractions" which
> > just shuffle code around for no value.
> 
> While a lot of your points are correct, I don't think the current patches from
> Jeremy are useless. May be I'm completely mistaken in assuming that you are
> referring to Jeremy's patches?

I'm not saying they are useless, but they need to be more complete
before we start converting code to it.
 
> Btw, on a slight tangent, there is also the problem of clk_round_rate() not
> being sufficient when a driver is trying to work across different mach's. I
> think we need a clk_set_rate_range(min, ideal, max) but I can start a separate
> thread on that if you want. I talked about it a bit in another thread.

Yes, but that's one step after the minimal set :)

Thanks,

	tglx
