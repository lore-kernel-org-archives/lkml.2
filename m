Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab2IBOOW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 10:14:22 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:48642 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab2IBOOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 10:14:20 -0400
Message-ID: <1346595257.4377.5.camel@lorien2>
Subject: [PATCH] dma-debug: Add dma map/unmap error tracking support
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: joerg.roedel@amd.com, paul.gortmaker@windriver.com, kubakici@wp.pl,
        stern@rowland.harvard.edu, dan.carpenter@oracle.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, rob@landley.net
Cc: linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Date: Sun, 02 Sep 2012 08:14:17 -0600
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent dma mapping error analysis effort showed that a large precentage
of dma_map_single() and dma_map_page() returns are not checked for mapping
errors. Reference: https://lkml.org/lkml/2012/8/10/326

Adding support for tracking dma mapping and unmapping errors to help assess
the following:

When do dma mapping errors get detected?
How often do these errors occur?
Why don't we see failures related to missing dma mapping error checks?
Are they silent failures?

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
---
 Documentation/DMA-API.txt |    7 +++++++
 lib/dma-debug.c           |   26 +++++++++++++++++++++++++-
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index 66bd97a..ee10a11 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -638,6 +638,13 @@ this directory the following files can currently be found:
 	dma-api/error_count	This file is read-only and shows the total
 				numbers of errors found.
 
+	dma-api/dma_map_errors  This file is read-only and shows the total
+				number of dma mapping errors detected.
+
+	dma-api/dma_unmap_errors
+				This file is read-only and shows the total
+				number of invalid dma unmapping attempts.
+
 	dma-api/num_errors	The number in this file shows how many
 				warnings will be printed to the kernel log
 				before it stops. This number is initialized to
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 66ce414..8596114 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -83,6 +83,10 @@ static u32 global_disable __read_mostly;
 /* Global error count */
 static u32 error_count;
 
+/* dma mapping error counts */
+static u32 dma_map_errors;
+static u32 dma_unmap_errors;
+
 /* Global error show enable*/
 static u32 show_all_errors __read_mostly;
 /* Number of errors to show */
@@ -104,6 +108,8 @@ static struct dentry *show_num_errors_dent  __read_mostly;
 static struct dentry *num_free_entries_dent __read_mostly;
 static struct dentry *min_free_entries_dent __read_mostly;
 static struct dentry *filter_dent           __read_mostly;
+static struct dentry *dma_map_errors_dent   __read_mostly;
+static struct dentry *dma_unmap_errors_dent __read_mostly;
 
 /* per-driver filter related state */
 
@@ -695,6 +701,19 @@ static int dma_debug_fs_init(void)
 	if (!filter_dent)
 		goto out_err;
 
+	dma_map_errors_dent = debugfs_create_u32("dma_map_errors", 0444,
+			dma_debug_dent,
+			&dma_map_errors);
+
+	if (!dma_map_errors_dent)
+		goto out_err;
+
+	dma_unmap_errors_dent = debugfs_create_u32("dma_unmap_errors", 0444,
+			dma_debug_dent,
+			&dma_unmap_errors);
+	if (!dma_unmap_errors_dent)
+		goto out_err;
+
 	return 0;
 
 out_err:
@@ -850,6 +869,7 @@ static void check_unmap(struct dma_debug_entry *ref)
 	unsigned long flags;
 
 	if (dma_mapping_error(ref->dev, ref->dev_addr)) {
+		dma_unmap_errors += 1;
 		err_printk(ref->dev, NULL, "DMA-API: device driver tries "
 			   "to free an invalid DMA memory address\n");
 		return;
@@ -1022,8 +1042,12 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
 	if (unlikely(global_disable))
 		return;
 
-	if (unlikely(dma_mapping_error(dev, dma_addr)))
+	if (unlikely(dma_mapping_error(dev, dma_addr))) {
+		dma_map_errors += 1;
+		err_printk(dev, NULL,
+			   "DMA-API: dma_map_page() returned error\n");
 		return;
+	}
 
 	entry = dma_entry_alloc();
 	if (!entry)
-- 
1.7.9.5



