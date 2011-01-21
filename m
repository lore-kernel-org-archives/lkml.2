Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab1AUHQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 02:16:08 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19079 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab1AUHQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 02:16:07 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6232"; a="71130270"
Message-ID: <4D3932B4.8010904@codeaurora.org>
Date: Thu, 20 Jan 2011 23:16:04 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Ben Dooks <ben-linux@fluff.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-sh <linux-sh@vger.kernel.org>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Uwe_Kleine?= =?ISO-8859-1?Q?-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Richard Zhao <linuxzsc@gmail.com>
Subject: Re: Locking in the clk API
References: <201101111016.42819.jeremy.kerr@canonical.com>	<20110111091607.GI12552@n2100.arm.linux.org.uk>	<201101111744.59712.jeremy.kerr@canonical.com>	<20110111103929.GN24920@pengutronix.de>	<AANLkTinHL9X_bqMPR=W8Va01O4xngUnpGCkCiE3xEdiQ@mail.gmail.com>	<4D386ABF.9060908@fluff.org> <20110120190822.GK6335@n2100.arm.linux.org.uk>
In-Reply-To: <20110120190822.GK6335@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2011 11:08 AM, Russell King - ARM Linux wrote:
> On Thu, Jan 20, 2011 at 05:02:55PM +0000, Ben Dooks wrote:
>> If you want to make it so that each low-power mode has to work
>> out what PLLs need to be disabled and then re-enabled makes me
>> want to be sick. Hiding this stuff behind specific implementations
>> is a recipe for disaster.
>
> Why should systems which don't suffer from such problems be prevented
> from gaining power saving from turning off their clocks when devices
> are not being used (eg, the console serial port.)
>
> One solution to your root PLL issue would be to have a separate set of
> enable/disable API calls which get called at setup/release time (or
> whatever you'd like to call it) which can only be called from non-atomic
> context.  Maybe clk_prepare() and clk_unprepare().  These functions
> should perform whatever is necessary to ensure that the clock source
> is available for use atomically when clk_enable() is called.
>
> So, in your case, clk_prepare() ensures that the root PLL is enabled,
> clk_unprepare() allows it to be turned off.
>
> In the case of a console driver, clk_prepare() can be called when we
> know the port will be used as a console.  clk_enable() is then called
> before writing out the string, and clk_disable() after we've completely
> sent the last character.
>
> This allows the best of both worlds.  We now have a clk_enable() which
> can be used to turn the clocks off through the clock tree up to the first
> non-atomic clock, and we also have a way to deal with those which need
> to sleep.  So not only do "sleeping clock" implementations become possible
> but these "sleeping clock" implementations also get the opportunity to
> shutdown some of their clock tree with minimal latency for doing so.

This suggestion looked promising till I realized that clk_set_rate() 
will still be atomic. clk_set_rate() will need to enable/disable the 
PLLs depending on which PLLs the rates are derived from. So, the locking 
in clk_prepare/unprepare() still has to be atomic since the "slow stuff" 
is shared with clk_set_rate().

IMO, the most workable/flexible suggestion I have seen so far is:
- Having a way to explicitly ask for an atomic clock from clk_get(). 
That way the driver can decide to fail early during probe or decide to 
enable/disable in open/close or if it gets atomic clocks to 
enable/disable in atomic context.
- Atomic and sleep-able variants of clk_enable/disable/set_rate. I 
personally prefer the existing APIs to be sleep-able and introduce new 
atomic variants, but it's not worth the time arguing over that.

Taking one step at a time, do we all at least agree having two variants 
of enable/disable/set_rate?

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
