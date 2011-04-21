Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab1DUG64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 02:58:56 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45483 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab1DUG6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 02:58:54 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6322"; a="86843579"
Message-ID: <4DAFD5AA.9020404@codeaurora.org>
Date: Wed, 20 Apr 2011 23:58:50 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paul.mckenney@linaro.org>
CC: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
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
References: <alpine.LFD.2.00.1104192339180.2744@localhost6.localdomain6>	<1303308457-7501-1-git-send-email-u.kleine-koenig@pengutronix.de>	<alpine.LFD.2.02.1104201704350.3323@ionos>	<20110420185922.GD31131@pengutronix.de> <alpine.LFD.2.02.1104202113250.3323@ionos>
In-Reply-To: <alpine.LFD.2.02.1104202113250.3323@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like most of what you had to say. Although, I think Jeremy did a pretty 
good job of trying to push things along in the right direction. So, I 
wouldn't call this an utter failure. I hope you aren't confusing 
Jeremy's patches with the additional patches that Sascha is adding on 
top. I haven't looked much at Sascha's patch series -- so I can't 
comment on them.

More comments follow.

On 04/20/2011 12:52 PM, Thomas Gleixner wrote:
> On Wed, 20 Apr 2011, Uwe Kleine-König wrote:
>> On Wed, Apr 20, 2011 at 06:16:39PM +0200, Thomas Gleixner wrote:
>>> On Wed, 20 Apr 2011, Uwe Kleine-König wrote:
>>>
>>> Very useful changelog.
>> IMHO OK for a RFC patch.
>
> Not at all.
>
>>>
>>> And this whole mess should be written:
>>>
>>>      ret = clk_prepare(clk->parent);
>>>      if (ret)
>>> 		return ret;
>>>
>>> Which returns 0 when there is no parent and it also returns 0 when
>>> there is no prepare callback for the parent. Why the hell do we need
>>> all this ERRPTR checking mess and all this conditional crap ?
>>
>> struct clk has no parent member, there is only clk_get_parent(). If
>
> Which is a complete failure to begin with. Why the heck do you need a
> callback to figure that out?
>
> Because someone claimed, that you need a callback to make it safe from
> changing? Or what's the reason for this?
>
>> there is no parent it returns ERR_PTR(-ENOSYS) and if you pass that
>> to clk_prepare it tries to dereference it. So either it must not be
>> called with an error pointer or clk_prepare et al. need adaption to
>> handle
>
> The whole clk struct is an utter failure.
>
> It's simply the least common denominator of all clk madness in the
> tree. Which results in a half documented data structure and a handful
> helper functions of which most of them are exported, though the
> functionality in them is less than the overhead of the EXPORT_SYMBOL.
>
> That's not an abstraction and neither it's a framework. It's a half
> arsed conglomorate of primitives w/o the minimal documentation how
> those primitives should be used and why they are there in the first
> place.
>
> This is new code and it should be aimed to cleanup things not to
> shuffle things around in a frenzy.
>
> So what's wrong with that code:
>
> 1) struct clk is just a collection of function pointers and two locks
>
>     It lacks:
>
>     - a flag field for properties
Agree. I would very much like it.

>     - a field for the parent

Agree.

>     - a field for the current clock rate

Meh! Not a big deal. Some clocks don't have the concept of setting their 
rate since they share a parent with another unrelated clock (Ah, looks 
like you talk about with the tree diagram). So, it might be easier to 
have the rate inside each implementation if they need it. I shouldn't 
add too much code.

>     - a field for the base register

Definitely no. It's completely useless for clocks whose registers don't 
all line up with fixed offsets from the base register. Now I will have 
to put one register here and the rest of the registers in the internal data?

>     - a struct for the offsets of the most common registers relative to
>       base

Ok, you thought about rest of the registers. But, how can this fit in 
the common code? Each clock h/w implementation has totally different set 
of registers. Sometimes different even within the same SoC. This would 
be quite wasteful and doesn't even make sense to store at the top level. 
Also, storing offsets is a pain in the neck when the register space is 
not clean (happens more often than we would like :-().

>     optionally a set of common register accessor functions like I did
>     for the generic irq chip.

Again, I don't see the point in having this in the common code. May be 
I'm missing something?

IMO, a better option instead of the base register and the offsets would 
be an option to have a priv_data pointer. I forgot the exact use case, 
but we thought that would have been helpful when we tried to port the 
msm clock driver in our tree on top of Jeremy's patches.

> 2) The "framework" API is just a set of low level primitive helper
>     functions
>
>     It lacks:
>
>     - proper refcounting. clk_get() / clk_put() should do that at the
>       framework level.

