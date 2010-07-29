Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab0G2Ncm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 09:32:42 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44670 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756638Ab0G2Nck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 09:32:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=b4/VgycxEavG09HxGiSNBGfiPwl2vtTbkN5dnNsrw7oR2PI7o+SjOh2yfmKx5o8K7J
         L1wdiNBc5TkMWiPQ7R4O4gsUZIjZN5+DnUsKunqDDvxNE+a8N8hG9b/17Z+djTa+E/6T
         6iFr+swuyC4qQWpJHKRbXwq8M2hJutaXnWLZ4=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cris: gpio: do not call copy_to_user()/copy_from_user() while holding spinlocks
Date: Thu, 29 Jul 2010 17:32:18 +0400
Message-Id: <1280410338-21501-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_to_user()/copy_from_user() must not be used with spinlocks held.
Move all cases of interaction with userspace out of global switch and
lock spinlocks only where they are needed.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 arch/cris/arch-v10/drivers/gpio.c |   96 +++++++++++++++++++------------------
 1 files changed, 50 insertions(+), 46 deletions(-)

diff --git a/arch/cris/arch-v10/drivers/gpio.c b/arch/cris/arch-v10/drivers/gpio.c
index 4b0f65f..74e3eed 100644
--- a/arch/cris/arch-v10/drivers/gpio.c
+++ b/arch/cris/arch-v10/drivers/gpio.c
@@ -510,12 +510,61 @@ gpio_ioctl(struct inode *inode, struct file *file,
 {
 	unsigned long flags;
 	unsigned long val;
-        int ret = 0;
+	int ret = 0;
 
 	struct gpio_private *priv = file->private_data;
 	if (_IOC_TYPE(cmd) != ETRAXGPIO_IOCTYPE)
 		return -EINVAL;
 
+	switch (_IOC_NR(cmd)) {
+	case IO_READ_INBITS:
+		spin_lock_irqsave(&gpio_lock, flags);
+		/* *arg is result of reading the input pins */
+		if (USE_PORTS(priv))
+			val = *priv->port;
+		else if (priv->minor == GPIO_MINOR_G)
+			val = *R_PORT_G_DATA;
+		spin_unlock_irqrestore(&gpio_lock, flags);
+		if (copy_to_user((void __user *)arg, &val, sizeof(val)))
+			ret = -EFAULT;
+		return ret;
+	case IO_READ_OUTBITS:
+		spin_lock_irqsave(&gpio_lock, flags);
+		 /* *arg is result of reading the output shadow */
+		if (USE_PORTS(priv))
+			val = *priv->shadow;
+		else if (priv->minor == GPIO_MINOR_G)
+			val = port_g_data_shadow;
+		spin_unlock_irqrestore(&gpio_lock, flags);
+		if (copy_to_user((void __user *)arg, &val, sizeof(val)))
+			ret = -EFAULT;
+		return ret;
+	case IO_SETGET_INPUT:
+		/* bits set in *arg is set to input,
+		 * *arg updated with current input pins.
+		 */
+		if (copy_from_user(&val, (void __user *)arg, sizeof(val)))
+			return -EFAULT;
+		spin_lock_irqsave(&gpio_lock, flags);
+		val = setget_input(priv, val);
+		spin_unlock_irqrestore(&gpio_lock, flags);
+		if (copy_to_user((void __user *)arg, &val, sizeof(val)))
+			ret = -EFAULT;
+		return ret;
+	case IO_SETGET_OUTPUT:
+		/* bits set in *arg is set to output,
+		 * *arg updated with current output pins.
+		 */
+		if (copy_from_user(&val, (void __user *)arg, sizeof(val)))
+			return -EFAULT;
+		spin_lock_irqsave(&gpio_lock, flags);
+		val = setget_output(priv, val);
+		spin_unlock_irqrestore(&gpio_lock, flags);
+		if (copy_to_user((void __user *)arg, &val, sizeof(val)))
+			ret = -EFAULT;
+		return ret;
+	}
+
 	spin_lock_irqsave(&gpio_lock, flags);
 
 	switch (_IOC_NR(cmd)) {
@@ -627,51 +676,6 @@ gpio_ioctl(struct inode *inode, struct file *file,
 			ret = -EPERM;
 		}
 		break;
-	case IO_READ_INBITS: 
-		/* *arg is result of reading the input pins */
-		if (USE_PORTS(priv)) {
-			val = *priv->port;
-		} else if (priv->minor == GPIO_MINOR_G) {
-			val = *R_PORT_G_DATA;
-		}
-		if (copy_to_user((void __user *)arg, &val, sizeof(val)))
-			ret = -EFAULT;
-		break;
-	case IO_READ_OUTBITS:
-		 /* *arg is result of reading the output shadow */
-		if (USE_PORTS(priv)) {
-			val = *priv->shadow;
-		} else if (priv->minor == GPIO_MINOR_G) {
-			val = port_g_data_shadow;
-		}
-		if (copy_to_user((void __user *)arg, &val, sizeof(val)))
-			ret = -EFAULT;
-		break;
-	case IO_SETGET_INPUT: 
-		/* bits set in *arg is set to input,
-		 * *arg updated with current input pins.
-		 */
-		if (copy_from_user(&val, (void __user *)arg, sizeof(val)))
-		{
-			ret = -EFAULT;
-			break;
-		}
-		val = setget_input(priv, val);
-		if (copy_to_user((void __user *)arg, &val, sizeof(val)))
-			ret = -EFAULT;
-		break;
-	case IO_SETGET_OUTPUT:
-		/* bits set in *arg is set to output,
-		 * *arg updated with current output pins.
-		 */
-		if (copy_from_user(&val, (void __user *)arg, sizeof(val))) {
-			ret = -EFAULT;
-			break;
-		}
-		val = setget_output(priv, val);
-		if (copy_to_user((void __user *)arg, &val, sizeof(val)))
-			ret = -EFAULT;
-		break;
 	default:
 		if (priv->minor == GPIO_MINOR_LEDS)
 			ret = gpio_leds_ioctl(cmd, arg);
-- 
1.7.0.4

