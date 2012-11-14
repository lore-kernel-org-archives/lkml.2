Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab2KNFyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:54:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55287 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756478Ab2KNFvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:51:10 -0500
Message-Id: <20121114053937.652708298@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:00 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [ 27/82] gpiolib: Dont return -EPROBE_DEFER to sysfs, or for invalid gpios
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit ad2fab36d7922401c4576fb7ea9b21a47a29a17f upstream.

gpios requested with invalid numbers, or gpios requested from userspace via sysfs
should not try to be deferred on failure.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpio/gpiolib.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 5d6c71e..1c8d9e3 100644
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


