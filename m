Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab1D0Kac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:30:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:23595 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932299Ab1D0Ka1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:30:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,273,1301900400"; 
   d="scan'208";a="739084311"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, david@woodhou.se,
        Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 7/8] staging/mei: AMT Watchdog
Date: Wed, 27 Apr 2011 13:27:36 +0300
Message-Id: <1303900057-21694-8-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1303900057-21694-1-git-send-email-oren.jer.weil@intel.com>
References: <1303900057-21694-1-git-send-email-oren.jer.weil@intel.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

code that open connection and invoke
heartbeats to the AMT Watchdog client/feature, if exists

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Itzhak Tzeel-Krupp <itzhak.tzeel-krupp@intel.com>
Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
---
 drivers/staging/mei/wd.c |  171 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 171 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/mei/wd.c

diff --git a/drivers/staging/mei/wd.c b/drivers/staging/mei/wd.c
new file mode 100644
index 0000000..28db50e
--- /dev/null
+++ b/drivers/staging/mei/wd.c
@@ -0,0 +1,171 @@
+/*
+ *
+ * Intel Management Engine Interface (Intel MEI) Linux driver
+ * Copyright (c) 2003-2011, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/device.h>
+#include <linux/pci.h>
+#include <linux/sched.h>
+
+#include "hw.h"
+#include "interface.h"
+#include "mei.h"
+
+/*
+ * MEI Watchdog Module Parameters
+ */
+static u16 watchdog_timeout = AMT_WD_VALUE;
+module_param(watchdog_timeout, ushort, 0);
+MODULE_PARM_DESC(watchdog_timeout,
+		"Intel(R) AMT Watchdog timeout value in seconds. (default="
+					__MODULE_STRING(AMT_WD_VALUE)
+					", disable=0)");
+
+static const u8 mei_start_wd_params[] = { 0x02, 0x12, 0x13, 0x10 };
+static const u8 mei_stop_wd_params[] = { 0x02, 0x02, 0x14, 0x10 };
+
+const u8 mei_wd_state_independence_msg[3][4] = {
+	{0x05, 0x02, 0x51, 0x10},
+	{0x05, 0x02, 0x52, 0x10},
+	{0x07, 0x02, 0x01, 0x10}
+};
+
+/* UUIDs for AMT F/W clients */
+const uuid_le mei_wd_guid = UUID_LE(0x05B79A6F, 0x4628, 0x4D7F, 0x89,
+						0x9D, 0xA9, 0x15, 0x14, 0xCB,
+						0x32, 0xAB);
+
+
+void mei_wd_start_setup(struct mei_device *dev)
+{
+	dev_dbg(&dev->pdev->dev, "dev->wd_timeout=%d.\n", dev->wd_timeout);
+	memcpy(dev->wd_data, mei_start_wd_params, MEI_WD_PARAMS_SIZE);
+	memcpy(dev->wd_data + MEI_WD_PARAMS_SIZE,
+		&dev->wd_timeout, sizeof(u16));
+}
+
+/**
+ * host_init_wd - mei initialization wd.
+ *
+ * @dev: the device structure
+ */
+void mei_wd_host_init(struct mei_device *dev)
+{
+	mei_init_file_private(&dev->wd_cl, dev);
+
+	/* look for WD client and connect to it */
+	dev->wd_cl.state = MEI_FILE_DISCONNECTED;
+	dev->wd_timeout = watchdog_timeout;
+
+	if (dev->wd_timeout > 0) {
+		mei_wd_start_setup(dev);
+		/* find ME WD client */
+		mei_find_me_client_update_filext(dev, &dev->wd_cl,
+					&mei_wd_guid, MEI_WD_HOST_CLIENT_ID);
+
+		dev_dbg(&dev->pdev->dev, "check wd_cl\n");
+		if (MEI_FILE_CONNECTING == dev->wd_cl.state) {
+			if (!mei_connect(dev, &dev->wd_cl)) {
+				dev_dbg(&dev->pdev->dev, "Failed to connect to WD client\n");
+				dev->wd_cl.state = MEI_FILE_DISCONNECTED;
+				dev->wd_cl.host_client_id = 0;
+				host_init_iamthif(dev) ;
+			} else {
+				dev->wd_cl.timer_count = CONNECT_TIMEOUT;
+			}
+		} else {
+			dev_dbg(&dev->pdev->dev, "Failed to find WD client\n");
+			host_init_iamthif(dev) ;
+		}
+	} else {
+		dev->wd_bypass = true;
+		dev_dbg(&dev->pdev->dev, "WD requested to be disabled\n");
+		host_init_iamthif(dev) ;
+	}
+}
+
+/**
+ * mei_wd_send - sends watch dog message to fw.
+ *
+ * @dev: the device structure
+ *
+ * returns  0 if success, -EIO when message send fails
+ */
+int mei_wd_send(struct mei_device *dev)
+{
+	struct mei_msg_hdr *mei_hdr;
+
+	mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
+	mei_hdr->host_addr = dev->wd_cl.host_client_id;
+	mei_hdr->me_addr = dev->wd_cl.me_client_id;
+	mei_hdr->msg_complete = 1;
+	mei_hdr->reserved = 0;
+
+	if (!memcmp(dev->wd_data, mei_start_wd_params, MEI_WD_PARAMS_SIZE))
+		mei_hdr->length = MEI_START_WD_DATA_SIZE;
+	else if (!memcmp(dev->wd_data, mei_stop_wd_params, MEI_WD_PARAMS_SIZE))
+		mei_hdr->length = MEI_WD_PARAMS_SIZE;
+	else
+		BUG();
+
+	if (mei_write_message(dev, mei_hdr, dev->wd_data, mei_hdr->length))
+		return 0;
+	return -EIO;
+}
+
+int mei_wd_stop(struct mei_device *dev, bool preserve)
+{
+	int ret;
+	u16 wd_timeout = dev->wd_timeout;
+
+	cancel_delayed_work(&dev->wd_work);
+	if (dev->wd_cl.state != MEI_FILE_CONNECTED || !dev->wd_timeout)
+		return 0;
+
+	dev->wd_timeout = 0;
+	dev->wd_due_counter = 0;
+	memcpy(dev->wd_data, mei_stop_wd_params, MEI_WD_PARAMS_SIZE);
+	dev->stop = 1;
+	if (dev->mei_host_buffer_is_empty &&
+	    mei_flow_ctrl_creds(dev, &dev->wd_cl)) {
+		dev->mei_host_buffer_is_empty = 0;
+
+		if (mei_wd_send(dev))
+			dev_dbg(&dev->pdev->dev, "send stop WD failed\n");
+		else
+			mei_flow_ctrl_reduce(dev, &dev->wd_cl);
+
+		dev->wd_pending = 0;
+	} else {
+		dev->wd_pending = 1;
+	}
+	dev->wd_stopped = 0;
+	mutex_unlock(&dev->device_lock);
+
+	ret = wait_event_interruptible_timeout(dev->wait_stop_wd,
+					dev->wd_stopped, 10 * HZ);
+	mutex_lock(&dev->device_lock);
+	if (!dev->wd_stopped)
+		dev_dbg(&dev->pdev->dev, "stop wd failed to complete.\n");
+	else
+		dev_dbg(&dev->pdev->dev, "stop wd complete.\n");
+
+	if (preserve)
+		dev->wd_timeout = wd_timeout;
+
+	return ret;
+}
+
-- 
1.7.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

