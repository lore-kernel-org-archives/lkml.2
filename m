Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab2J2ErR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 00:47:17 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:24649 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab2J2ErQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 00:47:16 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-cb-508e0a534d53
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000501cdb590$588260f0$098722d0$%han@samsung.com>
In-reply-to: <000501cdb590$588260f0$098722d0$%han@samsung.com>
Subject: [PATCH 2/2] backlight: max8925: drop devm_kfree of devm_kzalloc'd data
Date: Mon, 29 Oct 2012 13:47:15 +0900
Message-id: <000601cdb590$77a78dc0$66f6a940$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac21kFhmA4SJbq7/SSeHEgsu/+gYEgAAAliQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jQd1grr4Ag1fzBSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldG56I1LAULeCv2T3/E1sD4nquLkYNDQsBEYvak2i5GTiBTTOLC
	vfVsXYxcHEIC0xklXtz5zQThzGaSeLf/HTNIFZuAmsSXL4fZQWwRgQiJ5hmzmEEGMQv4SGye
	pQkSFhKwlXh/eRYTiM0pYCfx79UjMFtYwF/ielMPC4jNIqAqce7cZFYQmxeofsLLRUwQtqDE
	j8n3wGqYBbQk1u88zgRhy0tsXvOWGeJmdYlHf3UhLjCSmDftBlS5iMS+F+8YJzAKzUIyaRaS
	SbOQTJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOAgfia1g3Flg8UhRgEORiUe
	3sY3vQFCrIllxZW5hxglOJiVRHiXcgOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8zZ7pAQICaQn
	lqRmp6YWpBbBZJk4OKUaGFVeWD1d8qpfteLi7dnByy2eKdp4u1u8sTyZuv4Gk63qkbeHWJ8v
	0jx6cuJ7jx0vzO9K/um9X5+4beZrge6X101Ov5H0cN8ya9dXk0xW/e+C3WlaPfYOFapTWZpV
	ltju9NglwsW9t10ltbFT7Nvhyxf6JVaErelfuvh35MmfHfPmVu1/pDe1WFCJpTgj0VCLuag4
	EQA/53y5XgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_kfree function allocates memory that is released
when a driver detaches. Thus, there is no reason to explicitly
call devm_kfree in probe or remove functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/max8925_bl.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/video/backlight/max8925_bl.c b/drivers/video/backlight/max8925_bl.c
index f72ba54..01e9f7d 100644
--- a/drivers/video/backlight/max8925_bl.c
+++ b/drivers/video/backlight/max8925_bl.c
@@ -120,15 +120,13 @@ static int __devinit max8925_backlight_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_REG, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "No REG resource for mode control!\n");
-		ret = -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
 	data->reg_mode_cntl = res->start;
 	res = platform_get_resource(pdev, IORESOURCE_REG, 1);
 	if (!res) {
 		dev_err(&pdev->dev, "No REG resource for control!\n");
-		ret = -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
 	data->reg_cntl = res->start;
 
@@ -142,8 +140,7 @@ static int __devinit max8925_backlight_probe(struct platform_device *pdev)
 					&max8925_backlight_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
-		ret = PTR_ERR(bl);
-		goto out;
+		return PTR_ERR(bl);
 	}
 	bl->props.brightness = MAX_BRIGHTNESS;
 
@@ -166,8 +163,6 @@ static int __devinit max8925_backlight_probe(struct platform_device *pdev)
 	return 0;
 out_brt:
 	backlight_device_unregister(bl);
-out:
-	devm_kfree(&pdev->dev, data);
 	return ret;
 }
 
-- 
1.7.1


