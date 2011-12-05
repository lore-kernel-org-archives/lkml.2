Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758Ab1LEXtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 18:49:10 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58397 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932619Ab1LEXtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 18:49:09 -0500
Date: Mon, 5 Dec 2011 23:48:49 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: Mike Turquette <mturquette@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jeremy.kerr@canonical.com, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, aul@pwsan.com, grant.likely@secretlab.ca,
        sboyd@quicinc.com, shawn.guo@freescale.com, skannan@quicinc.com,
        magnus.damm@gmail.com, arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org, Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH v3 3/5] clk: introduce the common clock framework
Message-ID: <20111205234849.GA14547@n2100.arm.linux.org.uk>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org> <1321926047-14211-4-git-send-email-mturquette@linaro.org> <alpine.DEB.2.00.1112051342430.6289@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1112051342430.6289@utopia.booyaka.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 02:15:56PM -0700, Paul Walmsley wrote:
> The types associated with clock rates in the clock interface 
> (include/linux/clk.h) are inconsistent, and we should fix this. 

Rubbish.  They're different with good reason.  Rates are primerily
unsigned quantities - and should be treated as such.

The exception is clk_round_rate() which returns the rate, but also
_may_ return an error.  Therefore, its return type has to be signed.

> We could fix the immediate problem by changing the prototype of 
> clk_round_rate() to pass the rounded rate back to the caller via a pointer 
> in one of the arguments, and return an error code (if any) via the return 
> value:
> 
> int clk_round_rate(struct clk *clk, unsigned long rate, unsigned long 
>                    *rounded_rate);

Yes that might have been a better solution.

> But I'd propose that we instead increase the size of struct clk.rate to be 
> s64:
> 
> s64 clk_round_rate(struct clk *clk, s64 desired_rate);
> int clk_set_rate(struct clk *clk, s64 rate);
> s64 clk_get_rate(struct clk *clk);
> 
> struct clk {
> ...
>      s64 rate;
> ...
> };
> 
> That way the clock framework can accommodate current clock rates, as well 
> as any conceivable future clock rate.  (Some production CPUs are already 
> running at clock rates greater than 4 GiHZ[1].  RF devices with 4 GiHz+ 
> clock rates are also common, such as 802.11a devices running in the 5.8 
> GHz band, and drivers for those may eventually wish to use the clock 
> framework.)

Yuck.  You are aware that 64-bit math on 32-bit CPUs sucks?  So burdening
_everything_ with 64-bit rate quantities is absurd.  As for making then
64-bit signed quantities, that's asking for horrid code from gcc for the
majority of cases.
