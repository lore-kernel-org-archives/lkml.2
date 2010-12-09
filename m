Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088Ab0LIUTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:19:48 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:45730
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753721Ab0LIUTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:19:46 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: hjanssen@microsoft.com, zbr@ioremap.net, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 1/1] Properly check return values of kmalloc and vmbus_recvpacket
Date: Thu,  9 Dec 2010 12:23:29 -0800
Message-Id: <1291926209-17120-1-git-send-email-hjanssen@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct ugly oversight, we need to check the return values of kmalloc
and vmbus_recvpacket and return if they fail. I also tightened up the
call to kmalloc. 

Thanks to Evgeniy Polyakov <zbr@ioremap.net>  for pointing this out.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/hv_utils.c |   48 ++++++++++++++++++++++++++++------------
 1 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/hv/hv_utils.c b/drivers/staging/hv/hv_utils.c
index 53e1e29..ac68575 100644
--- a/drivers/staging/hv/hv_utils.c
+++ b/drivers/staging/hv/hv_utils.c
@@ -43,21 +43,27 @@ static void shutdown_onchannelcallback(void *context)
 {
 	struct vmbus_channel *channel = context;
 	u8 *buf;
-	u32 buflen, recvlen;
+	u32 recvlen;
 	u64 requestid;
 	u8  execute_shutdown = false;
+	int ret = 0;
 
 	struct shutdown_msg_data *shutdown_msg;
 
 	struct icmsg_hdr *icmsghdrp;
 	struct icmsg_negotiate *negop = NULL;
 
-	buflen = PAGE_SIZE;
-	buf = kmalloc(buflen, GFP_ATOMIC);
+	buf = kmalloc(PAGE_SIZE, GFP_ATOMIC);
 
-	vmbus_recvpacket(channel, buf, buflen, &recvlen, &requestid);
+	if (!buf) {
+		printk(KERN_INFO
+		       "Unable to allocate memory for shutdown_onchannelcallback");
+		return;
+	}
+
+	ret = vmbus_recvpacket(channel, buf, PAGE_SIZE, &recvlen, &requestid);
 
-	if (recvlen > 0) {
+	if (ret == 0 && recvlen > 0) {
 		DPRINT_DBG(VMBUS, "shutdown packet: len=%d, requestid=%lld",
 			   recvlen, requestid);
 
@@ -151,17 +157,23 @@ static void timesync_onchannelcallback(void *context)
 {
 	struct vmbus_channel *channel = context;
 	u8 *buf;
-	u32 buflen, recvlen;
+	u32 recvlen;
 	u64 requestid;
 	struct icmsg_hdr *icmsghdrp;
 	struct ictimesync_data *timedatap;
+	int ret = 0;
 
-	buflen = PAGE_SIZE;
-	buf = kmalloc(buflen, GFP_ATOMIC);
+	buf = kmalloc(PAGE_SIZE, GFP_ATOMIC);
 
-	vmbus_recvpacket(channel, buf, buflen, &recvlen, &requestid);
+	if (!buf) {
+		printk(KERN_INFO
+		       "Unable to allocate memory for timesync_onchannelcallback");
+		return;
+	}
 
-	if (recvlen > 0) {
+	ret = vmbus_recvpacket(channel, buf, PAGE_SIZE, &recvlen, &requestid);
+
+	if (ret == 0 && recvlen > 0) {
 		DPRINT_DBG(VMBUS, "timesync packet: recvlen=%d, requestid=%lld",
 			recvlen, requestid);
 
@@ -197,17 +209,23 @@ static void heartbeat_onchannelcallback(void *context)
 {
 	struct vmbus_channel *channel = context;
 	u8 *buf;
-	u32 buflen, recvlen;
+	u32 recvlen;
 	u64 requestid;
 	struct icmsg_hdr *icmsghdrp;
 	struct heartbeat_msg_data *heartbeat_msg;
+	int ret = 0;
+
+	buf = kmalloc(PAGE_SIZE, GFP_ATOMIC);
 
-	buflen = PAGE_SIZE;
-	buf = kmalloc(buflen, GFP_ATOMIC);
+	if (!buf) {
+		printk(KERN_INFO
+		    "Unable to allocate memory for heartbeat_onchannelcallback");
+		return;
+	}
 
-	vmbus_recvpacket(channel, buf, buflen, &recvlen, &requestid);
+	ret = vmbus_recvpacket(channel, buf, PAGE_SIZE, &recvlen, &requestid);
 
-	if (recvlen > 0) {
+	if (ret == 0 && recvlen > 0) {
 		DPRINT_DBG(VMBUS, "heartbeat packet: len=%d, requestid=%lld",
 			   recvlen, requestid);
 
-- 
1.6.0.2

