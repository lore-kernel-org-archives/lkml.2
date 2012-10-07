Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab2JGXoz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:44:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38200 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753134Ab2JGXWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:09 -0400
Message-Id: <20121007225835.561507311@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:58:40 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kevin Hilman <khilman@ti.com>, Felipe Balbi <balbi@ti.com>,
        Steve Sakoman <steve@sakoman.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 006/108] drivers/rtc/rtc-twl.c: ensure all interrupts are disabled during
 probe
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Hilman <khilman@ti.com>

commit 8dcebaa9a0ae8a0487f4342f3d56d2cb1c980860 upstream.

On some platforms, bootloaders are known to do some interesting RTC
programming.  Without going into the obscurities as to why this may be
the case, suffice it to say the the driver should not make any
assumptions about the state of the RTC when the driver loads.  In
particular, the driver probe should be sure that all interrupts are
disabled until otherwise programmed.

This was discovered when finding bursty I2C traffic every second on
Overo platforms.  This I2C overhead was keeping the SoC from hitting
deep power states.  The cause was found to be the RTC firing every
second on the I2C-connected TWL PMIC.

Special thanks to Felipe Balbi for suggesting to look for a rogue driver
as the source of the I2C traffic rather than the I2C driver itself.

Special thanks to Steve Sakoman for helping track down the source of the
continuous RTC interrups on the Overo boards.

Signed-off-by: Kevin Hilman <khilman@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Tested-by: Steve Sakoman <steve@sakoman.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Tested-by: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/rtc/rtc-twl.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -462,6 +462,11 @@ static int __devinit twl_rtc_probe(struc
 			goto out1;
 	}
 
+	/* ensure interrupts are disabled, bootloaders can be strange */
+	ret = twl_rtc_write_u8(0, REG_RTC_INTERRUPTS_REG);
+	if (ret < 0)
+		dev_warn(&pdev->dev, "unable to disable interrupt\n");
+
 	/* init cached IRQ enable bits */
 	ret = twl_rtc_read_u8(&rtc_irq_bits, REG_RTC_INTERRUPTS_REG);
 	if (ret < 0)


