Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab0EQFlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 01:41:47 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:62310 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab0EQFlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 01:41:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=sdkuFCSPfh3ySe9MN21phD/gVspfnHb2ABpBsCB5LlK65uNNVHp2g7iM3+hyRqmc63
         4mD6fl9WsqM6GDAIxIH01vnzRGlmKf+NLn9416TjlCRhMFEMuqptbHIl2vRN/JIDOcqZ
         x7fGMxKm7TPtEsEYhdmKX6ac2+MZqZHjwHfUc=
Subject: [PATCH] leds-ss4200: fix led_classdev_unregister twice in error
	handling
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Rodney Girod <rgirod@confocus.com>, Dave Hansen <dave@sr71.net>,
       Richard Purdie <rpurdie@linux.intel.com>
Content-Type: text/plain
Date: Mon, 17 May 2010 13:42:43 +0800
Message-Id: <1274074963.25630.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current implementation, if device_create_file failed in register_nasgpio_led,
led_classdev_unregister will be executed twice.
( in register_nasgpio_led it calls led_classdev_unregister before return and in nas_gpio_init out_err )

This patch fixes it by only unregistering those that were successfully registered in out_err.
( not including last failed register_nasgpio_led call )

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/leds-ss4200.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-ss4200.c b/drivers/leds/leds-ss4200.c
index 51477ec..a688293 100644
--- a/drivers/leds/leds-ss4200.c
+++ b/drivers/leds/leds-ss4200.c
@@ -534,7 +534,7 @@ static int __init nas_gpio_init(void)
 	set_power_light_amber_noblink();
 	return 0;
 out_err:
-	for (; i >= 0; i--)
+	for (i--; i >= 0; i--)
 		unregister_nasgpio_led(i);
 	pci_unregister_driver(&nas_gpio_pci_driver);
 	return ret;
-- 
1.5.4.3



