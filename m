Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933412Ab2EPMp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 08:45:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42353 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933188Ab2EPMp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 08:45:57 -0400
Date: Wed, 16 May 2012 05:44:27 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>
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
Subject: [PATCH 6/6] pstore/ram: Add ECC support
Message-ID: <20120516124427.GF18345@lizard>
References: <20120516124109.GA14658@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120516124109.GA14658@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is now straightforward: just introduce a module parameter and pass
the needed value to persistent_ram_new().

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Acked-by: Marco Stornelli <marco.stornelli@gmail.com>
Acked-by: Kees Cook <keescook@chromium.org>
---
 Documentation/ramoops.txt  |    6 ++++++
 fs/pstore/ram.c            |   15 ++++++++++++---
 include/linux/pstore_ram.h |    1 +
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/Documentation/ramoops.txt b/Documentation/ramoops.txt
index 470d2c4..4ba7db2 100644
--- a/Documentation/ramoops.txt
+++ b/Documentation/ramoops.txt
@@ -30,6 +30,11 @@ variable while setting 0 in that variable dumps only the panics.
 The module uses a counter to record multiple dumps but the counter gets reset
 on restart (i.e. new dumps after the restart will overwrite old ones).
 
+Ramoops also supports software ECC protection of persistent memory regions.
+This might be useful when a hardware reset was used to bring the machine back
+to life (i.e. a watchdog triggered). In such cases, RAM may be somewhat
+corrupt, but usually it is restorable.
+
 2. Setting the parameters
 
 Setting the ramoops parameters can be done in 2 different manners:
@@ -46,6 +51,7 @@ static struct ramoops_platform_data ramoops_data = {
         .mem_address            = <...>,
         .record_size            = <...>,
         .dump_oops              = <...>,
+        .ecc                    = <...>,
 };
 
 static struct platform_device ramoops_dev = {
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 62b13ed..9123cce 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -56,12 +56,18 @@ module_param(dump_oops, int, 0600);
 MODULE_PARM_DESC(dump_oops,
 		"set to 1 to dump oopses, 0 to only dump panics (default 1)");
 
+static int ramoops_ecc;
+module_param_named(ecc, ramoops_ecc, int, 0600);
+MODULE_PARM_DESC(ramoops_ecc,
+		"set to 1 to enable ECC support");
+
 struct ramoops_context {
 	struct persistent_ram_zone **przs;
 	phys_addr_t phys_addr;
 	unsigned long size;
 	size_t record_size;
 	int dump_oops;
+	bool ecc;
 	unsigned int count;
 	unsigned int max_count;
 	unsigned int read_count;
@@ -236,6 +242,7 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	cxt->phys_addr = pdata->mem_address;
 	cxt->record_size = pdata->record_size;
 	cxt->dump_oops = pdata->dump_oops;
+	cxt->ecc = pdata->ecc;
 
 	cxt->przs = kzalloc(sizeof(*cxt->przs) * cxt->max_count, GFP_KERNEL);
 	if (!cxt->przs) {
@@ -248,7 +255,7 @@ static int __init ramoops_probe(struct platform_device *pdev)
 		size_t sz = cxt->record_size;
 		phys_addr_t start = cxt->phys_addr + sz * i;
 
-		cxt->przs[i] = persistent_ram_new(start, sz, 0);
+		cxt->przs[i] = persistent_ram_new(start, sz, cxt->ecc);
 		if (IS_ERR(cxt->przs[i])) {
 			err = PTR_ERR(cxt->przs[i]);
 			dev_err(dev, "failed to request mem region (0x%zx@0x%llx): %d\n",
@@ -281,9 +288,10 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	record_size = pdata->record_size;
 	dump_oops = pdata->dump_oops;
 
-	pr_info("attached 0x%lx@0x%llx (%ux0x%zx)\n",
+	pr_info("attached 0x%lx@0x%llx (%ux0x%zx), ecc: %s\n",
 		cxt->size, (unsigned long long)cxt->phys_addr,
-		cxt->max_count, cxt->record_size);
+		cxt->max_count, cxt->record_size,
+		ramoops_ecc ? "on" : "off");
 
 	return 0;
 
@@ -347,6 +355,7 @@ static int __init ramoops_init(void)
 		dummy_data->mem_address = mem_address;
 		dummy_data->record_size = record_size;
 		dummy_data->dump_oops = dump_oops;
+		dummy_data->ecc = ramoops_ecc;
 		dummy = platform_create_bundle(&ramoops_driver, ramoops_probe,
 			NULL, 0, dummy_data,
 			sizeof(struct ramoops_platform_data));
diff --git a/include/linux/pstore_ram.h b/include/linux/pstore_ram.h
index ffe24a5..7ed7fd4 100644
--- a/include/linux/pstore_ram.h
+++ b/include/linux/pstore_ram.h
@@ -92,6 +92,7 @@ struct ramoops_platform_data {
 	unsigned long	mem_address;
 	unsigned long	record_size;
 	int		dump_oops;
+	bool		ecc;
 };
 
 #endif
-- 
1.7.9.2
