Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab1KPV0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 16:26:05 -0500
Received: from smtp.outflux.net ([198.145.64.163]:47186 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874Ab1KPV0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 16:26:00 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ben Gardner <bgardner@wabtec.com>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 2/2] ramoops: remove module parameters
Date: Wed, 16 Nov 2011 13:25:39 -0800
Message-Id: <1321478739-8978-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321478739-8978-1-git-send-email-keescook@chromium.org>
References: <1321478739-8978-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ramoops driver is intended to be used with platforms that define
persistent memory regions. If memory regions were configurable with
module parameters, it would be possible to read some RAM regions via
the pstore interface without access to /dev/mem (which would result
in a loss of kernel memory privacy when a system is built with
STRICT_DEVMEM), so remove this ability completely.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/char/ramoops.c |   53 +-----------------------------------------------
 1 files changed, 1 insertions(+), 52 deletions(-)

diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index 129d79a..2cc2177 100644
--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
@@ -37,21 +37,6 @@
 #define RAMOOPS_KERNMSG_HDR "===="
 #define MIN_MEM_SIZE 4096UL
 
-static ulong record_size = MIN_MEM_SIZE;
-module_param(record_size, ulong, 0400);
-MODULE_PARM_DESC(record_size,
-		"size of each dump done on oops/panic");
-
-static ulong mem_address;
-module_param(mem_address, ulong, 0400);
-MODULE_PARM_DESC(mem_address,
-		"start of reserved RAM used to store oops/panic logs");
-
-static ulong mem_size;
-module_param(mem_size, ulong, 0400);
-MODULE_PARM_DESC(mem_size,
-		"size of reserved RAM used to store oops/panic logs");
-
 static int ramoops_pstore_open(struct pstore_info *psi);
 static int ramoops_pstore_close(struct pstore_info *psi);
 static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
@@ -76,9 +61,6 @@ struct ramoops_context {
 	struct pstore_info pstore;
 };
 
-static struct platform_device *dummy;
-static struct ramoops_platform_data *dummy_data;
-
 static struct ramoops_context oops_cxt = {
 	.pstore = {
 		.owner	= THIS_MODULE,
@@ -237,13 +219,6 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	cxt->size = pdata->mem_size;
 	cxt->phys_addr = pdata->mem_address;
 	cxt->record_size = pdata->record_size;
-	/*
-	 * Update the module parameter variables as well so they are visible
-	 * through /sys/module/ramoops/parameters/
-	 */
-	mem_size = pdata->mem_size;
-	mem_address = pdata->mem_address;
-	record_size = pdata->record_size;
 
 	cxt->pstore.bufsize = cxt->record_size;
 	cxt->pstore.buf = kmalloc(cxt->pstore.bufsize, GFP_KERNEL);
@@ -316,38 +291,12 @@ static struct platform_driver ramoops_driver = {
 
 static int __init ramoops_init(void)
 {
-	int ret;
-	ret = platform_driver_probe(&ramoops_driver, ramoops_probe);
-	if (ret == -ENODEV) {
-		/*
-		 * If we didn't find a platform device, we use module parameters
-		 * building platform data on the fly.
-		 */
-		pr_info("platform device not found, using module parameters\n");
-		dummy_data = kzalloc(sizeof(struct ramoops_platform_data),
-				     GFP_KERNEL);
-		if (!dummy_data)
-			return -ENOMEM;
-		dummy_data->mem_size = mem_size;
-		dummy_data->mem_address = mem_address;
-		dummy_data->record_size = record_size;
-		dummy = platform_create_bundle(&ramoops_driver, ramoops_probe,
-			NULL, 0, dummy_data,
-			sizeof(struct ramoops_platform_data));
-
-		if (IS_ERR(dummy))
-			ret = PTR_ERR(dummy);
-		else
-			ret = 0;
-	}
-
-	return ret;
+	return platform_driver_probe(&ramoops_driver, ramoops_probe);
 }
 
 static void __exit ramoops_exit(void)
 {
 	platform_driver_unregister(&ramoops_driver);
-	kfree(dummy_data);
 }
 
 module_init(ramoops_init);
-- 
1.7.0.4

