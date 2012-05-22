Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757Ab2EVOUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:20:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60941 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab2EVOUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:20:41 -0400
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
Subject: [PATCH 10/16] pstore/ram: Add console messages handling
Date: Tue, 22 May 2012 07:17:53 -0700
Message-Id: <1337696279-8994-10-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <20120522141717.GA31574@lizard>
References: <20120522141717.GA31574@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The console log size is configurable via ramoops.console_size
module option, and the log itself is available via
<pstore-mount>/console-ramoops file.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/ram.c            |  107 ++++++++++++++++++++++++++++++++++++++------
 include/linux/pstore_ram.h |    1 +
 2 files changed, 95 insertions(+), 13 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 6dc9e96..4e1ba41 100644
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
@@ -63,9 +67,11 @@ MODULE_PARM_DESC(ramoops_ecc,
 
 struct ramoops_context {
 	struct persistent_ram_zone **przs;
+	struct persistent_ram_zone *cprz;
 	phys_addr_t phys_addr;
 	unsigned long size;
 	size_t record_size;
+	size_t console_size;
 	int dump_oops;
 	bool ecc;
 	unsigned int count;
@@ -96,6 +102,9 @@ ramoops_get_dump_prz(u64 id, enum pstore_type_id *type,
 		return NULL;
 
 	prz = cxt->przs[id];
+
+	/* Update old/shadowed buffer. */
+	persistent_ram_save_old(prz);
 	if (!persistent_ram_old_size(prz))
 		return NULL;
 
@@ -104,6 +113,19 @@ ramoops_get_dump_prz(u64 id, enum pstore_type_id *type,
 	return prz;
 }
 
+static struct persistent_ram_zone *
+ramoops_get_console_prz(u64 id, enum pstore_type_id *type,
+			struct ramoops_context *cxt)
+{
+	if (id >= cxt->max_count)
+		return NULL;
+
+	*type = PSTORE_TYPE_CONSOLE;
+	cxt->read_count = cxt->max_count;
+
+	return cxt->cprz;
+}
+
 static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 				   struct timespec *time,
 				   char **buf,
@@ -117,14 +139,14 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 
 	prz = ramoops_get_dump_prz(*id, type, cxt);
 	if (!prz)
+		prz = ramoops_get_console_prz(*id, type, cxt);
+	if (!prz)
 		return 0;
 
 	/* TODO(kees): Bogus time for the moment. */
 	time->tv_sec = 0;
 	time->tv_nsec = 0;
 
-	/* Update old/shadowed buffer. */
-	persistent_ram_save_old(prz);
 	size = persistent_ram_old_size(prz);
 	*buf = kmalloc(size, GFP_KERNEL);
 	if (*buf == NULL)
@@ -161,7 +183,13 @@ static int ramoops_pstore_write(enum pstore_type_id type,
 	struct persistent_ram_zone *prz = cxt->przs[cxt->count];
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
 
@@ -198,12 +226,17 @@ static int ramoops_pstore_erase(enum pstore_type_id type, u64 id,
 				struct pstore_info *psi)
 {
 	struct ramoops_context *cxt = psi->data;
+	struct persistent_ram_zone *prz;
 
-	if (id >= cxt->max_dump_count)
+	if (id >= cxt->max_dump_count && id < cxt->max_count)
+		prz = cxt->cprz;
+	else if (id < cxt->max_dump_count)
+		prz = cxt->przs[id];
+	else
 		return -EINVAL;
 
-	persistent_ram_free_old(cxt->przs[id]);
-	persistent_ram_zap(cxt->przs[id]);
+	persistent_ram_free_old(prz);
+	persistent_ram_zap(prz);
 
 	return 0;
 }
@@ -272,6 +305,35 @@ fail_prz:
 	return err;
 }
 
+static void ramoops_free_cprz(struct ramoops_context *cxt)
+{
+	kfree(cxt->cprz);
+}
+
+static int ramoops_init_cprz(struct device *dev, struct ramoops_context *cxt,
+			     phys_addr_t *paddr, size_t console_mem_sz)
+{
+	if (!console_mem_sz)
+		return 0;
+
+	if (*paddr + console_mem_sz > *paddr + cxt->size)
+		return -ENOMEM;
+
+	cxt->cprz = persistent_ram_new(*paddr, console_mem_sz, cxt->ecc);
+	if (IS_ERR(cxt->cprz)) {
+		int err = PTR_ERR(cxt->cprz);
+
+		dev_err(dev, "failed to request mem region (0x%zx@0x%llx): %d\n",
+			console_mem_sz, (unsigned long long)*paddr, err);
+		return err;
+	}
+
+	*paddr += console_mem_sz;
+	cxt->max_count++;
+
+	return 0;
+}
+
 static int __init ramoops_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -287,35 +349,51 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	if (cxt->max_dump_count)
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
 
 	cxt->max_count = 0;
 	cxt->count = 0;
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
+	err = ramoops_init_cprz(dev, cxt, &paddr, cxt->console_size);
+	if (err)
+		goto fail_init_cprz;
+
+	if (!cxt->max_count) {
 		pr_err("memory size too small, minimum is %lu\n",
-			cxt->record_size);
+			cxt->console_size + cxt->record_size);
 		goto fail_count;
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
@@ -324,7 +402,7 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	}
 
 	err = pstore_register(&cxt->pstore);
-	if (err || !cxt->max_count) {
+	if (err) {
 		pr_err("registering with pstore failed\n");
 		goto fail_buf;
 	}
@@ -352,6 +430,8 @@ fail_clear:
 	cxt->max_count = 0;
 	cxt->max_dump_count = 0;
 fail_count:
+	ramoops_free_cprz(cxt);
+fail_init_cprz:
 	ramoops_free_przs(cxt);
 fail_out:
 	return err;
@@ -403,6 +483,7 @@ static int __init ramoops_init(void)
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

