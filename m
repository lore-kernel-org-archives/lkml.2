Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965147Ab2EOCzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:55:05 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53336 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964851Ab2EOCRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:10 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 086/179] watchdog: mtx1-wdt: request gpio before using it
Date: Mon, 14 May 2012 22:13:02 -0400
Message-ID: <1337048075-6132-87-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Fainelli <florian@openwrt.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 9b19d40aa3ebaf1078779da10555da2ab8512422 upstream.

Otherwise, the gpiolib autorequest feature will produce a WARN_ON():

WARNING: at drivers/gpio/gpiolib.c:101 0x8020ec6c()
autorequest GPIO-215
[...]

Signed-off-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
[PG: use combo gpio_request+gpio_direction_output vs. gpio_request_one
 to avoid build failure, as per v2.6.32.47 commit 35b6863ce555c ]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/watchdog/mtx-1_wdt.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/watchdog/mtx-1_wdt.c b/drivers/watchdog/mtx-1_wdt.c
index 08e8a6a..c9dbe11 100644
--- a/drivers/watchdog/mtx-1_wdt.c
+++ b/drivers/watchdog/mtx-1_wdt.c
@@ -211,6 +211,13 @@ static int __devinit mtx1_wdt_probe(struct platform_device *pdev)
 	int ret;
 
 	mtx1_wdt_device.gpio = pdev->resource[0].start;
+	ret = gpio_request(mtx1_wdt_device.gpio, "mtx1-wdt");
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to request gpio");
+		return ret;
+	}
+
+	gpio_direction_output(mtx1_wdt_device.gpio, 1);
 
 	spin_lock_init(&mtx1_wdt_device.lock);
 	init_completion(&mtx1_wdt_device.stop);
@@ -236,6 +243,8 @@ static int __devexit mtx1_wdt_remove(struct platform_device *pdev)
 		mtx1_wdt_device.queue = 0;
 		wait_for_completion(&mtx1_wdt_device.stop);
 	}
+
+	gpio_free(mtx1_wdt_device.gpio);
 	misc_deregister(&mtx1_wdt_misc);
 	return 0;
 }
-- 
1.7.9.6

