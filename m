Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab1GABaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 21:30:00 -0400
Received: from smtp-out.google.com ([74.125.121.67]:56060 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab1GAB3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 21:29:40 -0400
From: Sergiu Iordache <sergiu@chromium.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Sergiu Iordache <sergiu@chromium.org>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] char drivers: ramoops dump_oops platform data
Date: Thu, 30 Jun 2011 18:28:38 -0700
Message-Id: <1309483720-1407-2-git-send-email-sergiu@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1309483720-1407-1-git-send-email-sergiu@chromium.org>
References: <1309483720-1407-1-git-send-email-sergiu@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform driver currently allows setting the mem_size and mem_address.
Since dump_oops is also a module parameter it would be more consistent
if it could be set through platform data as well.

Change-Id: I27e541a51c9722047c4163bf408e778caa77ecc9
Signed-off-by: Sergiu Iordache <sergiu@chromium.org>
---
The patch was built on the 2.6.38 kernel and is based on the following
patches which were applied from the mmotm tree:
ramoops-add-new-line-to-each-print
ramoops-use-module-parameters-instead-of-platform-data-if-not-available
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes

 drivers/char/ramoops.c  |    5 ++++-
 include/linux/ramoops.h |    1 +
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index c9e1028..5349d94 100644
--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
@@ -55,6 +55,7 @@ static struct ramoops_context {
 	void *virt_addr;
 	phys_addr_t phys_addr;
 	unsigned long size;
+	int dump_oops;
 	int count;
 	int max_count;
 } oops_cxt;
@@ -80,7 +81,7 @@ static void ramoops_do_dump(struct kmsg_dumper *dumper,
 		return;
 
 	/* Only dump oopses if dump_oops is set */
-	if (reason == KMSG_DUMP_OOPS && !dump_oops)
+	if (reason == KMSG_DUMP_OOPS && !cxt->dump_oops)
 		return;
 
 	buf = cxt->virt_addr + (cxt->count * RECORD_SIZE);
@@ -128,6 +129,7 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	cxt->count = 0;
 	cxt->size = pdata->mem_size;
 	cxt->phys_addr = pdata->mem_address;
+	cxt->dump_oops = pdata->dump_oops;
 
 	if (!request_mem_region(cxt->phys_addr, cxt->size, "ramoops")) {
 		pr_err("request mem region failed\n");
@@ -194,6 +196,7 @@ static int __init ramoops_init(void)
 			return -ENOMEM;
 		dummy_data->mem_size = mem_size;
 		dummy_data->mem_address = mem_address;
+		dummy_data->dump_oops = dump_oops;
 		dummy = platform_create_bundle(&ramoops_driver, ramoops_probe,
 			NULL, 0, dummy_data,
 			sizeof(struct ramoops_platform_data));
diff --git a/include/linux/ramoops.h b/include/linux/ramoops.h
index 0ae68a2..7105c4b 100644
--- a/include/linux/ramoops.h
+++ b/include/linux/ramoops.h
@@ -10,6 +10,7 @@
 struct ramoops_platform_data {
 	unsigned long	mem_size;
 	unsigned long	mem_address;
+	int		dump_oops;
 };
 
 #endif
-- 
1.7.3.1

