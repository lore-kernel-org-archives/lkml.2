Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab1EGBWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 21:22:19 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51964 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab1EGBWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 21:22:15 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com
Subject: [PATCH 05/11] rtc: m41t80: Initialize clientdata before registering device
Date: Fri,  6 May 2011 18:20:48 -0700
Message-Id: <1304731254-3238-6-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1304731254-3238-1-git-send-email-john.stultz@linaro.org>
References: <1304731254-3238-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f44f7f96a20 ("RTC: Initialize kernel state from RTC") uncovered
an issue in a number of RTC drivers, where the drivers call
rtc_device_register before initializing the clientdata.

This frequently results in null pointer dereferences when the
rtc_device_register immediately makes use of the rtc device, calling
rtc_read_alarm.

The solution is to ensure the clientdata is initialized prior to registering
the rtc device.

CC: Wolfram Sang <w.sang@pengutronix.de>
CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: rtc-linux@googlegroups.com
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/rtc-m41t80.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index 69fe664..eda128f 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -783,6 +783,9 @@ static int m41t80_probe(struct i2c_client *client,
 		goto exit;
 	}
 
+	clientdata->features = id->driver_data;
+	i2c_set_clientdata(client, clientdata);
+
 	rtc = rtc_device_register(client->name, &client->dev,
 				  &m41t80_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
@@ -792,8 +795,6 @@ static int m41t80_probe(struct i2c_client *client,
 	}
 
 	clientdata->rtc = rtc;
-	clientdata->features = id->driver_data;
-	i2c_set_clientdata(client, clientdata);
 
 	/* Make sure HT (Halt Update) bit is cleared */
 	rc = i2c_smbus_read_byte_data(client, M41T80_REG_ALARM_HOUR);
-- 
1.7.3.2.146.gca209

