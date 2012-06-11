Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab2FKALa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 20:11:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:37444 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab2FKAL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 20:11:29 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-ed-4fd537b06c36
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Johan Hovold'" <jhovold@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH v2 3/3][RESEND] backlight: lm3533_bl: use devm_ functions
Date: Mon, 11 Jun 2012 09:11:28 +0900
Message-id: <000d01cd4766$bf4e2be0$3dea83a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1HZr8xchIqMdbpRr6/AixHwCIxKA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jQd0N5lf9DU6807W4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZZ649ZSpo461YtJG7gfENVxcjJ4eEgInEuvszWSFsMYkL99az
	dTFycQgJTGeUWDHhKjuEM5tJonfVIUaQKjYBNYkvXw6zg9giAhESzTNmMYPYzAJFEuseXQWz
	hQU8JXZ92QtWzyKgKvFh32OwOK+ArcT0hh8sELagxI/J91ggerUk1u88zgRhy0tsXvMWqJ4D
	6CJ1iUd/dSFW6UmcfD0PqkREYt+Ld4wTGAVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnqu
	oV5xYm5xaV66XnJ+7iZGcFg+k9rBuLLB4hCjAAejEg+vwckr/kKsiWXFlbmHGCU4mJVEeLcy
	XfIX4k1JrKxKLcqPLyrNSS0+xCjNwaIkzttkfcFfSCA9sSQ1OzW1ILUIJsvEwSnVwDinUUlC
	8cHraiWh702r367/wbehaWnPzn1Jhx5OPHBhwhRdRe7vN1bs605QkIv5feGOem5j7UuN2o5T
	gbetG0J/ONSEvVX/zFLoE2ztws5TlbG3/KR7fd2cqXPVPj2oO2JXkPvi99KkRz92hp7ck1ri
	b/ljwY/b7zJdbd41vsh2Z7pacdbbY7cSS3FGoqEWc1FxIgCteKuvRwIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_ functions allocate memory that is released when a driver
detaches. This patch uses devm_kzalloc of these functions.

Acked-by: Johan Hovold <jhovold@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/lm3533_bl.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/video/backlight/lm3533_bl.c b/drivers/video/backlight/lm3533_bl.c
index 0148227..d916ffe 100644
--- a/drivers/video/backlight/lm3533_bl.c
+++ b/drivers/video/backlight/lm3533_bl.c
@@ -295,7 +295,7 @@ static int __devinit lm3533_bl_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	bl = kzalloc(sizeof(*bl), GFP_KERNEL);
+	bl = devm_kzalloc(&pdev->dev, sizeof(*bl), GFP_KERNEL);
 	if (!bl) {
 		dev_err(&pdev->dev,
 				"failed to allocate memory for backlight\n");
@@ -317,8 +317,7 @@ static int __devinit lm3533_bl_probe(struct platform_device *pdev)
 						&lm3533_bl_ops, &props);
 	if (IS_ERR(bd)) {
 		dev_err(&pdev->dev, "failed to register backlight device\n");
-		ret = PTR_ERR(bd);
-		goto err_free;
+		return PTR_ERR(bd);
 	}
 
 	bl->bd = bd;
@@ -348,8 +347,6 @@ err_sysfs_remove:
 	sysfs_remove_group(&bd->dev.kobj, &lm3533_bl_attribute_group);
 err_unregister:
 	backlight_device_unregister(bd);
-err_free:
-	kfree(bl);
 
 	return ret;
 }
@@ -367,7 +364,6 @@ static int __devexit lm3533_bl_remove(struct platform_device *pdev)
 	lm3533_ctrlbank_disable(&bl->cb);
 	sysfs_remove_group(&bd->dev.kobj, &lm3533_bl_attribute_group);
 	backlight_device_unregister(bd);
-	kfree(bl);
 
 	return 0;
 }
-- 
1.7.1


