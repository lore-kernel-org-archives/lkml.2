Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab1ALC15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 21:27:57 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:42178 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab1ALC1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 21:27:55 -0500
Date: Wed, 12 Jan 2011 11:25:47 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-sh@vger.kernel.org, Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
Message-ID: <20110112022546.GA2350@linux-sh.org>
References: <201101111016.42819.jeremy.kerr@canonical.com> <201101111744.59712.jeremy.kerr@canonical.com> <20110111101314.GA774@linux-sh.org> <201101111830.18597.jeremy.kerr@canonical.com> <20110111121816.GB774@linux-sh.org> <4D2D09E2.5030305@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2D09E2.5030305@codeaurora.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 05:54:42PM -0800, Saravana Kannan wrote:
> On 01/11/2011 04:18 AM, Paul Mundt wrote:
> >Again, you are approaching it from the angle that an atomic clock is a
> >special requirement rather than the default behaviour. Sleeping for
> >lookup, addition, and deletion are all quite acceptable, but
> >enable/disable pairs have always been intended to be usable from atomic
> >context. Anyone that doesn't count on that fact is either dealing with
> >special case clocks (PLLs, root clocks, etc.) or simply hasn't bothered
> >implementing any sort of fine grained runtime power management for their
> >platform.
> 
> Paul,
> 
> I see you repeating this point a couple of times and I'm a bit confused 
> how you handle the clock tree/dependencies.
> 
> Does your clock driver NOT hide the details of what root clock/PLL a 
> branch clock is sourced from? If you do hide the details of the root/PLL 
> source, how do you get the branch clk_enable() to be done atomically if 
> the root/PLL enables are not possible in atomic context?
> 
> Is it simply a matter of your hardware having PLLs and root clocks that 
> can be turned on/off quickly?
> 
There are a few cases where PLL clocks would benefit from a clk_enable()
that can sleep, but for us these are almost all in the device space. Most
of the SoCs however have fairly straightforward clock topologies where
the root clock in question is an external oscillator that can't be
disabled, and anything chained below that sits behind a PLL divider or
multiplier bank that can likewise be adjusted atomically. The vast
majority of the clocks below that can likewise be trivially
enabled/disabled from atomic context.

In response to your query, no, we do not hide those details. Each on-chip
clock generator is fed by a default oscillator via one input or a board
specific one via another, with a frequency that can vary wildly depending
on the implementation. In general we require the SoC code to register its
clock topology, the board code to work out which source its fed from (and
at what frequency), and then also providing an initial rate propagation
kick down the tree to make sure that all of the core clocks are set up
sensibly and to synchronize hardware/software state.

Having said that, we _do_ have clocks where rate changes are non-trivial
due to it being necessary to synchronize with internal timing circuitry,
but at the moment we don't really deal with those (this is something we'd
have to deal with for dynamically scaling the bus clock for example,
which requires a special watchdog overflow to relock an internal PLL,
which in general we leave fixed).

In general I would be happy to have a sleepable variant of clk_enable(),
it's just making clk_enable() sleepable by default or treating clocks
usable from atomic context as the special case that I take issue with,
particularly when the opposite is the demonstratable norm.
