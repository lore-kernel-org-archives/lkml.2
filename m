Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196Ab1ADWLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 17:11:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:23954 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab1ADWLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 17:11:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,274,1291622400"; 
   d="scan'208";a="874451581"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, gregkh@suse.de, alan@linux.intel.com
Cc: Mark Allyn <mark.a.allyn@intel.com>
Subject: [PATCH 1/1] staging: sep: update driver to SEP version 3.4.5
Date: Tue,  4 Jan 2011 14:16:59 -0800
Message-Id: <1294179419-23676-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes enable the driver to work with SEP
version 3.4.5

Major change is to use non DMA access for any data
comming from a function that uses the external application
service on the SEP.

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
---
 drivers/staging/sep/sep_driver.c        |   32 ++++++++++++------------------
 drivers/staging/sep/sep_driver_api.h    |    4 +-
 drivers/staging/sep/sep_driver_config.h |    4 +++
 3 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index a1b0bfe..ee23454 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -29,7 +29,6 @@
  *  2010.09.14  Upgrade to Medfield
  *
  */
-#define DEBUG
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/miscdevice.h>
@@ -2177,22 +2176,6 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 	dcb_table_ptr->out_vr_tail_pt = 0;
 
 	if (isapplet == true) {
-		tail_size = data_in_size % block_size;
-		if (tail_size) {
-			if (data_in_size < tail_block_size) {
-				dev_warn(&sep->pdev->dev, "data in size smaller than tail block size\n");
-				error = -ENOSPC;
-				goto end_function;
-			}
-			if (tail_block_size)
-				/*
-				 * Case the tail size should be
-				 * bigger than the real block size
-				 */
-				tail_size = tail_block_size +
-					((data_in_size -
-						tail_block_size) % block_size);
-		}
 
 		/* Check if there is enough data for DMA operation */
 		if (data_in_size < SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE) {
@@ -2213,7 +2196,7 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 			/* Set the output user-space address for mem2mem op */
 			if (app_out_address)
 				dcb_table_ptr->out_vr_tail_pt =
-							(u32)app_out_address;
+							(aligned_u64)app_out_address;
 
 			/*
 			 * Update both data length parameters in order to avoid
@@ -2222,6 +2205,17 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 			 */
 			tail_size = 0x0;
 			data_in_size = 0x0;
+
+		} else {
+			if (!app_out_address) {
+				tail_size = data_in_size % block_size;
+				if (!tail_size) {
+					if (tail_block_size == block_size)
+						tail_size = block_size;
+				}
+			} else {
+				tail_size = 0;
+			}
 		}
 		if (tail_size) {
 			if (is_kva == true) {
@@ -2243,7 +2237,7 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 				 * according to tail data size
 				 */
 				dcb_table_ptr->out_vr_tail_pt =
-					(u32)app_out_address + data_in_size
+					(aligned_u64)app_out_address + data_in_size
 					- tail_size;
 
 			/* Save the real tail data size */
diff --git a/drivers/staging/sep/sep_driver_api.h b/drivers/staging/sep/sep_driver_api.h
index fbbfa23..0f38d61 100644
--- a/drivers/staging/sep/sep_driver_api.h
+++ b/drivers/staging/sep/sep_driver_api.h
@@ -141,11 +141,11 @@ struct sep_dcblock {
 	/* size of data in the first output mlli */
 	u32	output_mlli_data_size;
 	/* pointer to the output virtual tail */
-	u32	out_vr_tail_pt;
+	aligned_u64 out_vr_tail_pt;
 	/* size of tail data */
 	u32	tail_data_size;
 	/* input tail data array */
-	u8	tail_data[64];
+	u8	tail_data[68];
 };
 
 struct sep_caller_id_entry {
diff --git a/drivers/staging/sep/sep_driver_config.h b/drivers/staging/sep/sep_driver_config.h
index b18625d..d3b9220 100644
--- a/drivers/staging/sep/sep_driver_config.h
+++ b/drivers/staging/sep/sep_driver_config.h
@@ -76,6 +76,10 @@ held by the proccess (struct file) */
 #define SEP_REQUEST_DAEMON_MAPPED 1
 #define SEP_REQUEST_DAEMON_UNMAPPED 0
 
+#define SEP_DEV_NAME "sep_sec_driver"
+#define SEP_DEV_SINGLETON "sep_sec_singleton_driver"
+#define SEP_DEV_DAEMON "sep_req_daemon_driver"
+
 /*--------------------------------------------------------
 	SHARED AREA  memory total size is 36K
 	it is divided is following:
-- 
1.6.3.3

