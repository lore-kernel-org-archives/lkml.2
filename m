Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab0EOVkI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:40:08 -0400
Received: from smtpauth20.prod.mesa1.secureserver.net ([64.202.165.36]:59288
	"HELO smtpauth20.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751242Ab0EOVkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:40:06 -0400
Message-ID: <4BEF14AE.6040009@sailtheuniverse.com>
Date: Sat, 15 May 2010 14:39:58 -0700
From: Hank Janssen <hjanssen@sailtheuniverse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: hjanssen@microsoft.com, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, virtualization@lists.osdl.org,
       gregkh@suse.de, haiyangz@microsoft.com
Subject: [PATCH 1/1] staging: hv: Added heartbeat functionality to hv_utils
References: <4BE0A5C9.2020409@sailtheuniverse.com>
In-Reply-To: <4BE0A5C9.2020409@sailtheuniverse.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 1/1] staging: hv: Added heartbeat functionality to hv_utils

Add heartbeat functionality to hv_utils/Hyper-V

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/channel_mgmt.c |   23 ++++++++++++-
 drivers/staging/hv/hv_utils.c     |   64 +++++++++++++++++++++++++++++++++++++
 drivers/staging/hv/utils.h        |    5 +++
 drivers/staging/hv/version_info.h |    3 +-
 4 files changed, 92 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index 6877e8e..3f53b4d 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -33,8 +33,8 @@ struct vmbus_channel_message_table_entry {
 	void (*messageHandler)(struct vmbus_channel_message_header *msg);
 };

-#define MAX_MSG_TYPES                    2
-#define MAX_NUM_DEVICE_CLASSES_SUPPORTED 6
+#define MAX_MSG_TYPES                    3
+#define MAX_NUM_DEVICE_CLASSES_SUPPORTED 7

 static const struct hv_guid
 	gSupportedDeviceClasses[MAX_NUM_DEVICE_CLASSES_SUPPORTED] = {
@@ -89,6 +89,14 @@ static const struct hv_guid
 			0xad, 0xce, 0xe8, 0x0a, 0xb0, 0x17, 0x5c, 0xaf
 		}
 	},
+	/* {57164f39-9115-4e78-ab55-382f3bd5422d} */
+	/* Heartbeat */
+	{
+		.data = {
+			0x39, 0x4f, 0x16, 0x57, 0x15, 0x91, 0x78, 0x4e,
+			0xab, 0x55, 0x38, 0x2f, 0x3b, 0xd5, 0x42, 0x2d
+		}
+	},
 };


@@ -211,6 +219,17 @@ struct hyperv_service_callback hv_cb_utils[MAX_MSG_TYPES] = {
 		.callback = chn_cb_negotiate,
 		.log_msg = "Timesync channel functionality initialized"
 	},
+	/* {57164f39-9115-4e78-ab55-382f3bd5422d} */
+	/* Heartbeat */
+	{
+		.msg_type = HV_HEARTBEAT_MSG,
+		.data = {
+			0x39, 0x4f, 0x16, 0x57, 0x15, 0x91, 0x78, 0x4e,
+			0xab, 0x55, 0x38, 0x2f, 0x3b, 0xd5, 0x42, 0x2d
+		},
+		.callback = chn_cb_negotiate,
+		.log_msg = "Heartbeat channel functionality initialized"
+	},
 };
 EXPORT_SYMBOL(hv_cb_utils);

diff --git a/drivers/staging/hv/hv_utils.c b/drivers/staging/hv/hv_utils.c
index db45d97..8a49aaf 100644
--- a/drivers/staging/hv/hv_utils.c
+++ b/drivers/staging/hv/hv_utils.c
@@ -194,6 +194,62 @@ static void timesync_onchannelcallback(void *context)
 	DPRINT_EXIT(VMBUS);
 }

