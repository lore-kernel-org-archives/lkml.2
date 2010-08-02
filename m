Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab0HBLdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 07:33:21 -0400
Received: from krynn.se.axis.com ([193.13.178.10]:48790 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab0HBLdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 07:33:19 -0400
Date: Mon, 2 Aug 2010 13:33:16 +0200
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Mikael Starvik <mikael.starvik@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cris: gpio: do not call
	copy_to_user()/copy_from_user() while holding spinlocks
Message-ID: <20100802113316.GJ9784@axis.com>
References: <1280410338-21501-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280410338-21501-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 03:32:18PM +0200, Kulikov Vasiliy wrote:
> copy_to_user()/copy_from_user() must not be used with spinlocks held.
> Move all cases of interaction with userspace out of global switch and
> lock spinlocks only where they are needed.

Thanks, but I'm thinking we should move the spinlock inside each case instead,
as in the below patch.
Unless there's any protests I'll add it to the cris-tree in the next couple of days:

CRIS: gpio: don't call copy_to_user()/copy_from_user() while holding spinlocks

copy_to_user()/copy_from_user() must not be used with spinlocks held.
Move locks inside each case so we have better control of when the locks
are held.

Also, since we use spinlocks, we don't need to hold the BKL, so remove it.

Reported-by: Kulikov Vasiliy <segooon@gmail.com>
Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v10/drivers/gpio.c |   77 +++++++++++++++++++++++--------------
 1 files changed, 48 insertions(+), 29 deletions(-)

diff --git a/arch/cris/arch-v10/drivers/gpio.c b/arch/cris/arch-v10/drivers/gpio.c
index 080927f..a570101 100644
--- a/arch/cris/arch-v10/drivers/gpio.c
+++ b/arch/cris/arch-v10/drivers/gpio.c
@@ -46,7 +46,7 @@ static char gpio_name[] = "etrax gpio";
 static wait_queue_head_t *gpio_wq;
 #endif
 
-static int gpio_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+static long gpio_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 static ssize_t gpio_write(struct file *file, const char __user *buf,
 	size_t count, loff_t *off);
 static int gpio_open(struct inode *inode, struct file *filp);
@@ -503,8 +503,7 @@ unsigned long inline setget_output(struct gpio_private *priv, unsigned long arg)
 static int
 gpio_leds_ioctl(unsigned int cmd, unsigned long arg);
 
-static int
-gpio_ioctl_unlocked(struct file *file, unsigned int cmd, unsigned long arg)
+static long gpio_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	unsigned long flags;
 	unsigned long val;
@@ -514,54 +513,65 @@ gpio_ioctl_unlocked(struct file *file, unsigned int cmd, unsigned long arg)
 	if (_IOC_TYPE(cmd) != ETRAXGPIO_IOCTYPE)
 		return -EINVAL;
 
-	spin_lock_irqsave(&gpio_lock, flags);
-
 	switch (_IOC_NR(cmd)) {
 	case IO_READBITS: /* Use IO_READ_INBITS and IO_READ_OUTBITS instead */
 		// read the port
+		spin_lock_irqsave(&gpio_lock, flags);
 		if (USE_PORTS(priv)) {
 			ret =  *priv->port;
 		} else if (priv->minor == GPIO_MINOR_G) {
 			ret =  (*R_PORT_G_DATA) & 0x7FFFFFFF;
 		}
+		spin_unlock_irqrestore(&gpio_lock, flags);
+
 		break;
 	case IO_SETBITS:
 		// set changeable bits with a 1 in arg
+		spin_lock_irqsave(&gpio_lock, flags);
+
 		if (USE_PORTS(priv)) {
-			*priv->port = *priv->shadow |= 
+			*priv->port = *priv->shadow |=
 			  ((unsigned char)arg & priv->changeable_bits);
 		} else if (priv->minor == GPIO_MINOR_G) {
 			*R_PORT_G_DATA = port_g_data_shadow |= (arg & dir_g_out_bits);
 		}
+		spin_unlock_irqrestore(&gpio_lock, flags);
+
 		break;
 	case IO_CLRBITS:
 		// clear changeable bits with a 1 in arg
+		spin_lock_irqsave(&gpio_lock, flags);
 		if (USE_PORTS(priv)) {
-			*priv->port = *priv->shadow &= 
+			*priv->port = *priv->shadow &=
 			 ~((unsigned char)arg & priv->changeable_bits);
 		} else if (priv->minor == GPIO_MINOR_G) {
 			*R_PORT_G_DATA = port_g_data_shadow &= ~((unsigned long)arg & dir_g_out_bits);
 		}
+		spin_unlock_irqrestore(&gpio_lock, flags);
 		break;
 	case IO_HIGHALARM:
 		// set alarm when bits with 1 in arg go high
+		spin_lock_irqsave(&gpio_lock, flags);
 		priv->highalarm |= arg;
 		gpio_some_alarms = 1;
+		spin_unlock_irqrestore(&gpio_lock, flags);
 		break;
 	case IO_LOWALARM:
 		// set alarm when bits with 1 in arg go low
+		spin_lock_irqsave(&gpio_lock, flags);
 		priv->lowalarm |= arg;
 		gpio_some_alarms = 1;
+		spin_unlock_irqrestore(&gpio_lock, flags);
 		break;
 	case IO_CLRALARM:
-		// clear alarm for bits with 1 in arg
+		/* clear alarm for bits with 1 in arg */
+		spin_lock_irqsave(&gpio_lock, flags);
 		priv->highalarm &= ~arg;
 		priv->lowalarm  &= ~arg;
 		{
 			/* Must update gpio_some_alarms */
 			struct gpio_private *p = alarmlist;
 			int some_alarms;
-			spin_lock_irq(&gpio_lock);
 			p = alarmlist;
 			some_alarms = 0;
 			while (p) {
@@ -572,11 +582,12 @@ gpio_ioctl_unlocked(struct file *file, unsigned int cmd, unsigned long arg)
 				p = p->next;
 			}
 			gpio_some_alarms = some_alarms;
-			spin_unlock_irq(&gpio_lock);
 		}
+		spin_unlock_irqrestore(&gpio_lock, flags);
 		break;
 	case IO_READDIR: /* Use IO_SETGET_INPUT/OUTPUT instead! */
 		/* Read direction 0=input 1=output */
+		spin_lock_irqsave(&gpio_lock, flags);
 		if (USE_PORTS(priv)) {
 			ret = *priv->dir_shadow;
 		} else if (priv->minor == GPIO_MINOR_G) {
@@ -585,30 +596,40 @@ gpio_ioctl_unlocked(struct file *file, unsigned int cmd, unsigned long arg)
 			 */
 			ret = (dir_g_shadow | dir_g_out_bits) & 0x7FFFFFFF;
 		}
+		spin_unlock_irqrestore(&gpio_lock, flags);
 		break;
 	case IO_SETINPUT: /* Use IO_SETGET_INPUT instead! */
-		/* Set direction 0=unchanged 1=input, 
-		 * return mask with 1=input 
+		/* Set direction 0=unchanged 1=input,
+		 * return mask with 1=input
 		 */
+		spin_lock_irqsave(&gpio_lock, flags);
 		ret = setget_input(priv, arg) & 0x7FFFFFFF;
+		spin_unlock_irqrestore(&gpio_lock, flags);
 		break;
 	case IO_SETOUTPUT: /* Use IO_SETGET_OUTPUT instead! */
-		/* Set direction 0=unchanged 1=output, 
-		 * return mask with 1=output 
+		/* Set direction 0=unchanged 1=output,
+		 * return mask with 1=output
 		 */
+		spin_lock_irqsave(&gpio_lock, flags);
 		ret =  setget_output(priv, arg) & 0x7FFFFFFF;
+		spin_unlock_irqrestore(&gpio_lock, flags);
 		break;
 	case IO_SHUTDOWN:
+		spin_lock_irqsave(&gpio_lock, flags);
 		SOFT_SHUTDOWN();
+		spin_unlock_irqrestore(&gpio_lock, flags);
 		break;
 	case IO_GET_PWR_BT:
+		spin_lock_irqsave(&gpio_lock, flags);
 #if defined (CONFIG_ETRAX_SOFT_SHUTDOWN)
 		ret = (*R_PORT_G_DATA & ( 1 << CONFIG_ETRAX_POWERBUTTON_BIT));
 #else
 		ret = 0;
 #endif
+		spin_unlock_irqrestore(&gpio_lock, flags);
 		break;
 	case IO_CFG_WRITE_MODE:
+		spin_lock_irqsave(&gpio_lock, flags);
 		priv->clk_mask = arg & 0xFF;
 		priv->data_mask = (arg >> 8) & 0xFF;
 		priv->write_msb = (arg >> 16) & 0x01;
@@ -624,28 +645,33 @@ gpio_ioctl_unlocked(struct file *file, unsigned int cmd, unsigned long arg)
 			priv->data_mask = 0;
 			ret = -EPERM;
 		}
+		spin_unlock_irqrestore(&gpio_lock, flags);
 		break;
-	case IO_READ_INBITS: 
+	case IO_READ_INBITS:
 		/* *arg is result of reading the input pins */
+		spin_lock_irqsave(&gpio_lock, flags);
 		if (USE_PORTS(priv)) {
 			val = *priv->port;
 		} else if (priv->minor == GPIO_MINOR_G) {
 			val = *R_PORT_G_DATA;
 		}
+		spin_unlock_irqrestore(&gpio_lock, flags);
 		if (copy_to_user((void __user *)arg, &val, sizeof(val)))
 			ret = -EFAULT;
 		break;
 	case IO_READ_OUTBITS:
 		 /* *arg is result of reading the output shadow */
+		spin_lock_irqsave(&gpio_lock, flags);
 		if (USE_PORTS(priv)) {
 			val = *priv->shadow;
 		} else if (priv->minor == GPIO_MINOR_G) {
 			val = port_g_data_shadow;
 		}
+		spin_unlock_irqrestore(&gpio_lock, flags);
 		if (copy_to_user((void __user *)arg, &val, sizeof(val)))
 			ret = -EFAULT;
 		break;
-	case IO_SETGET_INPUT: 
+	case IO_SETGET_INPUT:
 		/* bits set in *arg is set to input,
 		 * *arg updated with current input pins.
 		 */
@@ -654,7 +680,9 @@ gpio_ioctl_unlocked(struct file *file, unsigned int cmd, unsigned long arg)
 			ret = -EFAULT;
 			break;
 		}
