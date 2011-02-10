Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab1BJKLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 05:11:14 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:14525 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751934Ab1BJKLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 05:11:11 -0500
Message-ID: <4D53B9AC.8020609@bluewatersys.com>
Date: Thu, 10 Feb 2011 23:10:52 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Richard Zhao <richard.zhao@freescale.com>
CC: Jeremy Kerr <jeremy.kerr@canonical.com>,
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
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC,PATCH 1/3] Add a common struct clk
References: <1297233693.242364.862698430999.1.gpush@pororo> <4D52F73A.4010707@bluewatersys.com> <20110210100319.GB24710@b20223-02.ap.freescale.net>
In-Reply-To: <20110210100319.GB24710@b20223-02.ap.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/11 23:03, Richard Zhao wrote:
> On Thu, Feb 10, 2011 at 09:21:14AM +1300, Ryan Mallon wrote:
>> On 02/09/2011 07:41 PM, Jeremy Kerr wrote:
>>
>> Hi Jeremy,
>>
>> Couple more comments below.
>>
>> ~Ryan
>>
> [...]
>>> +int clk_enable(struct clk *clk)
>>> +{
>>> +     unsigned long flags;
>>> +     int ret = 0;
>>> +
>>> +     spin_lock_irqsave(&clk->enable_lock, flags);
>>          WARN_ON(clk->prepare_count == 0); ?
>>
>>> +     if (clk->enable_count == 0&&  clk->ops->enable)
>>> +             ret = clk->ops->enable(clk);
>> Does it make sense to have a clock with no enable function which still
>> returns success from clk_enable? Do we have any platforms which have
>> NULL clk_enable functions?
>>
>> I think that for enable/disable at least we should require platforms to
>> provide functions and oops if they have failed to do so. In the rare
>> case that a platform doesn't need to do anything for enable/disable they
>> can just supply empty functions.
> It's possible to be NULL. So are set_rate/get_rate.
> Ideally, if it's NULL:
> prepare/unprepare: only call parent's prepare/unprepare
> enable/disable: only call parent's enable/disable

No, the whole point of the generic framework is that _all_ clock users 
must call prepare/enable and disable/unprepare. Drivers, etc should not 
rely on underlying knowledge of a platform. This is why, for instance, 
clk_enable will warn if prepare count is zero.

However, I can see that a clock may be fully enabled by its prepare 
function and so the enable function is a no-op. User must still call 
both prepare and enable though. Perhaps this is what you meant?

~Ryan
