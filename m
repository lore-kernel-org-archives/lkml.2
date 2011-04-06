Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab1DGAR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 20:17:56 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:46795
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755240Ab1DGARz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 20:17:55 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 21/22] Staging: hv: Introduce a function to map channel properties onto block device info
Date: Wed,  6 Apr 2011 16:05:21 -0700
Message-Id: <1302131122-15530-21-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302131122-15530-1-git-send-email-kys@microsoft.com>
References: <1302131006-15411-1-git-send-email-kys@microsoft.com>
 <1302131122-15530-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for removing the IDE details from the block driver, implement
a function that maps channel properties to block device information.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc.c     |   68 ++++++++++++++++++++++++++++++++++++++
 drivers/staging/hv/storvsc_api.h |   10 +++++
 2 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index d7ce393..e2b3410 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -17,6 +17,8 @@
  * Authors:
  *   Haiyang Zhang <haiyangz@microsoft.com>
  *   Hank Janssen  <hjanssen@microsoft.com>
+ *
+ * 4/3/2011: K. Y. Srinivasan - Significant restructuring and cleanup.
  */
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -593,6 +595,72 @@ int stor_vsc_on_io_request(struct hv_device *device,
 }
 
 /*
+ * The channel properties uniquely specify how the device is to be
+ * presented to the guest. Map this information for use by the block
+ * driver. For Linux guests on Hyper-V, we emulate a scsi HBA in the guest
+ * (storvsc_drv) and so scsi devices in the guest  are handled by
+ * native upper level Linux drivers. Consequently, Hyper-V
+ * block driver, while being a generic block driver, presently does not
+ * deal with anything other than devices that would need to be presented
+ * to the guest as an IDE disk.
+ *
+ * This function maps the channel properties as embedded in the input
+ * parameter device_info onto information necessary to register the
+ * corresponding block device.
+ *
+ * Currently, there is no way to stop the emulation of the block device
+ * on the host side. And so, to prevent the native IDE drivers in Linux
+ * from taking over these devices (to be managedby Hyper-V block
+ * driver), we will take over if need be the major of the IDE controllers.
+ *
+ */
+
+int stor_vsc_get_major_info(struct storvsc_device_info *device_info,
+			    struct storvsc_major_info *major_info)
+{
+	static bool ide0_registered;
+	static bool ide1_registered;
+
+	/*
+	 * For now we only support IDE disks.
+	 */
+	major_info->devname = "ide";
+	major_info->diskname = "hd";
+
+	if (device_info->path_id) {
+		major_info->major = 22;
+		if (!ide1_registered)
+			major_info->do_register = true;
+		else {
+			major_info->do_register = false;
+			ide1_registered = true;
+		}
+		if (device_info->target_id)
+			major_info->index = 3;
+		 else
+			major_info->index = 2;
+
+		return 0;
+	} else {
+		major_info->major = 3;
+		if (!ide0_registered)
+			major_info->do_register = true;
+		else {
+			major_info->do_register = false;
+			ide0_registered = true;
+		}
+		if (device_info->target_id)
+			major_info->index = 1;
+		else
+			major_info->index = 0;
+
+		return 0;
+	}
+
+	return -ENODEV;
+}
+
+/*
  * stor_vsc_on_cleanup - Perform any cleanup when the driver is removed
  */
 void stor_vsc_on_cleanup(struct hv_driver *driver)
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index d7db949..c98139c 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -92,6 +92,14 @@ struct storvsc_device_info {
 	unsigned char target_id;
 };
 
+struct storvsc_major_info {
+	int major;
+	int index;
+	bool do_register;
+	char *devname;
+	char *diskname;
+};
+
 /* A storvsc device is a device object that contains a vmbus channel */
 struct storvsc_device {
 	struct hv_device *device;
@@ -155,5 +163,7 @@ int stor_vsc_on_io_request(struct hv_device *device,
 				struct hv_storvsc_request *request);
 void stor_vsc_on_cleanup(struct hv_driver *driver);
 
+int stor_vsc_get_major_info(struct storvsc_device_info *device_info,
+				struct storvsc_major_info *major_info);
 
 #endif /* _STORVSC_API_H_ */
-- 
1.7.4.1

