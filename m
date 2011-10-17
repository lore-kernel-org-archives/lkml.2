Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab1JQLbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 07:31:32 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40459 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab1JQLbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 07:31:31 -0400
Date: Mon, 17 Oct 2011 12:30:50 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Richard Zhao <richard.zhao@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        jeremy.kerr@canonical.com, paul@pwsan.com, linaro-dev@lists.linaro.org,
        linus.walleij@stericsson.com, patches@linaro.org,
        shawn.guo@freescale.com, magnus.damm@gmail.com,
        linux-kernel@vger.kernel.org, eric.miao@linaro.org,
        grant.likely@secretlab.ca, dsaxena@linaro.org,
        amit.kucheria@linaro.org, skannan@quicinc.com,
        arnd.bergmann@linaro.org, sboyd@quiinc.com, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [PATCH v2 1/7] clk: Add a generic clock infrastructure
Message-ID: <20111017113050.GI21648@n2100.arm.linux.org.uk>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com> <1316730422-20027-2-git-send-email-mturquette@ti.com> <20111014081024.GA9485@b20223-02.ap.freescale.net> <20111014100504.GC2966@opensource.wolfsonmicro.com> <20111014103233.GB9485@b20223-02.ap.freescale.net> <20111016175521.GA13565@pengutronix.de> <20111017084851.GB20184@b20223-02.ap.freescale.net> <20111017092028.GA3042@opensource.wolfsonmicro.com> <20111017105302.GC20184@b20223-02.ap.freescale.net> <20111017110539.GB18141@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017110539.GB18141@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 01:05:39PM +0200, Sascha Hauer wrote:
> It's not a problem to associate multiple clocks to a device, we can do
> this now already. What a driver can't do now is give-me-all-clocks-I-need(dev),
> but this problem should not be solved at clock core level but at the
> clkdev level.

I don't think it even needs solving at the clkdev level.

In order to get all clocks for a specific device, we'd need variable
length arrays to store the individual struct clk pointers, which isn't
going to be all that nice.  We'd need clk_get_alldev() and
clk_put_alldev() to deal with these variable length arrays - and as
far as the driver is concerned that's an opaque object - it can't know
anything about any particular individual struct clk in the array.

Then we'd need operations to operate on the array itself, which means
much more API baggage.

Also, if it did need to know about one particular struct clk, then
there's problems with avoiding that struct clk in the alldev() versions
(or we'll see drivers doing clk_get() followed by clk_disable() to
work-around any enabling done via the array versions.)

> The fact is that the different clocks for a device are really different
> clocks. A dumb driver may want to request/enable all relevant clocks at
> once while a more sophisticated driver may want to enable the clock for
> accessing registers in the probe function and a baud clock on device
> open time.

I don't think you can get away from drivers having to know about their
individual clocks in some form or other - and I don't think a dumb
driver should be a justification for creating an API.  If a dumb driver
wants to get the clocks for a device it has to behave as if it were
a smart driver and request each one (maybe having an array itself)
such as this:

static const char *con_ids[NR_CLKS] = {
	"foo",
	"bar",
};

struct driver_priv {
	struct clk *clk[NR_CLKS];
};

	
	for (err = i = 0; i < NR_CLKS; i++) {
		priv->clk[i] = clk_get(dev, con_ids[i];
		if (IS_ERR(priv->clk[i])) {
			err = PTR_ERR(priv->clk[i]);
			break;
		}
	}

	if (err) {
		for (i = 0; i < NR_CLKS && !IS_ERR(priv->clk[i]); i++)
			clk_put(priv->clk[i]);
		return err;
	}

This approach also has the advantage that we know what order the clocks
will be in the array, and so we can sensibly index the array to obtain
a particular clock.

However, going back to the bus fabric case, a driver probably doesn't
have the knowledge - it's a platform topology thing - one which can't
be represented by a clock tree.

It might help if we represented our busses closer to reality - like PCI
does - rather than a flattened set of platform devices.  Couple that with
runtime PM and a driver for the bus fabric, and it should fall out
fairly naturally from the infrastructure we already have.
