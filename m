Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab1AJPyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 10:54:21 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:48093 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751931Ab1AJPyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 10:54:19 -0500
Date: Mon, 10 Jan 2011 17:54:14 +0200
From: Felipe Balbi <balbi@ti.com>
To: Anand Gadiyar <gadiyar@ti.com>
Cc: linux-omap@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        Felipe Balbi <balbi@ti.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Benoit Cousson <b-cousson@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] arm: omap4: pandaboard: turn on PHY reference clock at
 init
Message-ID: <20110110155414.GC5573@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1294670535-9059-1-git-send-email-gadiyar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294670535-9059-1-git-send-email-gadiyar@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jan 10, 2011 at 08:12:15PM +0530, Anand Gadiyar wrote:
> The SMSC 3320 USB PHY on the OMAP4 Pandaboard needs a 19.2 MHz
> reference clock. This clock is provided from the OMAP4's fref_clk3
> pad.
> 
> Recent changes to clock44xx_data.c made the clock framework aware
> of the existence of these fref_clk[i] lines. If the option
> CONFIG_OMAP_RESET_CLOCKS is enabled in the kernel, then the
> clock framework will turn these clocks off during bootup.
> 
> Explicitly request and keep this clock enabled at init for the
> Pandaboard, so that the PHY receives this clock at all times.
> 
> Reported-by: Ming Lei <tom.leiming@gmail.com>
> Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
> Cc: Benoit Cousson <b-cousson@ti.com>
> Cc: Paul Walmsley <paul@pwsan.com>
> Cc: Tony Lindgren <tony@atomide.com>
> ---
> Tony,
> 
> The clock database changes were merged just before Christmas, so
> we did not detect this sooner. Would be nice to get this merged in
> the -rc series, so that we get EHCI and ethernet functional on the Panda.
> 
> Ming Lei,
> 
> Could you please test this and confirm it fixes the issue for you?
> 
> - Anand
> 
>  arch/arm/mach-omap2/board-omap4panda.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> Index: linux-2.6/arch/arm/mach-omap2/board-omap4panda.c
> ===================================================================
> --- linux-2.6.orig/arch/arm/mach-omap2/board-omap4panda.c
> +++ linux-2.6/arch/arm/mach-omap2/board-omap4panda.c
> @@ -19,6 +19,7 @@
>  #include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/platform_device.h>
> +#include <linux/clk.h>
>  #include <linux/io.h>
>  #include <linux/leds.h>
>  #include <linux/gpio.h>
> @@ -95,7 +96,16 @@ static const struct ehci_hcd_omap_platfo
>  static void __init omap4_ehci_init(void)
>  {
>  	int ret;
> +	struct clk *phy_ref_clk;
>  
> +	/* FREF_CLK3 provides the 19.2 MHz reference clock to the PHY */
> +	phy_ref_clk = clk_get(NULL, "auxclk3_ck");
> +	if (IS_ERR(phy_ref_clk)) {
> +		pr_err("Cannot request auxclk3\n");
> +		goto error1;
> +	}
> +	clk_set_rate(phy_ref_clk, 19200000);
> +	clk_enable(phy_ref_clk);

shouldn't you be enabling a child of this clock which would be the PHY's
reference clock ? What about PM, are you keeping this clock on forever ?
Wouldn't it be better to, at least, pass down a function pointer to
driver so it uses during probe() (to enable clocks) and suspend/resume
??

-- 
balbi
