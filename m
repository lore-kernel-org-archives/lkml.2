Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab0LIRZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:25:33 -0500
Received: from mga03.intel.com ([143.182.124.21]:12225 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821Ab0LIRZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:25:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,320,1288594800"; 
   d="scan'208";a="359435253"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, mark.a.allyn@intel.com,
        alan@linux.intel.com, dmitry.kasatkin@nokia.com
Subject: [PATCH 08/11] sep: limit time to wait for reconfig shared area complete
Date: Thu,  9 Dec 2010 09:32:13 -0800
Message-Id: <1291915933-18582-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
---
 drivers/staging/sep/sep_driver.c        |    9 ++++++++-
 drivers/staging/sep/sep_driver_config.h |    2 ++
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 5a54f98..83475eb 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -53,6 +53,7 @@
 #include <asm/cacheflush.h>
 #include <linux/sched.h>
 #include <linux/delay.h>
+#include <linux/jiffies.h>
 #include <linux/rar_register.h>
 
 #include "../memrar/memrar.h"
@@ -3244,6 +3245,9 @@ static int sep_reconfig_shared_area(struct sep_device *sep)
 {
 	int ret_val;
 
+	/* use to limit waiting for SEP */
+	unsigned long end_time;
+
 	dev_dbg(&sep->pdev->dev, "reconfig shared area start\n");
 
 	/* Send the new SHARED MESSAGE AREA to the SEP */
@@ -3255,7 +3259,10 @@ static int sep_reconfig_shared_area(struct sep_device *sep)
 	/* Poll for SEP response */
 	ret_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR1_REG_ADDR);
 
-	while (ret_val != 0xffffffff && ret_val != sep->shared_bus)
+	end_time = jiffies + (WAIT_TIME * HZ);
+
+	while ((time_before(jiffies, end_time)) && (ret_val != 0xffffffff) &&
+		(ret_val != sep->shared_bus))
 		ret_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR1_REG_ADDR);
 
 	/* Check the return value (register) */
diff --git a/drivers/staging/sep/sep_driver_config.h b/drivers/staging/sep/sep_driver_config.h
index b96045f..92338c0 100644
--- a/drivers/staging/sep/sep_driver_config.h
+++ b/drivers/staging/sep/sep_driver_config.h
@@ -230,5 +230,7 @@ held by the proccess (struct file) */
 /* the token that defines the data pool pointers address */
 #define SEP_EXT_CACHE_ADDR_VAL_TOKEN                          0xBABABABA
 
+/* Time limit for SEP to finish */
+#define WAIT_TIME 10
 
 #endif /* SEP DRIVER CONFIG */
-- 
1.6.3.3

