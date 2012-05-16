Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab2EPGBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:01:15 -0400
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:50006 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752607Ab2EPGBN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:01:13 -0400
MIME-Version: 1.0
In-Reply-To: <1336798797-8724-1-git-send-email-skannan@codeaurora.org>
References: <1336798797-8724-1-git-send-email-skannan@codeaurora.org>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Tue, 15 May 2012 23:00:50 -0700
Message-ID: <CAJOA=zNVQUDbHQCgnQ56S50fva2eKUXAH9aVkTbtyvQW+fq9SA@mail.gmail.com>
Subject: Re: [PATCH] clk: Fix race conditions between clk_set_parent() and clk_enable()
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Paul Walmsley <paul@pwsan.com>, Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Deepak Saxena <dsaxena@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 9:59 PM, Saravana Kannan <skannan@codeaurora.org> wrote:
> Since clocks with CLK_SET_PARENT_GATE flag only allow clk_set_parent() on
> unprepared clocks and calling clk_enable() on an unprepared clock would be
> violating the clock API usage model, allow set_parent() ops to be sleepable
> for clocks which have the CLK_SET_PARENT_GATE flag. Putting it another way,
> if a clock's parent can't be switched without sleeping, then by definition
> the parent can't be switched while it's prepared (CLK_SET_PARENT_GATE).
>
...
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index e5d5dc1..09b9112 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1059,7 +1059,7 @@ static int __clk_set_parent(struct clk *clk, struct clk *parent)
>  {
>        struct clk *old_parent;
>        unsigned long flags;
> -       int ret = -EINVAL;
> +       int ret;
>        u8 i;
>
>        old_parent = clk->parent;
> @@ -1083,7 +1083,13 @@ static int __clk_set_parent(struct clk *clk, struct clk *parent)
>        if (i == clk->num_parents) {
>                pr_debug("%s: clock %s is not a possible parent of clock %s\n",
>                                __func__, parent->name, clk->name);
> -               goto out;
> +               return -EINVAL;
> +       }
> +
> +       if (clk->flags & CLK_SET_PARENT_GATE) {
> +               ret = clk->ops->set_parent(clk->hw, i);
> +               clk->parent = parent;
> +               return ret;
>        }
>
>        /* migrate prepare and enable */

The above hunk is a good change since it fixes a bug where we
prepare/enable the parent clocks around the .set_parent callback, even
when CLK_SET_PARENT_GATE is set.  It should be a separate patch.

Thanks,
Mike
