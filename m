Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab2FSCSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 22:18:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43936 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab2FSCSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 22:18:25 -0400
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
Subject: [PATCH 6/7] pstore/ram: Make ECC size configurable
Date: Mon, 18 Jun 2012 19:15:55 -0700
Message-Id: <1340072156-6225-6-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120619021050.GA19387@lizard>
References: <20120619021050.GA19387@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is now pretty straightforward: instead of using bool, just pass
an integer. For backwards compatibility ramoops.ecc=1 means 16 bytes
ECC (using 1 byte for ECC isn't much of use anyway).

Suggested-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/ram.c            |   14 +++++++-------
 fs/pstore/ram_core.c       |   15 ++++++++-------
 include/linux/pstore_ram.h |    4 ++--
 3 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 58b93fb..78ecefc 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -73,7 +73,7 @@ struct ramoops_context {
 	size_t record_size;
 	size_t console_size;
 	int dump_oops;
-	bool ecc;
+	int ecc_size;
 	unsigned int max_dump_cnt;
 	unsigned int dump_write_cnt;
 	unsigned int dump_read_cnt;
@@ -288,7 +288,7 @@ static int ramoops_init_przs(struct device *dev, struct ramoops_context *cxt,
 	for (i = 0; i < cxt->max_dump_cnt; i++) {
 		size_t sz = cxt->record_size;
 
-		cxt->przs[i] = persistent_ram_new(*paddr, sz, cxt->ecc);
+		cxt->przs[i] = persistent_ram_new(*paddr, sz, cxt->ecc_size);
 		if (IS_ERR(cxt->przs[i])) {
 			err = PTR_ERR(cxt->przs[i]);
 			dev_err(dev, "failed to request mem region (0x%zx@0x%llx): %d\n",
@@ -314,7 +314,7 @@ static int ramoops_init_prz(struct device *dev, struct ramoops_context *cxt,
 	if (*paddr + sz > *paddr + cxt->size)
 		return -ENOMEM;
 
-	*prz = persistent_ram_new(*paddr, sz, cxt->ecc);
+	*prz = persistent_ram_new(*paddr, sz, cxt->ecc_size);
 	if (IS_ERR(*prz)) {
 		int err = PTR_ERR(*prz);
 
@@ -361,7 +361,7 @@ static int __devinit ramoops_probe(struct platform_device *pdev)
 	cxt->record_size = pdata->record_size;
 	cxt->console_size = pdata->console_size;
 	cxt->dump_oops = pdata->dump_oops;
-	cxt->ecc = pdata->ecc;
+	cxt->ecc_size = pdata->ecc_size;
 
 	paddr = cxt->phys_addr;
 
@@ -411,9 +411,9 @@ static int __devinit ramoops_probe(struct platform_device *pdev)
 	record_size = pdata->record_size;
 	dump_oops = pdata->dump_oops;
 
-	pr_info("attached 0x%lx@0x%llx, ecc: %s\n",
+	pr_info("attached 0x%lx@0x%llx, ecc: %d\n",
 		cxt->size, (unsigned long long)cxt->phys_addr,
-		ramoops_ecc ? "on" : "off");
+		cxt->ecc_size);
 
 	return 0;
 
@@ -478,7 +478,7 @@ static void ramoops_register_dummy(void)
 	dummy_data->record_size = record_size;
 	dummy_data->console_size = ramoops_console_size;
 	dummy_data->dump_oops = dump_oops;
-	dummy_data->ecc = ramoops_ecc;
+	dummy_data->ecc_size = ramoops_ecc == 1 ? 16 : ramoops_ecc;
 
 	dummy = platform_device_register_data(NULL, "ramoops", -1,
 			dummy_data, sizeof(struct ramoops_platform_data));
diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index 3f4d6e6..7e5a2a9 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -171,7 +171,8 @@ static void persistent_ram_ecc_old(struct persistent_ram_zone *prz)
 	}
 }
 
-static int persistent_ram_init_ecc(struct persistent_ram_zone *prz)
+static int persistent_ram_init_ecc(struct persistent_ram_zone *prz,
+				   int ecc_size)
 {
 	int numerr;
 	struct persistent_ram_buffer *buffer = prz->buffer;
@@ -184,7 +185,7 @@ static int persistent_ram_init_ecc(struct persistent_ram_zone *prz)
 		return 0;
 
 	prz->ecc_block_size = 128;
-	prz->ecc_size = 16;
+	prz->ecc_size = ecc_size;
 
 	ecc_blocks = DIV_ROUND_UP(prz->buffer_size, prz->ecc_block_size);
 	ecc_total = (ecc_blocks + 1) * prz->ecc_size;
@@ -390,13 +391,13 @@ static int persistent_ram_buffer_map(phys_addr_t start, phys_addr_t size,
 }
 
 static int __devinit persistent_ram_post_init(struct persistent_ram_zone *prz,
-					      bool ecc)
+					      int ecc_size)
 {
 	int ret;
 
-	prz->ecc = ecc;
+	prz->ecc = ecc_size;
 
-	ret = persistent_ram_init_ecc(prz);
+	ret = persistent_ram_init_ecc(prz, ecc_size);
 	if (ret)
 		return ret;
 
@@ -444,7 +445,7 @@ void persistent_ram_free(struct persistent_ram_zone *prz)
 
 struct persistent_ram_zone * __devinit persistent_ram_new(phys_addr_t start,
 							  size_t size,
-							  bool ecc)
+							  int ecc_size)
 {
 	struct persistent_ram_zone *prz;
 	int ret = -ENOMEM;
@@ -459,7 +460,7 @@ struct persistent_ram_zone * __devinit persistent_ram_new(phys_addr_t start,
 	if (ret)
 		goto err;
 
-	ret = persistent_ram_post_init(prz, ecc);
+	ret = persistent_ram_post_init(prz, ecc_size);
 	if (ret)
 		goto err;
 
diff --git a/include/linux/pstore_ram.h b/include/linux/pstore_ram.h
index a0975c0..94b79f1 100644
--- a/include/linux/pstore_ram.h
+++ b/include/linux/pstore_ram.h
@@ -48,7 +48,7 @@ struct persistent_ram_zone {
 
 struct persistent_ram_zone * __devinit persistent_ram_new(phys_addr_t start,
 							  size_t size,
-							  bool ecc);
+							  int ecc_size);
 void persistent_ram_free(struct persistent_ram_zone *prz);
 void persistent_ram_zap(struct persistent_ram_zone *prz);
 
@@ -74,7 +74,7 @@ struct ramoops_platform_data {
 	unsigned long	record_size;
 	unsigned long	console_size;
 	int		dump_oops;
-	bool		ecc;
+	int		ecc_size;
 };
 
 #endif
-- 
1.7.10.4

