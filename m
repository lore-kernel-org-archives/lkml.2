Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab2GWBsq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:48:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54445 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753558Ab2GWBnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:41 -0400
Message-Id: <20120723010657.690025574@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:32 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Beno=C3=AEt=20Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Sascha Hauer <kernel@pengutronix.de>,
        =?ISO-8859-15?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [ 041/108] drivers/rtc/rtc-mxc.c: fix irq enabled interrupts warning
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benoît Thébaudeau <benoit.thebaudeau@advansee.com>

commit b59f6d1febd6cbe9fae4589bf72da0ed32bc69e0 upstream.

Fixes

  WARNING: at irq/handle.c:146 handle_irq_event_percpu+0x19c/0x1b8()
  irq 25 handler mxc_rtc_interrupt+0x0/0xac enabled interrupts
  Modules linked in:
   (unwind_backtrace+0x0/0xf0) from (warn_slowpath_common+0x4c/0x64)
   (warn_slowpath_common+0x4c/0x64) from (warn_slowpath_fmt+0x30/0x40)
   (warn_slowpath_fmt+0x30/0x40) from (handle_irq_event_percpu+0x19c/0x1b8)
   (handle_irq_event_percpu+0x19c/0x1b8) from (handle_irq_event+0x28/0x38)
   (handle_irq_event+0x28/0x38) from (handle_level_irq+0x80/0xc4)
   (handle_level_irq+0x80/0xc4) from (generic_handle_irq+0x24/0x38)
   (generic_handle_irq+0x24/0x38) from (handle_IRQ+0x30/0x84)
   (handle_IRQ+0x30/0x84) from (avic_handle_irq+0x2c/0x4c)
   (avic_handle_irq+0x2c/0x4c) from (__irq_svc+0x40/0x60)
  Exception stack(0xc050bf60 to 0xc050bfa8)
  bf60: 00000001 00000000 003c4208 c0018e20 c050a000 c050a000 c054a4c8 c050a000
  bf80: c05157a8 4117b363 80503bb4 00000000 01000000 c050bfa8 c0018e2c c000e808
  bfa0: 60000013 ffffffff
   (__irq_svc+0x40/0x60) from (default_idle+0x1c/0x30)
   (default_idle+0x1c/0x30) from (cpu_idle+0x68/0xa8)
   (cpu_idle+0x68/0xa8) from (start_kernel+0x22c/0x26c)

Signed-off-by: Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Sascha Hauer <kernel@pengutronix.de>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/rtc/rtc-mxc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/rtc/rtc-mxc.c
+++ b/drivers/rtc/rtc-mxc.c
@@ -191,10 +191,11 @@ static irqreturn_t mxc_rtc_interrupt(int
 	struct platform_device *pdev = dev_id;
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 	void __iomem *ioaddr = pdata->ioaddr;
+	unsigned long flags;
 	u32 status;
 	u32 events = 0;
 
-	spin_lock_irq(&pdata->rtc->irq_lock);
+	spin_lock_irqsave(&pdata->rtc->irq_lock, flags);
 	status = readw(ioaddr + RTC_RTCISR) & readw(ioaddr + RTC_RTCIENR);
 	/* clear interrupt sources */
 	writew(status, ioaddr + RTC_RTCISR);
@@ -217,7 +218,7 @@ static irqreturn_t mxc_rtc_interrupt(int
 		rtc_update_alarm(&pdev->dev, &pdata->g_rtc_alarm);
 
 	rtc_update_irq(pdata->rtc, 1, events);
-	spin_unlock_irq(&pdata->rtc->irq_lock);
+	spin_unlock_irqrestore(&pdata->rtc->irq_lock, flags);
 
 	return IRQ_HANDLED;
 }


