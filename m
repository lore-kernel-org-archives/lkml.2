Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab1F1B0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 21:26:05 -0400
Received: from smtp-out.google.com ([74.125.121.67]:41394 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab1F1BWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 21:22:50 -0400
From: Sergiu Iordache <sergiu@chromium.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Sergiu Iordache <sergiu@chromium.org>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] char drivers: ramoops record_size module parameter
Date: Mon, 27 Jun 2011 18:21:53 -0700
Message-Id: <1309224113-21818-4-git-send-email-sergiu@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1309224113-21818-1-git-send-email-sergiu@chromium.org>
References: <1309224113-21818-1-git-send-email-sergiu@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size of the dump is currently set using the RECORD_SIZE macro which
is set to a page size. This patch makes the record size a module
parameter and allows it to be set through platform data as well to allow
larger dumps if needed.

Change-Id: Ie6bd28a898dab476abf34decb0eecc42122f17ce
Signed-off-by: Sergiu Iordache <sergiu@chromium.org>
---
 drivers/char/ramoops.c  |   18 +++++++++++-------
 include/linux/ramoops.h |    1 +
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index 56338a3..b16cf07 100644
--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
@@ -30,7 +30,10 @@
 
 #define RAMOOPS_KERNMSG_HDR "===="
 
-#define RECORD_SIZE 4096UL
+static ulong record_size = 4096UL;
+module_param(record_size, ulong, 0400);
+MODULE_PARM_DESC(record_size,
+		"size of each dump done on oops/panic");
 
 static ulong mem_address;
 module_param(mem_address, ulong, 0400);
@@ -77,10 +80,10 @@ static void ramoops_do_dump(struct kmsg_dumper *dumper,
 	if (reason == KMSG_DUMP_OOPS && !dump_oops)
 		return;
 
-	buf = cxt->virt_addr + (cxt->count * RECORD_SIZE);
+	buf = cxt->virt_addr + (cxt->count * record_size);
 	buf_orig = buf;
 
-	memset(buf, '\0', RECORD_SIZE);
+	memset(buf, '\0', record_size);
 	res = sprintf(buf, "%s", RAMOOPS_KERNMSG_HDR);
 	buf += res;
 	do_gettimeofday(&timestamp);
@@ -88,8 +91,8 @@ static void ramoops_do_dump(struct kmsg_dumper *dumper,
 	buf += res;
 
 	hdr_size = buf - buf_orig;
-	l2_cpy = min(l2, RECORD_SIZE - hdr_size);
-	l1_cpy = min(l1, RECORD_SIZE - hdr_size - l2_cpy);
+	l2_cpy = min(l2, record_size - hdr_size);
+	l1_cpy = min(l1, record_size - hdr_size - l2_cpy);
 
 	s2_start = l2 - l2_cpy;
 	s1_start = l1 - l1_cpy;
@@ -110,6 +113,7 @@ static int __init ramoops_probe(struct platform_device *pdev)
 		mem_size = pdata->mem_size;
 		mem_address = pdata->mem_address;
 		dump_oops = pdata->dump_oops;
+		record_size = pdata->record_size;
 	}
 
 	if (!mem_size) {
@@ -119,12 +123,12 @@ static int __init ramoops_probe(struct platform_device *pdev)
 
 	rounddown_pow_of_two(mem_size);
 
-	if (mem_size < RECORD_SIZE) {
+	if (mem_size < record_size) {
 		printk(KERN_ERR "ramoops: size too small");
 		goto fail3;
 	}
 
-	cxt->max_count = mem_size / RECORD_SIZE;
+	cxt->max_count = mem_size / record_size;
 	cxt->count = 0;
 	cxt->size = mem_size;
 	cxt->phys_addr = mem_address;
diff --git a/include/linux/ramoops.h b/include/linux/ramoops.h
index 1d05505..cfa2623 100644
--- a/include/linux/ramoops.h
+++ b/include/linux/ramoops.h
@@ -11,6 +11,7 @@ struct ramoops_platform_data {
 	unsigned long	mem_size;
 	unsigned long	mem_address;
 	unsigned char	dump_oops;
+	unsigned long	record_size;
 };
 
 #endif
-- 
1.7.3.1

