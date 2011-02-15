Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab1BOGMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 01:12:53 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46533 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab1BOGL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 01:11:59 -0500
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-omap@vger.kernel.org,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Alexander Shishkin <virtuoso@slind.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] ARM: etm: Add some missing locks and error checks
Date: Mon, 14 Feb 2011 22:11:14 -0800
Message-Id: <1297750276-12475-6-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1296701663-12168-1-git-send-email-arve@android.com>
References: <1296701663-12168-1-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not safe to call etm_lock or etb_lock without holding the
mutex since another thread may also have unlocked the registers.

Also add some missing checks for valid etb_regs in the etm sysfs
entries.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 arch/arm/kernel/etm.c |   57 +++++++++++++++++++++++++++++++++---------------
 1 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 96b1abb..8126beb 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -263,8 +263,13 @@ static void etm_dump(void)
 
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
@@ -373,6 +378,7 @@ static int __init etb_probe(struct amba_device *dev, struct amba_id *id)
 	if (ret)
 		goto out;
 
+	mutex_lock(&t->mutex);
 	t->etb_regs = ioremap_nocache(dev->res.start, resource_size(&dev->res));
 	if (!t->etb_regs) {
 		ret = -ENOMEM;
@@ -381,6 +387,16 @@ static int __init etb_probe(struct amba_device *dev, struct amba_id *id)
 
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
@@ -394,25 +410,19 @@ static int __init etb_probe(struct amba_device *dev, struct amba_id *id)
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
@@ -474,7 +484,10 @@ static ssize_t trace_running_store(struct kobject *kobj,
 		return -EINVAL;
 
 	mutex_lock(&tracer.mutex);
-	ret = value ? trace_start(&tracer) : trace_stop(&tracer);
+	if (!tracer.etb_regs)
+		ret = -ENODEV;
+	else
+		ret = value ? trace_start(&tracer) : trace_stop(&tracer);
 	mutex_unlock(&tracer.mutex);
 
 	return ret ? : n;
@@ -490,18 +503,25 @@ static ssize_t trace_info_show(struct kobject *kobj,
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
@@ -651,7 +671,6 @@ static int __init etm_probe(struct amba_device *dev, struct amba_id *id)
 
 	amba_set_drvdata(dev, t);
 
-	mutex_init(&t->mutex);
 	t->dev = &dev->dev;
 	t->flags = TRACER_CYCLE_ACC | TRACER_TRACE_DATA;
 	t->etm_portsz = 1;
@@ -745,6 +764,8 @@ static int __init etm_init(void)
 {
 	int retval;
 
+	mutex_init(&tracer.mutex);
+
 	retval = amba_driver_register(&etb_driver);
 	if (retval) {
 		printk(KERN_ERR "Failed to register etb\n");
-- 
1.7.3.1

