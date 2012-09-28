Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423054Ab2I1VoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:44:23 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:48962 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032341Ab2I1UZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:25:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Kevin Hilman <khilman@ti.com>, Felipe Balbi <balbi@ti.com>,
        Steve Sakoman <steve@sakoman.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 077/218] drivers/rtc/rtc-twl.c: ensure all interrupts are disabled during probe
Date: Fri, 28 Sep 2012 13:14:54 -0700
Message-Id: <20120928201510.399552147@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-twl.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -495,6 +495,11 @@ static int __devinit twl_rtc_probe(struc
 	if (ret < 0)
 		goto out1;
 
+	/* ensure interrupts are disabled, bootloaders can be strange */
+	ret = twl_rtc_write_u8(0, REG_RTC_INTERRUPTS_REG);
+	if (ret < 0)
+		dev_warn(&pdev->dev, "unable to disable interrupt\n");
+
 	/* init cached IRQ enable bits */
 	ret = twl_rtc_read_u8(&rtc_irq_bits, REG_RTC_INTERRUPTS_REG);
 	if (ret < 0)


