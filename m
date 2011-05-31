Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab1EaNq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:46:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45161 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751055Ab1EaNq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:46:58 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] watchdog: Handle multiple wm831x watchdogs being registered
Date: Tue, 31 May 2011 14:46:55 +0100
Message-Id: <1306849615-27434-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to the whole single instance based watchdog API we use static data
for the wm831x watchdog which means that if the system tries to register
a second one we end up trying to register the same miscdevice again,
corrupting the miscdevice list. Work around this by checking for duplicate
registrations until we get a watchdog core.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/watchdog/wm831x_wdt.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/watchdog/wm831x_wdt.c b/drivers/watchdog/wm831x_wdt.c
index 8c4b2d5..871caea 100644
--- a/drivers/watchdog/wm831x_wdt.c
+++ b/drivers/watchdog/wm831x_wdt.c
@@ -320,6 +320,11 @@ static int __devinit wm831x_wdt_probe(struct platform_device *pdev)
 	struct wm831x_watchdog_pdata *pdata;
 	int reg, ret;
 
+	if (wm831x) {
+		dev_err(&pdev->dev, "wm831x watchdog already registered\n");
+		return -EBUSY;
+	}
+
 	wm831x = dev_get_drvdata(pdev->dev.parent);
 
 	ret = wm831x_reg_read(wm831x, WM831X_WATCHDOG);
-- 
1.7.5.1

