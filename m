Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab0LIWE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 17:04:58 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:54133 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757185Ab0LIWE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 17:04:57 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1956fFBUqV53S/9Rw8RyodYUL2sFWLsduDl+FkYJ/
	wjNPiS3/gERAb1
From: Peter Huewe <peterhuewe@gmx.de>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Vasily Khoruzhick <anarsoul@gmail.com>,
        Vincent Sanders <support@simtec.co.uk>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] leds/h1940: Use gpiolib for latch access / fix build failure
Date: Thu,  9 Dec 2010 23:04:52 +0100
Message-Id: <1291932292-16049-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.2.2
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a build failure by converting leds-h1940.c to use
gpiolib for latch access introduced by 14477095abc6
(ARM: h1940: Use gpiolib for latch access)

Unfortunately this driver was not converted back then.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
KernelVersion: linux-next-20101209

Build failure:
  CC [M]  drivers/leds/leds-h1940.o
  drivers/leds/leds-h1940.c: In function 'h1940_greenled_set':
  drivers/leds/leds-h1940.c:33: error: implicit declaration of function 'h1940_latch_control'
  make[2]: *** [drivers/leds/leds-h1940

 drivers/leds/leds-h1940.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/leds/leds-h1940.c b/drivers/leds/leds-h1940.c
index 173d104..7811701 100644
--- a/drivers/leds/leds-h1940.c
+++ b/drivers/leds/leds-h1940.c
@@ -30,17 +30,17 @@ static void h1940_greenled_set(struct led_classdev *led_dev,
 {
 	switch (value) {
 	case LED_HALF:
-		h1940_latch_control(0, H1940_LATCH_LED_FLASH);
+		gpio_set_value(H1940_LATCH_LED_FLASH, 1);
 		s3c2410_gpio_setpin(S3C2410_GPA7, 1);
 		break;
 	case LED_FULL:
-		h1940_latch_control(0, H1940_LATCH_LED_GREEN);
+		gpio_set_value(H1940_LATCH_LED_GREEN, 1);
 		s3c2410_gpio_setpin(S3C2410_GPA7, 1);
 		break;
 	default:
 	case LED_OFF:
-		h1940_latch_control(H1940_LATCH_LED_FLASH, 0);
-		h1940_latch_control(H1940_LATCH_LED_GREEN, 0);
+		gpio_set_value(H1940_LATCH_LED_FLASH, 0);
+		gpio_set_value(H1940_LATCH_LED_GREEN, 0);
 		s3c2410_gpio_setpin(S3C2410_GPA7, 0);
 		break;
 	}
@@ -60,17 +60,17 @@ static void h1940_redled_set(struct led_classdev *led_dev,
 {
 	switch (value) {
 	case LED_HALF:
-		h1940_latch_control(0, H1940_LATCH_LED_FLASH);
+		gpio_set_value(H1940_LATCH_LED_FLASH, 1);
 		s3c2410_gpio_setpin(S3C2410_GPA1, 1);
 		break;
 	case LED_FULL:
-		h1940_latch_control(0, H1940_LATCH_LED_RED);
+		gpio_set_value(H1940_LATCH_LED_RED, 1);
 		s3c2410_gpio_setpin(S3C2410_GPA1, 1);
 		break;
 	default:
 	case LED_OFF:
-		h1940_latch_control(H1940_LATCH_LED_FLASH, 0);
-		h1940_latch_control(H1940_LATCH_LED_RED, 0);
+		gpio_set_value(H1940_LATCH_LED_FLASH, 0);
+		gpio_set_value(H1940_LATCH_LED_RED, 0);
 		s3c2410_gpio_setpin(S3C2410_GPA1, 0);
 		break;
 	}
@@ -91,10 +91,10 @@ static void h1940_blueled_set(struct led_classdev *led_dev,
 {
 	if (value) {
 		/* flashing Blue */
-		h1940_latch_control(0, H1940_LATCH_LED_FLASH);
+		gpio_set_value(H1940_LATCH_LED_FLASH, 1);
 		s3c2410_gpio_setpin(S3C2410_GPA3, 1);
 	} else {
-		h1940_latch_control(H1940_LATCH_LED_FLASH, 0);
+		gpio_set_value(H1940_LATCH_LED_FLASH, 0);
 		s3c2410_gpio_setpin(S3C2410_GPA3, 0);
 	}
 
-- 
1.7.2.2

