Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384Ab2FTWtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 18:49:21 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:41271 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955Ab2FTWsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 18:48:39 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 06/15] ARM: etm: Add some missing locks and error checks
Date: Wed, 20 Jun 2012 18:47:38 -0400
Message-Id: <1340232467-6023-7-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
References: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062022-1780-0000-0000-000006A6DDE2
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000282; HX=3.00000190; KW=3.00000007;
 PH=3.00000001; SC=3.00000003; SDB=6.00149807; UDB=6.00034058; UTC=2012-06-20
 22:48:37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

It is not safe to call etm_lock or etb_lock without holding the
mutex since another thread may also have unlocked the registers.

Also add some missing checks for valid etb_regs in the etm sysfs
entries.

CC: Russell King <linux@arm.linux.org.uk>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/arm/kernel/etm.c |   57 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 18 deletions(-)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index c651cf9..3d21cf6 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -264,8 +264,13 @@ static void etm_dump(void)
 
 static void sysrq_etm_dump(int key)
 {
+	if (!mutex_trylock(&tracer.mutex)) {
+		printk(KERN_INFO "Tracing hardware busy\n");
+		return;
+	}
 	dev_dbg(tracer.dev, "Dumping ETB buffer\n");
 	etm_dump();
+	mutex_unlock(&tracer.mutex);
 }
 
 static struct sysrq_key_op sysrq_etm_op = {
@@ -374,6 +379,7 @@ static int __devinit etb_probe(struct amba_device *dev, const struct amba_id *id
 	if (ret)
 		goto out;
 
+	mutex_lock(&t->mutex);
 	t->etb_regs = ioremap_nocache(dev->res.start, resource_size(&dev->res));
 	if (!t->etb_regs) {
 		ret = -ENOMEM;
@@ -382,6 +388,16 @@ static int __devinit etb_probe(struct amba_device *dev, const struct amba_id *id
 
 	amba_set_drvdata(dev, t);
 
+	etb_unlock(t);
+	t->etb_bufsz = etb_readl(t, ETBR_DEPTH);
+	dev_dbg(&dev->dev, "Size: %x\n", t->etb_bufsz);
+
+	/* make sure trace capture is disabled */
+	etb_writel(t, 0, ETBR_CTRL);
+	etb_writel(t, 0x1000, ETBR_FORMATTERCTRL);
+	etb_lock(t);
+	mutex_unlock(&t->mutex);
+
 	etb_miscdev.parent = &dev->dev;
 
 	ret = misc_register(&etb_miscdev);
@@ -395,25 +411,19 @@ static int __devinit etb_probe(struct amba_device *dev, const struct amba_id *id
 	else
 		clk_enable(t->emu_clk);
 
-	etb_unlock(t);
-	t->etb_bufsz = etb_readl(t, ETBR_DEPTH);
-	dev_dbg(&dev->dev, "Size: %x\n", t->etb_bufsz);
-
-	/* make sure trace capture is disabled */
-	etb_writel(t, 0, ETBR_CTRL);
-	etb_writel(t, 0x1000, ETBR_FORMATTERCTRL);
-	etb_lock(t);
-
 	dev_dbg(&dev->dev, "ETB AMBA driver initialized.\n");
 
 out:
 	return ret;
 
 out_unmap:
+	mutex_lock(&t->mutex);
 	amba_set_drvdata(dev, NULL);
 	iounmap(t->etb_regs);
+	t->etb_regs = NULL;
 
 out_release:
+	mutex_unlock(&t->mutex);
 	amba_release_regions(dev);
 
 	return ret;
@@ -475,7 +485,10 @@ static ssize_t trace_running_store(struct kobject *kobj,
 		return -EINVAL;
 
 	mutex_lock(&tracer.mutex);
-	ret = value ? trace_start(&tracer) : trace_stop(&tracer);
+	if (!tracer.etb_regs)
+		ret = -ENODEV;
+	else
+		ret = value ? trace_start(&tracer) : trace_stop(&tracer);
 	mutex_unlock(&tracer.mutex);
 
 	return ret ? : n;
@@ -491,18 +504,25 @@ static ssize_t trace_info_show(struct kobject *kobj,
 	u32 etb_wa, etb_ra, etb_st, etb_fc, etm_ctrl, etm_st;
 	int datalen;
 
-	etb_unlock(&tracer);
-	datalen = etb_getdatalen(&tracer);
-	etb_wa = etb_readl(&tracer, ETBR_WRITEADDR);
-	etb_ra = etb_readl(&tracer, ETBR_READADDR);
-	etb_st = etb_readl(&tracer, ETBR_STATUS);
-	etb_fc = etb_readl(&tracer, ETBR_FORMATTERCTRL);
-	etb_lock(&tracer);
+	mutex_lock(&tracer.mutex);
+	if (tracer.etb_regs) {
+		etb_unlock(&tracer);
+		datalen = etb_getdatalen(&tracer);
+		etb_wa = etb_readl(&tracer, ETBR_WRITEADDR);
+		etb_ra = etb_readl(&tracer, ETBR_READADDR);
+		etb_st = etb_readl(&tracer, ETBR_STATUS);
+		etb_fc = etb_readl(&tracer, ETBR_FORMATTERCTRL);
+		etb_lock(&tracer);
+	} else {
+		etb_wa = etb_ra = etb_st = etb_fc = ~0;
+		datalen = -1;
+	}
 
 	etm_unlock(&tracer);
 	etm_ctrl = etm_readl(&tracer, ETMR_CTRL);
 	etm_st = etm_readl(&tracer, ETMR_STATUS);
 	etm_lock(&tracer);
+	mutex_unlock(&tracer.mutex);
 
 	return sprintf(buf, "Trace buffer len: %d\nComparator pairs: %d\n"
 			"ETBR_WRITEADDR:\t%08x\n"
@@ -652,7 +672,6 @@ static int __devinit etm_probe(struct amba_device *dev, const struct amba_id *id
 
 	amba_set_drvdata(dev, t);
 
-	mutex_init(&t->mutex);
 	t->dev = &dev->dev;
 	t->flags = TRACER_CYCLE_ACC | TRACER_TRACE_DATA;
 	t->etm_portsz = 1;
@@ -746,6 +765,8 @@ static int __init etm_init(void)
 {
 	int retval;
 
+	mutex_init(&tracer.mutex);
+
 	retval = amba_driver_register(&etb_driver);
 	if (retval) {
 		printk(KERN_ERR "Failed to register etb\n");
-- 
1.7.9.5

