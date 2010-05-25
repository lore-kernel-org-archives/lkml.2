Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab0EYGsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 02:48:09 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53255 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab0EYGsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 02:48:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=bX5Hf4Tv+bt/F26tS2HyDuiJQ5OrOwf9/SPnf9SsoxvBu1W+V9Tdmxn1G8s+GholyX
         6IVN27GY1tdZSQoZFXqa6GG7Y2srG/8+dBJ+SQJdyEzPi7Ye+5AvpknJcSCcf/YcV0Lx
         Xzc25DCVoYVS2nea8G+GL+KGYMS1CCURKusSQ=
Subject: ab3100-otp: fix memory leak in ab3100_otp_probe
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain
Date: Tue, 25 May 2010 14:49:51 +0800
Message-Id: <1274770191.6998.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current implementation, there is a memory leak if ab3100_otp_read fail.
And in the case of ab3100_otp_init_debugfs fail, it does not properly remove
sysfs entries.
This patch properly handle above failure cases.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/ab3100-otp.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/ab3100-otp.c b/drivers/mfd/ab3100-otp.c
index 2d14655..939b876 100644
--- a/drivers/mfd/ab3100-otp.c
+++ b/drivers/mfd/ab3100-otp.c
@@ -202,7 +202,7 @@ static int __init ab3100_otp_probe(struct platform_device *pdev)
 
 	err = ab3100_otp_read(otp);
 	if (err)
-		return err;
+		goto err_otp_read;
 
 	dev_info(&pdev->dev, "AB3100 OTP readout registered\n");
 
@@ -211,21 +211,21 @@ static int __init ab3100_otp_probe(struct platform_device *pdev)
 		err = device_create_file(&pdev->dev,
 					 &ab3100_otp_attrs[i]);
 		if (err)
-			goto out_no_sysfs;
+			goto err_create_file;
 	}
 
 	/* debugfs entries */
 	err = ab3100_otp_init_debugfs(&pdev->dev, otp);
 	if (err)
-		goto out_no_debugfs;
+		goto err_init_debugfs;
 
 	return 0;
 
-out_no_sysfs:
-	for (i = 0; i < ARRAY_SIZE(ab3100_otp_attrs); i++)
-		device_remove_file(&pdev->dev,
-				   &ab3100_otp_attrs[i]);
-out_no_debugfs:
+err_init_debugfs:
+err_create_file:
+	while (--i >= 0)
+		device_remove_file(&pdev->dev, &ab3100_otp_attrs[i]);
+err_otp_read:
 	kfree(otp);
 	return err;
 }
-- 
1.5.4.3



