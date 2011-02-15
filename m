Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1BOBmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 20:42:36 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:62193 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753230Ab1BOBme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 20:42:34 -0500
Message-ID: <4D59DA29.6070501@bluewatersys.com>
Date: Tue, 15 Feb 2011 14:43:05 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jeremy Kerr <jeremy.kerr@canonical.com>
CC: linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [RFC,PATCH 1/3] Add a common struct clk
References: <1297233693.242364.862698430999.1.gpush@pororo> <4D52F73A.4010707@bluewatersys.com> <201102150936.26110.jeremy.kerr@canonical.com>
In-Reply-To: <201102150936.26110.jeremy.kerr@canonical.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2011 02:36 PM, Jeremy Kerr wrote:
> Hi Ryan,
> 
>>> +int clk_enable(struct clk *clk)
>>> +{
>>> +	unsigned long flags;
>>> +	int ret = 0;
>>> +
>>> +	spin_lock_irqsave(&clk->enable_lock, flags);
>>
>> 	WARN_ON(clk->prepare_count == 0); ?
> 
> Added later, but yes.

Okay, but still failing to understand why this isn't it the first patch.
You are introducing a new file after all.

>>
>>> +	if (clk->enable_count == 0 && clk->ops->enable)
>>> +		ret = clk->ops->enable(clk);
>>
>> Does it make sense to have a clock with no enable function which still
>> returns success from clk_enable? Do we have any platforms which have
>> NULL clk_enable functions?
> 
> It does, yes. Driver code should be always be calling clk_enable before using 
> a clock, regardless of the implementation (which it shouldn't have to care 
> abut), and should abort their initialisation if the clk_enable() fails.
> 
> Some clocks are always running, so the enable op will be empty. This is not an 
> error, so the driver is free to continue.
> 
>> I think that for enable/disable at least we should require platforms to
>> provide functions and oops if they have failed to do so. In the rare
>> case that a platform doesn't need to do anything for enable/disable they
>> can just supply empty functions.
> 
> Sounds like useless boilerplate - it's not an error to not need 
> enable/disable, so I don't see why we need to add extra effort to handle this 
> case.

I have been convinced that enable/prepare potentially being NULL
callbacks is valid :-).

> 
>>> +/**
>>> + * __clk_get - acquire a reference to a clock
>>> + *
>>> + * @clk: The clock to refcount
>>> + *
>>> + * Before a clock is returned from clk_get, this function should be
>>> called + * to update any clock-specific refcounting.
>>
>> This is a bit misleading. It's not "should be called", it "is called". I
>> think you should just remove the documentation for __clk_get/__clk_put
>> or move it into clk.c since the functions are only used internally by
>> the common clock code.
> 
> It'd be nice to remove this from the header, but this means we'll need extern 
> prototypes in clkdev.c. Might be a reasonable compromise though.

That's probably a better approach anyway, since that makes it blatantly
obvious that the __clk_get and __clk_put functions should not be called
from anywhere except clkdev.c.

> 
>>> +/**
>>> + * clk_prepare - prepare clock for atomic enabling.
>>> + *
>>> + * @clk: The clock to prepare
>>> + *
>>> + * Do any blocking initialisation on @clk, allowing the clock to be
>>> later + * enabled atomically (via clk_enable). This function may sleep.
>>
>> "Possibly blocking" as below?
> 
> Yep, will unify these (and spell "possibly" correctly :) )

:-)

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
