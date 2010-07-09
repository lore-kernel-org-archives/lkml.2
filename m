Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab0GIT5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 15:57:35 -0400
Received: from mx1.emlix.com ([193.175.82.87]:49790 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984Ab0GIT5e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 15:57:34 -0400
X-Greylist: delayed 1946 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jul 2010 15:57:33 EDT
From: =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org,
       =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [PATCH 1/2] gpiolib: get rid of struct poll_desc and worklet
Date: Fri,  9 Jul 2010 21:24:17 +0200
Message-Id: <1278703458-26412-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As sysfs_notify_dirent has been made irq safe, there is no reason
to not call it directly from irq. With the work_struct removed,
the remaining element in poll_desc is a sysfs_dirent pointer
which may not be NULL. We can therefore store it directly in the
idr and pass it as context to the irq handler.

Most part of the patch deals with renaming defines and variables
to reflect their new use without functional change.

I also took the opportunity to initialize the idr statically.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 drivers/gpio/gpiolib.c |   80 ++++++++++++++++-------------------------------
 1 files changed, 27 insertions(+), 53 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 3ca3654..67e6136 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -56,9 +56,9 @@ struct gpio_desc {
 #define FLAG_TRIG_RISE	6	/* trigger on rising edge */
 #define FLAG_ACTIVE_LOW	7	/* sysfs value has active low */
 
-#define PDESC_ID_SHIFT	16	/* add new flags before this one */
+#define ID_SHIFT	16	/* add new flags before this one */
 
-#define GPIO_FLAGS_MASK		((1 << PDESC_ID_SHIFT) - 1)
+#define GPIO_FLAGS_MASK		((1 << ID_SHIFT) - 1)
 #define GPIO_TRIGGER_MASK	(BIT(FLAG_TRIG_FALL) | BIT(FLAG_TRIG_RISE))
 
 #ifdef CONFIG_DEBUG_FS
@@ -68,12 +68,7 @@ struct gpio_desc {
 static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
 
 #ifdef CONFIG_GPIO_SYSFS
-struct poll_desc {
-	struct work_struct	work;
-	struct sysfs_dirent	*value_sd;
-};
-
-static struct idr pdesc_idr;
+static DEFINE_IDR(dirent_idr);
 #endif
 
 static inline void desc_set_label(struct gpio_desc *d, const char *label)
@@ -324,24 +319,16 @@ static const DEVICE_ATTR(value, 0644,
 
 static irqreturn_t gpio_sysfs_irq(int irq, void *priv)
 {
-	struct work_struct	*work = priv;
+	struct sysfs_dirent	*value_sd = priv;
 
-	schedule_work(work);
+	sysfs_notify_dirent(value_sd);
 	return IRQ_HANDLED;
 }
 
-static void gpio_notify_sysfs(struct work_struct *work)
-{
-	struct poll_desc	*pdesc;
-
-	pdesc = container_of(work, struct poll_desc, work);
-	sysfs_notify_dirent(pdesc->value_sd);
-}
-
 static int gpio_setup_irq(struct gpio_desc *desc, struct device *dev,
 		unsigned long gpio_flags)
 {
-	struct poll_desc	*pdesc;
+	struct sysfs_dirent	*value_sd;
 	unsigned long		irq_flags;
 	int			ret, irq, id;
 
@@ -352,18 +339,16 @@ static int gpio_setup_irq(struct gpio_desc *desc, struct device *dev,
 	if (irq < 0)
 		return -EIO;
 
-	id = desc->flags >> PDESC_ID_SHIFT;
-	pdesc = idr_find(&pdesc_idr, id);
-	if (pdesc) {
-		free_irq(irq, &pdesc->work);
-		cancel_work_sync(&pdesc->work);
-	}
+	id = desc->flags >> ID_SHIFT;
+	value_sd = idr_find(&dirent_idr, id);
+	if (value_sd)
+		free_irq(irq, value_sd);
 
 	desc->flags &= ~GPIO_TRIGGER_MASK;
 
 	if (!gpio_flags) {
 		ret = 0;
-		goto free_sd;
+		goto free_id;
 	}
 
 	irq_flags = IRQF_SHARED;
@@ -374,55 +359,46 @@ static int gpio_setup_irq(struct gpio_desc *desc, struct device *dev,
 		irq_flags |= test_bit(FLAG_ACTIVE_LOW, &desc->flags) ?
 			IRQF_TRIGGER_FALLING : IRQF_TRIGGER_RISING;
 
-	if (!pdesc) {
-		pdesc = kmalloc(sizeof(*pdesc), GFP_KERNEL);
-		if (!pdesc) {
-			ret = -ENOMEM;
+	if (!value_sd) {
+		value_sd = sysfs_get_dirent(dev->kobj.sd, NULL, "value");
+		if (!value_sd) {
+			ret = -ENODEV;
 			goto err_out;
 		}
 
 		do {
 			ret = -ENOMEM;
-			if (idr_pre_get(&pdesc_idr, GFP_KERNEL))
-				ret = idr_get_new_above(&pdesc_idr,
-						pdesc, 1, &id);
+			if (idr_pre_get(&dirent_idr, GFP_KERNEL))
+				ret = idr_get_new_above(&dirent_idr, value_sd,
+							1, &id);
 		} while (ret == -EAGAIN);
 
 		if (ret)
-			goto free_mem;
+			goto free_sd;
 
 		desc->flags &= GPIO_FLAGS_MASK;
-		desc->flags |= (unsigned long)id << PDESC_ID_SHIFT;
+		desc->flags |= (unsigned long)id << ID_SHIFT;
 
-		if (desc->flags >> PDESC_ID_SHIFT != id) {
+		if (desc->flags >> ID_SHIFT != id) {
 			ret = -ERANGE;
 			goto free_id;
 		}
-
-		pdesc->value_sd = sysfs_get_dirent(dev->kobj.sd, NULL, "value");
-		if (!pdesc->value_sd) {
-			ret = -ENODEV;
-			goto free_id;
-		}
-		INIT_WORK(&pdesc->work, gpio_notify_sysfs);
 	}
 
 	ret = request_irq(irq, gpio_sysfs_irq, irq_flags,
-			"gpiolib", &pdesc->work);
+				"gpiolib", value_sd);
 	if (ret)
-		goto free_sd;
+		goto free_id;
 
 	desc->flags |= gpio_flags;
 	return 0;
 
-free_sd:
-	if (pdesc)
-		sysfs_put(pdesc->value_sd);
 free_id:
-	idr_remove(&pdesc_idr, id);
+	idr_remove(&dirent_idr, id);
 	desc->flags &= GPIO_FLAGS_MASK;
-free_mem:
-	kfree(pdesc);
+free_sd:
+	if (value_sd)
+		sysfs_put(value_sd);
 err_out:
 	return ret;
 }
@@ -992,8 +968,6 @@ static int __init gpiolib_sysfs_init(void)
 	unsigned long	flags;
 	unsigned	gpio;
 
-	idr_init(&pdesc_idr);
-
 	status = class_register(&gpio_class);
 	if (status < 0)
 		return status;
-- 
1.7.1

