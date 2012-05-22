Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837Ab2EVOWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:22:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33962 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758668Ab2EVOUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:20:34 -0400
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
Subject: [PATCH 08/16] pstore/ram: Factor dmesg przs initialization out of probe()
Date: Tue, 22 May 2012 07:17:51 -0700
Message-Id: <1337696279-8994-8-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <20120522141717.GA31574@lizard>
References: <20120522141717.GA31574@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will help make code clearer when we'll add support for other
message types.

This also makes probe() much shorter and understandable, plus
makes mem/record size checking a bit easier.

Implementation detail: we now use a paddr pointer, this will
be used for allocating persistent ram zones for other message
types.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/ram.c |  105 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 66 insertions(+), 39 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index cdaeda9..9785c84 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -203,13 +203,67 @@ static struct ramoops_context oops_cxt = {
 	},
 };
 
+static void ramoops_free_przs(struct ramoops_context *cxt)
+{
+	int i;
+
+	if (!cxt->przs)
+		return;
+
+	for (i = 0; cxt->przs[i]; i++)
+		persistent_ram_free(cxt->przs[i]);
+	kfree(cxt->przs);
+}
+
+static int ramoops_init_przs(struct device *dev, struct ramoops_context *cxt,
+			      phys_addr_t *paddr, size_t dump_mem_sz)
+{
+	int err = -ENOMEM;
+	int i;
+
+	if (!cxt->record_size)
+		return 0;
+
+	cxt->max_dump_count = dump_mem_sz / cxt->record_size;
+	if (!cxt->max_dump_count)
+		return -ENOMEM;
+
+	cxt->przs = kzalloc(sizeof(*cxt->przs) * cxt->max_dump_count,
+			     GFP_KERNEL);
+	if (!cxt->przs) {
+		dev_err(dev, "failed to initialize a prz array for dumps\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < cxt->max_dump_count; i++) {
+		size_t sz = cxt->record_size;
+
+		cxt->przs[i] = persistent_ram_new(*paddr, sz, cxt->ecc);
+		if (IS_ERR(cxt->przs[i])) {
+			err = PTR_ERR(cxt->przs[i]);
+			dev_err(dev, "failed to request mem region (0x%zx@0x%llx): %d\n",
+				sz, (unsigned long long)*paddr, err);
+			goto fail_prz;
+		}
+		*paddr += sz;
+	}
+
+	cxt->max_count += cxt->max_dump_count;
+
+	return 0;
+fail_prz:
+	ramoops_free_przs(cxt);
+	return err;
+}
+
 static int __init ramoops_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct ramoops_platform_data *pdata = pdev->dev.platform_data;
 	struct ramoops_context *cxt = &oops_cxt;
+	size_t dump_mem_sz;
+	phys_addr_t paddr;
 	int err = -EINVAL;
-	int i;
 
 	/* Only a single ramoops area allowed at a time, so fail extra
 	 * probes.
@@ -226,22 +280,7 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	pdata->mem_size = rounddown_pow_of_two(pdata->mem_size);
 	pdata->record_size = rounddown_pow_of_two(pdata->record_size);
 
-	/* Check for the minimum memory size */
-	if (pdata->mem_size < MIN_MEM_SIZE &&
-			pdata->record_size < MIN_MEM_SIZE) {
-		pr_err("memory size too small, minimum is %lu\n",
-			MIN_MEM_SIZE);
-		goto fail_out;
-	}
-
-	if (pdata->mem_size < pdata->record_size) {
-		pr_err("The memory size must be larger than the "
-			"records size\n");
-		goto fail_out;
-	}
-
-	cxt->max_count = pdata->mem_size / pdata->record_size;
-	cxt->max_dump_count = cxt->max_count;
+	cxt->max_count = 0;
 	cxt->count = 0;
 	cxt->size = pdata->mem_size;
 	cxt->phys_addr = pdata->mem_address;
@@ -249,24 +288,14 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	cxt->dump_oops = pdata->dump_oops;
 	cxt->ecc = pdata->ecc;
 
-	cxt->przs = kzalloc(sizeof(*cxt->przs) * cxt->max_dump_count, GFP_KERNEL);
-	if (!cxt->przs) {
-		err = -ENOMEM;
-		dev_err(dev, "failed to initialize a prz array\n");
-		goto fail_out;
-	}
-
-	for (i = 0; i < cxt->max_dump_count; i++) {
-		size_t sz = cxt->record_size;
-		phys_addr_t start = cxt->phys_addr + sz * i;
+	paddr = cxt->phys_addr;
 
-		cxt->przs[i] = persistent_ram_new(start, sz, cxt->ecc);
-		if (IS_ERR(cxt->przs[i])) {
-			err = PTR_ERR(cxt->przs[i]);
-			dev_err(dev, "failed to request mem region (0x%zx@0x%llx): %d\n",
-				sz, (unsigned long long)start, err);
-			goto fail_przs;
-		}
+	dump_mem_sz = cxt->size;
+	err = ramoops_init_przs(dev, cxt, &paddr, dump_mem_sz);
+	if (err) {
+		pr_err("memory size too small, minimum is %lu\n",
+			cxt->record_size);
+		goto fail_count;
 	}
 
 	cxt->pstore.data = cxt;
@@ -279,7 +308,7 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	}
 
 	err = pstore_register(&cxt->pstore);
-	if (err) {
+	if (err || !cxt->max_count) {
 		pr_err("registering with pstore failed\n");
 		goto fail_buf;
 	}
@@ -306,10 +335,8 @@ fail_clear:
 	cxt->pstore.bufsize = 0;
 	cxt->max_count = 0;
 	cxt->max_dump_count = 0;
-fail_przs:
-	for (i = 0; cxt->przs[i]; i++)
-		persistent_ram_free(cxt->przs[i]);
-	kfree(cxt->przs);
+fail_count:
+	ramoops_free_przs(cxt);
 fail_out:
 	return err;
 }
-- 
1.7.9.2

