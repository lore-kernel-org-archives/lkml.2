Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758513Ab0LMRlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 12:41:51 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:34114
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757859Ab0LMRlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 12:41:50 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: hjanssen@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 1/1] hv: Use only one receive buffer and kmalloc on initialize
Date: Mon, 13 Dec 2010 09:45:50 -0800
Message-Id: <1292262350-29001-1-git-send-email-hjanssen@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct issue with not checking kmalloc return value.
This fix now only uses one receive buffer for all hv_utils 
channels, and will do only one kmalloc on init and will return
with a -ENOMEM if kmalloc fails on initialize.

Thanks to Evgeniy Polyakov <zbr@ioremap.net> for pointing this out.
And thanks to Jesper Juhl <jj@chaosbits.net> and Ky Srinivasan 
<ksrinivasan@novell.com> for suggesting a better implementation of
my original patch.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Cc:Evgeniy Polyakov <zbr@ioremap.net>
Cc:Jesper Juhl <jj@chaosbits.net>
Cc:Ky Srinivasan <ksrinivasan@novell.com>

---
 drivers/staging/hv/hv_utils.c |   68 +++++++++++++++++++---------------------
 1 files changed, 32 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/hv/hv_utils.c b/drivers/staging/hv/hv_utils.c
index 53e1e29..4ed4ab8 100644
--- a/drivers/staging/hv/hv_utils.c
+++ b/drivers/staging/hv/hv_utils.c
@@ -38,12 +38,15 @@
 #include "vmbus_api.h"
 #include "utils.h"
 
