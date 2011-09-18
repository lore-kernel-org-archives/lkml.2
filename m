Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab1IRRJe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 13:09:34 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:53764
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755576Ab1IRRJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 13:09:31 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 3/3] Staging: hv: vmbus: Get rid of hv_cb_utils[] and other unneeded code
Date: Sun, 18 Sep 2011 10:31:35 -0700
Message-Id: <1316367095-739-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316367095-739-1-git-send-email-kys@microsoft.com>
References: <1316367053-700-1-git-send-email-kys@microsoft.com>
 <1316367095-739-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the transformation of the util driver is complete,
get rid of hv_cb_utils[] and other unneeded code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/channel_mgmt.c |   94 -------------------------------------
 drivers/staging/hv/hyperv.h       |   13 -----
 2 files changed, 0 insertions(+), 107 deletions(-)

diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index 99cc334..9f00752 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -158,100 +158,6 @@ void prep_negotiate_resp(struct icmsg_hdr *icmsghdrp,
 }
 EXPORT_SYMBOL(prep_negotiate_resp);
 
-/**
- * chn_cb_negotiate() - Default handler for non IDE/SCSI/NETWORK
- * Hyper-V requests
- * @context: Pointer to argument structure.
- *
- * Set up the default handler for non device driver specific requests
- * from Hyper-V. This stub responds to the default negotiate messages
- * that come in for every non IDE/SCSI/Network request.
- * This behavior is normally overwritten in the hv_utils driver. That
- * driver handles requests like graceful shutdown, heartbeats etc.
- *
- * Mainly used by Hyper-V drivers.
- */
-void chn_cb_negotiate(void *context)
-{
-	struct vmbus_channel *channel = context;
-	u8 *buf;
-	u32 buflen, recvlen;
-	u64 requestid;
-
-	struct icmsg_hdr *icmsghdrp;
-	struct icmsg_negotiate *negop = NULL;
-
-	buflen = PAGE_SIZE;
-	buf = kmalloc(buflen, GFP_ATOMIC);
-
-	vmbus_recvpacket(channel, buf, buflen, &recvlen, &requestid);
-
-	if (recvlen > 0) {
-		icmsghdrp = (struct icmsg_hdr *)&buf[
-			sizeof(struct vmbuspipe_hdr)];
-
-		prep_negotiate_resp(icmsghdrp, negop, buf);
-
-		icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION
-			| ICMSGHDRFLAG_RESPONSE;
-
-		vmbus_sendpacket(channel, buf,
-				       recvlen, requestid,
-				       VM_PKT_DATA_INBAND, 0);
-	}
-
-	kfree(buf);
-}
-EXPORT_SYMBOL(chn_cb_negotiate);
-
-/*
- * Function table used for message responses for non IDE/SCSI/Network type
- * messages. (Such as KVP/Shutdown etc)
- */
-struct hyperv_service_callback hv_cb_utils[MAX_MSG_TYPES] = {
-	/* 0E0B6031-5213-4934-818B-38D90CED39DB */
-	/* Shutdown */
-	{
-		.msg_type = HV_SHUTDOWN_MSG,
-		.data.b = {
-			0x31, 0x60, 0x0B, 0X0E, 0x13, 0x52, 0x34, 0x49,
-			0x81, 0x8B, 0x38, 0XD9, 0x0C, 0xED, 0x39, 0xDB
-		},
-		.log_msg = "Shutdown channel functionality initialized"
-	},
-
-	/* {9527E630-D0AE-497b-ADCE-E80AB0175CAF} */
-	/* TimeSync */
-	{
-		.msg_type = HV_TIMESYNC_MSG,
-		.data.b = {
-			0x30, 0xe6, 0x27, 0x95, 0xae, 0xd0, 0x7b, 0x49,
-			0xad, 0xce, 0xe8, 0x0a, 0xb0, 0x17, 0x5c, 0xaf
-		},
-		.log_msg = "Timesync channel functionality initialized"
-	},
-	/* {57164f39-9115-4e78-ab55-382f3bd5422d} */
-	/* Heartbeat */
-	{
-		.msg_type = HV_HEARTBEAT_MSG,
-		.data.b = {
-			0x39, 0x4f, 0x16, 0x57, 0x15, 0x91, 0x78, 0x4e,
-			0xab, 0x55, 0x38, 0x2f, 0x3b, 0xd5, 0x42, 0x2d
-		},
-		.log_msg = "Heartbeat channel functionality initialized"
-	},
-	/* {A9A0F4E7-5A45-4d96-B827-8A841E8C03E6} */
-	/* KVP */
-	{
-		.data.b = {
-			0xe7, 0xf4, 0xa0, 0xa9, 0x45, 0x5a, 0x96, 0x4d,
-			0xb8, 0x27, 0x8a, 0x84, 0x1e, 0x8c, 0x3,  0xe6
-		},
-		.log_msg = "KVP channel functionality initialized"
-	},
-};
-EXPORT_SYMBOL(hv_cb_utils);
-
 /*
  * alloc_channel - Allocate and initialize a vmbus channel object
  */
diff --git a/drivers/staging/hv/hyperv.h b/drivers/staging/hv/hyperv.h
index 49ef2b2..0cbfc59 100644
--- a/drivers/staging/hv/hyperv.h
+++ b/drivers/staging/hv/hyperv.h
@@ -581,11 +581,6 @@ struct vmbus_channel {
 	struct work_struct work;
 
 	enum vmbus_channel_state state;
-	/*
-	 * For util channels, stash the
-	 * the service index for easy access.
-	 */
-	s8 util_index;
 
 	struct vmbus_channel_offer_channel offermsg;
 	/*
@@ -963,12 +958,6 @@ struct ictimesync_data {
 	u8 flags;
 } __packed;
 
-/* Index for each IC struct in array hv_cb_utils[] */
-#define HV_SHUTDOWN_MSG		0
-#define HV_TIMESYNC_MSG		1
-#define HV_HEARTBEAT_MSG	2
-#define HV_KVP_MSG		3
-
 struct hyperv_service_callback {
 	u8 msg_type;
 	char *log_msg;
@@ -979,7 +968,5 @@ struct hyperv_service_callback {
 
 extern void prep_negotiate_resp(struct icmsg_hdr *,
 				struct icmsg_negotiate *, u8 *);
-extern void chn_cb_negotiate(void *);
-extern struct hyperv_service_callback hv_cb_utils[];
 
 #endif /* _HYPERV_H */
-- 
1.7.4.1

