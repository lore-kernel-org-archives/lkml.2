Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933834Ab1J1XWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 19:22:18 -0400
Received: from smtp-out.google.com ([74.125.121.67]:19830 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab1J1XWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 19:22:16 -0400
From: Bryan Freed <bfreed@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: sergiu@chromium.org, akpm@linux-foundation.org, msb@chromium.org,
        marco.stornelli@gmail.com, seiji.aguchi@hds.com,
        Bryan Freed <bfreed@chromium.org>
Subject: [PATCH] ramoops: Add support for ARM systems.
Date: Fri, 28 Oct 2011 16:21:50 -0700
Message-Id: <1319844110-23062-2-git-send-email-bfreed@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319844110-23062-1-git-send-email-bfreed@chromium.org>
References: <1319844110-23062-1-git-send-email-bfreed@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ramoops driver erroneously (I belive) uses ioremap() to map physical RAM
to a virtual address.  This happens to work on x86 which has this additional
support, but it does not work on ARM.

Add support for ARM by using xlate_dev_mem_ptr() for systems (like ARM) where
page_is_ram() returns true.  This is what the /dev/mem driver uses, and we use
that driver to access the data.

Signed-off-by: Bryan Freed <bfreed@chromium.org>
---
 drivers/char/ramoops.c |   67 +++++++++++++++++++++++++++++++++++++----------
 1 files changed, 52 insertions(+), 15 deletions(-)

diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index 810aff9..7c50309 100644
--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
@@ -31,6 +31,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/ramoops.h>
+#include <linux/mm.h>
 
 #define RAMOOPS_KERNMSG_HDR "===="
 #define MIN_MEM_SIZE 4096UL
@@ -113,6 +114,53 @@ static void ramoops_do_dump(struct kmsg_dumper *dumper,
 	cxt->count = (cxt->count + 1) % cxt->max_count;
 }
 
+void __weak unxlate_dev_mem_ptr(unsigned long phys, void *addr)
+{
+}
+
+/*
+ * For systems that recognize the region as RAM (eg, ARM), the
+ * region is already reserved and mapped.  Just xlate it here
+ * as /dev/mem does it in drivers/char/mem.c.
+ *
+ * For systems that do not recognize the region as RAM (eg, x86),
+ * reserve and map the region here so /dev/mem can xlate it.
+ */
+static int map_context(struct ramoops_context *cxt)
+{
+	if (page_is_ram(cxt->phys_addr << PAGE_SHIFT)) {
+		cxt->virt_addr = xlate_dev_mem_ptr(cxt->phys_addr);
+		if (!cxt->virt_addr) {
+			pr_err("xlate_dev_mem_ptr failed\n");
+			return -EINVAL;
+		}
+	} else {
+		if (!request_mem_region(cxt->phys_addr, cxt->size, "ramoops")) {
+			pr_err("request mem region failed\n");
+			return -EINVAL;
+		}
+
+		cxt->virt_addr = ioremap(cxt->phys_addr,  cxt->size);
+		if (!cxt->virt_addr) {
+			pr_err("ioremap failed\n");
+			release_mem_region(cxt->phys_addr, cxt->size);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static void unmap_context(struct ramoops_context *cxt)
+{
+	if (page_is_ram(cxt->phys_addr << PAGE_SHIFT)) {
+		unxlate_dev_mem_ptr(cxt->phys_addr, cxt->virt_addr);
+	} else {
+		iounmap(cxt->virt_addr);
+		release_mem_region(cxt->phys_addr, cxt->size);
+	}
+}
+
 static int __init ramoops_probe(struct platform_device *pdev)
 {
 	struct ramoops_platform_data *pdata = pdev->dev.platform_data;
@@ -156,17 +204,9 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	record_size = pdata->record_size;
 	dump_oops = pdata->dump_oops;
 
-	if (!request_mem_region(cxt->phys_addr, cxt->size, "ramoops")) {
-		pr_err("request mem region failed\n");
-		err = -EINVAL;
+	err = map_context(cxt);
+	if (err)
 		goto fail3;
-	}
-
-	cxt->virt_addr = ioremap(cxt->phys_addr,  cxt->size);
-	if (!cxt->virt_addr) {
-		pr_err("ioremap failed\n");
-		goto fail2;
-	}
 
 	cxt->dump.dump = ramoops_do_dump;
 	err = kmsg_dump_register(&cxt->dump);
@@ -178,9 +218,7 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	return 0;
 
 fail1:
-	iounmap(cxt->virt_addr);
-fail2:
-	release_mem_region(cxt->phys_addr, cxt->size);
+	unmap_context(cxt);
 fail3:
 	return err;
 }
@@ -192,8 +230,7 @@ static int __exit ramoops_remove(struct platform_device *pdev)
 	if (kmsg_dump_unregister(&cxt->dump) < 0)
 		pr_warn("could not unregister kmsg_dumper\n");
 
-	iounmap(cxt->virt_addr);
-	release_mem_region(cxt->phys_addr, cxt->size);
+	unmap_context(cxt);
 	return 0;
 }
 
-- 
1.7.3.1

