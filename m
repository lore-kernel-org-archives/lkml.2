Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab0LIRZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:25:56 -0500
Received: from mga14.intel.com ([143.182.124.37]:1706 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603Ab0LIRZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:25:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,320,1288594800"; 
   d="scan'208";a="359435445"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, mark.a.allyn@intel.com,
        alan@linux.intel.com, dmitry.kasatkin@nokia.com
Subject: [PATCH 10/11] sep: ensure that caller id buffer is little endian
Date: Thu,  9 Dec 2010 09:32:38 -0800
Message-Id: <1291915958-18658-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
---
 drivers/staging/sep/sep_driver.c        |    8 ++++++++
 drivers/staging/sep/sep_driver_config.h |    3 +++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 903d610..bb42b04 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -897,6 +897,7 @@ end_function:
 static int sep_set_current_caller_id(struct sep_device *sep)
 {
 	int i;
+	u32 *hash_buf_ptr;
 
 	dev_dbg(&sep->pdev->dev, "sep_set_current_caller_id start\n");
 	dev_dbg(&sep->pdev->dev, "current process is %d\n", current->pid);
@@ -915,6 +916,13 @@ static int sep_set_current_caller_id(struct sep_device *sep)
 			break;
 		}
 	}
+	/* Ensure data is in little endian */
+	hash_buf_ptr = (u32 *)sep->shared_addr +
+		SEP_CALLER_ID_OFFSET_BYTES;
+
+	for (i = 0; i < SEP_CALLER_ID_HASH_SIZE_IN_WORDS; i++)
+		hash_buf_ptr[i] = cpu_to_le32(hash_buf_ptr[i]);
+
 	dev_dbg(&sep->pdev->dev, "sep_set_current_caller_id end\n");
 	return 0;
 }
diff --git a/drivers/staging/sep/sep_driver_config.h b/drivers/staging/sep/sep_driver_config.h
index 92338c0..b18625d 100644
--- a/drivers/staging/sep/sep_driver_config.h
+++ b/drivers/staging/sep/sep_driver_config.h
@@ -201,6 +201,9 @@ held by the proccess (struct file) */
 /* size of the caller id hash (sha2) */
 #define SEP_CALLER_ID_HASH_SIZE_IN_BYTES                      32
 
+/* size of the caller id hash (sha2) in 32 bit words */
+#define SEP_CALLER_ID_HASH_SIZE_IN_WORDS                8
+
 /* maximum number of entries in the caller id table */
 #define SEP_CALLER_ID_TABLE_NUM_ENTRIES                       20
 
-- 
1.6.3.3