+		spin_lock_irqsave(&gpio_lock, flags);
 		val = setget_input(priv, val);
+		spin_unlock_irqrestore(&gpio_lock, flags);
 		if (copy_to_user((void __user *)arg, &val, sizeof(val)))
 			ret = -EFAULT;
 		break;
@@ -666,34 +694,25 @@ gpio_ioctl_unlocked(struct file *file, unsigned int cmd, unsigned long arg)
 			ret = -EFAULT;
 			break;
 		}
+		spin_lock_irqsave(&gpio_lock, flags);
 		val = setget_output(priv, val);
+		spin_unlock_irqrestore(&gpio_lock, flags);
 		if (copy_to_user((void __user *)arg, &val, sizeof(val)))
 			ret = -EFAULT;
 		break;
 	default:
+		spin_lock_irqsave(&gpio_lock, flags);
 		if (priv->minor == GPIO_MINOR_LEDS)
 			ret = gpio_leds_ioctl(cmd, arg);
 		else
 			ret = -EINVAL;
+		spin_unlock_irqrestore(&gpio_lock, flags);
 	} /* switch */
 
-	spin_unlock_irqrestore(&gpio_lock, flags);
 	return ret;
 }
 
 static int
-gpio_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-{
-       long ret;
-
-       lock_kernel();
-       ret = gpio_ioctl_unlocked(file, cmd, arg);
-       unlock_kernel();
-
-       return ret;
-}
-
-static int
 gpio_leds_ioctl(unsigned int cmd, unsigned long arg)
 {
 	unsigned char green;
-- 
1.6.4.GIT


/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
