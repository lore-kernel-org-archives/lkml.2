Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab1AKJpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 04:45:16 -0500
Received: from adelie.canonical.com ([91.189.90.139]:44568 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab1AKJpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 04:45:10 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: Locking in the clk API
Date: Tue, 11 Jan 2011 17:44:59 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; x86_64; ; )
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
References: <201101111016.42819.jeremy.kerr@canonical.com> <20110111091607.GI12552@n2100.arm.linux.org.uk>
In-Reply-To: <20110111091607.GI12552@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101111744.59712.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

> I object to this as one of the purposes behind the clk API is to allow
> power savings to be made, and unless we can perform clk enable/disable
> from atomic contexts, the best you can do is enable the clock when the
> device is probed and disable it when it's released.
> 
> [...]
>
> Sometimes the only point that you know you need the clock enabled is when
> your driver has already been called in an atomic context.

.. provided that the enable (and subsequent things that depend on the clock 
signal to be valid) can't be deferred; I'm not sure how often this will be 
possible.

So, it sounds like the best approach is to provide an atomic clk_enable. I 
agree with Sascha that the clk_enable and clk_enable_atomic polarity makes the 
most sense, so how about:

int clk_enable(struct clk *clk)
{
	might_sleep();

	[...]
}

int clk_enable_atomic(struct clk *clk)
{
	BUG_ON(!(clk->flags & CLK_ATOMIC));

	[...]
}

Paul: even though you mention that the atomic clocks are the usual case, I 
think that this way around illustrates the atomic 'restriction' at the call 
site more clearly. When the drivers don't care about the atomicity, 
clk_enable() is fine. When drivers do need an atomic clock, 
clk_enable_atomic() shows this requirement.

Cheers,


Jeremy
