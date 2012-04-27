Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab2D0FBO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 01:01:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58157 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab2D0FBN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 01:01:13 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "lockwood@android.com" <lockwood@android.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 26 Apr 2012 22:01:10 -0700
Subject: [PATCH] timed_output : disable the timed output device when the
 device is unregistered
Thread-Topic: [PATCH] timed_output : disable the timed output device when
 the device is unregistered
Thread-Index: Ac0kMsLysJFRMGApTcaWNiIqNsypMw==
Message-ID: <DD6B9D658496A2488636C8C75B9C0CB601E4E7F1@EXMAIL04.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Life cycle of timed output device driver)

1) register the device as the timed output
2) enable() ops is called via the sysfs
   timeout > 0 : timer is activated and device is turned on
   timeout = 0 : timer is cancelled and device is off
3) unregister the timed output device if not used any more

So the registered device should be disabled explicitly when the module is removed.
('disabled' means the timer is stopped and the device is turned off)

Rather than implementing that code in each driver,
just call enable() with timeout = 0 to clean up the driver.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/staging/android/timed_output.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/android/timed_output.c b/drivers/staging/android/timed_output.c
index f373422..38d930c 100644
--- a/drivers/staging/android/timed_output.c
+++ b/drivers/staging/android/timed_output.c
@@ -99,6 +99,7 @@ EXPORT_SYMBOL_GPL(timed_output_dev_register);
 
 void timed_output_dev_unregister(struct timed_output_dev *tdev)
 {
+	tdev->enable(tdev, 0);
 	device_remove_file(tdev->dev, &dev_attr_enable);
 	device_destroy(timed_output_class, MKDEV(0, tdev->index));
 	dev_set_drvdata(tdev->dev, NULL);
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim


