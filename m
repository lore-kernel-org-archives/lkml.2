Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab1DLOzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:55:42 -0400
Received: from kroah.org ([198.145.64.141]:57477 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069Ab1DLOhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:37:50 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:50 2011
Message-Id: <20110412143550.829232674@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Julia Lawall <julia@diku.dk>, Wim Van Sebroeck <wim@iguana.be>
Subject: [027/105] watchdog: Convert release_resource to release_region/release_mem_region
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Julia Lawall <julia@diku.dk>

commit f712eacf02ecfbf4f1686addb8c569841549b0b7 upstream.

Request_mem_region should be used with release_mem_region, not
release_resource.

In pnx4008_wdt.c, a missing clk_put is added as well.

The semantic match that finds the first problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,E;
@@
*x = request_mem_region(...)
... when != release_mem_region(x)
    when != x = E
* release_resource(x);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/watchdog/davinci_wdt.c |   22 ++++++++++------------
 drivers/watchdog/max63xx_wdt.c |   20 ++++++++------------
 drivers/watchdog/pnx4008_wdt.c |   28 +++++++++++++---------------
 3 files changed, 31 insertions(+), 39 deletions(-)

--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -202,7 +202,6 @@ static struct miscdevice davinci_wdt_mis
 static int __devinit davinci_wdt_probe(struct platform_device *pdev)
 {
 	int ret = 0, size;
-	struct resource *res;
 	struct device *dev = &pdev->dev;
 
 	wdt_clk = clk_get(dev, NULL);
@@ -216,31 +215,31 @@ static int __devinit davinci_wdt_probe(s
 
 	dev_info(dev, "heartbeat %d sec\n", heartbeat);
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
+	wdt_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (wdt_mem == NULL) {
 		dev_err(dev, "failed to get memory region resource\n");
 		return -ENOENT;
 	}
 
-	size = resource_size(res);
-	wdt_mem = request_mem_region(res->start, size, pdev->name);
-
-	if (wdt_mem == NULL) {
+	size = resource_size(wdt_mem);
+	if (!request_mem_region(wdt_mem->start, size, pdev->name)) {
 		dev_err(dev, "failed to get memory region\n");
 		return -ENOENT;
 	}
 
-	wdt_base = ioremap(res->start, size);
+	wdt_base = ioremap(wdt_mem->start, size);
 	if (!wdt_base) {
 		dev_err(dev, "failed to map memory region\n");
+		release_mem_region(wdt_mem->start, size);
+		wdt_mem = NULL;
 		return -ENOMEM;
 	}
 
 	ret = misc_register(&davinci_wdt_miscdev);
 	if (ret < 0) {
 		dev_err(dev, "cannot register misc device\n");
-		release_resource(wdt_mem);
-		kfree(wdt_mem);
+		release_mem_region(wdt_mem->start, size);
+		wdt_mem = NULL;
 	} else {
 		set_bit(WDT_DEVICE_INITED, &wdt_status);
 	}
@@ -253,8 +252,7 @@ static int __devexit davinci_wdt_remove(
 {
 	misc_deregister(&davinci_wdt_miscdev);
 	if (wdt_mem) {
-		release_resource(wdt_mem);
-		kfree(wdt_mem);
+		release_mem_region(wdt_mem->start, resource_size(wdt_mem));
 		wdt_mem = NULL;
 	}
 
--- a/drivers/watchdog/max63xx_wdt.c
+++ b/drivers/watchdog/max63xx_wdt.c
@@ -270,7 +270,6 @@ static int __devinit max63xx_wdt_probe(s
 {
 	int ret = 0;
 	int size;
-	struct resource *res;
 	struct device *dev = &pdev->dev;
 	struct max63xx_timeout *table;
 
@@ -294,21 +293,19 @@ static int __devinit max63xx_wdt_probe(s
 
 	max63xx_pdev = pdev;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
+	wdt_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (wdt_mem == NULL) {
 		dev_err(dev, "failed to get memory region resource\n");
 		return -ENOENT;
 	}
 
-	size = resource_size(res);
-	wdt_mem = request_mem_region(res->start, size, pdev->name);
-
-	if (wdt_mem == NULL) {
+	size = resource_size(wdt_mem);
+	if (!request_mem_region(wdt_mem->start, size, pdev->name)) {
 		dev_err(dev, "failed to get memory region\n");
 		return -ENOENT;
 	}
 
-	wdt_base = ioremap(res->start, size);
+	wdt_base = ioremap(wdt_mem->start, size);
 	if (!wdt_base) {
 		dev_err(dev, "failed to map memory region\n");
 		ret = -ENOMEM;
@@ -326,8 +323,8 @@ static int __devinit max63xx_wdt_probe(s
 out_unmap:
 	iounmap(wdt_base);
 out_request:
-	release_resource(wdt_mem);
-	kfree(wdt_mem);
+	release_mem_region(wdt_mem->start, size);
+	wdt_mem = NULL;
 
 	return ret;
 }
@@ -336,8 +333,7 @@ static int __devexit max63xx_wdt_remove(
 {
 	misc_deregister(&max63xx_wdt_miscdev);
 	if (wdt_mem) {
-		release_resource(wdt_mem);
-		kfree(wdt_mem);
+		release_mem_region(wdt_mem->start, resource_size(wdt_mem));
 		wdt_mem = NULL;
 	}
 
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -254,7 +254,6 @@ static struct miscdevice pnx4008_wdt_mis
 static int __devinit pnx4008_wdt_probe(struct platform_device *pdev)
 {
 	int ret = 0, size;
-	struct resource *res;
 
 	if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
 		heartbeat = DEFAULT_HEARTBEAT;
@@ -262,42 +261,42 @@ static int __devinit pnx4008_wdt_probe(s
 	printk(KERN_INFO MODULE_NAME
 		"PNX4008 Watchdog Timer: heartbeat %d sec\n", heartbeat);
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
+	wdt_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (wdt_mem == NULL) {
 		printk(KERN_INFO MODULE_NAME
 			"failed to get memory region resouce\n");
 		return -ENOENT;
 	}
 
-	size = resource_size(res);
-	wdt_mem = request_mem_region(res->start, size, pdev->name);
+	size = resource_size(wdt_mem);
 
-	if (wdt_mem == NULL) {
+	if (!request_mem_region(wdt_mem->start, size, pdev->name)) {
 		printk(KERN_INFO MODULE_NAME "failed to get memory region\n");
 		return -ENOENT;
 	}
-	wdt_base = (void __iomem *)IO_ADDRESS(res->start);
+	wdt_base = (void __iomem *)IO_ADDRESS(wdt_mem->start);
 
 	wdt_clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(wdt_clk)) {
 		ret = PTR_ERR(wdt_clk);
-		release_resource(wdt_mem);
-		kfree(wdt_mem);
+		release_mem_region(wdt_mem->start, size);
+		wdt_mem = NULL;
 		goto out;
 	}
 
 	ret = clk_enable(wdt_clk);
 	if (ret) {
-		release_resource(wdt_mem);
-		kfree(wdt_mem);
+		release_mem_region(wdt_mem->start, size);
+		wdt_mem = NULL;
+		clk_put(wdt_clk);
 		goto out;
 	}
 
 	ret = misc_register(&pnx4008_wdt_miscdev);
 	if (ret < 0) {
 		printk(KERN_ERR MODULE_NAME "cannot register misc device\n");
-		release_resource(wdt_mem);
-		kfree(wdt_mem);
+		release_mem_region(wdt_mem->start, size);
+		wdt_mem = NULL;
 		clk_disable(wdt_clk);
 		clk_put(wdt_clk);
 	} else {
@@ -320,8 +319,7 @@ static int __devexit pnx4008_wdt_remove(
 	clk_put(wdt_clk);
 
 	if (wdt_mem) {
-		release_resource(wdt_mem);
-		kfree(wdt_mem);
+		release_mem_region(wdt_mem->start, resource_size(wdt_mem));
 		wdt_mem = NULL;
 	}
 	return 0;


