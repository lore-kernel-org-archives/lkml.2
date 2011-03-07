Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728Ab1CGFvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 00:51:47 -0500
Received: from mail-gw0-f51.google.com ([74.125.83.51]:40948 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1CGFvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 00:51:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=C/Qs0Z5WDeXvcvfw+D7oveMKol7frg8C2YRjtMyQq3Ww4NidEyskO+/7c6Ki/E0TLr
         SntJZLbgKNs14hxRiGpXDhb2/QtgZmWX2v7WjoO0Q1cPOx5B07BUreVobuDvjKl8Qxfb
         VrqhGpScUytjISIPcBYBV9kRHpnqIjME7cTIo=
Subject: [PATCH 2/2] [ARM] am300epd: fix resource leak in
	am300_init_gpio_regs error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <1299477315.10486.1.camel@mola>
References: <1299477315.10486.1.camel@mola>
Content-Type: text/plain
Date: Mon, 07 Mar 2011 13:56:11 +0800
Message-Id: <1299477371.10486.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If gpio_request fails when i > 0, gpios[0] is not freed in current
implementation.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 arch/arm/mach-pxa/am300epd.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-pxa/am300epd.c b/arch/arm/mach-pxa/am300epd.c
index 993d75e..fa8bad2 100644
--- a/arch/arm/mach-pxa/am300epd.c
+++ b/arch/arm/mach-pxa/am300epd.c
@@ -125,10 +125,7 @@ static int am300_init_gpio_regs(struct broadsheetfb_par *par)
 		if (err) {
 			dev_err(&am300_device->dev, "failed requesting "
 				"gpio %d, err=%d\n", i, err);
-			while (i >= DB0_GPIO_PIN)
-				gpio_free(i--);
-			i = ARRAY_SIZE(gpios) - 1;
-			goto err_req_gpio;
+			goto err_req_gpio2;
 		}
 	}
 
@@ -159,9 +156,13 @@ static int am300_init_gpio_regs(struct broadsheetfb_par *par)
 
 	return 0;
 
+err_req_gpio2:
+	while (--i >= DB0_GPIO_PIN)
+		gpio_free(i);
+	i = ARRAY_SIZE(gpios);
 err_req_gpio:
-	while (i > 0)
-		gpio_free(gpios[i--]);
+	while (--i >= 0)
+		gpio_free(gpios[i]);
 
 	return err;
 }
-- 
1.7.2



