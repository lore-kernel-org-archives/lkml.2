Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab1DGBfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 21:35:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:58064 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757052Ab1DGBfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 21:35:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,313,1299484800"; 
   d="scan'208";a="906535541"
From: Feng Tang <feng.tang@intel.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, alan@linux.intel.com
Cc: Feng Tang <feng.tang@intel.com>, Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 1/2] rtc: rtc-mrst: follow on to the change of rtc_device_register()
Date: Thu,  7 Apr 2011 09:39:44 +0800
Message-Id: <1302140384-27571-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit f44f7f96a20 (RTC: Initialize kernel state from RTC) will
call rtc_read_alarm() inside rtc_device_register(), so rtc-mrst
driver need to call dev_set_drvdata() before rtc_device_register()
get called.

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 drivers/rtc/rtc-mrst.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-mrst.c b/drivers/rtc/rtc-mrst.c
index 332a2c4..b2f0968 100644
--- a/drivers/rtc/rtc-mrst.c
+++ b/drivers/rtc/rtc-mrst.c
@@ -342,6 +342,8 @@ vrtc_mrst_do_probe(struct device *dev, struct resource *iomem, int rtc_irq)
 
 	mrst_rtc.irq = rtc_irq;
 	mrst_rtc.iomem = iomem;
+	mrst_rtc.dev = dev;
+	dev_set_drvdata(dev, &mrst_rtc);
 
 	mrst_rtc.rtc = rtc_device_register(driver_name, dev,
 				&mrst_rtc_ops, THIS_MODULE);
@@ -350,8 +352,6 @@ vrtc_mrst_do_probe(struct device *dev, struct resource *iomem, int rtc_irq)
 		goto cleanup0;
 	}
 
-	mrst_rtc.dev = dev;
-	dev_set_drvdata(dev, &mrst_rtc);
 	rename_region(iomem, dev_name(&mrst_rtc.rtc->dev));
 
 	spin_lock_irq(&rtc_lock);
@@ -376,9 +376,10 @@ vrtc_mrst_do_probe(struct device *dev, struct resource *iomem, int rtc_irq)
 	return 0;
 
 cleanup1:
-	mrst_rtc.dev = NULL;
 	rtc_device_unregister(mrst_rtc.rtc);
 cleanup0:
+	dev_set_drvdata(dev, NULL);
+	mrst_rtc.dev = NULL;
 	release_region(iomem->start, iomem->end + 1 - iomem->start);
 	dev_err(dev, "rtc-mrst: unable to initialise\n");
 	return retval;
-- 
1.7.0.4

