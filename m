Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375Ab2JYLBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 07:01:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:21983 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756484Ab2JYLBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 07:01:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,646,1344236400"; 
   d="scan'208";a="210645398"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: linus.walleij@stericsson.com
Cc: grant.likely@secretlab.ca, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH] gpiolib: Don't return -EPROBE_DEFER to sysfs, or for invalid gpios
Date: Thu, 25 Oct 2012 14:03:03 +0300
Message-Id: <1351162983-27723-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpios requested with invalid numbers, or gpios requested from userspace via sysfs
should not try to be deferred on failure.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/gpio/gpiolib.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 141f793..b59d240 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -651,9 +651,11 @@ static ssize_t export_store(struct class *class,
 	 */
 
 	status = gpio_request(gpio, "sysfs");
-	if (status < 0)
+	if (status < 0) {
+		if (status == -EPROBE_DEFER)
+			status = -ENODEV;
 		goto done;
-
+	}
 	status = gpio_export(gpio, true);
 	if (status < 0)
 		gpio_free(gpio);
@@ -1220,8 +1222,10 @@ int gpio_request(unsigned gpio, const char *label)
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	if (!gpio_is_valid(gpio))
+	if (!gpio_is_valid(gpio)) {
+		status = -EINVAL;
 		goto done;
+	}
 	desc = &gpio_desc[gpio];
 	chip = desc->chip;
 	if (chip == NULL)
-- 
1.7.4.1

