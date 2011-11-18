Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab1KRTdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 14:33:06 -0500
Received: from smtp.outflux.net ([198.145.64.163]:60344 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009Ab1KRTdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 14:33:03 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Chen Gong <gong.chen@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 2/2] ramoops: remove module parameters
Date: Fri, 18 Nov 2011 11:31:38 -0800
Message-Id: <1321644698-13677-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321644698-13677-1-git-send-email-keescook@chromium.org>
References: <1321644698-13677-1-git-send-email-keescook@chromium.org>
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
 Documentation/ramoops.txt |    7 +----
 drivers/char/ramoops.c    |   53 +--------------------------------------------
 2 files changed, 3 insertions(+), 57 deletions(-)

diff --git a/Documentation/ramoops.txt b/Documentation/ramoops.txt
index 6f6327a..260cb21 100644
--- a/Documentation/ramoops.txt
+++ b/Documentation/ramoops.txt
@@ -29,11 +29,8 @@ on restart (i.e. new dumps after the restart will overwrite old ones).
 
 2. Setting the parameters
 
-Setting the ramoops parameters can be done in 2 different manners:
- 1. Use the module parameters (which have the names of the variables described
- as before).
- 2. Use a platform device and set the platform data. The parameters can then
- be set through that platform data. An example of doing that is:
+Setting the ramoops parameters can be done via a platform device's platform
+data. An example of doing that is:
 
 #include <linux/ramoops.h>
 [...]
diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index e19c23c..064fe36 100644
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
 struct ramoops_context {
 	void *virt_addr;
 	phys_addr_t phys_addr;
@@ -63,9 +48,6 @@ struct ramoops_context {
 	struct pstore_info pstore;
 };
 
-static struct platform_device *dummy;
-static struct ramoops_platform_data *dummy_data;
-
 static int ramoops_pstore_open(struct pstore_info *psi)
 {
 	struct ramoops_context *cxt = (struct ramoops_context *)psi->data;
@@ -218,13 +200,6 @@ static int __init ramoops_probe(struct platform_device *pdev)
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
 
 	cxt->pstore.data = cxt;
 	cxt->pstore.bufsize = cxt->record_size;
@@ -299,38 +274,12 @@ static struct platform_driver ramoops_driver = {
 
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

