Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab1AKKP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 05:15:28 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:39820 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab1AKKPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 05:15:21 -0500
Date: Tue, 11 Jan 2011 19:13:14 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
Subject: Re: Locking in the clk API
Message-ID: <20110111101314.GA774@linux-sh.org>
References: <201101111016.42819.jeremy.kerr@canonical.com> <20110111091607.GI12552@n2100.arm.linux.org.uk> <201101111744.59712.jeremy.kerr@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101111744.59712.jeremy.kerr@canonical.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 05:44:59PM +0800, Jeremy Kerr wrote:
> So, it sounds like the best approach is to provide an atomic clk_enable. I 
> agree with Sascha that the clk_enable and clk_enable_atomic polarity makes the 
> most sense, so how about:
> 
> int clk_enable(struct clk *clk)
> {
> 	might_sleep();
> 
> 	[...]
> }
> 
> int clk_enable_atomic(struct clk *clk)
> {
> 	BUG_ON(!(clk->flags & CLK_ATOMIC));
> 
> 	[...]
> }
> 
> Paul: even though you mention that the atomic clocks are the usual case, I 
> think that this way around illustrates the atomic 'restriction' at the call 
> site more clearly. When the drivers don't care about the atomicity, 
> clk_enable() is fine. When drivers do need an atomic clock, 
> clk_enable_atomic() shows this requirement.
> 
No, the sleeping clock case is and always will be a corner case, and I
have no interest in pretending otherwise. On SH we have hundreds of
clocks that are all usable in the atomic context and perhaps less than a
dozen that aren't (and even in those cases much of the PLL negotiation is
handled in hardware so there's never any visibility for the lock-down
from the software side, other architectures also have similar behaviour).

Keep in mind that all users except for the few that you cited were
already quite content with the atomic context use, so this 'restriction'
you speak of is just an artificial limitation introduced by a couple of
new platforms that deviated from what everyone else was already doing.

If you want to go this route, then SH and ARM-based SH-Mobiles will at
least not be making use of the generic struct clk.
