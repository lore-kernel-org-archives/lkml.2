Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab1BOFdG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 00:33:06 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27425 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab1BOFdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 00:33:04 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6257"; a="74478820"
Message-ID: <4D5A100F.9000809@codeaurora.org>
Date: Mon, 14 Feb 2011 21:33:03 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jeremy Kerr <jeremy.kerr@canonical.com>
CC: linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        linux-sh@vger.kernel.org, Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Dima Zavin <dmitriyz@google.com>, Ben Dooks <ben-linux@fluff.org>,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [RFC,PATCH 1/3] Add a common struct clk
References: <1297233693.242364.862698430999.1.gpush@pororo>	<4D53749B.6010102@codeaurora.org> <201102151041.40655.jeremy.kerr@canonical.com>
In-Reply-To: <201102151041.40655.jeremy.kerr@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Russell, A question for you further down this email. Please take a look.

On 02/14/2011 06:41 PM, Jeremy Kerr wrote:
> Hi Saravana,
>
>> Shouldn't you be grabbing the prepare_lock here?
>
> This depends on semantics that (as far as I can tell) aren't defined yet.

Sure, one could argue that in some archs for a certain set of clocks the 
slow stuff in prepare/unprepare won't need to be done during set rate -- 
say, a simple clock that always runs off the same PLL but just has a 
integer divider to change the rate.

In those cases, not grabbing the prepare_lock would make the code less 
"locky".

> We
> may even want to disallow set_rate (and set_parent) when prepare_count is non-
> zero.

This is definitely not right. Changing the rate of a clock when it's 
already enabled/prepared is a very reasonable thing to do. It's only 
doing a set rate at the "same time" as a prepare/unprepare that's wrong 
for some clocks. We could have the specific implementation deal with the 
locking internally.

So essentially, the prepare_lock is just for the prepare_cnt and the 
call to the corresponding ops.

> Ideally, we should work out what the semantics are with regards to changing a
> clock's rate when it has multiple users and/or is enabled or prepared, but
> that's a separate issue, and we should *definitely* implement that as a
> separate change.

Agreed about having the semantics defined for setting the rate when 
there are multiple users. As for "is already enabled/prepared", I think 
clear that it needs to be supported/allowed. MSM drivers definitely do 
it all the time.

> I'd prefer to enforce the 'sleepability' with might_sleep instead.

Yeah, I realized this option after sending out my previous email. Please 
do add a might_sleep(). It will actually point out errors (per the new 
clarification) in some serial drivers.

>> You should probably rename the lock to something else since it's not
>> limited to prepare/unprepare. How about resource_lock?
>
> It's not, but that's the only thing it's protecting in the common code. I'm
> open for better names, but resource_lock is too generic.

We can get back to this later after we settle on the stuff below.

>>> +int clk_set_parent(struct clk *clk, struct clk *parent)
>>> +{
>>> +	if (clk->ops->set_parent)
>>> +		return clk->ops->set_parent(clk, parent);
>>
>> I'm not sure on this one. If the prepare ops for a clock also calls the
>> prepare ops on the parent, shouldn't we prevent changing the parent
>> while the prepare/unprepare is going on?
>
> Again, this is related to set_rate during enable/disable or prepare/unprepare;
> we don't have defined semantics for this at present.

After thinking about this the past couple of days, this looks like a 
location where the locking is more necessary than inside set rate. I 
always saw the parent clock as the clock that generates the clock signal 
from which this clock derives (divide, etc) it's clock signal from.

Assuming Russell and/or the community agrees on the semantics of 
"parent", without the generic implementation grabbing the prepare_lock 
while setting the parent, there is no way for the specific clock driver 
implementations to cleanly ensure correctness. The only option for them 
would be to peek into the generic clock struct and grab the prepare lock 
-- to me that would be an ugly hack and/or layering violation that would 
cause problems later on.

Russell/All,

What's the meaning of a parent clock? Do you agree with my definition -- 
"the parent clock is the clock that generates the clock signal from 
which the child clock derives (divide, etc) it's clock signal from."? Or 
is it open to interpretation by each implementation?

>>> +
>>> +/* static initialiser for clocks */
>>> +#define INIT_CLK(name, o) {						\
>>> +	.ops		=&o,						\
>>> +	.enable_count	= 0,						\
>>> +	.prepare_count	= 0,						\
>>
>> Do we need these inits? Doesn't check patch complain about initing
>> static/global to 0? If it's generally frowned upon, why the exception
>> here. I realize that checkpatch won't catch this, but still...
>
> This took some reading through c99, but yes, it looks like we can drop these
> zero initialisations.
>
> However, the coding style convention for the implicit zeroing of static
> variables is to allow these variables to be put into the .bss section,
> reducing object size. In this case, the clock will never be able to go into
> .bss (it has non-zero elements too), and so this will have no change on object
> size. I prefer to be explicit here, and show that the counts are initialised
> to zero.

I don't think the coding style convention was to make sure the variables 
end up in the BSS. I would be surprised if GCC wasn't intelligent enough 
to notice that we are initing a variable with zero and hence it can be 
safely put in the BSS. It think the coding style convention was chosen 
just to ensure "don't be redundant and add 'noisy' code".

> I'm happy to go either way. I have a preference for the explicit
> initialisation, but that may not be general style.

I don't have a strong opinion, but I thought I should point out the 
deviation from the usual coding style.

>>
>>> +	.enable_lock	= __SPIN_LOCK_UNLOCKED(name.enable_lock),	\
>>> +	.prepare_lock	= __MUTEX_INITIALIZER(name.prepare_lock),	\
>>
>> After a long day, I'm not able to wrap my head around this. Probably a
>> stupid question, but will this name.xxx thing prevent using this
>> INIT_CLK macro to initialize an array of clocks? More specifically,
>> prevent the sub class macro (like INIT_CLK_FIXED) from being used to
>> initialize an array of clocks?
>
> That's correct. For an array of clocks, you'll have to use a different
> initialiser. We can add helpers for that that when (and if) the need arises.

Would it even be possible to get this to work for an array? You don't 
have to change this in the patch, but I'm curious to know how to get 
this to work for an array without doing a run time init of the lock.

>>> + * The clk_enable/clk_disable and clk_prepare/clk_unprepare pairs allow
>>> + * implementations to split any work between atomic (enable) and
>>> sleepable + * (prepare) contexts.  If a clock requires blocking code to
>>> be turned on, this
>>
>> Aren't all locks blocking? Shouldn't it be, "If turning on a clock
>> requires code that might sleep, it should be done in clk_prepare"?
>> Replace all "blocking" with "sleepable" or "sleeping" in the comments?
>
> I think "blocking" is generally accepted as is intended in this case, but it's
> probably better to be explicit here.

I obviously think what I suggested is clearer, but no strong opinion here.

Cheers,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
