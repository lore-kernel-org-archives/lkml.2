Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab1IGGFC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:05:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:39453 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755497Ab1IGGE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:04:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,343,1312182000"; 
   d="scan'208";a="48789625"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, alan@linux.intel.com, wim@iguana.be,
        tomas.winkler@intel.com, Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 03/12 v2] staging: mei: registering the MEI driver with the kernel watchdog core interface
Date: Wed,  7 Sep 2011 09:03:09 +0300
Message-Id: <1315375398-29529-4-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315375398-29529-1-git-send-email-oren.jer.weil@intel.com>
References: <1315375398-29529-1-git-send-email-oren.jer.weil@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding kernel watchdog interface (/dev/watchdog) to the MEI Driver to support AMT Watchdog feature.
This patch and the following one will replace MEI Driver self management of the AMT watchdog
with the standard kernel watchdog interface.

Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/staging/mei/init.c      |    1 +
 drivers/staging/mei/interface.h |    4 +++-
 drivers/staging/mei/interrupt.c |   12 ++++++++++++
 drivers/staging/mei/main.c      |    4 ++++
 drivers/staging/mei/mei_dev.h   |    9 +++++++++
 drivers/staging/mei/wd.c        |   20 ++++++++++++++++++--
 6 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/mei/init.c b/drivers/staging/mei/init.c
index 69a57e7..cb0ebbe 100644
--- a/drivers/staging/mei/init.c
+++ b/drivers/staging/mei/init.c
@@ -133,6 +133,7 @@ struct mei_device *mei_device_init(struct pci_dev *pdev)
 	init_waitqueue_head(&dev->wait_stop_wd);
 	dev->mei_state = MEI_INITIALIZING;
 	dev->iamthif_state = MEI_IAMTHIF_IDLE;
+	dev->wd_interface_reg = false;
 
 
 	mei_io_list_init(&dev->read_list);
diff --git a/drivers/staging/mei/interface.h b/drivers/staging/mei/interface.h
index 7bcf096..2b5a22c 100644
--- a/drivers/staging/mei/interface.h
+++ b/drivers/staging/mei/interface.h
@@ -23,7 +23,9 @@
 #include "mei_dev.h"
 
 
-#define AMT_WD_VALUE 120	/* seconds */
+#define AMT_WD_DEFAULT_TIMEOUT 120	/* seconds */
+#define AMT_WD_MIN_TIMEOUT 120	/* seconds */
+#define AMT_WD_MAX_TIMEOUT 65535	/* seconds */
 
 #define MEI_WATCHDOG_DATA_SIZE         16
 #define MEI_START_WD_DATA_SIZE         20
diff --git a/drivers/staging/mei/interrupt.c b/drivers/staging/mei/interrupt.c
index ca1e0c9..958a7e2 100644
--- a/drivers/staging/mei/interrupt.c
+++ b/drivers/staging/mei/interrupt.c
@@ -396,6 +396,18 @@ static void mei_client_connect_response(struct mei_device *dev,
 		dev->wd_due_counter = (dev->wd_timeout) ? 1 : 0;
 
 		dev_dbg(&dev->pdev->dev, "successfully connected to WD client.\n");
+
+		/* Registering watchdog interface device once we got connection
+		   to the WD Client
+		*/
+		if (watchdog_register_device(&amt_wd_dev)) {
+			printk(KERN_ERR "mei: unable to register watchdog device.\n");
+			dev->wd_interface_reg = false;
+		} else {
+			dev_dbg(&dev->pdev->dev, "successfully register watchdog interface.\n");
+			dev->wd_interface_reg = true;
+		}
+
 		mei_host_init_iamthif(dev);
 		return;
 	}
diff --git a/drivers/staging/mei/main.c b/drivers/staging/mei/main.c
index 8d76785..37f07da 100644
--- a/drivers/staging/mei/main.c
+++ b/drivers/staging/mei/main.c
@@ -241,6 +241,10 @@ static void __devexit mei_remove(struct pci_dev *pdev)
 		mei_disconnect_host_client(dev, &dev->wd_cl);
 	}
 
+	/* Unregistering watchdog device */
+	if (dev->wd_interface_reg)
+		watchdog_unregister_device(&amt_wd_dev);
+
 	/* remove entry if already in list */
 	dev_dbg(&pdev->dev, "list del iamthif and wd file list.\n");
 	mei_remove_client_from_file_list(dev, dev->wd_cl.host_client_id);
diff --git a/drivers/staging/mei/mei_dev.h b/drivers/staging/mei/mei_dev.h
index 2e11077..d434afc 100644
--- a/drivers/staging/mei/mei_dev.h
+++ b/drivers/staging/mei/mei_dev.h
@@ -18,6 +18,7 @@
 #define _MEI_DEV_H_
 
 #include <linux/types.h>
+#include <linux/watchdog.h>
 #include "mei.h"
 #include "hw.h"
 
@@ -37,6 +38,12 @@
 #define MEI_WD_STATE_INDEPENDENCE_MSG_SENT       (1 << 0)
 
 /*
+ * AMT Watchdog Device
+ */
+#define INTEL_AMT_WATCHDOG_ID "INTCAMT"
+extern struct watchdog_device amt_wd_dev;
+
+/*
  * AMTHI Client UUID
  */
 extern const uuid_le mei_amthi_guid;
@@ -258,6 +265,8 @@ struct mei_device {
 	bool iamthif_flow_control_pending;
 	bool iamthif_ioctl;
 	bool iamthif_canceled;
+
+	bool wd_interface_reg;
 };
 
 
diff --git a/drivers/staging/mei/wd.c b/drivers/staging/mei/wd.c
index 721487d..d9e41a7 100644
--- a/drivers/staging/mei/wd.c
+++ b/drivers/staging/mei/wd.c
@@ -19,6 +19,7 @@
 #include <linux/device.h>
 #include <linux/pci.h>
 #include <linux/sched.h>
+#include <linux/watchdog.h>
 
 #include "mei_dev.h"
 #include "hw.h"
@@ -26,13 +27,28 @@
 #include "mei.h"
 
 /*
+ * Watchdog Device structs
+ */
+const struct watchdog_info wd_info = {
+		.identity = INTEL_AMT_WATCHDOG_ID,
+};
+
+struct watchdog_device amt_wd_dev = {
+		.info = &wd_info,
+		.timeout = AMT_WD_DEFAULT_TIMEOUT,
+		.min_timeout = AMT_WD_MIN_TIMEOUT,
+		.max_timeout = AMT_WD_MAX_TIMEOUT,
+};
+
+
+/*
  * MEI Watchdog Module Parameters
  */
-static u16 watchdog_timeout = AMT_WD_VALUE;
+static u16 watchdog_timeout = AMT_WD_DEFAULT_TIMEOUT;
 module_param(watchdog_timeout, ushort, 0);
 MODULE_PARM_DESC(watchdog_timeout,
 		"Intel(R) AMT Watchdog timeout value in seconds. (default="
-					__MODULE_STRING(AMT_WD_VALUE)
+					__MODULE_STRING(AMT_WD_DEFAULT_TIMEOUT)
 					", disable=0)");
 
 static const u8 mei_start_wd_params[] = { 0x02, 0x12, 0x13, 0x10 };
-- 
1.7.4.1

