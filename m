Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab1ADQvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 11:51:35 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54440 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab1ADQvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 11:51:31 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg KH <gregkh@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-doc@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: [PATCH 1/2] gpiolib: annotate gpio-intialization with __must_check
Date: Tue,  4 Jan 2011 17:51:07 +0100
Message-Id: <1294159868-4989-2-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1294159868-4989-1-git-send-email-w.sang@pengutronix.de>
References: <1294159868-4989-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because GPIOs can have crucial functions especially in embedded systems,
we are better safe than sorry regarding their configuration. For
gpio_request, the documentation is simply enforced: <quote>"The return
value of gpio_request() must be checked."</quote> For gpio_direction_*
and gpio_request_*, we now act accordingly.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <gregkh@suse.de>
---
 Documentation/gpio.txt     |    2 +-
 include/asm-generic/gpio.h |   10 +++++-----
 include/linux/gpio.h       |    6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/gpio.txt b/Documentation/gpio.txt
index 792faa3..a492d92 100644
--- a/Documentation/gpio.txt
+++ b/Documentation/gpio.txt
@@ -135,7 +135,7 @@ setting up a platform_device using the GPIO, is mark its direction:
 	int gpio_direction_input(unsigned gpio);
 	int gpio_direction_output(unsigned gpio, int value);
 
-The return value is zero for success, else a negative errno.  It should
+The return value is zero for success, else a negative errno.  It must
 be checked, since the get/set calls don't have error returns and since
 misconfiguration is possible.  You should normally issue these calls from
 a task context.  However, for spinlock-safe GPIOs it's OK to use them
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index ff5c660..6098cae 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -147,11 +147,11 @@ extern struct gpio_chip *gpiochip_find(void *data,
 /* Always use the library code for GPIO management calls,
  * or when sleeping may be involved.
  */
-extern int gpio_request(unsigned gpio, const char *label);
+extern int __must_check gpio_request(unsigned gpio, const char *label);
 extern void gpio_free(unsigned gpio);
 
-extern int gpio_direction_input(unsigned gpio);
-extern int gpio_direction_output(unsigned gpio, int value);
+extern int __must_check gpio_direction_input(unsigned gpio);
+extern int __must_check gpio_direction_output(unsigned gpio, int value);
 
 extern int gpio_set_debounce(unsigned gpio, unsigned debounce);
 
@@ -192,8 +192,8 @@ struct gpio {
 	const char	*label;
 };
 
-extern int gpio_request_one(unsigned gpio, unsigned long flags, const char *label);
-extern int gpio_request_array(struct gpio *array, size_t num);
+extern int __must_check gpio_request_one(unsigned gpio, unsigned long flags, const char *label);
+extern int __must_check gpio_request_array(struct gpio *array, size_t num);
 extern void gpio_free_array(struct gpio *array, size_t num);
 
 #ifdef CONFIG_GPIO_SYSFS
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index e41f7dd..1d5214a 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -29,7 +29,7 @@ static inline int gpio_is_valid(int number)
 	return 0;
 }
 
-static inline int gpio_request(unsigned gpio, const char *label)
+static inline int __must_check gpio_request(unsigned gpio, const char *label)
 {
 	return -ENOSYS;
 }
@@ -42,12 +42,12 @@ static inline void gpio_free(unsigned gpio)
 	WARN_ON(1);
 }
 
-static inline int gpio_direction_input(unsigned gpio)
+static inline int __must_check gpio_direction_input(unsigned gpio)
 {
 	return -ENOSYS;
 }
 
-static inline int gpio_direction_output(unsigned gpio, int value)
+static inline int __must_check gpio_direction_output(unsigned gpio, int value)
 {
 	return -ENOSYS;
 }
-- 
1.7.2.3

