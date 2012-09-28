Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946320Ab2I1Vi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:38:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59993 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423355Ab2I1VgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:36:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 07/12] staging/iio/lis3l02dq: fix building without irq_to_gpio
Date: Fri, 28 Sep 2012 23:36:12 +0200
Message-Id: <1348868177-21205-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1348868177-21205-1-git-send-email-arnd@arndb.de>
References: <1348868177-21205-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:C76e+5/7KkLhmDCy42xx+CCBr6jhJyc2PSAu04CdD+e
 SzOjikNKjeKGezwsnfWctcq9Erb+u91Y3fOQlW2LPdOiltX7XX
 EMvdPDsKWf5YuJ5AyYT9UylPLnV6JNK1GvxWgNIg31F4XvnDCu
 yjvIECys2pP4ZOeHS96tDLZbMPCODoAxIW0ZoduIGw9lnQJQ7S
 aywmInVq3PHdJp/28ixNEj8yHGU5nvVM42+a+tU1zo234rWa/f
 iTcMBj+4iWpiY/ZrE1Zb5SsMdXuG+MMxOJwre5lNy/nC5O6nHi
 ZrMNh2xCW2loxORajJyRbm1Iq51a/iJmNmq4fDFp9Egg26GAJT
 9YDTBt5QYweIbjX5QxanBzLJJY3+M0qR7iHgBpecApdA1MqMyx
 msuu3AcHAml/w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver has not been building for some time after the
irq_to_gpio function has been removed from the kernel.

The only board in the upstream kernel that provides
this device is the "Stargate 2", which is also maintained
by Jonathan Cameron. Rather than working around the problem
by adding new platform data for this driver, this patch
uses the of_gpio framework to get to the gpio number.

However, the stargate2 code does not (yet) use DT based
probing, so it is still broken, but at least building
allyesconfig works again.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/iio/accel/lis3l02dq.h      |    1 +
 drivers/staging/iio/accel/lis3l02dq_core.c |   10 ++++++----
 drivers/staging/iio/accel/lis3l02dq_ring.c |    2 +-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/iio/accel/lis3l02dq.h b/drivers/staging/iio/accel/lis3l02dq.h
index f9bcd41..2bac722 100644
--- a/drivers/staging/iio/accel/lis3l02dq.h
+++ b/drivers/staging/iio/accel/lis3l02dq.h
@@ -158,6 +158,7 @@ struct lis3l02dq_state {
 	struct spi_device		*us;
 	struct iio_trigger		*trig;
 	struct mutex			buf_lock;
+	int				gpio;
 	bool				trigger_on;
 
 	u8	tx[LIS3L02DQ_MAX_RX] ____cacheline_aligned;
diff --git a/drivers/staging/iio/accel/lis3l02dq_core.c b/drivers/staging/iio/accel/lis3l02dq_core.c
index 21b0469..d13c7e9 100644
--- a/drivers/staging/iio/accel/lis3l02dq_core.c
+++ b/drivers/staging/iio/accel/lis3l02dq_core.c
@@ -15,6 +15,7 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/gpio.h>
+#include <linux/of_gpio.h>
 #include <linux/mutex.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
@@ -690,6 +691,7 @@ static int __devinit lis3l02dq_probe(struct spi_device *spi)
 	spi_set_drvdata(spi, indio_dev);
 
 	st->us = spi;
+	st->gpio = of_get_gpio(spi->dev.of_node, 0);
 	mutex_init(&st->buf_lock);
 	indio_dev->name = spi->dev.driver->name;
 	indio_dev->dev.parent = &spi->dev;
@@ -711,7 +713,7 @@ static int __devinit lis3l02dq_probe(struct spi_device *spi)
 		goto error_unreg_buffer_funcs;
 	}
 
-	if (spi->irq && gpio_is_valid(irq_to_gpio(spi->irq)) > 0) {
+	if (spi->irq) {
 		ret = request_threaded_irq(st->us->irq,
 					   &lis3l02dq_th,
 					   &lis3l02dq_event_handler,
@@ -738,10 +740,10 @@ static int __devinit lis3l02dq_probe(struct spi_device *spi)
 	return 0;
 
 error_remove_trigger:
-	if (spi->irq && gpio_is_valid(irq_to_gpio(spi->irq)))
+	if (spi->irq)
 		lis3l02dq_remove_trigger(indio_dev);
 error_free_interrupt:
-	if (spi->irq && gpio_is_valid(irq_to_gpio(spi->irq)) > 0)
+	if (spi->irq)
 		free_irq(st->us->irq, indio_dev);
 error_uninitialize_buffer:
 	iio_buffer_unregister(indio_dev);
@@ -790,7 +792,7 @@ static int __devexit lis3l02dq_remove(struct spi_device *spi)
 	lis3l02dq_disable_all_events(indio_dev);
 	lis3l02dq_stop_device(indio_dev);
 
-	if (spi->irq && gpio_is_valid(irq_to_gpio(spi->irq)) > 0)
+	if (spi->irq)
 		free_irq(st->us->irq, indio_dev);
 
 	lis3l02dq_remove_trigger(indio_dev);
diff --git a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging/iio/accel/lis3l02dq_ring.c
index fa4190d..13c0b4b 100644
--- a/drivers/staging/iio/accel/lis3l02dq_ring.c
+++ b/drivers/staging/iio/accel/lis3l02dq_ring.c
@@ -263,7 +263,7 @@ static int lis3l02dq_trig_try_reen(struct iio_trigger *trig)
 	/* If gpio still high (or high again)
 	 * In theory possible we will need to do this several times */
 	for (i = 0; i < 5; i++)
-		if (gpio_get_value(irq_to_gpio(st->us->irq)))
+		if (gpio_get_value(st->gpio))
 			lis3l02dq_read_all(indio_dev, NULL);
 		else
 			break;
-- 
1.7.10

