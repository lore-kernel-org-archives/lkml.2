Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab1AFSVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:21:14 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:49086 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752204Ab1AFSVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:21:12 -0500
Message-ID: <4D260812.3010605@ti.com>
Date: Thu, 06 Jan 2011 12:21:06 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Kevin Hilman <khilman@ti.com>
CC: Koen Kooi <koen@dominion.thruhere.net>, Brad Parker <brad@heeltoe.com>,
        Anand Gadiyar <gadiyar@ti.com>, Ming Lei <tom.leiming@gmail.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Paul Walmsley <paul@pwsan.com>, Greg KH <greg@kroah.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org
Subject: Re: linux-next: manual merge of the usb tree with the omap tree
References: <20101223171859.f6842045.sfr@canb.auug.org.au>	<4D139517.3010608@ti.com>	<AANLkTi=pTNg2iWN+=uEv=CyZHHCoddF51pmmCMjPeMUF@mail.gmail.com>	<4ce0f816f951f24ca3de9c84d9f70842@mail.gmail.com>	<4D25E313.4060202@heeltoe.com>	<8B3471BB-CB3F-4CE6-B523-D9C5E87B9CEC@dominion.thruhere.net> <87pqs9vqya.fsf@ti.com>
In-Reply-To: <87pqs9vqya.fsf@ti.com>
Content-Type: multipart/mixed;
 boundary="------------070407080708020700080200"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070407080708020700080200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Kevin Hilman had written, on 01/06/2011 12:15 PM, the following:
> Koen Kooi <koen@dominion.thruhere.net> writes:
> 
>> Op 6 jan 2011, om 16:43 heeft Brad Parker het volgende geschreven:
>>
>>> It's probably expected, but I can't get the EHCI USB port  to work
>>> on a beagle board XM (36xx) using the current omap tree.
>>>
>>> It this most likely due to these clock issues?
>> You need this patch: http://thread.gmane.org/gmane.linux.ports.arm.omap/47807/
>>
>> I'm currently too lazy to split it up like Nishant wants as I don't
>> see the point splitting for the sake of splitting.--
> 
> IMO, it doesn't need to be split up.
> 
> But it does have to fix the other comments I made on the same thread[1]
> 
> 1) add a descriptive changelog, and
> 2) Cc linux-arm-kernel

Kevin,
there are four things being done in the patch:
a) fix GPIO number for EHCI power on
b) fix GPIO number for DVI reset line
c) switch on DVI
d) switch on Camera

I have split the first 2 up. I just splitting the (c) up when I noticed 
the code is confusing - I will reply in thread to the original patch.

I apologize, but I disagree - as far as I see it, these are separate 
changes being done.

-- 
Regards,
Nishanth Menon

--------------070407080708020700080200
Content-Type: text/x-patch;
 name="0001-omap3-beaglexm-fix-EHCI-power-up-GPIO-dir.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-omap3-beaglexm-fix-EHCI-power-up-GPIO-dir.patch"

>From c03fd107da409806ec15d508db6c7c352244a1f4 Mon Sep 17 00:00:00 2001
From: Koen Kooi <koen@beagleboard.org>
Date: Thu, 6 Jan 2011 12:08:15 -0600
Subject: [PATCH 1/2] omap3: beaglexm: fix EHCI power up GPIO dir

EHCI enable power pin is inverted (active high) in comparison
to vanilla beagle which is active low. Handle this case conditionally.

[nm@ti.com: helped split up]
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Koen Kooi <koen@beagleboard.org>
---
 arch/arm/mach-omap2/board-omap3beagle.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index 6c12760..1b5aa7a 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -297,9 +297,16 @@ static int beagle_twl_gpio_setup(struct device *dev,
 	gpio_request(gpio + 1, "EHCI_nOC");
 	gpio_direction_input(gpio + 1);
 
-	/* TWL4030_GPIO_MAX + 0 == ledA, EHCI nEN_USB_PWR (out, active low) */
+	/*
+	 * TWL4030_GPIO_MAX + 0 == ledA, EHCI nEN_USB_PWR (out, XM active
+	 * high / others active low)
+	 */
 	gpio_request(gpio + TWL4030_GPIO_MAX, "nEN_USB_PWR");
 	gpio_direction_output(gpio + TWL4030_GPIO_MAX, 0);
+	if (omap3_beagle_get_rev() == OMAP3BEAGLE_BOARD_XM)
+		gpio_direction_output(gpio + TWL4030_GPIO_MAX, 1);
+	else
+		gpio_direction_output(gpio + TWL4030_GPIO_MAX, 0);
 
 	/* TWL4030_GPIO_MAX + 1 == ledB, PMU_STAT (out, active low LED) */
 	gpio_leds[2].gpio = gpio + TWL4030_GPIO_MAX + 1;
-- 
1.6.3.3


--------------070407080708020700080200
Content-Type: text/x-patch;
 name="0002-omap3-beaglexm-fix-DVI-reset-GPIO.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0002-omap3-beaglexm-fix-DVI-reset-GPIO.patch"

>From d34971b71d61f3fc20e724a48dbdfe347aa53802 Mon Sep 17 00:00:00 2001
From: Koen Kooi <koen@beagleboard.org>
Date: Thu, 6 Jan 2011 12:14:00 -0600
Subject: [PATCH 2/2] omap3: beaglexm: fix DVI reset GPIO

GPIO reset line for Beagle XM is different from vanilla beagle
so we populate it as part of gpio update routine.

Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Koen Kooi <koen@beagleboard.org>
---
 arch/arm/mach-omap2/board-omap3beagle.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index 1b5aa7a..d628f5e 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -199,7 +199,7 @@ static struct omap_dss_device beagle_dvi_device = {
 	.name = "dvi",
 	.driver_name = "generic_panel",
 	.phy.dpi.data_lines = 24,
-	.reset_gpio = 170,
+	.reset_gpio = -EINVAL,
 	.platform_enable = beagle_enable_dvi,
 	.platform_disable = beagle_disable_dvi,
 };
@@ -308,6 +308,12 @@ static int beagle_twl_gpio_setup(struct device *dev,
 	else
 		gpio_direction_output(gpio + TWL4030_GPIO_MAX, 0);
 
+	/* DVI reset GPIO is different between beagle revisions */
+	if (omap3_beagle_get_rev() == OMAP3BEAGLE_BOARD_XM)
+		beagle_dvi_device.reset_gpio = 129;
+	else
+		beagle_dvi_device.reset_gpio = 170;
+
 	/* TWL4030_GPIO_MAX + 1 == ledB, PMU_STAT (out, active low LED) */
 	gpio_leds[2].gpio = gpio + TWL4030_GPIO_MAX + 1;
 
-- 
1.6.3.3


--------------070407080708020700080200--
