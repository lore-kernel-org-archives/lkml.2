Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab2EYCaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 22:30:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:9268 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab2EYCaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 22:30:14 -0400
X-AuditID: cbfee61b-b7faf6d000001f49-a6-4fbeeeb4afe3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Eric Miao'" <eric.y.miao@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 11/13] backlight: tdo24m: use devm_ functions
Date: Fri, 25 May 2012 11:30:12 +0900
Message-id: <001601cd3a1e$4f9754c0$eec5fe40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac06Hk+CcWddkrSBSTOxRuZeIJDNDw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jQd0t7/b5Gyz+r2BxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyOppnMRfsEKyY1nqOsYFxMV8XIyeHhICJxOFt81ghbDGJC/fW
	s3UxcnEICUxnlFh15w8ThDObSeLHktVgVWwCahJfvhxmB7FFBCIkmmfMYgaxmQWKJR62tDCC
	2MICthLrd09kAbFZBFQlVr9bDlTPwcELFD9wD2wMr4CgxI/J91ggWrUkNm9rYoWw5SU2r3nL
	DFIuIaAu8eivLsQmPYkXu7ugNolI7HvxjnECo8AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihO
	Ss810itOzC0uzUvXS87P3cQIDstn0jsYVzVYHGIU4GBU4uENeLPPX4g1say4MvcQowQHs5II
	r2AkUIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvkyU7/IUE0hNLUrNTUwtSi2CyTBycUg2MKgl7
	L0rqBDI1X3YQPMSg8NmjVoGvsuhwaWvfzKTifvM7jr9WcnA7LMtcLRCUPGfP9Ba9nedUbflu
	+T+rzm3z+fTv0cN7z17abVy65cI+vSf2vb738o/n3a7a/NBS63DtS9vm1AwtPh2md0JZlqse
	P3QL0HeN7Huy+U6+9rSjdSc26/2oUNyvxFKckWioxVxUnAgACiBUAEcCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_ functions allocate memory that is released when a driver
detaches. This patch uses devm_kzalloc of these functions.

Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/tdo24m.c |   21 ++++++---------------
 1 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/video/backlight/tdo24m.c b/drivers/video/backlight/tdo24m.c
index 2368b8e..02444d0 100644
--- a/drivers/video/backlight/tdo24m.c
+++ b/drivers/video/backlight/tdo24m.c
@@ -349,7 +349,7 @@ static int __devinit tdo24m_probe(struct spi_device *spi)
 	if (err)
 		return err;
 
-	lcd = kzalloc(sizeof(struct tdo24m), GFP_KERNEL);
+	lcd = devm_kzalloc(&spi->dev, sizeof(struct tdo24m), GFP_KERNEL);
 	if (!lcd)
 		return -ENOMEM;
 
@@ -357,11 +357,9 @@ static int __devinit tdo24m_probe(struct spi_device *spi)
 	lcd->power = FB_BLANK_POWERDOWN;
 	lcd->mode = MODE_VGA;	/* default to VGA */
 
-	lcd->buf = kmalloc(TDO24M_SPI_BUFF_SIZE, GFP_KERNEL);
-	if (lcd->buf == NULL) {
-		kfree(lcd);
+	lcd->buf = devm_kzalloc(&spi->dev, TDO24M_SPI_BUFF_SIZE, GFP_KERNEL);
+	if (lcd->buf == NULL)
 		return -ENOMEM;
-	}
 
 	m = &lcd->msg;
 	x = &lcd->xfer;
@@ -383,15 +381,13 @@ static int __devinit tdo24m_probe(struct spi_device *spi)
 		break;
 	default:
 		dev_err(&spi->dev, "Unsupported model");
-		goto out_free;
+		return -EINVAL;
 	}
 
 	lcd->lcd_dev = lcd_device_register("tdo24m", &spi->dev,
 					lcd, &tdo24m_ops);
-	if (IS_ERR(lcd->lcd_dev)) {
-		err = PTR_ERR(lcd->lcd_dev);
-		goto out_free;
-	}
+	if (IS_ERR(lcd->lcd_dev))
+		return PTR_ERR(lcd->lcd_dev);
 
 	dev_set_drvdata(&spi->dev, lcd);
 	err = tdo24m_power(lcd, FB_BLANK_UNBLANK);
@@ -402,9 +398,6 @@ static int __devinit tdo24m_probe(struct spi_device *spi)
 
 out_unregister:
 	lcd_device_unregister(lcd->lcd_dev);
-out_free:
-	kfree(lcd->buf);
-	kfree(lcd);
 	return err;
 }
 
@@ -414,8 +407,6 @@ static int __devexit tdo24m_remove(struct spi_device *spi)
 
 	tdo24m_power(lcd, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(lcd->lcd_dev);
-	kfree(lcd->buf);
-	kfree(lcd);
 
 	return 0;
 }
-- 
1.7.1


