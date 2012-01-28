Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab2A1QBE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 11:01:04 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53688 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab2A1QBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 11:01:01 -0500
Date: Sat, 28 Jan 2012 16:00:11 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Roland Stigge <stigge@antcom.de>
Cc: w.sang@pengutronix.de, grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix LPC32XX's clock.c
Message-ID: <20120128160011.GA15455@n2100.arm.linux.org.uk>
References: <1327673868-19741-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327673868-19741-1-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 03:17:48PM +0100, Roland Stigge wrote:
> @@ -382,30 +388,62 @@ static u32 local_clk_usbpll_setup(struct clk_pll_setup *pHCLKPllSetup)
>  static int local_usbpll_enable(struct clk *clk, int enable)
>  {
>  	u32 reg;
> -	int ret = -ENODEV;
> -	unsigned long timeout = 1 + msecs_to_jiffies(10);
> +	int ret = 0;
> +	unsigned long timeout = jiffies + msecs_to_jiffies(20);

...

> -		/* Wait for PLL lock */
> -		while ((timeout > jiffies) & (ret == -ENODEV)) {
> +		/*
> +		 * Enable PLL
> +		 */
> +		reg |= LPC32XX_CLKPWR_USBCTRL_PLL_PWRUP;
> +		__raw_writel(reg, LPC32XX_CLKPWR_USB_CTRL);
> +
> +		/*
> +		 * Wait for PLL to lock
> +		 */
> +		while ((timeout > jiffies) && (ret == -ENODEV)) {

This is buggy - it's waiting to go wrong when jiffies wraps.  You really
want to use time_before() or time_after() to make these comparisons, which
are safe against wrap-around.
