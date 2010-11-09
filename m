Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab0KIIiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 03:38:07 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39596 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab0KIIiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 03:38:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=v16XXGP4pLYYp3fBcCUGVXtadCqoY9I3fHwrlwcTWjPfTxN7ogx4Gh6HG7rK0c4skf
         Wh6qxwemrJjfa/IluZLPAN3Fmb6Y7VFko4NQEVazdVfwiJ4gOvBICTXgei7sYzXrNYni
         UrKqdXLiPYXikcTGt6NHU0U/F+9NNsKmY5zSo=
Subject: [PATCH v2] hwmon: (gpio-fan) Fix fan_ctrl_init error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Simon Guinot <sguinot@lacie.com>, lm-sensors@lm-sensors.org
Content-Type: text/plain
Date: Tue, 09 Nov 2010 16:41:48 +0800
Message-Id: <1289292108.28671.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current implementation, the sysfs entries is not removed before return -ENODEV.

Creating the sysfs attribute should be the last thing done by the function,
after all the rest has been successful.
Otherwise there is a small window during which user-space can access the attribute
but the driver isn't ready to deal with the requests.

Fix it by moving sysfs_create_group to be the last thing done by the function.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/hwmon/gpio-fan.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index aa701a1..f141a1d 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -376,10 +376,6 @@ static int fan_ctrl_init(struct gpio_fan_data *fan_data,
 		}
 	}
 
-	err = sysfs_create_group(&pdev->dev.kobj, &gpio_fan_ctrl_group);
-	if (err)
-		goto err_free_gpio;
-
 	fan_data->num_ctrl = num_ctrl;
 	fan_data->ctrl = ctrl;
 	fan_data->num_speed = pdata->num_speed;
@@ -391,6 +387,10 @@ static int fan_ctrl_init(struct gpio_fan_data *fan_data,
 		goto err_free_gpio;
 	}
 
+	err = sysfs_create_group(&pdev->dev.kobj, &gpio_fan_ctrl_group);
+	if (err)
+		goto err_free_gpio;
+
 	return 0;
 
 err_free_gpio:
-- 
1.7.2



