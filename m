Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab2JVAjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 20:39:19 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36728 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab2JVAjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 20:39:18 -0400
Message-ID: <508495B0.7010308@gmail.com>
Date: Mon, 22 Oct 2012 11:39:12 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] gpiolib: Refactor gpio_export
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gpio_export function uses nested if statements and the status
variable to handle the failure cases. This makes the function logic
difficult to follow. Refactor the code to abort immediately on failure
using goto. This makes the code slightly longer, but significantly
reduces the nesting and number of split lines and makes the code easier
to read.

Signed-off-by: Ryan Mallon
---

Changes since v1:

 - Return immediately if no unwinding needed
 - Added pr_debug to immediate returns
 - Changed unavailable (!requested || exported) to -EPERM

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 5d6c71e..d5f9742 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -702,8 +702,9 @@ int gpio_export(unsigned gpio, bool direction_may_change)
 {
 	unsigned long		flags;
 	struct gpio_desc	*desc;
-	int			status = -EINVAL;
+	int			status;
 	const char		*ioname = NULL;
+	struct device		*dev;
 
 	/* can't export until sysfs is available ... */
 	if (!gpio_class.p) {
@@ -711,59 +712,65 @@ int gpio_export(unsigned gpio, bool direction_may_change)
 		return -ENOENT;
 	}
 
-	if (!gpio_is_valid(gpio))
-		goto done;
+	if (!gpio_is_valid(gpio)) {
+		pr_debug("%s: gpio %d is not valid\n", __func__, gpio);
+		return -EINVAL;
+	}
 
 	mutex_lock(&sysfs_lock);
 
 	spin_lock_irqsave(&gpio_lock, flags);
 	desc = &gpio_desc[gpio];
-	if (test_bit(FLAG_REQUESTED, &desc->flags)
-			&& !test_bit(FLAG_EXPORT, &desc->flags)) {
-		status = 0;
-		if (!desc->chip->direction_input
-				|| !desc->chip->direction_output)
-			direction_may_change = false;
+	if (!test_bit(FLAG_REQUESTED, &desc->flags) ||
+	     test_bit(FLAG_EXPORT, &desc->flags)) {
+		spin_unlock_irqrestore(&gpio_lock, flags);
+		pr_debug("%s: gpio %d unavailable (requested=%d, exported=%d)\n",
+				__func__, gpio,
+				test_bit(FLAG_REQUESTED, &desc->flags),
+				test_bit(FLAG_EXPORT, &desc->flags));
+		return -EPERM;
 	}
+
+	if (!desc->chip->direction_input || !desc->chip->direction_output)
+		direction_may_change = false;
 	spin_unlock_irqrestore(&gpio_lock, flags);
 
 	if (desc->chip->names && desc->chip->names[gpio - desc->chip->base])
 		ioname = desc->chip->names[gpio - desc->chip->base];
 
-	if (status == 0) {
-		struct device	*dev;
-
-		dev = device_create(&gpio_class, desc->chip->dev, MKDEV(0, 0),
-				desc, ioname ? ioname : "gpio%u", gpio);
-		if (!IS_ERR(dev)) {
-			status = sysfs_create_group(&dev->kobj,
-						&gpio_attr_group);
-
-			if (!status && direction_may_change)
-				status = device_create_file(dev,
-						&dev_attr_direction);
-
-			if (!status && gpio_to_irq(gpio) >= 0
-					&& (direction_may_change
-						|| !test_bit(FLAG_IS_OUT,
-							&desc->flags)))
-				status = device_create_file(dev,
-						&dev_attr_edge);
-
-			if (status != 0)
-				device_unregister(dev);
-		} else
-			status = PTR_ERR(dev);
-		if (status == 0)
-			set_bit(FLAG_EXPORT, &desc->flags);
+	dev = device_create(&gpio_class, desc->chip->dev, MKDEV(0, 0),
+			    desc, ioname ? ioname : "gpio%u", gpio);
+	if (IS_ERR(dev)) {
+		status = PTR_ERR(dev);
+		goto fail_unlock;
 	}
 
-	mutex_unlock(&sysfs_lock);
-
-done:
+	status = sysfs_create_group(&dev->kobj, &gpio_attr_group);
 	if (status)
-		pr_debug("%s: gpio%d status %d\n", __func__, gpio, status);
+		goto fail_unregister_device;
+
+	if (direction_may_change) {
+		status = device_create_file(dev, &dev_attr_direction);
+		if (status)
+			goto fail_unregister_device;
+	}
 
+	if (gpio_to_irq(gpio) >= 0 && (direction_may_change ||
+				       !test_bit(FLAG_IS_OUT, &desc->flags))) {
+		status = device_create_file(dev, &dev_attr_edge);
+		if (status)
+			goto fail_unregister_device;
+	}
+
+	set_bit(FLAG_EXPORT, &desc->flags);
+	mutex_unlock(&sysfs_lock);
+	return 0;
+
+fail_unregister_device:
+	device_unregister(dev);
+fail_unlock:
+	mutex_unlock(&sysfs_lock);
+	pr_debug("%s: gpio%d status %d\n", __func__, gpio, status);
 	return status;
 }
 EXPORT_SYMBOL_GPL(gpio_export);

