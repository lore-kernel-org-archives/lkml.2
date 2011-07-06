Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab1GFXab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 19:30:31 -0400
Received: from smtp-out.google.com ([216.239.44.51]:50918 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab1GFXa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 19:30:29 -0400
From: Sergiu Iordache <sergiu@chromium.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Sergiu Iordache <sergiu@chromium.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/3] char drivers: ramoops record_size module parameter
Date: Wed,  6 Jul 2011 16:29:49 -0700
Message-Id: <1309994990-4729-3-git-send-email-sergiu@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1309994990-4729-1-git-send-email-sergiu@chromium.org>
References: <1309994990-4729-1-git-send-email-sergiu@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size of the dump is currently set using the RECORD_SIZE macro which
is set to a page size. This patch makes the record size a module 
parameter and allows it to be set through platform data as well to allow
larger dumps if needed.

Signed-off-by: Sergiu Iordache <sergiu@chromium.org>

Change-Id: Ie5a53acb50d5881d51354f5d9d13e3d6bedf6a2e
---
 drivers/char/ramoops.c  |   37 +++++++++++++++++++++++++++----------
 include/linux/ramoops.h |    1 +
 2 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index 5349d94..bd9b94b 100644
--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
@@ -32,8 +32,12 @@
 #include <linux/ramoops.h>
 
 #define RAMOOPS_KERNMSG_HDR "===="
+#define MIN_MEM_SIZE 4096UL
 
-#define RECORD_SIZE 4096UL
+static ulong record_size = MIN_MEM_SIZE;
+module_param(record_size, ulong, 0400);
+MODULE_PARM_DESC(record_size,
+		"size of each dump done on oops/panic");
 
 static ulong mem_address;
 module_param(mem_address, ulong, 0400);
@@ -55,6 +59,7 @@ static struct ramoops_context {
 	void *virt_addr;
 	phys_addr_t phys_addr;
 	unsigned long size;
+	unsigned long record_size;
 	int dump_oops;
 	int count;
 	int max_count;
@@ -84,10 +89,10 @@ static void ramoops_do_dump(struct kmsg_dumper *dumper,
 	if (reason == KMSG_DUMP_OOPS && !cxt->dump_oops)
 		return;
 
-	buf = cxt->virt_addr + (cxt->count * RECORD_SIZE);
+	buf = cxt->virt_addr + (cxt->count * cxt->record_size);
 	buf_orig = buf;
 
-	memset(buf, '\0', RECORD_SIZE);
+	memset(buf, '\0', cxt->record_size);
 	res = sprintf(buf, "%s", RAMOOPS_KERNMSG_HDR);
 	buf += res;
 	do_gettimeofday(&timestamp);
@@ -95,8 +100,8 @@ static void ramoops_do_dump(struct kmsg_dumper *dumper,
 	buf += res;
 
 	hdr_size = buf - buf_orig;
-	l2_cpy = min(l2, RECORD_SIZE - hdr_size);
-	l1_cpy = min(l1, RECORD_SIZE - hdr_size - l2_cpy);
+	l2_cpy = min(l2, cxt->record_size - hdr_size);
+	l1_cpy = min(l1, cxt->record_size - hdr_size - l2_cpy);
 
 	s2_start = l2 - l2_cpy;
 	s1_start = l1 - l1_cpy;
@@ -113,22 +118,33 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	struct ramoops_context *cxt = &oops_cxt;
 	int err = -EINVAL;
 
-	if (!pdata->mem_size) {
-		pr_err("invalid size specification\n");
+	if (!pdata->mem_size || !pdata->record_size) {
+		pr_err("The memory size and the record size must be "
+			"non-zero\n");
 		goto fail3;
 	}
 
 	rounddown_pow_of_two(pdata->mem_size);
+	rounddown_pow_of_two(pdata->record_size);
 
-	if (pdata->mem_size < RECORD_SIZE) {
-		pr_err("size too small\n");
+	/* Check for the minimum memory size */
+	if (pdata->mem_size < MIN_MEM_SIZE &&
+			pdata->record_size < MIN_MEM_SIZE) {
+		pr_err("memory size too small, minium is %lu\n", MIN_MEM_SIZE);
 		goto fail3;
 	}
 
-	cxt->max_count = pdata->mem_size / RECORD_SIZE;
+	if (pdata->mem_size < pdata->record_size) {
+		pr_err("The memory size must be larger than the "
+			"records size\n");
+		goto fail3;
+	}
+
+	cxt->max_count = pdata->mem_size / pdata->record_size;
 	cxt->count = 0;
 	cxt->size = pdata->mem_size;
 	cxt->phys_addr = pdata->mem_address;
+	cxt->record_size = pdata->record_size;
 	cxt->dump_oops = pdata->dump_oops;
 
 	if (!request_mem_region(cxt->phys_addr, cxt->size, "ramoops")) {
@@ -196,6 +212,7 @@ static int __init ramoops_init(void)
 			return -ENOMEM;
 		dummy_data->mem_size = mem_size;
 		dummy_data->mem_address = mem_address;
+		dummy_data->record_size = record_size;
 		dummy_data->dump_oops = dump_oops;
 		dummy = platform_create_bundle(&ramoops_driver, ramoops_probe,
 			NULL, 0, dummy_data,
diff --git a/include/linux/ramoops.h b/include/linux/ramoops.h
index 7105c4b..484fef8 100644
--- a/include/linux/ramoops.h
+++ b/include/linux/ramoops.h
@@ -10,6 +10,7 @@
 struct ramoops_platform_data {
 	unsigned long	mem_size;
 	unsigned long	mem_address;
+	unsigned long	record_size;
 	int		dump_oops;
 };
 
-- 
1.7.3.1

