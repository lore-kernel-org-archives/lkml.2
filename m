Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab2EZNYT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 09:24:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58205 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab2EZNW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 09:22:29 -0400
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
Subject: [PATCH 05/11] pstore/ram: Add console messages handling
Date: Sat, 26 May 2012 06:20:23 -0700
Message-Id: <1338038429-21945-5-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <20120526131747.GA15054@lizard>
References: <20120526131747.GA15054@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The console log size is configurable via ramoops.console_size
module option, and the log itself is available via
<pstore-mount>/console-ramoops file.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Acked-by: Kees Cook <keescook@chromium.org>
---
 fs/pstore/ram.c            |  100 +++++++++++++++++++++++++++++++++++++-------
 include/linux/pstore_ram.h |    1 +
 2 files changed, 87 insertions(+), 14 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index d770d72..c7acf94 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -41,6 +41,10 @@ module_param(record_size, ulong, 0400);
 MODULE_PARM_DESC(record_size,
 		"size of each dump done on oops/panic");
 
+static ulong ramoops_console_size = MIN_MEM_SIZE;
+module_param_named(console_size, ramoops_console_size, ulong, 0400);
+MODULE_PARM_DESC(console_size, "size of kernel console log");
+
 static ulong mem_address;
 module_param(mem_address, ulong, 0400);
 MODULE_PARM_DESC(mem_address,
@@ -63,14 +67,17 @@ MODULE_PARM_DESC(ramoops_ecc,
 
 struct ramoops_context {
 	struct persistent_ram_zone **przs;
+	struct persistent_ram_zone *cprz;
 	phys_addr_t phys_addr;
 	unsigned long size;
 	size_t record_size;
+	size_t console_size;
 	int dump_oops;
 	bool ecc;
 	unsigned int max_dump_cnt;
 	unsigned int dump_write_cnt;
 	unsigned int dump_read_cnt;
+	unsigned int console_read_cnt;
 	struct pstore_info pstore;
 };
 
@@ -82,6 +89,7 @@ static int ramoops_pstore_open(struct pstore_info *psi)
 	struct ramoops_context *cxt = psi->data;
 
 	cxt->dump_read_cnt = 0;
+	cxt->console_read_cnt = 0;
 	return 0;
 }
 
@@ -125,6 +133,9 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 				   cxt->max_dump_cnt, id, type,
 				   PSTORE_TYPE_DMESG, 1);
 	if (!prz)
+		prz = ramoops_get_next_prz(&cxt->cprz, &cxt->console_read_cnt,
+					   1, id, type, PSTORE_TYPE_CONSOLE, 0);
+	if (!prz)
 		return 0;
 
 	/* TODO(kees): Bogus time for the moment. */
@@ -167,7 +178,13 @@ static int ramoops_pstore_write(enum pstore_type_id type,
 	struct persistent_ram_zone *prz = cxt->przs[cxt->dump_write_cnt];
 	size_t hlen;
 
-	/* Currently ramoops is designed to only store dmesg dumps. */
+	if (type == PSTORE_TYPE_CONSOLE) {
+		if (!cxt->cprz)
+			return -ENOMEM;
+		persistent_ram_write(cxt->cprz, cxt->pstore.buf, size);
+		return 0;
+	}
+
 	if (type != PSTORE_TYPE_DMESG)
 		return -EINVAL;
 
@@ -204,12 +221,23 @@ static int ramoops_pstore_erase(enum pstore_type_id type, u64 id,
 				struct pstore_info *psi)
 {
 	struct ramoops_context *cxt = psi->data;
+	struct persistent_ram_zone *prz;
 
-	if (id >= cxt->max_dump_cnt)
+	switch (type) {
+	case PSTORE_TYPE_DMESG:
+		if (id >= cxt->max_dump_cnt)
+			return -EINVAL;
+		prz = cxt->przs[id];
+		break;
+	case PSTORE_TYPE_CONSOLE:
+		prz = cxt->cprz;
+		break;
+	default:
 		return -EINVAL;
+	}
 
-	persistent_ram_free_old(cxt->przs[id]);
-	persistent_ram_zap(cxt->przs[id]);
+	persistent_ram_free_old(prz);
+	persistent_ram_zap(prz);
 
 	return 0;
 }
@@ -276,6 +304,32 @@ fail_prz:
 	return err;
 }
 
