Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011Ab1FGQz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 12:55:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42695 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab1FGQz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 12:55:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uT/4JkNWzTQkbDvAeNBCptyW/Q9L1KIf4ZHrrVjpfk6QC9YyIN0rc1TwjxIfiaHsGy
         PI6AuASDda2Ok82TXvYoqGzLy2tLia5Z9RpFPRZ+q6jz9Ne2G7X5prl9luWzHp4FP/va
         rzPX1C/VXSI79GzGKfuZPE9mL86WKF6I94bFo=
Message-ID: <4DEE56AF.1040601@gmail.com>
Date: Tue, 07 Jun 2011 18:49:51 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: kyungmin.park@samsung.com, stevie.trujillo@gmail.com,
        xiyou.wangcong@gmail.com
Subject: [PATCH 1/2 v3] ramoops: use module parameters instead of platform
 data if not available
References: <4DE0B9D8.3020405@gmail.com> <4DE10B4D.50501@gmail.com>
In-Reply-To: <4DE10B4D.50501@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Use generic module parameters instead of platform data, if platform
data are not available. This limitation has been introduced with
commit c3b92ce9e75f6353104fc7f8e32fb9fdb2550ad0.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
CC: Kyungmin Park <kyungmin.park@samsung.com>
CC: Américo Wang <xiyou.wangcong@gmail.com>
Reported-by: Stevie Trujillo <stevie.trujillo@gmail.com>
---
ChangeLog
- v3: add a check for kzalloc return value;
      removed cast for kzalloc return value
- v2: fixed tab/space problem

diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index 1a9f5f6..df092e1 100644
--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
@@ -26,6 +26,7 @@
 #include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <linux/ramoops.h>
 
 #define RAMOOPS_KERNMSG_HDR "===="
@@ -56,6 +57,9 @@ static struct ramoops_context {
 	int max_count;
 } oops_cxt;
 
+static struct platform_device *dummy;
+static struct ramoops_platform_data *dummy_data;
+
 static void ramoops_do_dump(struct kmsg_dumper *dumper,
 		enum kmsg_dump_reason reason, const char *s1, unsigned long l1,
 		const char *s2, unsigned long l2)
@@ -106,27 +110,22 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	struct ramoops_context *cxt = &oops_cxt;
 	int err = -EINVAL;
 
-	if (pdata) {
-		mem_size = pdata->mem_size;
-		mem_address = pdata->mem_address;
-	}
-
-	if (!mem_size) {
+	if (!pdata->mem_size) {
 		printk(KERN_ERR "ramoops: invalid size specification");
 		goto fail3;
 	}
 
-	rounddown_pow_of_two(mem_size);
+	rounddown_pow_of_two(pdata->mem_size);
 
-	if (mem_size < RECORD_SIZE) {
+	if (pdata->mem_size < RECORD_SIZE) {
 		printk(KERN_ERR "ramoops: size too small");
 		goto fail3;
 	}
 
-	cxt->max_count = mem_size / RECORD_SIZE;
+	cxt->max_count = pdata->mem_size / RECORD_SIZE;
 	cxt->count = 0;
-	cxt->size = mem_size;
-	cxt->phys_addr = mem_address;
+	cxt->size = pdata->mem_size;
+	cxt->phys_addr = pdata->mem_address;
 
 	if (!request_mem_region(cxt->phys_addr, cxt->size, "ramoops")) {
 		printk(KERN_ERR "ramoops: request mem region failed");
@@ -179,12 +178,37 @@ static struct platform_driver ramoops_driver = {
 
 static int __init ramoops_init(void)
 {
-	return platform_driver_probe(&ramoops_driver, ramoops_probe);
+	int ret;
+	ret = platform_driver_probe(&ramoops_driver, ramoops_probe);
+	if (ret == -ENODEV)
+	{
+		/* 
+		 * if we didn't find a platform device, we use module parameters
+		 * building platform data on the fly.
+		 */
+		dummy_data = kzalloc(sizeof(struct ramoops_platform_data),
+				     GFP_KERNEL);
+		if (!dummy_data)
+			return -ENOMEM;
+		dummy_data->mem_size = mem_size;
+		dummy_data->mem_address = mem_address;
+		dummy = platform_create_bundle(&ramoops_driver, ramoops_probe,
+			NULL, 0, dummy_data,
+			sizeof(struct ramoops_platform_data));
+
+		if (IS_ERR(dummy)) 
+			ret = PTR_ERR(dummy);
+		else
+			ret = 0;
+	}
+	
+	return ret;
 }
 
 static void __exit ramoops_exit(void)
 {
 	platform_driver_unregister(&ramoops_driver);
+	kfree(dummy_data);
 }
 
 module_init(ramoops_init);