This has nothing to do with the patches Jeremy made. clk_get()/_put() is 
in clkdev. Also, I'm not sure if clk_get()/put() needs refcounting. 
That's like asking kalloc/kfree to have refcounting.

>     - the ability to propagate enable/disable/prepare/unprepare down
>       through the parent tree

Agree. That would be nice. I think the main reason people were not 
pushing for it was to do things in manageable steps. It took a long time 
for people to agree on even the current framework Jeremy added.

>     - proper mechanisms to sanity check clk_set_parent(),
>       clk_set_rate() et. al.
>
>       This is not a implementation detail inside a specific clock. It's
>       a problem which is common at least on the tree level:
>
>                      rootclk
>                   /          \
>                clk1          clk2
>               /   \
>             clk3  clk4
> 	   /
>           clk5
>
>      So now you want to change the rate of clk1. Can you do that?
>
>      No, but where is the sanity check which prevents that ?
 >
>          In the clk1->set_rate() callback ?
>
> 	Great, that's the wrong place.

Ah! Nice to see that this bothers you too. This has been a point of 
contention with in our internal team too. I keep pushing back on 
requests to make child clock's set rate propagate up to the patent when 
the parent has two unrelated child clocks going to different devices.

IMO, the set rate should only work on the parent clock and if there 
really in a need to change the child clock rates, then the users of 
those child clocks will have to co-ordinate it amongst themselves. 
Although, our use case is a bit simpler in that most of the time the 
child clocks are direct branches (no dividers) of the parent.

To handle, more complex cases like these, I think a
clk_set_divider(div)
and/or
clk_set_frac_mult(numerator, denominator)

might be an API that we should add. If a child clock cares only about a 
ratio with the parent clock, clk_set_divider() is a much better API that 
clk_set_rate(). And we have real use cases of for these in MSM.

>      So now you want to switch the parent of clk3 from clk1 to
>      clk2. Can you do that?

At least in h/w I have seen so far, all the clocks that can really 
change parents fall under one of these categories:
1. A clock with a mux for input from several PLLs running at fixed rates 
(fixed at least after boot). So, these clocks can actually generate 
frequencies that they can guarantee won't change from underneath.

2. Clocks with are a mux from a bunch of external inputs that's 
completely end user/board defined.

For (1) the parent is really changed as part of "clk_set_rate()". For 
(2) I think we should just let set_parent() control the mux.

I'm not sure how realistic/common your example of switching parents for 
clk3 is. May be it is -- I would interested in what people have to say.

So, between clk_set_divider(), clk_set_parent() and clk_set_rate(), I 
think we should be able to cover most clock trees as long as we don't 
propagate clk_set_rate() to parents with more than one children. In 
those case, the children should just implement clk_set_divider() (or not 
even that if there is no divider) and not allow clk_set_rate().

>      No, but where is the sanity check which prevents that ?
>
>      	In the clk3->set_parent() callback ?
>
> 	Again, the wrong place.
>
>      And these are not problems of a particular clk implementation,
>      these are general problems and those want to be addressed in a
>      real framework.
>
>      It's debatable, whether you want to be able to change clocks which
>      have active childs or not. If not the decision function is pretty
>      simple. If yes, you need a list of child clks which you want to
>      consult first before committing the change.
>
> So unless you fix this stuff you should not even think about
> converting anything to this "framework". That's just waste of time and
> effort. Aside of declaring it stable and useful ....

I think you haven't seen all the repetition of refcounting and each 
mach's implementation of some variant of clock ops. The current patch 
set from Jeremy will certainly help cut down some of that. If we get the 
"enable parent before you enable child, etc" in now, I don't think there 
will be much churn when we try to add code to enforce the tree 
restrictions you mention above.

> The least thing which we need now are half baken "abstractions" which
> just shuffle code around for no value.

While a lot of your points are correct, I don't think the current 
patches from Jeremy are useless. May be I'm completely mistaken in 
assuming that you are referring to Jeremy's patches?

Btw, on a slight tangent, there is also the problem of clk_round_rate() 
not being sufficient when a driver is trying to work across different 
mach's. I think we need a clk_set_rate_range(min, ideal, max) but I can 
start a separate thread on that if you want. I talked about it a bit in 
another thread.

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
