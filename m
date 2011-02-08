Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab1BHD3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 22:29:45 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:30216 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750758Ab1BHD3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 22:29:44 -0500
Message-ID: <4D50B8C0.7050701@bluewatersys.com>
Date: Tue, 08 Feb 2011 16:30:08 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jeremy Kerr <jeremy.kerr@canonical.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dima Zavin <dmitriyz@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>
Subject: Re: [RFC,PATCH 1/3] Add a common struct clk
References: <1297058877.800158.458894385837.1.gpush@pororo> <4D50541B.2030405@bluewatersys.com> <201102081054.58005.jeremy.kerr@canonical.com>
In-Reply-To: <201102081054.58005.jeremy.kerr@canonical.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2011 03:54 PM, Jeremy Kerr wrote:
> Hi Ryan,
> 
>>> +unsigned long clk_get_rate(struct clk *clk)
>>> +{
>>> +	if (clk->ops->get_rate)
>>> +		return clk->ops->get_rate(clk);
>>
>> Possibly we should shadow the clock rate if ops->get_rate is no-op? So
>> clock initialisation and clk_set_rate store the rate in the shadow
>> field, and then do:
>>
>> 	if (clk->ops->get_rate)
>> 		return clk->ops->get_rate(clk);
>> 	return clk->shadow_rate;
>>
>> Because the API is generic, driver writers should reasonably expect that
>> clk_get_rate will return something valid without having to know the
>> platform implementation details. It may also be worth having a warning
>> to let the user know that the returned rate may be approximate.
> 
> I'd prefer to require that get_rate is implemented as an op, rather than 
> allowing two methods for retrieving the rate of the clock.

If a platform does not provide ops->get_rate and a driver writer does
not know this, they could naively use the 0 return from clk_get_rate in
calculations, which is especially bad if they ever divide by the rate.
At the very least the documentation for clk_get_rate should state that
the return value needs to be checked and that 0 means the rate is unknown.

> 
>>> +	return 0;
>>> +}
>>> +EXPORT_SYMBOL_GPL(clk_get_rate);
>>> +
>>> +int __clk_get(struct clk *clk)
>>> +{
>>> +	if (clk->ops->get)
>>> +		return clk->ops->get(clk);
>>> +	return 1;
>>> +}
>>> +EXPORT_SYMBOL_GPL(__clk_get);
>>> +
>>> +void clk_put(struct clk *clk)
>>> +{
>>> +	if (clk->ops->put)
>>> +		clk->ops->put(clk);
>>> +}
>>> +EXPORT_SYMBOL_GPL(clk_put);
>>
>> This has probably been covered, and I have probably missed it, but why
>> don't the generic clk_get/put functions do ref-counting? Drivers must
>> have matched clk_get/put calls so it should work like enable/prepare
>> counting right?
> 
> clk_get is used to find a clock; most implementations will not use this for 
> refcounting.
> 
> However, for the case where clocks are dynamically allocated, we need clk_put 
> to do any possible freeing. There's an existing API for this type of reference 
> counting (kref), so for the cases where this matters, the clock 
> implementations can use that.

Ah, I see how the clkdev part fits in now. You are correct, the ref
counting is only needed/useful for dynamic allocation of clocks and
should therefore be done in the platform specific code.

We do currently have the slightly indirect route to getting a clock of
doing: clk_get -> __clk_get -> clk->ops->get. I'm guessing that the long
term goal is to remove the middle step once everything is using the
common clock api?

Also, how come you decided to keep the clk_get -> __clk_get call in
clkdev.c, but ifdef'ed clk_put? If you just leave clk_put as is in
clkdev.c and change clk_put to __clk_put in the generic clock code then
you need zero changes to clkdev.c

> 
>>> + * The choice of atomic or non-atomic clock depends on how the clock is
>>> enabled. + * Typically, you'll want to use a non-atomic clock. For
>>> clocks that need to be + * enabled/disabled in interrupt context, use
>>> CLK_ATOMIC. Note that atomic + * clocks with parents will typically
>>> cascade enable/disable operations to + * their parent, so the parent of
>>> an atomic clock *must* be atomic too.
>>
>> This comment seems out of date now that we have the prepare/enable
>> semantics?
> 
> Yep, will update.
> 
>>> + * @unprepare:	Release the clock from its prepared state. This will
>>> typically + *		undo any work done in the @prepare callback. Called 
>>> with + *		clk->prepare_lock held.
>>
>> I think you need to make it more clear the prepare/unprepare must be
>> called from a sleepable context.
> 
> The documentation on clk_ops is intended for the clock implementor, so it's 
> not really the right place to descibe the caller's requirements.
> 
> Indeed, the documentation for clk_prepare & clk_unprepare describe the 
> caller's requirements for these (and contain the words "This function may 
> sleep").

Okay. Should we document for the implementer that clk_enable/disable
must not sleep then? I don't think atomically is necessarily the right
word to use here. For example Documentation/serial/driver uses "This
call must not sleep".

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
