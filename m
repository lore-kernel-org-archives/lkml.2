Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab1LEVP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 16:15:59 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:48856 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398Ab1LEVP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 16:15:57 -0500
Date: Mon, 5 Dec 2011 14:15:56 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Mike Turquette <mturquette@ti.com>
cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jeremy.kerr@canonical.com, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, aul@pwsan.com, grant.likely@secretlab.ca,
        sboyd@quicinc.com, shawn.guo@freescale.com, skannan@quicinc.com,
        magnus.damm@gmail.com, arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org, Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH v3 3/5] clk: introduce the common clock framework
In-Reply-To: <1321926047-14211-4-git-send-email-mturquette@linaro.org>
Message-ID: <alpine.DEB.2.00.1112051342430.6289@utopia.booyaka.com>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org> <1321926047-14211-4-git-send-email-mturquette@linaro.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

a brief comment concerning clock rates:

On Mon, 21 Nov 2011, Mike Turquette wrote:

> +unsigned long clk_get_rate(struct clk *clk)

...

> +long clk_round_rate(struct clk *clk, unsigned long rate)

...

> +int clk_set_rate(struct clk *clk, unsigned long rate)

...

> +struct clk {
...
> +	unsigned long		rate;
...
> +};

The types associated with clock rates in the clock interface 
(include/linux/clk.h) are inconsistent, and we should fix this. 
clk_round_rate() is the problematic case, returning a signed long rather 
than an unsigned long.  So clk_round_rate() won't work correctly with any 
rates higher than 2 GiHz.

We could fix the immediate problem by changing the prototype of 
clk_round_rate() to pass the rounded rate back to the caller via a pointer 
in one of the arguments, and return an error code (if any) via the return 
value:

int clk_round_rate(struct clk *clk, unsigned long rate, unsigned long 
                   *rounded_rate);

But I'd propose that we instead increase the size of struct clk.rate to be 
s64:

s64 clk_round_rate(struct clk *clk, s64 desired_rate);
int clk_set_rate(struct clk *clk, s64 rate);
s64 clk_get_rate(struct clk *clk);

struct clk {
...
     s64 rate;
...
};

That way the clock framework can accommodate current clock rates, as well 
as any conceivable future clock rate.  (Some production CPUs are already 
running at clock rates greater than 4 GiHZ[1].  RF devices with 4 GiHz+ 
clock rates are also common, such as 802.11a devices running in the 5.8 
GHz band, and drivers for those may eventually wish to use the clock 
framework.)



- Paul

1. www.cpu-world.com, "Intel Xeon X5698 - AT80614007314AA" 
   http://www.cpu-world.com/CPUs/Xeon/Intel-Xeon%20X5698%20-%20AT80614007314AA.html
