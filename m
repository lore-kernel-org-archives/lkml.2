Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab2EZNWZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 09:22:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44590 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab2EZNWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 09:22:22 -0400
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
Subject: [PATCH 03/11] pstore/ram: Factor dmesg przs initialization out of probe()
Date: Sat, 26 May 2012 06:20:21 -0700
Message-Id: <1338038429-21945-3-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <20120526131747.GA15054@lizard>
References: <20120526131747.GA15054@lizard>
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
Acked-by: Kees Cook <keescook@chromium.org>
---
 fs/pstore/ram.c |   99 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 62 insertions(+), 37 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 9b274b9..6b76767 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -202,13 +202,65 @@ static struct ramoops_context oops_cxt = {
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
+	cxt->max_dump_cnt = dump_mem_sz / cxt->record_size;
+	if (!cxt->max_dump_cnt)
+		return -ENOMEM;
+
+	cxt->przs = kzalloc(sizeof(*cxt->przs) * cxt->max_dump_cnt,
+			     GFP_KERNEL);
+	if (!cxt->przs) {
+		dev_err(dev, "failed to initialize a prz array for dumps\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < cxt->max_dump_cnt; i++) {
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
@@ -225,21 +277,6 @@ static int __init ramoops_probe(struct platform_device *pdev)
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
-	cxt->max_dump_cnt = pdata->mem_size / pdata->record_size;
 	cxt->dump_read_cnt = 0;
 	cxt->size = pdata->mem_size;
 	cxt->phys_addr = pdata->mem_address;
@@ -247,24 +284,14 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	cxt->dump_oops = pdata->dump_oops;
 	cxt->ecc = pdata->ecc;
 
-	cxt->przs = kzalloc(sizeof(*cxt->przs) * cxt->max_dump_cnt, GFP_KERNEL);
-	if (!cxt->przs) {
-		err = -ENOMEM;
-		dev_err(dev, "failed to initialize a prz array\n");
-		goto fail_out;
-	}
-
-	for (i = 0; i < cxt->max_dump_cnt; i++) {
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
@@ -303,10 +330,8 @@ fail_buf:
 fail_clear:
 	cxt->pstore.bufsize = 0;
 	cxt->max_dump_cnt = 0;
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

