Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab1AOOyt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 09:54:49 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43329 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab1AOOys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 09:54:48 -0500
Date: Sat, 15 Jan 2011 14:53:58 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Christer Weinigel <christer@weinigel.se>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
Message-ID: <20110115145358.GC15996@n2100.arm.linux.org.uk>
References: <201101111016.42819.jeremy.kerr@canonical.com> <20110111091607.GI12552@n2100.arm.linux.org.uk> <4D2D184A.8020405@codeaurora.org> <20110112090301.GS11039@n2100.arm.linux.org.uk> <4D31A8F1.4080301@weinigel.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D31A8F1.4080301@weinigel.se>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 03:02:25PM +0100, Christer Weinigel wrote:
> This feels a bit like perfect being the enemy of good.
>
> On platforms that need to sleep to enable the UART clock, configuring  
> the UART as the kernel console should be equivalent to userspace opening  
> the UART device, i.e. enable the clock.  At least to me that feels like  
> an acceptable tradeoff, and if I wanted to save the last bit of power  
> I'll have to refrain from using UART as the kernel console.
>
> If both printk to the console and disabling the clock is really really  
> neccesary, add a clk_enable_busywait, but that will be a bit of a hack.

Well, we're not discussing a _new_ API here - we're discussing an API
with existing users which works completely fine on the devices its
used, with differing expectations between implementations.

> Both of these feel like they should use a call such as clk_get_atomic  
> and be able to handle EWOULDBLOCK/EAGAIN (or whatever error code is used  
> to indicate that it would have to sleep) and delegate to a worker thread  
> to enable the clock.  To catch uses of plain clk_enable from atomic  
> contects, add a WARN_ON/BUG_ON(in_atomic()).  It won't catch everything,  
> but would help a bit at least.

We've never allowed clk_get() to be called in interruptible context,
so that's not the issue.  The issue is purely about clk_enable() and
clk_disable() and whether they should be able to be called in atomic
context or not.

We've been around returning EAGAIN, WARN_ONs, BUG_ONs, having clk_enable()
vs clk_enable_atomic(), clk_enable_cansleep() vs clk_enable(), etc.

There's been a lot of talk on this issue for ages with no real progress
that I'm just going to repeat: let's unify those implementations which
use a spinlock for their clks into one consolidated solution, and
a separate consolidated solution for those which use a mutex.

This will at least allow us to have _some_ consolidation of the existing
implementations - and it doesn't add anything to the problem at hand.
It might actually help identify what can be done at code level to resolve
this issue.
