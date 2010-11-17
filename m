Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934686Ab0KQOck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 09:32:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:20610 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933847Ab0KQOcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 09:32:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,211,1288594800"; 
   d="scan'208";a="574715882"
Date: Wed, 17 Nov 2010 22:09:54 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>, chuanxiao.dong@intel.com,
        yunpeng.gao@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: spectra: asynchronous init
Message-ID: <20101117140954.GB5790@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The spectra nand driver takes quite some time to initialize because
it needs to scan the whole nand disk to find the latest block table.
This patch initializes the spectra nand driver asynchronously so that
other things in the kernel can initialize in parallel to the scanning
operation.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
---
 drivers/staging/spectra/ffsport.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/spectra/ffsport.c b/drivers/staging/spectra/ffsport.c
index ae101a2..007b24b 100644
--- a/drivers/staging/spectra/ffsport.c
+++ b/drivers/staging/spectra/ffsport.c
@@ -28,6 +28,7 @@
 #include <linux/log2.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/async.h>
 
 /**** Helper functions used for Div, Remainder operation on u64 ****/
 
@@ -729,7 +730,7 @@ static void create_sysfs_entry(struct device *dev)
 }
 */
 
-int register_spectra_ftl()
+static void register_spectra_ftl_async(void *unused, async_cookie_t cookie)
 {
 	int i;
 
@@ -738,7 +739,7 @@ int register_spectra_ftl()
 	if (PASS != GLOB_FTL_IdentifyDevice(&IdentifyDeviceData)) {
 		printk(KERN_ERR "Spectra: Unable to Read Flash Device. "
 		       "Aborting\n");
-		return -ENOMEM;
+		return;
 	} else {
 		nand_dbg_print(NAND_DBG_WARN, "In GLOB_SBD_init: "
 			       "Num blocks=%d, pagesperblock=%d, "
@@ -772,15 +773,19 @@ int register_spectra_ftl()
 		       "Spectra: module loaded with major number %d\n",
 		       GLOB_SBD_majornum);
 
-	return PASS;
+	return;
 
 out_blk_register:
 	unregister_blkdev(GLOB_SBD_majornum, GLOB_SBD_NAME);
 out_ftl_flash_register:
 	GLOB_FTL_Cache_Release();
 	printk(KERN_ERR "Spectra: Module load failed.\n");
+}
 
-	return FAIL;
+int register_spectra_ftl()
+{
+	async_schedule(register_spectra_ftl_async, NULL);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(register_spectra_ftl);
 
-- 
1.5.5.1

