Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261Ab0GSJDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 05:03:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:16628 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760216Ab0GSJDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 05:03:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,226,1278313200"; 
   d="scan'208";a="536788151"
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 1/2] memrar: Address kernel oops during resource cleanup
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Mon, 19 Jul 2010 09:32:26 +0100
Message-ID: <20100719083212.7357.28472.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ossama Othman <ossama.othman@intel.com>

Some delayed initialization is performed in this driver.  Make sure
resources that are used during driver clean-up (e.g. during driver's
release() function) are fully initialized before first use.  This is
particularly important for the case when the delayed initialization
isn't completed, leaving behind a partially initialized driver.

Such a scenario can occur when RAR is not available on the platform,
and the driver is release()d.

Signed-off-by: Ossama Othman <ossama.othman@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/memrar/memrar_handler.c |   28 +++++++++++++++++++---------
 1 files changed, 19 insertions(+), 9 deletions(-)


diff --git a/drivers/staging/memrar/memrar_handler.c b/drivers/staging/memrar/memrar_handler.c
index 5fe6028..a98b3f1 100644
--- a/drivers/staging/memrar/memrar_handler.c
+++ b/drivers/staging/memrar/memrar_handler.c
@@ -278,15 +278,6 @@ static int memrar_init_rar_resources(int rarnum, char const *devname)
 	BUG_ON(!memrar_is_valid_rar_type(rarnum));
 	BUG_ON(rar->allocated);
 
-	mutex_init(&rar->lock);
-
-	/*
-	 * Initialize the process table before we reach any
-	 * code that exit on failure since the finalization
-	 * code requires an initialized list.
-	 */
-	INIT_LIST_HEAD(&rar->buffers.list);
-
 	if (rar_get_address(rarnum, &low, &high) != 0)
 		/* No RAR is available. */
 		return -ENODEV;
@@ -940,9 +931,28 @@ static int memrar_registration_callback(unsigned long rar)
 static int __init memrar_init(void)
 {
 	int err;
+	int i;
 
 	printk(banner);
 
+	/*
+	 * Some delayed initialization is performed in this driver.
+	 * Make sure resources that are used during driver clean-up
+	 * (e.g. during driver's release() function) are fully
+	 * initialized before first use.  This is particularly
+	 * important for the case when the delayed initialization
+	 * isn't completed, leaving behind a partially initialized
+	 * driver.
+	 *
+	 * Such a scenario can occur when RAR is not available on the
+	 * platform, and the driver is release()d.
+	 */
+	for (i = 0; i != ARRAY_SIZE(memrars); ++i) {
+		struct memrar_rar_info * const rar = &memrars[i];
+		mutex_init(&rar->lock);
+		INIT_LIST_HEAD(&rar->buffers.list);
+	}
+
 	err = misc_register(&memrar_miscdev);
 	if (err)
 		return err;

