Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab0IGOfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:35:24 -0400
Received: from www.tglx.de ([62.245.132.106]:44005 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757179Ab0IGOep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:34:45 -0400
Message-Id: <20100907125057.470704521@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 14:33:57 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        lm-sensors@lm-sensors.org
Subject: [patch 29/30] hwmon: s3c-hwmon: Use a real mutex
References: <20100907124636.880953480@linutronix.de>
Content-Disposition: inline; filename=drivers-hwmon-s3c-hwmon-sema.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semaphore which protects the ADC is semantically a mutex. Use a
real mutex.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: lm-sensors@lm-sensors.org
---
 drivers/hwmon/s3c-hwmon.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/hwmon/s3c-hwmon.c
===================================================================
--- linux-2.6.orig/drivers/hwmon/s3c-hwmon.c
+++ linux-2.6/drivers/hwmon/s3c-hwmon.c
@@ -51,7 +51,7 @@ struct s3c_hwmon_attr {
  * @attr: The holders for the channel attributes.
 */
 struct s3c_hwmon {
-	struct semaphore	lock;
+	struct mutex		lock;
 	struct s3c_adc_client	*client;
 	struct device		*hwmon_dev;
 
@@ -73,14 +73,14 @@ static int s3c_hwmon_read_ch(struct devi
 {
 	int ret;
 
-	ret = down_interruptible(&hwmon->lock);
+	ret = mutex_lock_interruptible(&hwmon->lock);
 	if (ret < 0)
 		return ret;
 
 	dev_dbg(dev, "reading channel %d\n", channel);
 
 	ret = s3c_adc_read(hwmon->client, channel);
-	up(&hwmon->lock);
+	mutex_unlock(&hwmon->lock);
 
 	return ret;
 }
@@ -296,7 +296,7 @@ static int __devinit s3c_hwmon_probe(str
 
 	platform_set_drvdata(dev, hwmon);
 
-	init_MUTEX(&hwmon->lock);
+	mutex_init(&hwmon->lock);
 
 	/* Register with the core ADC driver. */
 


