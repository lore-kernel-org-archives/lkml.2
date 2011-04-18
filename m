Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab1DRLnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 07:43:31 -0400
Received: from pequod.mess.org ([188.220.58.213]:37775 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab1DRLn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 07:43:26 -0400
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Apr 2011 07:43:26 EDT
Date: Mon, 18 Apr 2011 12:36:40 +0100
From: Sean Young <sean@mess.org>
To: Robin Becker <robin@reportlab.com>
Cc: Nicolas Pitre <nico@fluxnic.net>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: arm: mach-kirkwood: Make the red led available on the eSATA
 SheevaPlug
Message-ID: <20110418113640.GA11559@pequod.mess.org>
References: <20110416220842.GA1518@pequod.mess.org>
 <4DAC0390.9050205@chamonix.reportlab.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DAC0390.9050205@chamonix.reportlab.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 10:25:36AM +0100, Robin Becker wrote:
> On 16/04/2011 23:08, Sean Young wrote:
> >After this patch:
> >
> >         7780c80 arm: mach-kirkwood: add led in sheevaplug-setup.c
> >
> >On a eSATA SheevaPlug, neither the red nor the green led can be controlled,
> >since probing fails with:
> >
> >[    6.188278] leds-gpio: probe of leds-gpio failed with error -22
> >
> >Signed-off-by: Sean Young<sean@mess.org>
> >
> >diff --git a/arch/arm/mach-kirkwood/sheevaplug-setup.c b/arch/arm/mach-kirkwood/sheevaplug-setup.c
> >index 17de0bf..92db979 100644
> >--- a/arch/arm/mach-kirkwood/sheevaplug-setup.c
> >+++ b/arch/arm/mach-kirkwood/sheevaplug-setup.c
> >@@ -94,6 +94,7 @@ static unsigned int sheevaplug_mpp_config[] __initdata = {
> >  static unsigned int sheeva_esata_mpp_config[] __initdata = {
> >  	MPP29_GPIO,	/* USB Power Enable */
> >  	MPP44_GPIO,	/* SD Write Protect */
> >+	MPP46_GPIO,	/* LED Red */
> >  	MPP47_GPIO,	/* SD Card Detect */
> >  	MPP49_GPIO,	/* LED Green */
> >  	0
> >
> 
> I think my original patch had some changes to gpio_led
> sheevaplug_led_pins as well. 

Yes, which causes breakage on my eSATA SheevaPlug without my patch above,
since the corresponding GPIO pins aren't enabled.

> It definitely works on my standard
> sheeva plug. In fact I have three controllable leds at 46, 48 & 49.
> GPIO 45 is also an led, but is also grounded so is permanently on.
> This is something like the patch I am using with plugbox
> 
> diff --git a/arch/arm/mach-kirkwood/sheevaplug-setup.c b/arch/arm/mach-kirkwood/
> index d2eec35..e14893b 100644
> --- a/arch/arm/mach-kirkwood/sheevaplug-setup.c
> +++ b/arch/arm/mach-kirkwood/sheevaplug-setup.c
> @@ -58,7 +58,19 @@
> 
>  static struct gpio_led sheevaplug_led_pins[] = {
>     {
> -       .name           = "plug:green:health",
> +       .name           = "status:red:misc",
> +       .default_trigger    = "none",
> +       .gpio           = 46,
> +       .active_low     = 1,
> +   },
> +   {
> +       .name           = "status:green:health",
> +       .default_trigger    = "none",
> +       .gpio           = 48,
> +       .active_low     = 1,
> +   },
> +   {
> +       .name           = "status:blue:health",
>         .default_trigger    = "default-on",
>         .gpio           = 49,
>         .active_low     = 1,
> @@ -80,7 +92,9 @@
> 
>  static unsigned int sheevaplug_mpp_config[] __initdata = {
>     MPP29_GPIO, /* USB Power Enable */
> -   MPP49_GPIO, /* LED */
> +   MPP46_GPIO, /* LED Red Misc */
> +   MPP48_GPIO, /* LED Green Health */
> +   MPP49_GPIO, /* LED Blue Health */
>     0
>  };
> 

First of all, your mail client has replaced tabs with spaces, causing 
the patch to be garbage.

Again you're not enabling the GPIO pins on the eSATA SheevaPlug for the 
leds you're adding. For the eSATA SheevaPlug sheeva_esata_mpp_config[] 
is used, not sheevaplug_mpp_config[], causing this patch and 
2.6.39-rc? to break on the eSATA SheevaPlug.


Sean
