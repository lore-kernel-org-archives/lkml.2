Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934034Ab2KBC5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 22:57:23 -0400
Received: from mailserver6.natinst.com ([130.164.80.6]:56904 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694Ab2KBC5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 22:57:19 -0400
Date: Thu, 1 Nov 2012 20:56:47 -0600
From: Josh Cartwright <josh.cartwright@ni.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Linn <John.Linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 8/8] clocksource: xilinx_ttc: add OF_CLK support
Message-ID: <20121102025647.GN5190@beefymiracle.amer.corp.natinst.com>
References: <cover.1351721190.git.josh.cartwright@ni.com>
 <0ea1ba71afb3f4551ac27a6dfa41bd97b63cef48.1351721190.git.josh.cartwright@ni.com>
MIME-Version: 1.0
In-Reply-To: <0ea1ba71afb3f4551ac27a6dfa41bd97b63cef48.1351721190.git.josh.cartwright@ni.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/01/2012 09:56:40 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/01/2012 09:56:40 PM,
	Serialize complete at 11/01/2012 09:56:40 PM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-11-01_07:2012-11-01,2012-11-01,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 01:56:14PM -0600, Josh Cartwright wrote:
> Add support for retrieving TTC configuration from device tree.  This
> includes the ability to pull information about the driving clocks from
> the of_clk bindings.
> 
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> ---
> diff --git a/drivers/clocksource/xilinx_ttc.c b/drivers/clocksource/xilinx_ttc.c
> index ff38b3e..a4718f7 100644
> --- a/drivers/clocksource/xilinx_ttc.c
> +++ b/drivers/clocksource/xilinx_ttc.c
> @@ -209,7 +153,8 @@ static struct clocksource clocksource_xttcpss = {
>  static int xttcpss_set_next_event(unsigned long cycles,
>  					struct clock_event_device *evt)
>  {
> -	struct xttcpss_timer *timer = &timers[XTTCPSS_CLOCKEVENT];
> +	struct xttcpss_timer_clockevent *xttce = to_xttcpss_timer_clkevent(evt);
> +	struct xttcpss_timer *timer = &xttce->xttc;
>  
>  	xttcpss_set_interval(timer, cycles);
>  	return 0;
> @@ -224,12 +169,14 @@ static int xttcpss_set_next_event(unsigned long cycles,
>  static void xttcpss_set_mode(enum clock_event_mode mode,
>  					struct clock_event_device *evt)
>  {
> -	struct xttcpss_timer *timer = &timers[XTTCPSS_CLOCKEVENT];
> +	struct xttcpss_timer_clockevent *xttce = to_xttcpss_timer_clkevent(evt);
> +	struct xttcpss_timer *timer = &xttce->xttc;
>  	u32 ctrl_reg;
>  
>  	switch (mode) {
>  	case CLOCK_EVT_MODE_PERIODIC:
> -		xttcpss_set_interval(timer, TIMER_RATE / HZ);
> +		xttcpss_set_interval(timer,
> +				     clk_get_rate(xttce->clk) / PRESCALE);

I discovered with further testing that the above calculation is broken;
calculated interval also needs to be divided by HZ.

(I'll post a v2; just wanted to get this out there in the slim chance
anyone's testing this ;)

  Josh
