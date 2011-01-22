Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab1AVCWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 21:22:41 -0500
Received: from smtp-out.google.com ([216.239.44.51]:8811 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985Ab1AVCWi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 21:22:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IYt+PIf3eeCp7hV7mxdVjAccbQ6os/bYoKIaXtXrJ5Q/KpkSQKSQFSNg/Ccv8E24v7
         adyrJIPNFvZxPO+NWCNQ==
MIME-Version: 1.0
In-Reply-To: <4D3A346E.9070709@codeaurora.org>
References: <201101111016.42819.jeremy.kerr@canonical.com>
	<20110111031552.GJ3760@linux-sh.org>
	<4D3862DB.5000708@fluff.org>
	<20110120185617.GI6335@n2100.arm.linux.org.uk>
	<alpine.LFD.2.00.1101201623480.8580@xanadu.home>
	<AANLkTimwBruVgGQWs5NQG7U3PcF6RQHZ6Pd1hjxyGpcA@mail.gmail.com>
	<4D3907BD.4040900@codeaurora.org>
	<AANLkTik53zyXytvuAd5zK0_zExfQT3FmOgTr8BexmGeT@mail.gmail.com>
	<alpine.LFD.2.00.1101211618170.8580@xanadu.home>
	<20110121220238.GE23151@n2100.arm.linux.org.uk>
	<AANLkTimT+vfg9p4GSnn1jGW9r_gVom7xEUzMVJDscPg2@mail.gmail.com>
	<4D3A346E.9070709@codeaurora.org>
Date: Fri, 21 Jan 2011 18:22:34 -0800
Message-ID: <AANLkTi=T=mBBT=1G7DpwQEOnrXSamfwppv6j8uUPE4Sj@mail.gmail.com>
Subject: Re: Locking in the clk API
From: Colin Cross <ccross@google.com>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dima Zavin <dmitriyz@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>,
        "Uwe Kleine-K??nig" <u.kleine-koenig@pengutronix.de>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 5:35 PM, Saravana Kannan <skannan@codeaurora.org> wrote:
> On 01/21/2011 02:28 PM, Colin Cross wrote:
>>
>> On Fri, Jan 21, 2011 at 2:02 PM, Russell King - ARM Linux
>> <linux@arm.linux.org.uk>  wrote:
>>>
>>> On Fri, Jan 21, 2011 at 04:53:44PM -0500, Nicolas Pitre wrote:
>>>>
>>>> So I think that the API must be augmented with more methods, such as:
>>>>
>>>> clk_slow_enable():
>>>>   - may sleep
>>>>   - may be a no-op if the clk_fast_enable() is supported
>>>>
>>>> clk_fast_enable():
>>>>   - may not sleep, used in atomic context
>>>>   - may be a no-op if controlling the clock takes time, in which case
>>>>     clk_slow_enable() must have set the clock up entirely
>>>>
>>>> ... and similar for clk_slow_disable() and clk_fast_disable().
>>>
>>> Isn't this along the same lines as my clk_prepare() vs clk_enable()
>>> suggestion?
>>>
>>> I suggested that clk_prepare() be callable only from non-atomic contexts,
>>> and do whatever's required to ensure that the clock is available.  That
>>> may end up enabling the clock as a result.
>>>
>>> clk_enable() callable from atomic contexts, and turns the clock on if
>>> the hardware supports such an operation.
>>>
>>> So, if you have something like:
>>>
>>> Xtal--->PLL--->Routing/Masking--->Device
>>>
>>> clk = clk_get() returns the clock for the device.
>>>
>>> clk_prepare(clk) would walk up the clock tree, selecting the routing and
>>> preparing each clock.  Clocks prior to _and_ including the PLL would need
>>> to be enabled.
>>>
>>> clk_enable(clk) would walk up the tree if the clock isn't already
>>> enabled,
>>> calling clk_enable() on the parent clock.  As we require prepared clocks
>>> to already be enabled, this automatically stops at the PLL.
>>>
>>> To encourage correct usage, we just need to make sure that clk_prepare()
>>> has a might_sleep() thing, and clk_enable() throws a fit if it's used
>>> on a clk without prepare being used first.  The second point is not easy
>>> to do in a foolproof manner though, but doing _something_ is better than
>>> nothing.
>>
>> I like this proposal, and I prefer the clk_prepare naming over
>> clk_slow_enable - too many people would call clk_slow_enable instead
>> of, and not as well as, clk_fast_enable.
>>
>> On Tegra, I currently use the ugly conditional mutex or spinlock
>> method to deal with voltage scaling based on clock frequency.
>
> Colin,
>
> MSM is in a similar situation, so thought I should bring this up to you
> attention -- do you have no use case for changing the rate in atomic
> context? If you do, the clk_prepare/unprepare() approach won't work.
>
> Do you have no such requirement?

I can't think of any case that requires clk_set_rate in atomic
context.  We usually only scale frequencies to save power, so we can
always scale up early in sleepable context for a minor power penalty.
