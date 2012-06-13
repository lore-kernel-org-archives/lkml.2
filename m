Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab2FMLX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:23:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:36018 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2FMLX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:23:58 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-5f-4fd8783d4815
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Dmitry Baryshkov'" <dbaryshkov@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Axel Lin'" <axel.lin@gmail.com>
Subject: [PATCH 4/7] backlight: tosa_bl: use devm_gpio_request()
Date: Wed, 13 Jun 2012 20:23:41 +0900
Message-id: <000501cd4956$fc9daf60$f5d90e20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1JVvyMF9a1cLecQPafP9CojyKfnA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jQV3bihv+Bo+PWFtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M9/O2sRRM5qk4fb2DvYGxk6uLkZNDQsBE4uDBjYwQtpjEhXvr
	2UBsIYHpjBILdup1MXIB2bOZJH4c7mcBSbAJqEl8+XKYHcQWEYiQaJ4xixmkiFlgDqPEmtcL
	wIqEBRwk+nZNZwaxWQRUJRYtv8oKYvMK2EpMP/GLGcIWlPgx+R5YPbOAlsT6nceZIGx5ic1r
	3gLVcABdpC7x6K8uxC49iWVLPzNClIhI7HvxjnECo8AsJJNmIZk0C8mkWUhaFjCyrGIUTS1I
	LihOSs810itOzC0uzUvXS87P3cQIDsxn0jsYVzVYHGIU4GBU4uHlKL3hL8SaWFZcmXuIUYKD
	WUmE91k2UIg3JbGyKrUoP76oNCe1+BCjNAeLkjhvk/UFfyGB9MSS1OzU1ILUIpgsEwenVANj
	7I7mbRX7XPW/z4yR+/FaWcmr8uGLPRoevloFzS+DpwRKbJ569mNdYlfn/BvXvkl/XPr2gtxP
	7s06YTnHL7zjOqjLnuye/ba7zilVrOl56ceP15SsZTanXngowZYZ8v37Y4mOrTZlL0yW1DVE
	ntpqbK/ytmBqxoyejJjj/j9L72Wqlm4NrJNSYinOSDTUYi4qTgQAy+6glUgCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_ functions allocate memory that is released when a driver
detaches. This patch uses devm_gpio_request of these functions.

Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/tosa_bl.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/video/backlight/tosa_bl.c b/drivers/video/backlight/tosa_bl.c
index 0d54e60..49342e1 100644
--- a/drivers/video/backlight/tosa_bl.c
+++ b/drivers/video/backlight/tosa_bl.c
@@ -92,14 +92,14 @@ static int __devinit tosa_bl_probe(struct i2c_client *client,
 
 	data->comadj = sharpsl_param.comadj == -1 ? COMADJ_DEFAULT : sharpsl_param.comadj;
 
-	ret = gpio_request(TOSA_GPIO_BL_C20MA, "backlight");
+	ret = devm_gpio_request(&client->dev, TOSA_GPIO_BL_C20MA, "backlight");
 	if (ret) {
 		dev_dbg(&data->bl->dev, "Unable to request gpio!\n");
 		return ret;
 	}
 	ret = gpio_direction_output(TOSA_GPIO_BL_C20MA, 0);
 	if (ret)
-		goto err_gpio_dir;
+		return ret;
 
 	i2c_set_clientdata(client, data);
 	data->i2c = client;
@@ -123,8 +123,6 @@ static int __devinit tosa_bl_probe(struct i2c_client *client,
 
 err_reg:
 	data->bl = NULL;
-err_gpio_dir:
-	gpio_free(TOSA_GPIO_BL_C20MA);
 	return ret;
 }
 
@@ -135,8 +133,6 @@ static int __devexit tosa_bl_remove(struct i2c_client *client)
 	backlight_device_unregister(data->bl);
 	data->bl = NULL;
 
-	gpio_free(TOSA_GPIO_BL_C20MA);
-
 	return 0;
 }
 
-- 
1.7.1


