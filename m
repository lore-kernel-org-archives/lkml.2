Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab2FKALR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 20:11:17 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:37307 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2FKALQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 20:11:16 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-c2-4fd537972d60
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Christian Gmeiner'" <christian.gmeiner@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH v2 2/3][RESEND] backlight: ot200_bl: use devm_ functions
Date: Mon, 11 Jun 2012 09:11:02 +0900
Message-id: <000c01cd4766$b013b410$103b1c30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1HZq/5zo7BussZTOuS7BOfBqeUJA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jAd3p5lf9DbYc5bW4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZk3aeZyn4wldxoyuygXE7TxcjJ4eEgInE1QXvWSFsMYkL99az
	gdhCAosYJU71lXUxcgHZs5kkNu2aCVbEJqAm8eXLYXYQW0QgQqJ5xixmkCJmgWZGiZXLNzKC
	JIQFPCRWvJsEZrMIqEr0HlnEBGLzCthKdPXeZoewBSV+TL7HAmIzC2hJrN95nAnClpfYvOYt
	0FAOoIvUJR791YXYpSex5tojdogSEYl9L94xTmAUmIVk0iwkk2YhmTQLScsCRpZVjKKpBckF
	xUnpuUZ6xYm5xaV56XrJ+bmbGMFh+Ux6B+OqBotDjAIcjEo8vIYnr/gLsSaWFVfmHmKU4GBW
	EuHdynTJX4g3JbGyKrUoP76oNCe1+BCjNAeLkjhvk/UFfyGB9MSS1OzU1ILUIpgsEwenVAMj
	X/HyWzulpuYHvnrE8qZauzCs+WJrvMfKo69vdmz4ULTNwbdxL3MzfwPHU+ZnjkHHNOI5XwqL
	/VJ4f0qL2WC9lJfomvmLAvQYf1hGRNzZvelP4TRuh82FdRcfWa26yfZ2f4vJVPbzbxNjTMM7
	mCofuHSoVj0tVIjT+m9nfCw8d3Ulw9kMgVtKLMUZiYZazEXFiQCNk2ZWRwIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_ functions allocate memory that is released when a driver
detaches. This patch uses devm_kzalloc of these functions

Cc: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ot200_bl.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/video/backlight/ot200_bl.c b/drivers/video/backlight/ot200_bl.c
index f519d55..ef637ff 100644
--- a/drivers/video/backlight/ot200_bl.c
+++ b/drivers/video/backlight/ot200_bl.c
@@ -97,10 +97,10 @@ static int ot200_backlight_probe(struct platform_device *pdev)
 		goto error_mfgpt_alloc;
 	}
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
 	if (!data) {
 		retval = -ENOMEM;
-		goto error_kzalloc;
+		goto error_devm_kzalloc;
 	}
 
 	/* setup gpio */
@@ -122,16 +122,14 @@ static int ot200_backlight_probe(struct platform_device *pdev)
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
 		retval = PTR_ERR(bl);
-		goto error_backlight_device_register;
+		goto error_devm_kzalloc;
 	}
 
 	platform_set_drvdata(pdev, bl);
 
 	return 0;
 
-error_backlight_device_register:
-	kfree(data);
-error_kzalloc:
+error_devm_kzalloc:
 	cs5535_mfgpt_free_timer(pwm_timer);
 error_mfgpt_alloc:
 	gpio_free(GPIO_DIMM);
@@ -141,7 +139,6 @@ error_mfgpt_alloc:
 static int ot200_backlight_remove(struct platform_device *pdev)
 {
 	struct backlight_device *bl = platform_get_drvdata(pdev);
-	struct ot200_backlight_data *data = bl_get_data(bl);
 
 	backlight_device_unregister(bl);
 
@@ -154,7 +151,6 @@ static int ot200_backlight_remove(struct platform_device *pdev)
 	cs5535_mfgpt_free_timer(pwm_timer);
 	gpio_free(GPIO_DIMM);
 
-	kfree(data);
 	return 0;
 }
 
-- 
1.7.1


