Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab1KZGxv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 01:53:51 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:10834 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab1KZGxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 01:53:49 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Sat, 26 Nov 2011 15:06:02 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Mike Turquette <mturquette@ti.com>
CC: <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <jeremy.kerr@canonical.com>, <broonie@opensource.wolfsonmicro.com>,
        <tglx@linutronix.de>, <linus.walleij@stericsson.com>,
        <amit.kucheria@linaro.org>, <dsaxena@linaro.org>, <patches@linaro.org>,
        <linaro-dev@lists.linaro.org>, <aul@pwsan.com>,
        <grant.likely@secretlab.ca>, <sboyd@quicinc.com>,
        <skannan@quicinc.com>, <magnus.damm@gmail.com>,
        <arnd.bergmann@linaro.org>, <eric.miao@linaro.org>,
        <richard.zhao@linaro.org>, Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH v3 0/5] common clk framework
Message-ID: <20111126070601.GA19176@S2100-06.ap.freescale.net>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 05:40:42PM -0800, Mike Turquette wrote:
[...]

>   .the most notable change is the removal of struct clk_hw.

Happy to see that.

> This extra
> layer of abstraction is only necessary if we want hide the definition of
> struct clk from platform code.  Many developers expressed the need to
> know some details of the generic struct clk in the platform layer, and
> rightly so.  Now struct clk is defined in include/linux/clk.h, protected
> by #ifdef CONFIG_GENERIC_CLK.
> 
>   .flags have been introduced to struct clk, with several of them
> defined and used in the common code.  These flags protect against
> changing clk rates or switching the clk parent while that clk is
> enabled; another flag is used to signal to clk_set_rate that it should
> ask the parent to change it's rate too.
> 
>   .speaking of which, clk_set_rate has been overhauled and is now
> recursive. *collective groan*.  clk_set_rate is still simple for the
> common case of simply setting a single clk's rate.  But if your clk has
> the CLK_PARENT_SET_RATE flag and the .round_rate callback recommends
> changing the parent rate, then clk_set_rate will recurse upwards to the
> parent and try it all over again.  In the event of a failure everything
> unwinds and all the clks go out for drinks.
> 
I smell that this will be the part which makes the whole series risky
of being accepted in a desired time frame, with saying rate change
notifications are still missing for now.

>   .clk_register has been replaced by clk_init, which does NOT allocate
> memory for you.  Platforms should allocate their own clk_hw_whatever
> structure which contains struct clk.  clk_init is still necessary to
> initialize struct clk internals.  clk_init also accepts struct device
> *dev as an argument, but does nothing with it.  This is in anticipation
> of device tree support.
> 
I would say that we do not necessarily need to have 'struct device'
for each clk (for imx6 example, we have 110 clks, and I heard some
omap support has 225 clks?).  The device tree support can work out
everything it needs from the 'struct device_node', which can be a
clock blob constraining multiple clks (thanks to 'clock-cells').  That
said you may want to add the 'dev' argument for other reasons, but I
never used it when converting imx6 clock to device tree.

>   .Documentation!  I'm sure somebody reads it.
> 
>   .sysfs support.  Visualize your clk tree at /sys/clk!  Where would be
> a better place to put the clk tree besides the root of /sys/?  When a
> consensus on this is reached I'll submit the proper changes to
> Documentation/ABI/testing/.
> 
> What's missing?
> 
>   .per tree locking.  I implemented this at the Linaro Connect
> conference but the implementation was unpopular, so it didn't make the
> cut.  There needs to be better understanding of everyone's needs for
> this to work.
> 
>   .rate change notifications.  I simply didn't want to delay getting
> these patches to the list any longer, so the notifiers didn't make it
> in.  I'll submit them to the list soon, or roll them into the V4
> patchset.  There are comments in the clk API definitions for where
> PRECHANGE, POSTCHANGE and ABORT propagation will go.
> 
>   .basic mux clk, divider and dummy clk implementations.  I think others
> have some code lying around to implement these, so I left them out.
> 
>   .device tree support.  I haven't looked much at the on-going
> discussions on the dt clk bindings.  How compatible (or not) are the
> device tree clk bindings and the way these patches want to initialize
> clks?
> 
I have just converted imx6 clock to device tree based on this series
and Grant's of-clk series with one minor change on clk-basic which
technically is not part of the core support.  So I would say, do not
worry, it's perfectly compatible with device tree :)

>   .what is the overlap between common clk and clkdev?  We're essentially
> tracking the clks in two places (common clk's tree and clkdevs's list),
> which feels a bit wasteful.
> 
I do not see the overlap between these two.  The clkdev is nothing but
a list maintaining the mapping between necessary 'struct clk' and its
consumer's 'struct dev'.  It has no clock tree topology, and common
clk's tree has no that mapping.

-- 
Regards,
Shawn

