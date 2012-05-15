Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966609Ab2EOTm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 15:42:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58086 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966435Ab2EOTm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 15:42:56 -0400
Date: Tue, 15 May 2012 21:42:45 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Walmsley <paul@pwsan.com>,
        Shawn Guo <shawn.guo@freescale.com>, Jamie Iles <jamie@jamieiles.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] clk: Fix race conditions between clk_set_parent() and
 clk_enable()
Message-ID: <20120515194245.GO30400@pengutronix.de>
References: <1336798797-8724-1-git-send-email-skannan@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336798797-8724-1-git-send-email-skannan@codeaurora.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 21:36:53 up 185 days,  3:23, 40 users,  load average: 0.09, 0.04,
 0.06
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Saravana,

On Fri, May 11, 2012 at 09:59:56PM -0700, Saravana Kannan wrote:
> Without this patch, the following race conditions are possible.
> 
> Race condition 1:
> * clk-A has two parents - clk-X and clk-Y.
> * All three are disabled and clk-X is current parent.
> * Thread A: clk_set_parent(clk-A, clk-Y).
> * Thread A: <snip execution flow>
> * Thread A: Grabs enable lock.
> * Thread A: Sees enable count of clk-A is 0, so doesn't enable clk-Y.
> * Thread A: Releases enable lock.
> * Thread B: Calls clk_enable(clk-A), which in turn enables clk-X.
> * Thread A: Switches clk-A's parent to clk-Y in hardware.
> 
> clk-A is now enabled in software, but not clocking in hardware.
> 
> Race condition 2:
> * clk-A has two parents - clk-X and clk-Y.
> * All three are disabled and clk-X is current parent.
> * Thread A: clk_set_parent(clk-A, clk-Y).
> * Thread A: <snip execution flow>
> * Thread A: Switches parent in hardware to clk-Y.
> * Thread A: Grabs enable lock.
> * Thread A: Sees enable count of clk-A is 0, so doesn't disable clk-X.
> * Thread A: Releases enable lock.
> * Thread B: Calls clk_enable(clk-A)
> * Thread B: Software state still says parent is clk-X.
> * Thread B: So, enables clk-X and then itself.
> * Thread A: Updates parent in software state to clk-Y.

Had a look at this and I can follow your reasoning and you patch seems
to fix this. However, there is a problem,

>  
>  	/* migrate prepare and enable */
> @@ -1092,23 +1098,23 @@ static int __clk_set_parent(struct clk *clk, struct clk *parent)
>  
>  	/* FIXME replace with clk_is_enabled(clk) someday */
>  	spin_lock_irqsave(&enable_lock, flags);
> +
>  	if (clk->enable_count)
>  		__clk_enable(parent);
> -	spin_unlock_irqrestore(&enable_lock, flags);
>  
>  	/* change clock input source */
>  	ret = clk->ops->set_parent(clk->hw, i);

You call ->set_parent while holding a spinlock. This won't work with i2c
clocks.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
