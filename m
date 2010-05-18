Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab0ERXrB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 19:47:01 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:47856 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab0ERXq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 19:46:58 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: linux-input@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Michael Roth <mroth@nessie.de>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] touchscreen: ads7846: please don't touch free'd memory
Date: Tue, 18 May 2010 16:46:53 -0700
Message-Id: <1274226413-8520-1-git-send-email-khilman@deeprootsystems.com>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the _probe() method fails, the 'ts' struct is freed, yet it is
still used as the drvdata passed to suspend/resume/remove methods.
Even though the input device does not get registerd, the driver's
suspend/resume methods still get called as it's a registered SPI
device.  This patch adds sanity checks to these methods to ensure that
drvdata is valid before using it.

Problem discovered when using lockdep since the ts->lock taken in
suspend & resume methods was left pointing into free'd memory if
_probe() fails.

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 drivers/input/touchscreen/ads7846.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index 532279c..1da2369 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -815,6 +815,9 @@ static int ads7846_suspend(struct spi_device *spi, pm_message_t message)
 {
 	struct ads7846 *ts = dev_get_drvdata(&spi->dev);
 
+	if (WARN_ON_ONCE(!ts))
+		return 0;
+
 	spin_lock_irq(&ts->lock);
 
 	ts->is_suspended = 1;
@@ -833,6 +836,9 @@ static int ads7846_resume(struct spi_device *spi)
 {
 	struct ads7846 *ts = dev_get_drvdata(&spi->dev);
 
+	if (WARN_ON_ONCE(!ts))
+		return 0;
+
 	if (device_may_wakeup(&ts->spi->dev))
 		disable_irq_wake(ts->spi->irq);
 
@@ -1231,6 +1237,7 @@ static int __devinit ads7846_probe(struct spi_device *spi)
 	input_free_device(input_dev);
 	kfree(packet);
 	kfree(ts);
+	dev_set_drvdata(&spi->dev, NULL);
 	return err;
 }
 
@@ -1240,6 +1247,9 @@ static int __devexit ads7846_remove(struct spi_device *spi)
 
 	device_init_wakeup(&spi->dev, false);
 
+	if (WARN_ON_ONCE(!ts))
+		return 0;
+
 	ads784x_hwmon_unregister(spi, ts);
 	input_unregister_device(ts->input);
 
-- 
1.7.0.2

