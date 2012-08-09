Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab2HILLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 07:11:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60693 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757922Ab2HILLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 07:11:36 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-input@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH] Input: omap4-keypad: Fix the pm_runtime_get_sync return check
Date: Thu, 9 Aug 2012 16:41:30 +0530
Message-ID: <1344510690-13030-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A non-zero on pm_runtime_get_sync shouldnt be considered as an error
it only means that there was another user. Fix the error check to check
for negative values only.

This should fix issues like below
[  917.049713] omap4-keypad omap4-keypad: pm_runtime_get_sync() failed
[  917.056457] omap4-keypad: probe of omap4-keypad failed with error 1

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/input/keyboard/omap4-keypad.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
index 17efede..34cddaf 100644
--- a/drivers/input/keyboard/omap4-keypad.c
+++ b/drivers/input/keyboard/omap4-keypad.c
@@ -305,8 +305,8 @@ static int __devinit omap4_keypad_probe(struct platform_device *pdev)
 	 */
 	pm_runtime_enable(&pdev->dev);
 	error = pm_runtime_get_sync(&pdev->dev);
-	if (error) {
-		dev_err(&pdev->dev, "pm_runtime_get_sync() failed\n");
+	if (IS_ERR_VALUE(error)) {
+		dev_err(&pdev->dev, "pm_runtime_get_sync() failed %d\n", error);
 		goto err_unmap;
 	}
 	rev = __raw_readl(keypad_data->base + OMAP4_KBD_REVISION);
-- 
1.7.5.4

