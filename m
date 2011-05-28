Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab1E1Rrl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 13:47:41 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50714 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab1E1Rrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 13:47:39 -0400
Date: Sat, 28 May 2011 19:47:33 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>, kernel@pengutronix.de
Subject: Re: [PATCH] leds: make LEDS_GPIO_REGISTER depend on NEW_LEDS
Message-ID: <20110528174733.GF9907@pengutronix.de>
References: <1306576376.10669.12.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1306576376.10669.12.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Axel,

On Sat, May 28, 2011 at 05:52:56PM +0800, Axel Lin wrote:
> Commit 4440673a "leds: provide helper to register "leds-gpio" devices"
> adds "config LEDS_GPIO_REGISTER" in drivers/leds/Kconfig.
> However, config LEDS_GPIO_REGISTER does not depend on NEW_LEDS, while executing
> make menuconfig a side-effect is observed that the "LED drivers" and
> "LED Triggers" are now displayed at the same level of "LED Support".
> ( They was in sub-menu of "LED Support" before the commit. )
OK, this was unintended.
 
> This patch makes LEDS_GPIO_REGISTER depend on NEW_LEDS to correctly show
> "LED drivers" and "LED Triggers" in sub-menu of "LED Support".
This is wrong, LEDS_GPIO_REGISTER has to be available even when
NEW_LEDS=n.
 
> Besides, LEDS_GPIO_REGISTER is set to be bool but no description.  Thus I
> cannot find LEDS_GPIO_REGISTER config option while executing make menuconfig.
And it's not supposed to be user-selectable because it only provides a
function used by arch code. And if nothing uses this function enabling
doesn't make sense. OTOH if arch code uses the function disabling
doesn't make sense as it would result in a build failure, so arch code
needs to select LEDS_GPIO_REGISTER and it doesn't need to be visible.
 
Below is a patch that fixes the layout problem but keeps the
functionality as before and intended.

-----8<-----
leds: move LEDS_GPIO_REGISTER out of menuconfig NEW_LEDS

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Commit 4440673a "leds: provide helper to register "leds-gpio" devices"
broke the display of the NEW_LEDS menu as it didn't depend on NEW_LEDS
and so made "LED drivers" and "LED Triggers" appear at the same level as
"LED Support" instead of below it as it was before 4440673a.

Moving LEDS_GPIO_REGISTER out of the menuconfig NEW_LEDS fixes this
unintended side effect.

Reported-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/leds/Kconfig |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 23f0d5e..12ca135 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -1,3 +1,10 @@
+config LEDS_GPIO_REGISTER
+	bool
+	help
+	  This option provides the function gpio_led_register_device.
+	  As this function is used by arch code it must not be compiled as a
+	  module.
+
 menuconfig NEW_LEDS
 	bool "LED Support"
 	help
@@ -14,13 +21,6 @@ config LEDS_CLASS
 	  This option enables the led sysfs class in /sys/class/leds.  You'll
 	  need this to do anything useful with LEDs.  If unsure, say N.
 
-config LEDS_GPIO_REGISTER
-	bool
-	help
-	  This option provides the function gpio_led_register_device.
-	  As this function is used by arch code it must not be compiled as a
-	  module.
-
 if NEW_LEDS
 
 comment "LED drivers"
-- 
1.7.2.5



-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
