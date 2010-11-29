Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab0K2PgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:36:20 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36014 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab0K2PgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:36:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PgjK5IE+yvtFU4CMvUv5+Nx7a1iXErKJzGANK6Q9EzkyPdUgLAo1R/IkSjaLQXJRos
         ULsO9weRGkeCtCr/ymASaIoznTuAtM9kvIdY2b3u1TyzUlKPp7MM2JM8zKHiVPgEIABE
         kztnvl/bLiV/wt3qoP3AUE5uWt0psYBvGn8p4=
Subject: [PATCH] backlight: l4f00242t03: Prevent unbalanced calls to
 regulator enable/disable
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Purdie <rpurdie@rpsys.net>, Marek Vasut <marek.vasut@gmail.com>,
        Tejun Heo <tj@kernel.org>, Axel Lin <axel.lin@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1290964433.3016.2.camel@realization>
References: <1290964433.3016.2.camel@realization>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 16:36:11 +0100
Message-ID: <1291044971.3139.61.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise a double call to:
$ echo 4 > /sys/class/lcd/l4f00242t03/lcd_power
Will, the first power down the lcd and regulators correctly and the
second produce an unbalanced call to regulator disable.

Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
---

This patch follow the one this mail is answering.
Thanks for reviewing.

Best regards,
Alberto!

 drivers/video/backlight/l4f00242t03.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
index c04aa90..98ad3e5 100644
--- a/drivers/video/backlight/l4f00242t03.c
+++ b/drivers/video/backlight/l4f00242t03.c
@@ -136,10 +136,12 @@ static int l4f00242t03_lcd_power_set(struct lcd_device *ld, int power)
 		}
 	} else {
 		/* power == FB_BLANK_POWERDOWN */
-		/* Clear the screen before shutting down */
-		spi_write(spi, (const u8 *)&disoff, sizeof(u16));
-		msleep(60);
-		l4f00242t03_lcd_powerdown(spi);
+		if (priv->lcd_state != FB_BLANK_POWERDOWN) {
+			/* Clear the screen before shutting down */
+			spi_write(spi, (const u8 *)&disoff, sizeof(u16));
+			msleep(60);
+			l4f00242t03_lcd_powerdown(spi);
+		}
 	}
 
 	priv->lcd_state = power;
-- 
1.6.3.3



