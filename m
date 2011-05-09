Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628Ab1EJIdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:33:08 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:53218
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756111Ab1EJIax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:53 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 173/206] Staging: hv: Include the contents of storvsc_api.h
Date: Mon,  9 May 2011 14:57:35 -0700
Message-Id: <1304978288-22999-173-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject line says it all.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/hyperv_storage.h |  138 ++++++++++++++++++++++++++++++++++-
 1 files changed, 136 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/hyperv_storage.h b/drivers/staging/hv/hyperv_storage.h
index 4324493..93fac7c 100644
--- a/drivers/staging/hv/hyperv_storage.h
+++ b/drivers/staging/hv/hyperv_storage.h
@@ -22,6 +22,9 @@
  *
  */
 
+#ifndef _HYPERV_STORAGE_H
+#define _HYPERV_STORAGE_H
+
 /*
  * vstorage.w revision number.  This is used in the case
  * of a version match, to alert the user that structure sizes may
@@ -29,8 +32,11 @@
  * protocol versions match.
  */
 
-#ifndef _HYPERV_STORAGE_H
-#define _HYPERV_STORAGE_H
+#include <linux/kernel.h>
+#include <linux/atomic.h>
+#include <linux/completion.h>
+#include <linux/wait.h>
+
 
 #define REVISION_STRING(REVISION_) #REVISION_
 #define FILL_VMSTOR_REVISION(RESULT_LVALUE_)				\
@@ -198,4 +204,132 @@ struct vstor_packet {
 /*  This is the set of flags that the vsc can set in any packets it sends */
 #define VSC_LEGAL_FLAGS		(REQUEST_COMPLETION_FLAG)
 
+/* Defines */
+#define STORVSC_RING_BUFFER_SIZE			(20*PAGE_SIZE)
+#define BLKVSC_RING_BUFFER_SIZE				(20*PAGE_SIZE)
+
+#define STORVSC_MAX_IO_REQUESTS				128
+
+/*
+ * In Hyper-V, each port/path/target maps to 1 scsi host adapter.  In
+ * reality, the path/target is not used (ie always set to 0) so our
+ * scsi host adapter essentially has 1 bus with 1 target that contains
+ * up to 256 luns.
+ */
+#define STORVSC_MAX_LUNS_PER_TARGET			64
+#define STORVSC_MAX_TARGETS				1
+#define STORVSC_MAX_CHANNELS				1
+
+struct hv_storvsc_request;
+
+/* Matches Windows-end */
+enum storvsc_request_type {
+	WRITE_TYPE,
+	READ_TYPE,
+	UNKNOWN_TYPE,
+};
+
+
+struct hv_storvsc_request {
+	struct hv_storvsc_request *request;
+	struct hv_device *device;
+
+	/* Synchronize the request/response if needed */
+	struct completion wait_event;
+
+	unsigned char *sense_buffer;
+	void *context;
+	void (*on_io_completion)(struct hv_storvsc_request *request);
+	struct hv_multipage_buffer data_buffer;
+
+	struct vstor_packet vstor_packet;
+};
+
+
+struct storvsc_device_info {
+	u32 ring_buffer_size;
+	unsigned int port_number;
+	unsigned char path_id;
+	unsigned char target_id;
+};
+
+struct storvsc_major_info {
+	int major;
+	int index;
+	bool do_register;
+	char *devname;
+	char *diskname;
+};
+
+/* A storvsc device is a device object that contains a vmbus channel */
+struct storvsc_device {
+	struct hv_device *device;
+
+	/* 0 indicates the device is being destroyed */
+	atomic_t ref_count;
+
+	bool	 drain_notify;
+	atomic_t num_outstanding_req;
+
+	wait_queue_head_t waiting_to_drain;
+
+	/*
+	 * Each unique Port/Path/Target represents 1 channel ie scsi
+	 * controller. In reality, the pathid, targetid is always 0
+	 * and the port is set by us
+	 */
+	unsigned int port_number;
+	unsigned char path_id;
+	unsigned char target_id;
+
+	/* Used for vsc/vsp channel reset process */
+	struct hv_storvsc_request init_request;
+	struct hv_storvsc_request reset_request;
+};
+
+
+/* Get the stordevice object iff exists and its refcount > 1 */
+static inline struct storvsc_device *get_stor_device(struct hv_device *device)
+{
+	struct storvsc_device *stor_device;
+
+	stor_device = (struct storvsc_device *)device->ext;
+	if (stor_device && atomic_read(&stor_device->ref_count) > 1)
+		atomic_inc(&stor_device->ref_count);
+	else
+		stor_device = NULL;
+
+	return stor_device;
+}
+
+
+static inline void put_stor_device(struct hv_device *device)
+{
+	struct storvsc_device *stor_device;
+
+	stor_device = (struct storvsc_device *)device->ext;
+
+	atomic_dec(&stor_device->ref_count);
+}
+
+static inline void storvsc_wait_to_drain(struct storvsc_device *dev)
+{
+	dev->drain_notify = true;
+	wait_event(dev->waiting_to_drain,
+		   atomic_read(&dev->num_outstanding_req) == 0);
+	dev->drain_notify = false;
+}
+
+/* Interface */
+
+int storvsc_dev_add(struct hv_device *device,
+				void *additional_info);
+int storvsc_dev_remove(struct hv_device *device);
+
+int storvsc_do_io(struct hv_device *device,
+				struct hv_storvsc_request *request);
+
+int storvsc_get_major_info(struct storvsc_device_info *device_info,
+				struct storvsc_major_info *major_info);
+
 #endif /* _HYPERV_STORAGE_H */
-- 
1.7.4.1

