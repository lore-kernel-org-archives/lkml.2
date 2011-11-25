Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab1KYOLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 09:11:31 -0500
Received: from 8.mo2.mail-out.ovh.net ([188.165.52.147]:34524 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755784Ab1KYOL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 09:11:29 -0500
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: linux-kernel@vger.kernel.org
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Grant Likely <grant.likely@secretlab.ca>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [PATCH 1/2] gpiolib: introduce gpio_set_pullup
Date: Fri, 25 Nov 2011 15:08:39 +0100
Message-Id: <1322230120-14120-1-git-send-email-plagnioj@jcrosoft.com>
X-Mailer: git-send-email 1.7.2.3
X-Ovh-Tracer-Id: 11676426460463082264
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefiedrudduucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhephffvufffkffosedttdertdertddtnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucffohhmrghinhepne
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -230
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefhedrudehucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnehlihhnuhigfeigucdlqdeftddmnehvohhiugdpihhnthculddquddttddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/gpio/gpiolib.c     |   44 ++++++++++++++++++++++++++++++++++++++++++++
 include/asm-generic/gpio.h |    4 ++++
 include/linux/gpio.h       |    5 +++++
 3 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index a971e3d..b7e5e75 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1519,6 +1519,50 @@ fail:
 }
 EXPORT_SYMBOL_GPL(gpio_set_debounce);
 
+/**
+ * gpio_set_pullup - sets @pullup for a @gpio
+ * @gpio: the gpio to set pullup
+ * @pullup: pullup level
+ */
+int gpio_set_pullup(unsigned gpio, unsigned pullup)
+{
+	unsigned long		flags;
+	struct gpio_chip	*chip;
+	struct gpio_desc	*desc = &gpio_desc[gpio];
+	int			status = -EINVAL;
+
+	spin_lock_irqsave(&gpio_lock, flags);
+
+	if (!gpio_is_valid(gpio))
+		goto fail;
+	chip = desc->chip;
+	if (!chip || !chip->set_pullup)
+		goto fail;
+	gpio -= chip->base;
+	if (gpio >= chip->ngpio)
+		goto fail;
+	status = gpio_ensure_requested(desc, gpio);
+	if (status < 0)
+		goto fail;
+
+	/* now we know the gpio is valid and chip won't vanish */
+
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
+	might_sleep_if(chip->can_sleep);
+
+	return chip->set_pullup(chip, gpio, pullup);
+
+fail:
+	spin_unlock_irqrestore(&gpio_lock, flags);
+	if (status)
+		pr_debug("%s: gpio-%d status %d\n",
+			__func__, gpio, status);
+
+	return status;
+}
+EXPORT_SYMBOL_GPL(gpio_set_pullup);
+
 /* I/O calls are only valid after configuration completed; the relevant
  * "is this a valid GPIO" error checks should already have been done.
  *
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 8c86210..085ef16 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -107,6 +107,9 @@ struct gpio_chip {
 	int			(*set_debounce)(struct gpio_chip *chip,
 						unsigned offset, unsigned debounce);
 
+	int			(*set_pullup)(struct gpio_chip *chip,
+						unsigned offset, unsigned pullup);
+
 	void			(*set)(struct gpio_chip *chip,
 						unsigned offset, int value);
 
@@ -155,6 +158,7 @@ extern int gpio_direction_input(unsigned gpio);
 extern int gpio_direction_output(unsigned gpio, int value);
 
 extern int gpio_set_debounce(unsigned gpio, unsigned debounce);
+extern int gpio_set_pullup(unsigned gpio, unsigned pullup);
 
 extern int gpio_get_value_cansleep(unsigned gpio);
 extern void gpio_set_value_cansleep(unsigned gpio, int value);
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 38ac48b..5c786e7 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -90,6 +90,11 @@ static inline int gpio_set_debounce(unsigned gpio, unsigned debounce)
 	return -ENOSYS;
 }
 
+static inline int gpio_set_pullup(unsigned gpio, unsigned pullup)
+{
+	return -ENOSYS;
+}
+
 static inline int gpio_get_value(unsigned gpio)
 {
 	/* GPIO can never have been requested or set as {in,out}put */
-- 
1.7.7

