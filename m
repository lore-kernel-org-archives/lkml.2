Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973Ab2GFQeA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 12:34:00 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:48142 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757914Ab2GFQd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 12:33:57 -0400
From: Kevin Hilman <khilman@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/rtc/rtc-twl.c: fix threaded IRQ to use IRQF_ONESHOT
Date: Fri,  6 Jul 2012 09:33:54 -0700
Message-Id: <1341592434-4207-1-git-send-email-khilman@ti.com>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Requesting a threaded interrupt without a primary handler and without
IRQF_ONESHOT is dangerous, and after commit 1c6c6952 (genirq: Reject
bogus threaded irq requests), these requests are rejected.  This
causes ->probe() to fail, and the RTC driver not to be availble.

To fix, add IRQF_ONESHOT to the IRQ flags.

Tested on OMAP3730/OveroSTORM and OMAP4430/Panda board using rtcwake
to wake from system suspend multiple times.

Signed-off-by: Kevin Hilman <khilman@ti.com>
---
Resending to broader audience and including Andrew.  Since, I understand
that drivers/rtc is somewhat orphaned, Andrew, can you queue this fix for
v3.5.  Thanks.

 drivers/rtc/rtc-twl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 258abea..c5d06fe 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -510,7 +510,7 @@ static int __devinit twl_rtc_probe(struct platform_device *pdev)
 	}
 
 	ret = request_threaded_irq(irq, NULL, twl_rtc_interrupt,
-				   IRQF_TRIGGER_RISING,
+				   IRQF_TRIGGER_RISING | IRQF_ONESHOT,
 				   dev_name(&rtc->dev), rtc);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "IRQ is not free.\n");
-- 
1.7.9.2

