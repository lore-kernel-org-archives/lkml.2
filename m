Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab2KBRHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:07:19 -0400
Received: from mail.kernel.org ([198.145.19.201]:33195 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762937Ab2KBRHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:07:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [ 03/11] gpiolib: Dont return -EPROBE_DEFER to sysfs, or for invalid gpios
Date: Fri,  2 Nov 2012 10:06:38 -0700
Message-Id: <20121102170314.444398718@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121102170314.204845540@linuxfoundation.org>
References: <20121102170314.204845540@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit ad2fab36d7922401c4576fb7ea9b21a47a29a17f upstream.

gpios requested with invalid numbers, or gpios requested from userspace via sysfs
should not try to be deferred on failure.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpiolib.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -623,9 +623,11 @@ static ssize_t export_store(struct class
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
@@ -1191,8 +1193,10 @@ int gpio_request(unsigned gpio, const ch
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	if (!gpio_is_valid(gpio))
+	if (!gpio_is_valid(gpio)) {
+		status = -EINVAL;
 		goto done;
+	}
 	desc = &gpio_desc[gpio];
 	chip = desc->chip;
 	if (chip == NULL)


