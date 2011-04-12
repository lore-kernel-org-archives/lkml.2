Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab1DLO4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:56:18 -0400
Received: from kroah.org ([198.145.64.141]:57470 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757172Ab1DLOht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:37:49 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:50 2011
Message-Id: <20110412143550.724467233@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Julia Lawall <julia@diku.dk>, Wim Van Sebroeck <wim@iguana.be>
Subject: [026/105] watchdog: s3c2410_wdt.c: Convert release_resource to release_region/release_mem_region
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Julia Lawall <julia@diku.dk>

commit f72401e94d159bc4b2beab51d74e956da2c32e0a upstream.

Request_mem_region should be used with release_mem_region, not
release_resource.

The semantic match that finds this problem is as follows:
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
 drivers/watchdog/s3c2410_wdt.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -402,7 +402,6 @@ static inline void s3c2410wdt_cpufreq_de
 
 static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 {
-	struct resource *res;
 	struct device *dev;
 	unsigned int wtcon;
 	int started = 0;
@@ -416,20 +415,19 @@ static int __devinit s3c2410wdt_probe(st
 
 	/* get the memory region for the watchdog timer */
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
+	wdt_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (wdt_mem == NULL) {
 		dev_err(dev, "no memory resource specified\n");
 		return -ENOENT;
 	}
 
-	size = resource_size(res);
-	wdt_mem = request_mem_region(res->start, size, pdev->name);
-	if (wdt_mem == NULL) {
+	size = resource_size(wdt_mem);
+	if (!request_mem_region(wdt_mem->start, size, pdev->name)) {
 		dev_err(dev, "failed to get memory region\n");
 		return -EBUSY;
 	}
 
-	wdt_base = ioremap(res->start, size);
+	wdt_base = ioremap(wdt_mem->start, size);
 	if (wdt_base == NULL) {
 		dev_err(dev, "failed to ioremap() region\n");
 		ret = -EINVAL;
@@ -524,8 +522,8 @@ static int __devinit s3c2410wdt_probe(st
 	iounmap(wdt_base);
 
  err_req:
-	release_resource(wdt_mem);
-	kfree(wdt_mem);
+	release_mem_region(wdt_mem->start, size);
+	wdt_mem = NULL;
 
 	return ret;
 }
@@ -545,8 +543,7 @@ static int __devexit s3c2410wdt_remove(s
 
 	iounmap(wdt_base);
 
-	release_resource(wdt_mem);
-	kfree(wdt_mem);
+	release_mem_region(wdt_mem->start, resource_size(wdt_mem));
 	wdt_mem = NULL;
 	return 0;
 }