+static int ramoops_init_prz(struct device *dev, struct ramoops_context *cxt,
+			    struct persistent_ram_zone **prz,
+			    phys_addr_t *paddr, size_t sz)
+{
+	if (!sz)
+		return 0;
+
+	if (*paddr + sz > *paddr + cxt->size)
+		return -ENOMEM;
+
+	*prz = persistent_ram_new(*paddr, sz, cxt->ecc);
+	if (IS_ERR(*prz)) {
+		int err = PTR_ERR(*prz);
+
+		dev_err(dev, "failed to request mem region (0x%zx@0x%llx): %d\n",
+			sz, (unsigned long long)*paddr, err);
+		return err;
+	}
+
+	persistent_ram_zap(*prz);
+
+	*paddr += sz;
+
+	return 0;
+}
+
 static int __init ramoops_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -291,34 +345,50 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	if (cxt->max_dump_cnt)
 		goto fail_out;
 
-	if (!pdata->mem_size || !pdata->record_size) {
-		pr_err("The memory size and the record size must be "
+	if (!pdata->mem_size || (!pdata->record_size && !pdata->console_size)) {
+		pr_err("The memory size and the record/console size must be "
 			"non-zero\n");
 		goto fail_out;
 	}
 
 	pdata->mem_size = rounddown_pow_of_two(pdata->mem_size);
 	pdata->record_size = rounddown_pow_of_two(pdata->record_size);
+	pdata->console_size = rounddown_pow_of_two(pdata->console_size);
 
 	cxt->dump_read_cnt = 0;
 	cxt->size = pdata->mem_size;
 	cxt->phys_addr = pdata->mem_address;
 	cxt->record_size = pdata->record_size;
+	cxt->console_size = pdata->console_size;
 	cxt->dump_oops = pdata->dump_oops;
 	cxt->ecc = pdata->ecc;
 
 	paddr = cxt->phys_addr;
 
-	dump_mem_sz = cxt->size;
+	dump_mem_sz = cxt->size - cxt->console_size;
 	err = ramoops_init_przs(dev, cxt, &paddr, dump_mem_sz);
-	if (err) {
+	if (err)
+		goto fail_out;
+
+	err = ramoops_init_prz(dev, cxt, &cxt->cprz, &paddr, cxt->console_size);
+	if (err)
+		goto fail_init_cprz;
+
+	if (!cxt->przs && !cxt->cprz) {
 		pr_err("memory size too small, minimum is %lu\n",
-			cxt->record_size);
-		goto fail_count;
+			cxt->console_size + cxt->record_size);
+		goto fail_cnt;
 	}
 
 	cxt->pstore.data = cxt;
-	cxt->pstore.bufsize = cxt->przs[0]->buffer_size;
+	/*
+	 * Console can handle any buffer size, so prefer dumps buffer
+	 * size since usually it is smaller.
+	 */
+	if (cxt->przs)
+		cxt->pstore.bufsize = cxt->przs[0]->buffer_size;
+	else
+		cxt->pstore.bufsize = cxt->cprz->buffer_size;
 	cxt->pstore.buf = kmalloc(cxt->pstore.bufsize, GFP_KERNEL);
 	spin_lock_init(&cxt->pstore.buf_lock);
 	if (!cxt->pstore.buf) {
@@ -341,9 +411,8 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	record_size = pdata->record_size;
 	dump_oops = pdata->dump_oops;
 
-	pr_info("attached 0x%lx@0x%llx (%ux0x%zx), ecc: %s\n",
+	pr_info("attached 0x%lx@0x%llx, ecc: %s\n",
 		cxt->size, (unsigned long long)cxt->phys_addr,
-		cxt->max_dump_cnt, cxt->record_size,
 		ramoops_ecc ? "on" : "off");
 
 	return 0;
@@ -353,7 +422,9 @@ fail_buf:
 fail_clear:
 	cxt->pstore.bufsize = 0;
 	cxt->max_dump_cnt = 0;
-fail_count:
+fail_cnt:
+	kfree(cxt->cprz);
+fail_init_cprz:
 	ramoops_free_przs(cxt);
 fail_out:
 	return err;
@@ -405,6 +476,7 @@ static int __init ramoops_init(void)
 		dummy_data->mem_size = mem_size;
 		dummy_data->mem_address = mem_address;
 		dummy_data->record_size = record_size;
+		dummy_data->console_size = ramoops_console_size;
 		dummy_data->dump_oops = dump_oops;
 		dummy_data->ecc = ramoops_ecc;
 		dummy = platform_create_bundle(&ramoops_driver, ramoops_probe,
diff --git a/include/linux/pstore_ram.h b/include/linux/pstore_ram.h
index 3b823d4..9385d41 100644
--- a/include/linux/pstore_ram.h
+++ b/include/linux/pstore_ram.h
@@ -93,6 +93,7 @@ struct ramoops_platform_data {
 	unsigned long	mem_size;
 	unsigned long	mem_address;
 	unsigned long	record_size;
+	unsigned long	console_size;
 	int		dump_oops;
 	bool		ecc;
 };
-- 
1.7.9.2

