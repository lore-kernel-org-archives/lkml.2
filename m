Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab1JZAXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 20:23:32 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:60809
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754072Ab1JZAXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 20:23:30 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        dmitry.torokhov@gmail.com, joe@perches.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 4/6] Staging: hv: mousevsc: Cleanup mousevsc_on_channel_callback()
Date: Tue, 25 Oct 2011 17:19:50 -0700
Message-Id: <1319588392-9982-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1319588392-9982-1-git-send-email-kys@microsoft.com>
References: <1319588311-9935-1-git-send-email-kys@microsoft.com>
 <1319588392-9982-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup mousevsc_on_channel_callback(). This is based on the code provided
by Joe Perches <joe@perches.com>.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |   85 ++++++++++++++++++-----------------------
 1 files changed, 37 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index ed071b8..b10466f 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -313,73 +313,62 @@ static void mousevsc_on_receive(struct hv_device *device,
 
 static void mousevsc_on_channel_callback(void *context)
 {
-	const int packetSize = 0x100;
-	int ret = 0;
-	struct hv_device *device = (struct hv_device *)context;
-
+	const int packet_size = 0x100;
+	int ret;
+	struct hv_device *device = context;
 	u32 bytes_recvd;
 	u64 req_id;
-	unsigned char packet[0x100];
 	struct vmpacket_descriptor *desc;
-	unsigned char	*buffer = packet;
-	int	bufferlen = packetSize;
+	unsigned char	*buffer;
+	int	bufferlen = packet_size;
 
+	buffer = kmalloc(bufferlen, GFP_ATOMIC);
+	if (!buffer)
+		return;
 
 	do {
 		ret = vmbus_recvpacket_raw(device->channel, buffer,
 					bufferlen, &bytes_recvd, &req_id);
 
-		if (ret == 0) {
-			if (bytes_recvd > 0) {
-				desc = (struct vmpacket_descriptor *)buffer;
-
-				switch (desc->type) {
-				case VM_PKT_COMP:
-					break;
-
-				case VM_PKT_DATA_INBAND:
-					mousevsc_on_receive(
-						device, desc);
-					break;
-
-				default:
-					pr_err("unhandled packet type %d, tid %llx len %d\n",
-						   desc->type,
-						   req_id,
-						   bytes_recvd);
-					break;
-				}
-
-				/* reset */
-				if (bufferlen > packetSize) {
-					kfree(buffer);
-
-					buffer = packet;
-					bufferlen = packetSize;
-				}
-			} else {
-				if (bufferlen > packetSize) {
-					kfree(buffer);
-
-					buffer = packet;
-					bufferlen = packetSize;
-				}
+		switch (ret) {
+		case 0:
+			if (bytes_recvd <= 0) {
+				kfree(buffer);
+				return;
+			}
+			desc = (struct vmpacket_descriptor *)buffer;
+
+			switch (desc->type) {
+			case VM_PKT_COMP:
+				break;
+
+			case VM_PKT_DATA_INBAND:
+				mousevsc_on_receive(device, desc);
+				break;
+
+			default:
+				pr_err("unhandled packet type %d, tid %llx len %d\n",
+				   desc->type,
+				   req_id,
+				   bytes_recvd);
 				break;
 			}
-		} else if (ret == -ENOBUFS) {
+
+			break;
+
+		case -ENOBUFS:
+			kfree(buffer);
 			/* Handle large packet */
 			bufferlen = bytes_recvd;
-			buffer = kzalloc(bytes_recvd, GFP_ATOMIC);
+			buffer = kmalloc(bytes_recvd, GFP_ATOMIC);
 
 			if (buffer == NULL) {
-				buffer = packet;
-				bufferlen = packetSize;
-				break;
+				return;
 			}
+			break;
 		}
 	} while (1);
 
-	return;
 }
 
 static int mousevsc_connect_to_vsp(struct hv_device *device)
-- 
1.7.4.1

