Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab2HQLe7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 07:34:59 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40201 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890Ab2HQLe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 07:34:57 -0400
Date: Fri, 17 Aug 2012 12:34:42 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BUG: clk_find() misses some clocks
Message-ID: <20120817113442.GN18957@n2100.arm.linux.org.uk>
References: <1345196843-23059-1-git-send-email-richard.genoud@gmail.com> <20120817095837.GM18957@n2100.arm.linux.org.uk> <CACQ1gAh3YcMBXp7BFoR68+rdDM1PEe4fenNG77s=SP05RditEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACQ1gAh3YcMBXp7BFoR68+rdDM1PEe4fenNG77s=SP05RditEA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 12:23:06PM +0200, Richard Genoud wrote:
> Ok, so I have to declare it like that :
> CLKDEV_CON_DEV_ID(NULL, "fffff400.gpio", &pioAB_clk)

Yes, because the wildcarding is in the clkdev tables, not in the driver.
If you think about what's going on, that's the way it has to be.  Remember
that it's the _device_ that defines what the connection name is (there's
the hint: it's the connection name on the device itself) and it isn't a
global clock name.

So, for example, if set of devices used in multiple different SoCs have a
clock input called "apbclk" and on some SoCs this clock is uncontrollable,
but on others it can be individually controlled, we can cater for this:

- the SoC where this clock is uncontrollable can create a dummy clock with
  a connection ID of "apbclk" and a NULL device name, which will match
  against any device asking for an "apbclk".
- the SoC where the clock is individually controllable would list the
  individual "apbclk" entries in the clkdev table, and clkdev will return
  the appropriate one.

In mixed environments, this also works, because we return the "best match"
from clkdev.

Same goes for devices where they have an "iclk" and an "fclk" (iow, two
clocks) - the connection ID can be wildcarded in the clkdev tables so that
the same clock can be returned for the same device where the driver asks
for the clocks individually - if that's what the SoC support desires.

It makes no sense for a driver to ask for "any clock on this device"
because drivers always want the clock for a particular purpose.  Hence
why NULL arguments to clk_get() don't act as wildcards.
