Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab1C2GdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 02:33:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42041 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab1C2GdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 02:33:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=n1zJ3vCGqMaxuUZ8hmvAiZ7k+OdqZEsZN0GWxYVpGE3V4O42sWComOAMcGmjOFMBPp
         DVuQFTaS0NvhWbDydTyMidyLyAz84ude09Y0BUQGTOhw1bpi8w4w71i2S9YMoM8QAwyP
         +Ludqr0WpYWJOEmGFzTt7FyVB7f/qSq5Q6D3g=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: ben-linux@fluff.org
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, rpurdie@rpsys.net, esta1ien@gmail.com,
        buserror@gmail.com, Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 4/4] s3c2440: mini2440: Enable the backlight LED earlier at boot time.
Date: Tue, 29 Mar 2011 08:32:43 +0200
Message-Id: <1301380363-3282-5-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301380363-3282-1-git-send-email-marek.belisko@open-nandra.com>
References: <1301380363-3282-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code overtaken from:
http://repo.or.cz/w/linux-2.6/mini2440.git

Use flag that allows s3c24xx LED to start in the "on" state.
This is necesary to enable LCD backlight during early boot stage.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
Signed-off-by: Michel Pollet <buserror@gmail.com>
---
 arch/arm/mach-s3c2410/include/mach/leds-gpio.h |    1 +
 arch/arm/mach-s3c2440/mach-mini2440.c          |    1 +
 drivers/leds/leds-s3c24xx.c                    |    6 +++++-
 3 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-s3c2410/include/mach/leds-gpio.h b/arch/arm/mach-s3c2410/include/mach/leds-gpio.h
index d8a7672..c3ae81f 100644
--- a/arch/arm/mach-s3c2410/include/mach/leds-gpio.h
+++ b/arch/arm/mach-s3c2410/include/mach/leds-gpio.h
@@ -16,6 +16,7 @@
 
 #define S3C24XX_LEDF_ACTLOW	(1<<0)		/* LED is on when GPIO low */
 #define S3C24XX_LEDF_TRISTATE	(1<<1)		/* tristate to turn off */
+#define S3C24XX_LEDF_STARTON    (1<<2)          /* Initialise 'on' */
 
 struct s3c24xx_led_platdata {
 	unsigned int		 gpio;
diff --git a/arch/arm/mach-s3c2440/mach-mini2440.c b/arch/arm/mach-s3c2440/mach-mini2440.c
index 163d318..46f2034 100644
--- a/arch/arm/mach-s3c2440/mach-mini2440.c
+++ b/arch/arm/mach-s3c2440/mach-mini2440.c
@@ -451,6 +451,7 @@ static struct s3c24xx_led_platdata mini2440_led4_pdata = {
 static struct s3c24xx_led_platdata mini2440_led_backlight_pdata = {
 	.name		= "backlight",
 	.gpio		= S3C2410_GPG(4),
+	.flags		= S3C24XX_LEDF_STARTON,
 	.def_trigger	= "backlight",
 };
 
diff --git a/drivers/leds/leds-s3c24xx.c b/drivers/leds/leds-s3c24xx.c
index a77771d..42d0a08 100644
--- a/drivers/leds/leds-s3c24xx.c
+++ b/drivers/leds/leds-s3c24xx.c
@@ -95,7 +95,11 @@ static int s3c24xx_led_probe(struct platform_device *dev)
 		s3c2410_gpio_cfgpin(pdata->gpio, S3C2410_GPIO_INPUT);
 	} else {
 		s3c2410_gpio_pullup(pdata->gpio, 0);
-		s3c2410_gpio_setpin(pdata->gpio, 0);
+
+		if (pdata->flags & S3C24XX_LEDF_STARTON)
+			s3c2410_gpio_setpin(pdata->gpio, 1);
+		else
+			s3c2410_gpio_setpin(pdata->gpio, 0);
 		s3c2410_gpio_cfgpin(pdata->gpio, S3C2410_GPIO_OUTPUT);
 	}
 
-- 
1.7.1

