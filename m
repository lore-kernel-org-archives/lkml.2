Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab0HRIeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 04:34:04 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25333 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab0HRIeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 04:34:01 -0400
Date: Wed, 18 Aug 2010 17:33:46 +0900
From: Kyungmin Park <kmpark@infradead.org>
To: linux-kernel@vger.kernel.org, Marco Stornelli <marco.stornelli@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Ramoops: use the platform data structure instead of module
	params
Message-id: <20100818083346.GA6308@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 18 Aug 2010 08:33:53.0597 (UTC)
 FILETIME=[174846D0:01CB3EB0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

As each board and system has different memory for ramoops. It's better to define the platform data instead of module params.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index 74f00b5..eb7faba 100644
--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
@@ -25,6 +25,8 @@
 #include <linux/time.h>
 #include <linux/io.h>
 #include <linux/ioport.h>
+#include <linux/platform_device.h>
+#include <linux/ramoops.h>
 
 #define RAMOOPS_KERNMSG_HDR "===="
 #define RAMOOPS_HEADER_SIZE   (5 + sizeof(struct timeval))
@@ -91,11 +93,17 @@ static void ramoops_do_dump(struct kmsg_dumper *dumper,
 	cxt->count = (cxt->count + 1) % cxt->max_count;
 }
 
-static int __init ramoops_init(void)
+static int __init ramoops_probe(struct platform_device *pdev)
 {
+	struct ramoops_platform_data *pdata = pdev->dev.platform_data;
 	struct ramoops_context *cxt = &oops_cxt;
 	int err = -EINVAL;
 
+	if (pdata) {
+		mem_size = pdata->mem_size;
+		mem_address = pdata->mem_address;
+	}
+
 	if (!mem_size) {
 		printk(KERN_ERR "ramoops: invalid size specification");
 		goto fail3;
@@ -142,7 +150,7 @@ fail3:
 	return err;
 }
 
-static void __exit ramoops_exit(void)
+static void __exit ramoops_remove(void)
 {
 	struct ramoops_context *cxt = &oops_cxt;
 
@@ -153,6 +161,23 @@ static void __exit ramoops_exit(void)
 	release_mem_region(cxt->phys_addr, cxt->size);
 }
 
+static struct platform_driver ramoops_driver = {
+	.remove		= __exit_p(ramoops_remove),
+	.driver		= {
+		.name	= "ramoops",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init ramoops_init(void)
+{
+	return platform_driver_probe(&ramoops_driver, ramoops_probe);
+}
+
+static void __exit ramoops_exit(void)
+{
+	platform_driver_unregister(&ramoops_driver);
+}
 
 module_init(ramoops_init);
 module_exit(ramoops_exit);
diff --git a/include/linux/ramoops.h b/include/linux/ramoops.h
new file mode 100644
index 0000000..0ae68a2
--- /dev/null
+++ b/include/linux/ramoops.h
@@ -0,0 +1,15 @@
+#ifndef __RAMOOPS_H
+#define __RAMOOPS_H
+
+/*
+ * Ramoops platform data
+ * @mem_size	memory size for ramoops
+ * @mem_address	physical memory address to contain ramoops
+ */
+
+struct ramoops_platform_data {
+	unsigned long	mem_size;
+	unsigned long	mem_address;
+};
+
+#endif