+/*
+ * Buffer used to receive packets from Hyper-V
+ */
+static u8 *chan_buf;
 
 static void shutdown_onchannelcallback(void *context)
 {
 	struct vmbus_channel *channel = context;
-	u8 *buf;
-	u32 buflen, recvlen;
+	u32 recvlen;
 	u64 requestid;
 	u8  execute_shutdown = false;
 
@@ -52,22 +55,19 @@ static void shutdown_onchannelcallback(void *context)
 	struct icmsg_hdr *icmsghdrp;
 	struct icmsg_negotiate *negop = NULL;
 
-	buflen = PAGE_SIZE;
-	buf = kmalloc(buflen, GFP_ATOMIC);
-
-	vmbus_recvpacket(channel, buf, buflen, &recvlen, &requestid);
+	vmbus_recvpacket(channel, chan_buf, PAGE_SIZE, &recvlen, &requestid);
 
 	if (recvlen > 0) {
 		DPRINT_DBG(VMBUS, "shutdown packet: len=%d, requestid=%lld",
 			   recvlen, requestid);
 
-		icmsghdrp = (struct icmsg_hdr *)&buf[
+		icmsghdrp = (struct icmsg_hdr *)&chan_buf[
 			sizeof(struct vmbuspipe_hdr)];
 
 		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
-			prep_negotiate_resp(icmsghdrp, negop, buf);
+			prep_negotiate_resp(icmsghdrp, negop, chan_buf);
 		} else {
-			shutdown_msg = (struct shutdown_msg_data *)&buf[
+			shutdown_msg = (struct shutdown_msg_data *)&chan_buf[
 				sizeof(struct vmbuspipe_hdr) +
 				sizeof(struct icmsg_hdr)];
 
@@ -93,13 +93,11 @@ static void shutdown_onchannelcallback(void *context)
 		icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION
 			| ICMSGHDRFLAG_RESPONSE;
 
-		vmbus_sendpacket(channel, buf,
+		vmbus_sendpacket(channel, chan_buf,
 				       recvlen, requestid,
 				       VmbusPacketTypeDataInBand, 0);
 	}
 
-	kfree(buf);
-
 	if (execute_shutdown == true)
 		orderly_poweroff(false);
 }
@@ -150,28 +148,24 @@ static inline void adj_guesttime(u64 hosttime, u8 flags)
 static void timesync_onchannelcallback(void *context)
 {
 	struct vmbus_channel *channel = context;
-	u8 *buf;
-	u32 buflen, recvlen;
+	u32 recvlen;
 	u64 requestid;
 	struct icmsg_hdr *icmsghdrp;
 	struct ictimesync_data *timedatap;
 
-	buflen = PAGE_SIZE;
-	buf = kmalloc(buflen, GFP_ATOMIC);
-
-	vmbus_recvpacket(channel, buf, buflen, &recvlen, &requestid);
+	vmbus_recvpacket(channel, chan_buf, PAGE_SIZE, &recvlen, &requestid);
 
 	if (recvlen > 0) {
 		DPRINT_DBG(VMBUS, "timesync packet: recvlen=%d, requestid=%lld",
 			recvlen, requestid);
 
-		icmsghdrp = (struct icmsg_hdr *)&buf[
+		icmsghdrp = (struct icmsg_hdr *)&chan_buf[
 				sizeof(struct vmbuspipe_hdr)];
 
 		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
-			prep_negotiate_resp(icmsghdrp, NULL, buf);
+			prep_negotiate_resp(icmsghdrp, NULL, chan_buf);
 		} else {
-			timedatap = (struct ictimesync_data *)&buf[
+			timedatap = (struct ictimesync_data *)&chan_buf[
 				sizeof(struct vmbuspipe_hdr) +
 				sizeof(struct icmsg_hdr)];
 			adj_guesttime(timedatap->parenttime, timedatap->flags);
@@ -180,12 +174,10 @@ static void timesync_onchannelcallback(void *context)
 		icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION
 			| ICMSGHDRFLAG_RESPONSE;
 
-		vmbus_sendpacket(channel, buf,
+		vmbus_sendpacket(channel, chan_buf,
 				recvlen, requestid,
 				VmbusPacketTypeDataInBand, 0);
 	}
-
-	kfree(buf);
 }
 
 /*
@@ -196,28 +188,24 @@ static void timesync_onchannelcallback(void *context)
 static void heartbeat_onchannelcallback(void *context)
 {
 	struct vmbus_channel *channel = context;
-	u8 *buf;
-	u32 buflen, recvlen;
+	u32 recvlen;
 	u64 requestid;
 	struct icmsg_hdr *icmsghdrp;
 	struct heartbeat_msg_data *heartbeat_msg;
 
-	buflen = PAGE_SIZE;
-	buf = kmalloc(buflen, GFP_ATOMIC);
-
-	vmbus_recvpacket(channel, buf, buflen, &recvlen, &requestid);
+	vmbus_recvpacket(channel, chan_buf, PAGE_SIZE, &recvlen, &requestid);
 
 	if (recvlen > 0) {
 		DPRINT_DBG(VMBUS, "heartbeat packet: len=%d, requestid=%lld",
 			   recvlen, requestid);
 
-		icmsghdrp = (struct icmsg_hdr *)&buf[
+		icmsghdrp = (struct icmsg_hdr *)&chan_buf[
 				sizeof(struct vmbuspipe_hdr)];
 
 		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
-			prep_negotiate_resp(icmsghdrp, NULL, buf);
+			prep_negotiate_resp(icmsghdrp, NULL, chan_buf);
 		} else {
-			heartbeat_msg = (struct heartbeat_msg_data *)&buf[
+			heartbeat_msg = (struct heartbeat_msg_data *)&chan_buf[
 				sizeof(struct vmbuspipe_hdr) +
 				sizeof(struct icmsg_hdr)];
 
@@ -230,12 +218,10 @@ static void heartbeat_onchannelcallback(void *context)
 		icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION
 			| ICMSGHDRFLAG_RESPONSE;
 
-		vmbus_sendpacket(channel, buf,
+		vmbus_sendpacket(channel, chan_buf,
 				       recvlen, requestid,
 				       VmbusPacketTypeDataInBand, 0);
 	}
-
-	kfree(buf);
 }
 
 static const struct pci_device_id __initconst
@@ -268,6 +254,14 @@ static int __init init_hyperv_utils(void)
 	if (!dmi_check_system(hv_utils_dmi_table))
 		return -ENODEV;
 
+	chan_buf = kmalloc(PAGE_SIZE, GFP_ATOMIC);
+
+	if (!chan_buf) {
+		printk(KERN_INFO
+		       "Unable to allocate memory for receive buffer\n");
+		return -ENOMEM;
+	}
+
 	hv_cb_utils[HV_SHUTDOWN_MSG].channel->onchannel_callback =
 		&shutdown_onchannelcallback;
 	hv_cb_utils[HV_SHUTDOWN_MSG].callback = &shutdown_onchannelcallback;
@@ -298,6 +292,8 @@ static void exit_hyperv_utils(void)
 	hv_cb_utils[HV_HEARTBEAT_MSG].channel->onchannel_callback =
 		&chn_cb_negotiate;
 	hv_cb_utils[HV_HEARTBEAT_MSG].callback = &chn_cb_negotiate;
+
+	kfree(chan_buf);
 }
 
 module_init(init_hyperv_utils);
-- 
1.6.0.2

