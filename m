Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab2FSCR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 22:17:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50286 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab2FSCR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 22:17:58 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 1/7] pstore/ram: Probe as early as possible
Date: Mon, 18 Jun 2012 19:15:50 -0700
Message-Id: <1340072156-6225-1-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120619021050.GA19387@lizard>
References: <20120619021050.GA19387@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Registering the platform driver before module_init allows us to log oopses
that happen during device probing.

This requires changing module_init to postcore_initcall, and switching
from platform_driver_probe to platform_driver_register because the
platform device is not registered when the platform driver is registered;
and because we use driver_register, now can't use create_bundle() (since
it will try to register the same driver once again), so we have to switch
to platform_device_register_data().

Also, some __init -> __devinit changes were needed.

Overall, the registration logic is now much clearer, since we have only
one driver registration point, and just an optional dummy device, which
is created from the module parameters.

Suggested-by: Colin Cross <ccross@android.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/ram.c            |   63 ++++++++++++++++++++++----------------------
 fs/pstore/ram_core.c       |    9 ++++---
 include/linux/pstore_ram.h |    6 ++---
 3 files changed, 40 insertions(+), 38 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index c7acf94..0b36e91 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -330,7 +330,7 @@ static int ramoops_init_prz(struct device *dev, struct ramoops_context *cxt,
 	return 0;
 }
 
-static int __init ramoops_probe(struct platform_device *pdev)
+static int __devinit ramoops_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct ramoops_platform_data *pdata = pdev->dev.platform_data;
@@ -452,6 +452,7 @@ static int __exit ramoops_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver ramoops_driver = {
+	.probe		= ramoops_probe,
 	.remove		= __exit_p(ramoops_remove),
 	.driver		= {
 		.name	= "ramoops",
@@ -459,46 +460,46 @@ static struct platform_driver ramoops_driver = {
 	},
 };
 
-static int __init ramoops_init(void)
+static void ramoops_register_dummy(void)
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
-		dummy_data->console_size = ramoops_console_size;
-		dummy_data->dump_oops = dump_oops;
-		dummy_data->ecc = ramoops_ecc;
-		dummy = platform_create_bundle(&ramoops_driver, ramoops_probe,
-			NULL, 0, dummy_data,
-			sizeof(struct ramoops_platform_data));
-
-		if (IS_ERR(dummy))
-			ret = PTR_ERR(dummy);
-		else
-			ret = 0;
+	if (!mem_size)
+		return;
+
+	pr_info("using module parameters\n");
+
+	dummy_data = kzalloc(sizeof(*dummy_data), GFP_KERNEL);
+	if (!dummy_data) {
+		pr_info("could not allocate pdata\n");
+		return;
 	}
 
-	return ret;
+	dummy_data->mem_size = mem_size;
+	dummy_data->mem_address = mem_address;
+	dummy_data->record_size = record_size;
+	dummy_data->console_size = ramoops_console_size;
+	dummy_data->dump_oops = dump_oops;
+	dummy_data->ecc = ramoops_ecc;
+
+	dummy = platform_device_register_data(NULL, "ramoops", -1,
+			dummy_data, sizeof(struct ramoops_platform_data));
+	if (IS_ERR(dummy)) {
+		pr_info("could not create platform device: %ld\n",
+			PTR_ERR(dummy));
+	}
+}
+
+static int __init ramoops_init(void)
+{
+	ramoops_register_dummy();
+	return platform_driver_register(&ramoops_driver);
 }
+postcore_initcall(ramoops_init);
 
 static void __exit ramoops_exit(void)
 {
 	platform_driver_unregister(&ramoops_driver);
 	kfree(dummy_data);
 }
-
-module_init(ramoops_init);
 module_exit(ramoops_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index 0fd8161..2653185 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -390,7 +390,8 @@ static int persistent_ram_buffer_map(phys_addr_t start, phys_addr_t size,
 	return 0;
 }
 
-static int __init persistent_ram_post_init(struct persistent_ram_zone *prz, bool ecc)
+static int __devinit persistent_ram_post_init(struct persistent_ram_zone *prz,
+					      bool ecc)
 {
 	int ret;
 
@@ -436,9 +437,9 @@ void persistent_ram_free(struct persistent_ram_zone *prz)
 	kfree(prz);
 }
 
-struct persistent_ram_zone * __init persistent_ram_new(phys_addr_t start,
-						       size_t size,
-						       bool ecc)
+struct persistent_ram_zone * __devinit persistent_ram_new(phys_addr_t start,
+							  size_t size,
+							  bool ecc)
 {
 	struct persistent_ram_zone *prz;
 	int ret = -ENOMEM;
diff --git a/include/linux/pstore_ram.h b/include/linux/pstore_ram.h
index 2470bb5..e681af9 100644
--- a/include/linux/pstore_ram.h
+++ b/include/linux/pstore_ram.h
@@ -48,9 +48,9 @@ struct persistent_ram_zone {
 	size_t old_log_size;
 };
 
-struct persistent_ram_zone * __init persistent_ram_new(phys_addr_t start,
-						       size_t size,
-						       bool ecc);
+struct persistent_ram_zone * __devinit persistent_ram_new(phys_addr_t start,
+							  size_t size,
+							  bool ecc);
 void persistent_ram_free(struct persistent_ram_zone *prz);
 void persistent_ram_zap(struct persistent_ram_zone *prz);
 
-- 
1.7.10.4

