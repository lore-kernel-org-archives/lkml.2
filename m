Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab2CCNc0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 08:32:26 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37231 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab2CCNcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 08:32:25 -0500
Date: Sat, 3 Mar 2012 14:31:58 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mike Turquette <mturquette@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        linaro-dev@lists.linaro.org, Grant Likely <grant.likely@secretlab.ca>,
        Saravana Kannan <skannan@codeaurora.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Mike Turquette <mturquette@ti.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergman <arnd.bergmann@linaro.org>, patches@linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [PATCH v5 3/4] clk: introduce the common clock framework
Message-ID: <20120303133158.GA26882@pengutronix.de>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
 <1330763341-3437-4-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330763341-3437-4-git-send-email-mturquette@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:13:49 up 111 days, 21:00, 15 users,  load average: 0.00, 0.02,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2012 at 12:29:00AM -0800, Mike Turquette wrote:
> The common clock framework defines a common struct clk useful across
> most platforms as well as an implementation of the clk api that drivers
> can use safely for managing clocks.
> 
> The net result is consolidation of many different struct clk definitions
> and platform-specific clock framework implementations.
> 
> This patch introduces the common struct clk, struct clk_ops and an
> implementation of the well-known clock api in include/clk/clk.h.
> Platforms may define their own hardware-specific clock structure and
> their own clock operation callbacks, so long as it wraps an instance of
> struct clk_hw.
> 
> See Documentation/clk.txt for more details.
> 
> This patch is based on the work of Jeremy Kerr, which in turn was based
> on the work of Ben Herrenschmidt.
> 
> +
> +/**
> + * struct clk_hw - handle for traversing from a struct clk to its corresponding
> + * hardware-specific structure.  struct clk_hw should be declared within struct
> + * clk_foo and then referenced by the struct clk instance that uses struct
> + * clk_foo's clk_ops
> + *
> + * clk: pointer to the struct clk instance that points back to this struct
> + * clk_hw instance
> + */
> +struct clk_hw {
> +	struct clk *clk;
> +};

The reason for doing this is that struct clk should be an opaque cookie
for both drivers and implementers of clocks. I recently had the idea whether
the roles of these two structs could be swapped. So instead of the above we
could do:

struct clk {
	struct clk_hw *hw;
}

The effect would be the same, but this version would make the struct clk
pointer known at compile time thus making it possible for static
initializers to specify their parent clock.

I just saw that clk_register now takes a parent name array, that may
make this change unnecessary anyway.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
