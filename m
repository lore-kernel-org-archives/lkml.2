Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab2LMOBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:01:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43975 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab2LMOBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:01:12 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 008/241] gpiolib: Don't return -EPROBE_DEFER to sysfs, or for invalid gpios
Date: Thu, 13 Dec 2012 11:56:13 -0200
Message-Id: <1355407206-17100-9-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit ad2fab36d7922401c4576fb7ea9b21a47a29a17f upstream.

gpios requested with invalid numbers, or gpios requested from userspace via sysfs
should not try to be deferred on failure.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpio/gpiolib.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 120b2a0..bd76017 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -623,9 +623,11 @@ static ssize_t export_store(struct class *class,
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
@@ -1191,8 +1193,10 @@ int gpio_request(unsigned gpio, const char *label)
 
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
1.7.9.5

