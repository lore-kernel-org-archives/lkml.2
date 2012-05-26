Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab2EZNWV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 09:22:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58205 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab2EZNWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 09:22:18 -0400
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
Subject: [PATCH 02/11] pstore/ram: Give proper names to dump-related variables
Date: Sat, 26 May 2012 06:20:20 -0700
Message-Id: <1338038429-21945-2-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <20120526131747.GA15054@lizard>
References: <20120526131747.GA15054@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're about to add support for other message types, so let's rename
some variables to not be confused later.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/ram.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 453030f..9b274b9 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -68,9 +68,9 @@ struct ramoops_context {
 	size_t record_size;
 	int dump_oops;
 	bool ecc;
-	unsigned int count;
-	unsigned int max_count;
-	unsigned int read_count;
+	unsigned int max_dump_cnt;
+	unsigned int dump_write_cnt;
+	unsigned int dump_read_cnt;
 	struct pstore_info pstore;
 };
 
@@ -81,7 +81,7 @@ static int ramoops_pstore_open(struct pstore_info *psi)
 {
 	struct ramoops_context *cxt = psi->data;
 
-	cxt->read_count = 0;
+	cxt->dump_read_cnt = 0;
 	return 0;
 }
 
@@ -94,10 +94,10 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 	struct ramoops_context *cxt = psi->data;
 	struct persistent_ram_zone *prz;
 
-	if (cxt->read_count >= cxt->max_count)
+	if (cxt->dump_read_cnt >= cxt->max_dump_cnt)
 		return -EINVAL;
 
-	*id = cxt->read_count++;
+	*id = cxt->dump_read_cnt++;
 	prz = cxt->przs[*id];
 
 	/* Only supports dmesg output so far. */
@@ -141,7 +141,7 @@ static int ramoops_pstore_write(enum pstore_type_id type,
 				size_t size, struct pstore_info *psi)
 {
 	struct ramoops_context *cxt = psi->data;
-	struct persistent_ram_zone *prz = cxt->przs[cxt->count];
+	struct persistent_ram_zone *prz = cxt->przs[cxt->dump_write_cnt];
 	size_t hlen;
 
 	/* Currently ramoops is designed to only store dmesg dumps. */
@@ -172,7 +172,7 @@ static int ramoops_pstore_write(enum pstore_type_id type,
 		size = prz->buffer_size - hlen;
 	persistent_ram_write(prz, cxt->pstore.buf, size);
 
-	cxt->count = (cxt->count + 1) % cxt->max_count;
+	cxt->dump_write_cnt = (cxt->dump_write_cnt + 1) % cxt->max_dump_cnt;
 
 	return 0;
 }
@@ -182,7 +182,7 @@ static int ramoops_pstore_erase(enum pstore_type_id type, u64 id,
 {
 	struct ramoops_context *cxt = psi->data;
 
-	if (id >= cxt->max_count)
+	if (id >= cxt->max_dump_cnt)
 		return -EINVAL;
 
 	persistent_ram_free_old(cxt->przs[id]);
@@ -213,7 +213,7 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	/* Only a single ramoops area allowed at a time, so fail extra
 	 * probes.
 	 */
-	if (cxt->max_count)
+	if (cxt->max_dump_cnt)
 		goto fail_out;
 
 	if (!pdata->mem_size || !pdata->record_size) {
@@ -239,22 +239,22 @@ static int __init ramoops_probe(struct platform_device *pdev)
 		goto fail_out;
 	}
 
-	cxt->max_count = pdata->mem_size / pdata->record_size;
-	cxt->count = 0;
+	cxt->max_dump_cnt = pdata->mem_size / pdata->record_size;
+	cxt->dump_read_cnt = 0;
 	cxt->size = pdata->mem_size;
 	cxt->phys_addr = pdata->mem_address;
 	cxt->record_size = pdata->record_size;
 	cxt->dump_oops = pdata->dump_oops;
 	cxt->ecc = pdata->ecc;
 
-	cxt->przs = kzalloc(sizeof(*cxt->przs) * cxt->max_count, GFP_KERNEL);
+	cxt->przs = kzalloc(sizeof(*cxt->przs) * cxt->max_dump_cnt, GFP_KERNEL);
 	if (!cxt->przs) {
 		err = -ENOMEM;
 		dev_err(dev, "failed to initialize a prz array\n");
 		goto fail_out;
 	}
 
-	for (i = 0; i < cxt->max_count; i++) {
+	for (i = 0; i < cxt->max_dump_cnt; i++) {
 		size_t sz = cxt->record_size;
 		phys_addr_t start = cxt->phys_addr + sz * i;
 
@@ -293,7 +293,7 @@ static int __init ramoops_probe(struct platform_device *pdev)
 
 	pr_info("attached 0x%lx@0x%llx (%ux0x%zx), ecc: %s\n",
 		cxt->size, (unsigned long long)cxt->phys_addr,
-		cxt->max_count, cxt->record_size,
+		cxt->max_dump_cnt, cxt->record_size,
 		ramoops_ecc ? "on" : "off");
 
 	return 0;
@@ -302,7 +302,7 @@ fail_buf:
 	kfree(cxt->pstore.buf);
 fail_clear:
 	cxt->pstore.bufsize = 0;
-	cxt->max_count = 0;
+	cxt->max_dump_cnt = 0;
 fail_przs:
 	for (i = 0; cxt->przs[i]; i++)
 		persistent_ram_free(cxt->przs[i]);
@@ -321,7 +321,7 @@ static int __exit ramoops_remove(struct platform_device *pdev)
 
 	iounmap(cxt->virt_addr);
 	release_mem_region(cxt->phys_addr, cxt->size);
-	cxt->max_count = 0;
+	cxt->max_dump_cnt = 0;
 
 	/* TODO(kees): When pstore supports unregistering, call it here. */
 	kfree(cxt->pstore.buf);
-- 
1.7.9.2

