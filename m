Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab1BOIdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 03:33:47 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45327 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab1BOIdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 03:33:45 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6257"; a="74295920"
Message-ID: <9c19ea8f4feb750f9f17486226099cd0.squirrel@codeaurora.org>
In-Reply-To: <201102151526.54280.jeremy.kerr@canonical.com>
References: <1297233693.242364.862698430999.1.gpush@pororo>
    <201102151041.40655.jeremy.kerr@canonical.com>
    <4D5A100F.9000809@codeaurora.org>
    <201102151526.54280.jeremy.kerr@canonical.com>
Date: Tue, 15 Feb 2011 00:33:25 -0800 (PST)
Subject: Re: [RFC,PATCH 1/3] Add a common struct clk
From: "Saravana Kannan" <skannan@codeaurora.org>
To: "Jeremy Kerr" <jeremy.kerr@canonical.com>
Cc: "Saravana Kannan" <skannan@codeaurora.org>,
        "Nicolas Pitre" <nicolas.pitre@linaro.org>,
        "Dima Zavin" <dmitriyz@google.com>,
        "Lorenzo Pieralisi" <lorenzo.pieralisi@arm.com>,
        "Russell King" <linux@arm.linux.org.uk>, linux-sh@vger.kernel.org,
        "Ben Herrenschmidt" <benh@kernel.crashing.org>,
        "Sascha Hauer" <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        "Paul Mundt" <lethal@linux-sh.org>, "Ben Dooks" <ben-linux@fluff.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        "Vincent Guittot" <vincent.guittot@linaro.org>,
        linux-arm-kernel@lists.infradead.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy,

Sorry, if the formatting is weird. Using webmail client

On Mon, February 14, 2011 11:26 pm, Jeremy Kerr wrote:
>> > We
>> > may even want to disallow set_rate (and set_parent) when prepare_count
>> is
>> > non- zero.
>>
>> This is definitely not right.
>
> Why is that? Consider two devices using one clock; one does some
> initialisation based on the return value of clk_get_rate(), the other
> calls
> clk_set_rate() some time later. Now the first device is incorrectly
> initialised.

The case you describe is certainly something I consider as incorrect and
agree with you in that we should try to prevent it. But

(prepare_count != 0) != (two devices using one clock).

For one, prepare_count == 1 would be a normal case when a clock is enabled
and the MSM drivers certainly want to be able to set the rate when the
clock is enabled.

But (prepare_count > 1 || enable_count > 1) doesn't mean more than one
device/device driver using the clock either. A simple example would be a
driver wrapping all it's register accesses with a clk_enable/clk_disable
and not having to worry about if a clock is enabled during register access
when it has multiple execution paths (threads, interrupt handler, timers,
etc) that access registers. The driver would just do the enable/disable
around register accesses and let the clock code's ref counting dealing
with making sure a clock is never turned off when it's needed. In these
case both the prepare_count (less likely, but likely) and enable_count can
greater than 1.

Long story short, I support your desire to prevent one driver from
changing the rate from underneath another driver, but the condition you
chose to figure that out is not accurate.

> Regardless, this is definitely something to flag for a later discussion.
> I'm
> happy to return to that, but we should focus on one issue at a time here.

Sure, this discussion of set rate with count is non-zero can be reserved
for later. But I think the discussion of grabbing the lock during
set_parent should be discussed in the context of this patch.

Waiting to see how others feel about this.

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


