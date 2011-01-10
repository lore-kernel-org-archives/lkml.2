Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab1AJQSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 11:18:15 -0500
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:39605 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193Ab1AJQSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 11:18:12 -0500
Message-ID: <4D2B3131.7040604@ti.com>
Date: Mon, 10 Jan 2011 21:47:53 +0530
From: Anand Gadiyar <gadiyar@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: balbi@ti.com
CC: linux-omap@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Benoit Cousson <b-cousson@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] arm: omap4: pandaboard: turn on PHY reference clock at
 init
References: <1294670535-9059-1-git-send-email-gadiyar@ti.com> <20110110155414.GC5573@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110110155414.GC5573@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/10/2011 9:24 PM, Felipe Balbi wrote:
> Hi,
> 
> On Mon, Jan 10, 2011 at 08:12:15PM +0530, Anand Gadiyar wrote:
>> The SMSC 3320 USB PHY on the OMAP4 Pandaboard needs a 19.2 MHz
>> reference clock. This clock is provided from the OMAP4's fref_clk3
>> pad.
>>
>> Recent changes to clock44xx_data.c made the clock framework aware
>> of the existence of these fref_clk[i] lines. If the option
>> CONFIG_OMAP_RESET_CLOCKS is enabled in the kernel, then the
>> clock framework will turn these clocks off during bootup.
>>
>> Explicitly request and keep this clock enabled at init for the
>> Pandaboard, so that the PHY receives this clock at all times.
>>
>> Reported-by: Ming Lei <tom.leiming@gmail.com>
>> Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
>> Cc: Benoit Cousson <b-cousson@ti.com>
>> Cc: Paul Walmsley <paul@pwsan.com>
>> Cc: Tony Lindgren <tony@atomide.com>
>> ---
>> Tony,
>>
>> The clock database changes were merged just before Christmas, so
>> we did not detect this sooner. Would be nice to get this merged in
>> the -rc series, so that we get EHCI and ethernet functional on the Panda.
>>
>> Ming Lei,
>>
>> Could you please test this and confirm it fixes the issue for you?
>>
>> - Anand
>>
>>  arch/arm/mach-omap2/board-omap4panda.c |   10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> Index: linux-2.6/arch/arm/mach-omap2/board-omap4panda.c
>> ===================================================================
>> --- linux-2.6.orig/arch/arm/mach-omap2/board-omap4panda.c
>> +++ linux-2.6/arch/arm/mach-omap2/board-omap4panda.c
>> @@ -19,6 +19,7 @@
>>  #include <linux/kernel.h>
>>  #include <linux/init.h>
>>  #include <linux/platform_device.h>
>> +#include <linux/clk.h>
>>  #include <linux/io.h>
>>  #include <linux/leds.h>
>>  #include <linux/gpio.h>
>> @@ -95,7 +96,16 @@ static const struct ehci_hcd_omap_platfo
>>  static void __init omap4_ehci_init(void)
>>  {
>>  	int ret;
>> +	struct clk *phy_ref_clk;
>>  
>> +	/* FREF_CLK3 provides the 19.2 MHz reference clock to the PHY */
>> +	phy_ref_clk = clk_get(NULL, "auxclk3_ck");
>> +	if (IS_ERR(phy_ref_clk)) {
>> +		pr_err("Cannot request auxclk3\n");
>> +		goto error1;
>> +	}
>> +	clk_set_rate(phy_ref_clk, 19200000);
>> +	clk_enable(phy_ref_clk);
> 
> shouldn't you be enabling a child of this clock which would be the PHY's
> reference clock ? What about PM, are you keeping this clock on forever ?

This is simply one of 5 reference clock-outs that the OMAP provides to
various components on the PCB. It's a simple divide-down from the OMAP's
own reference system clock, or DPLLs. There are no children for this
clock right now.

Keeping this on forever was intentional. There's no reason to control
this clock dynamically at this point, given the driver doesn't currently
gate other clocks.

We haven't yet come up with a policy for when this clock can be safely
turned off, and that's not what this patch is supposed to do right now.
In this patch, we're only restoring behavior that existed before the
clock data was updated to include this clock.

> Wouldn't it be better to, at least, pass down a function pointer to
> driver so it uses during probe() (to enable clocks) and suspend/resume
> ??

Yes, this would work, but it didn't seem to be useful, given that
only the Panda uses this right now. It's very much board specific.

