Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab0GVMGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 08:06:06 -0400
Received: from sand.ocn.ne.jp ([122.28.30.136]:54514 "EHLO smtp.sand.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345Ab0GVMGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 08:06:01 -0400
From: Jon Povey <jon.povey@racelogic.co.uk>
To: dbrownell@users.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Jon Povey <jon.povey@racelogic.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jani Nikula <ext-jani.1.nikula@nokia.com>,
        Andi Kleen <ak@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] gpio: Fix spurious printk when freeing a gpio
Date: Thu, 22 Jul 2010 21:05:26 +0900
Message-Id: <1279800327-32643-1-git-send-email-jon.povey@racelogic.co.uk>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When freeing a gpio that has not been exported, gpio_unexport() prints a
debug message when it should just fall through silently.

Example spurious message:

	gpio_unexport: gpio0 status -22

Signed-off-by: Jon Povey <jon.povey@racelogic.co.uk>
---
 drivers/gpio/gpiolib.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index eb0c3fe..e38687d 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -893,10 +893,12 @@ EXPORT_SYMBOL_GPL(gpio_sysfs_set_active_low);
 void gpio_unexport(unsigned gpio)
 {
 	struct gpio_desc	*desc;
-	int			status = -EINVAL;
+	int			status = 0;
 
-	if (!gpio_is_valid(gpio))
+	if (!gpio_is_valid(gpio)) {
+		status = -EINVAL;
 		goto done;
+	}
 
 	mutex_lock(&sysfs_lock);
 
@@ -911,7 +913,6 @@ void gpio_unexport(unsigned gpio)
 			clear_bit(FLAG_EXPORT, &desc->flags);
 			put_device(dev);
 			device_unregister(dev);
-			status = 0;
 		} else
 			status = -ENODEV;
 	}
-- 
1.6.3.3

