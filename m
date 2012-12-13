Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab2LMCFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 21:05:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:59521 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359Ab2LMCFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 21:05:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,269,1355126400"; 
   d="scan'208";a="261429955"
From: Feng Tang <feng.tang@intel.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org
Cc: alek.du@intel.com, Feng Tang <feng.tang@intel.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH 2/3] rtc: Skip the suspend/resume handling if persistent clock exist
Date: Thu, 13 Dec 2012 10:05:27 +0800
Message-Id: <1355364328-19550-2-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355364328-19550-1-git-send-email-feng.tang@intel.com>
References: <1355364328-19550-1-git-send-email-feng.tang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the RTC suspend and resume functions are to compensate the
sleep time, but this is already done in timekeeping.c if persistent
clock exist.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 drivers/rtc/class.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index f8a0aab..bf4c6d3 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -50,6 +50,10 @@ static int rtc_suspend(struct device *dev, pm_message_t mesg)
 	struct rtc_device	*rtc = to_rtc_device(dev);
 	struct rtc_time		tm;
 	struct timespec		delta, delta_delta;
+
+	if (persistent_clock_exist)
+		return 0;
+
 	if (strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) != 0)
 		return 0;
 
@@ -88,6 +92,9 @@ static int rtc_resume(struct device *dev)
 	struct timespec		new_system, new_rtc;
 	struct timespec		sleep_time;
 
+	if (persistent_clock_exist)
+		return 0;
+
 	rtc_hctosys_ret = -ENODEV;
 	if (strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) != 0)
 		return 0;
-- 
1.7.9.5

