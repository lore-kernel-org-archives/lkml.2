Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab1GRJol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 05:44:41 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44024 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab1GRJok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 05:44:40 -0400
Date: Mon, 18 Jul 2011 10:44:09 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Nick Bowler <nbowler@elliptictech.com>, linux-watchdog@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] SP805 updates for Versatile Express
Message-ID: <20110718094409.GQ23270@n2100.arm.linux.org.uk>
References: <1310742242-14647-1-git-send-email-nbowler@elliptictech.com> <20110715205954.GR3834@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110715205954.GR3834@infomag.iguana.be>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 10:59:54PM +0200, Wim Van Sebroeck wrote:
> Hi Nick,
> 
> > Here are some updates to get the SP805 watchdog working on the ARM
> > Versatile Express.  The first two patches fix observed issues; the
> > third fixes a potential (but not observed) issue with asynchronous
> > posted writes.
> > 
> > All three patches are independent and should be applicable in any
> > order, with some fuzz on the third.
> 
> looks good at first glance.
> 
> Russel: what's your opinion?

Win,

This series looks fine.  However, looking through the driver, there's
a few oddities:

static u32 wdt_timeleft(void)
{
        u64 load, rate;

        rate = clk_get_rate(wdt->clk);

        spin_lock(&wdt->lock);
        load = readl(wdt->base + WDTVALUE);

        /*If the interrupt is inactive then time left is WDTValue + WDTLoad. */
        if (!(readl(wdt->base + WDTRIS) & INT_MASK))
                load += wdt->load_val + 1;
        spin_unlock(&wdt->lock);

        return div_u64(load, rate);
}

clk_get_rate returns an unsigned long, not a u64.  There's no point
expanding it to a 64-bit int for div_u64 - rate might as well be
declared as an unsigned long.

Same goes for wdt_setload, and there stuff like "div_u64(rate, 2)"
can become normal maths rather than the special 64-bit stuff.

Then there's:

        if (!request_mem_region(adev->res.start, resource_size(&adev->res),
                                "sp805_wdt")) {
                dev_warn(&adev->dev, "Failed to get memory region resource\n");
                ret = -ENOENT;
                goto err;
        }

Is amba_request_regions()/amba_release_regions() not good enough to
handle requesting/releasing these regions?
