Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030465Ab2ERW0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 18:26:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53446 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030325Ab2ERW0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 18:26:42 -0400
Date: Fri, 18 May 2012 15:25:12 -0700
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
Subject: [PATCH 06/14] pstore/ram: Introduce ramoops_context.max_dump_count
Message-ID: <20120518222512.GF23089@lizard>
References: <20120518222314.GA9425@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120518222314.GA9425@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So far it is the same as max_count, but this will change when
we'll add support for other message types (e.g. console, mce,
tracing).

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/ram.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 43d9727..408fb07 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -70,6 +70,7 @@ struct ramoops_context {
 	bool ecc;
 	unsigned int count;
 	unsigned int max_count;
+	unsigned int max_dump_count;
 	unsigned int read_count;
 	struct pstore_info pstore;
 };
@@ -94,7 +95,7 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 	struct ramoops_context *cxt = psi->data;
 	struct persistent_ram_zone *prz;
 
-	if (cxt->read_count >= cxt->max_count)
+	if (cxt->read_count >= cxt->max_dump_count)
 		return -EINVAL;
 
 	*id = cxt->read_count++;
@@ -172,7 +173,7 @@ static int ramoops_pstore_write(enum pstore_type_id type,
 		size = prz->buffer_size - hlen;
 	persistent_ram_write(prz, cxt->pstore.buf, size);
 
-	cxt->count = (cxt->count + 1) % cxt->max_count;
+	cxt->count = (cxt->count + 1) % cxt->max_dump_count;
 
 	return 0;
 }
@@ -182,7 +183,7 @@ static int ramoops_pstore_erase(enum pstore_type_id type, u64 id,
 {
 	struct ramoops_context *cxt = psi->data;
 
-	if (id >= cxt->max_count)
+	if (id >= cxt->max_dump_count)
 		return -EINVAL;
 
 	persistent_ram_free_old(cxt->przs[id]);
@@ -213,7 +214,7 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	/* Only a single ramoops area allowed at a time, so fail extra
 	 * probes.
 	 */
-	if (cxt->max_count)
+	if (cxt->max_dump_count)
 		goto fail_out;
 
 	if (!pdata->mem_size || !pdata->record_size) {
@@ -240,6 +241,7 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	}
 
 	cxt->max_count = pdata->mem_size / pdata->record_size;
+	cxt->max_dump_count = cxt->max_count;
 	cxt->count = 0;
 	cxt->size = pdata->mem_size;
 	cxt->phys_addr = pdata->mem_address;
@@ -247,14 +249,14 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	cxt->dump_oops = pdata->dump_oops;
 	cxt->ecc = pdata->ecc;
 
-	cxt->przs = kzalloc(sizeof(*cxt->przs) * cxt->max_count, GFP_KERNEL);
+	cxt->przs = kzalloc(sizeof(*cxt->przs) * cxt->max_dump_count, GFP_KERNEL);
 	if (!cxt->przs) {
 		err = -ENOMEM;
 		dev_err(dev, "failed to initialize a prz array\n");
 		goto fail_out;
 	}
 
-	for (i = 0; i < cxt->max_count; i++) {
+	for (i = 0; i < cxt->max_dump_count; i++) {
 		size_t sz = cxt->record_size;
 		phys_addr_t start = cxt->phys_addr + sz * i;
 
@@ -303,6 +305,7 @@ fail_buf:
 fail_clear:
 	cxt->pstore.bufsize = 0;
 	cxt->max_count = 0;
+	cxt->max_dump_count = 0;
 fail_przs:
 	for (i = 0; cxt->przs[i]; i++)
 		persistent_ram_free(cxt->przs[i]);
-- 
1.7.9.2

