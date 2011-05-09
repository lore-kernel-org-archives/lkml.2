Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594Ab1EJIhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:37:03 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:53207
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756101Ab1EJIaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 179/206] Staging: hv: Include the contents of utils.h
Date: Mon,  9 May 2011 14:57:41 -0700
Message-Id: <1304978288-22999-179-git-send-email-kys@microsoft.com>
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
 include/linux/hyperv.h |   98 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 97 insertions(+), 1 deletions(-)

diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 81f8742..e6bf39f 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -842,4 +842,100 @@ void vmbus_child_driver_unregister(struct device_driver *drv);
 extern struct completion hv_channel_ready;
 
 
-#endif /* _HYPERV_H_ */
+/*
+ * Common header for Hyper-V ICs
+ */
+#define ICMSGTYPE_NEGOTIATE		0
+#define ICMSGTYPE_HEARTBEAT		1
+#define ICMSGTYPE_KVPEXCHANGE		2
+#define ICMSGTYPE_SHUTDOWN		3
+#define ICMSGTYPE_TIMESYNC		4
+#define ICMSGTYPE_VSS			5
+
+#define ICMSGHDRFLAG_TRANSACTION	1
+#define ICMSGHDRFLAG_REQUEST		2
+#define ICMSGHDRFLAG_RESPONSE		4
+
+#define HV_S_OK				0x00000000
+#define HV_E_FAIL			0x80004005
+#define HV_ERROR_NOT_SUPPORTED		0x80070032
+#define HV_ERROR_MACHINE_LOCKED		0x800704F7
+
+struct vmbuspipe_hdr {
+	u32 flags;
+	u32 msgsize;
+} __packed;
+
+struct ic_version {
+	u16 major;
+	u16 minor;
+} __packed;
+
+struct icmsg_hdr {
+	struct ic_version icverframe;
+	u16 icmsgtype;
+	struct ic_version icvermsg;
+	u16 icmsgsize;
+	u32 status;
+	u8 ictransaction_id;
+	u8 icflags;
+	u8 reserved[2];
+} __packed;
+
+struct icmsg_negotiate {
+	u16 icframe_vercnt;
+	u16 icmsg_vercnt;
+	u32 reserved;
+	struct ic_version icversion_data[1]; /* any size array */
+} __packed;
+
+struct shutdown_msg_data {
+	u32 reason_code;
+	u32 timeout_seconds;
+	u32 flags;
+	u8  display_message[2048];
+} __packed;
+
+struct heartbeat_msg_data {
+	u64 seq_num;
+	u32 reserved[8];
+} __packed;
+
+/* Time Sync IC defs */
+#define ICTIMESYNCFLAG_PROBE	0
+#define ICTIMESYNCFLAG_SYNC	1
+#define ICTIMESYNCFLAG_SAMPLE	2
+
+#ifdef __x86_64__
+#define WLTIMEDELTA	116444736000000000L	/* in 100ns unit */
+#else
+#define WLTIMEDELTA	116444736000000000LL
+#endif
+
+struct ictimesync_data {
+	u64 parenttime;
+	u64 childtime;
+	u64 roundtriptime;
+	u8 flags;
+} __packed;
+
+/* Index for each IC struct in array hv_cb_utils[] */
+#define HV_SHUTDOWN_MSG		0
+#define HV_TIMESYNC_MSG		1
+#define HV_HEARTBEAT_MSG	2
+#define HV_KVP_MSG		3
+
+struct hyperv_service_callback {
+	u8 msg_type;
+	char *log_msg;
+	unsigned char data[16];
+	struct vmbus_channel *channel;
+	void (*callback) (void *context);
+};
+
+extern void prep_negotiate_resp(struct icmsg_hdr *,
+				struct icmsg_negotiate *, u8 *);
+extern void chn_cb_negotiate(void *);
+extern struct hyperv_service_callback hv_cb_utils[];
+
+#endif /* _HYPERV_H */
-- 
1.7.4.1