+/*
+ * Heartbeat functionality.
+ * Every two seconds, Hyper-V send us a heartbeat request message.
+ * we respond to this message, and Hyper-V knows we are alive.
+ */
+static void heartbeat_onchannelcallback(void *context)
+{
+	struct vmbus_channel *channel = context;
+	u8 *buf;
+	u32 buflen, recvlen;
+	u64 requestid;
+	struct icmsg_hdr *icmsghdrp;
+	struct heartbeat_msg_data *heartbeat_msg;
+
+	DPRINT_ENTER(VMBUS);
+
+	buflen = PAGE_SIZE;
+	buf = kmalloc(buflen, GFP_ATOMIC);
+
+	VmbusChannelRecvPacket(channel, buf, buflen, &recvlen, &requestid);
+
+	if (recvlen > 0) {
+		DPRINT_DBG(VMBUS, "heartbeat packet: len=%d, requestid=%lld",
+			   recvlen, requestid);
+
+		icmsghdrp = (struct icmsg_hdr *)&buf[
+			sizeof(struct vmbuspipe_hdr)];
+
+		icmsghdrp = (struct icmsg_hdr *)&buf[
+				sizeof(struct vmbuspipe_hdr)];
+
+		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
+			prep_negotiate_resp(icmsghdrp, NULL, buf);
+		} else {
+			heartbeat_msg = (struct heartbeat_msg_data *)&buf[
+				sizeof(struct vmbuspipe_hdr) +
+				sizeof(struct icmsg_hdr)];
+
+			DPRINT_DBG(VMBUS, "heartbeat seq = %lld",
+				   heartbeat_msg->seq_num);
+
+			heartbeat_msg->seq_num += 1;
+		}
+
+		icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION
+			| ICMSGHDRFLAG_RESPONSE;
+
+		VmbusChannelSendPacket(channel, buf,
+				       recvlen, requestid,
+				       VmbusPacketTypeDataInBand, 0);
+	}
+
+	kfree(buf);
+
+	DPRINT_EXIT(VMBUS);
+}

 static int __init init_hyperv_utils(void)
 {
@@ -207,6 +263,10 @@ static int __init init_hyperv_utils(void)
 		&timesync_onchannelcallback;
 	hv_cb_utils[HV_TIMESYNC_MSG].callback = &timesync_onchannelcallback;

+	hv_cb_utils[HV_HEARTBEAT_MSG].channel->OnChannelCallback =
+		&heartbeat_onchannelcallback;
+	hv_cb_utils[HV_HEARTBEAT_MSG].callback = &heartbeat_onchannelcallback;
+
 	return 0;
 }

@@ -221,6 +281,10 @@ static void exit_hyperv_utils(void)
 	hv_cb_utils[HV_TIMESYNC_MSG].channel->OnChannelCallback =
 		&chn_cb_negotiate;
 	hv_cb_utils[HV_TIMESYNC_MSG].callback = &chn_cb_negotiate;
+
+	hv_cb_utils[HV_HEARTBEAT_MSG].channel->OnChannelCallback =
+		&chn_cb_negotiate;
+	hv_cb_utils[HV_HEARTBEAT_MSG].callback = &chn_cb_negotiate;
 }

 module_init(init_hyperv_utils);
diff --git a/drivers/staging/hv/utils.h b/drivers/staging/hv/utils.h
index a4b9fd0..7c07499 100644
--- a/drivers/staging/hv/utils.h
+++ b/drivers/staging/hv/utils.h
@@ -75,6 +75,10 @@ struct shutdown_msg_data {
 	u8  display_message[2048];
 } __attribute__((packed));

+struct heartbeat_msg_data {
+	u64 seq_num;
+	u32 reserved[8];
+} __attribute__((packed));

 /* Time Sync IC defs */
 #define ICTIMESYNCFLAG_PROBE	0
@@ -97,6 +101,7 @@ struct ictimesync_data{
 /* Index for each IC struct in array hv_cb_utils[] */
 #define HV_SHUTDOWN_MSG		0
 #define HV_TIMESYNC_MSG		1
+#define HV_HEARTBEAT_MSG	2

 struct hyperv_service_callback {
 	u8 msg_type;
diff --git a/drivers/staging/hv/version_info.h b/drivers/staging/hv/version_info.h
index 82e74b1..35178f2 100644
--- a/drivers/staging/hv/version_info.h
+++ b/drivers/staging/hv/version_info.h
@@ -40,8 +40,9 @@
  *	Minor Number	Changes when new functionality is added
  *			to the Linux IC's that is not a bug fix.
  *
+ * 3.1 - Added completed hv_utils driver. Shutdown/Heartbeat/Timesync
  */
-#define HV_DRV_VERSION           "3.0"
+#define HV_DRV_VERSION           "3.1"


 #endif
-- 
1.6.0.2


