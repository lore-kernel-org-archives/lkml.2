Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab2LAO1m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:27:42 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:47958
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035Ab2LAOXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:23:39 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 07/28] Drivers: hv: Support handling multiple VMBUS versions
Date: Sat,  1 Dec 2012 06:46:38 -0800
Message-Id: <1354373219-31374-7-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354373219-31374-1-git-send-email-kys@microsoft.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code hard coded the vmbus version independent of the host
it was running on. Add code to dynamically negotiate the most appropriate
version.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/connection.c |  165 +++++++++++++++++++++++++++++++---------------
 include/linux/hyperv.h  |    6 --
 2 files changed, 111 insertions(+), 60 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index d1019a7..2b56a3f 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -40,15 +40,111 @@ struct vmbus_connection vmbus_connection = {
 };
 
 /*
+ * VMBUS version is 32 bit entity broken up into
+ * two 16 bit quantities: major_number. minor_number.
+ *
+ * 0 . 13 (Windows Server 2008)
+ * 1 . 1  (Windows 7)
+ * 2 . 4  (Windows 8)
+ */
+
+#define VERSION_WS2008	((0 << 16) | (13))
+#define VERSION_WIN7	((1 << 16) | (1))
+#define VERSION_WIN8	((2 << 16) | (4))
+
+#define VERSION_INVAL -1
+
+static __u32 vmbus_get_next_version(__u32 current_version)
+{
+	switch (current_version) {
+	case (VERSION_WIN7):
+		return VERSION_WS2008;
+
+	case (VERSION_WIN8):
+		return VERSION_WIN7;
+
+	case (VERSION_WS2008):
+	default:
+		return VERSION_INVAL;
+	}
+}
+
+static int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo,
+					__u32 version)
+{
+	int ret = 0;
+	struct vmbus_channel_initiate_contact *msg;
+	unsigned long flags;
+	int t;
+
+	init_completion(&msginfo->waitevent);
+
+	msg = (struct vmbus_channel_initiate_contact *)msginfo->msg;
+
+	msg->header.msgtype = CHANNELMSG_INITIATE_CONTACT;
+	msg->vmbus_version_requested = version;
+	msg->interrupt_page = virt_to_phys(vmbus_connection.int_page);
+	msg->monitor_page1 = virt_to_phys(vmbus_connection.monitor_pages);
+	msg->monitor_page2 = virt_to_phys(
+			(void *)((unsigned long)vmbus_connection.monitor_pages +
+				 PAGE_SIZE));
+
+	/*
+	 * Add to list before we send the request since we may
+	 * receive the response before returning from this routine
+	 */
+	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
+	list_add_tail(&msginfo->msglistentry,
+		      &vmbus_connection.chn_msg_list);
+
+	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
+
+	ret = vmbus_post_msg(msg,
+			       sizeof(struct vmbus_channel_initiate_contact));
+	if (ret != 0) {
+		spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
+		list_del(&msginfo->msglistentry);
+		spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock,
+					flags);
+		return ret;
+	}
+
+	/* Wait for the connection response */
+	t =  wait_for_completion_timeout(&msginfo->waitevent, 5*HZ);
+	if (t == 0) {
+		spin_lock_irqsave(&vmbus_connection.channelmsg_lock,
+				flags);
+		list_del(&msginfo->msglistentry);
+		spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock,
+					flags);
+		return -ETIMEDOUT;
+	}
+
+	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
+	list_del(&msginfo->msglistentry);
+	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
+
+	/* Check if successful */
+	if (msginfo->response.version_response.version_supported) {
+		vmbus_connection.conn_state = CONNECTED;
+	} else {
+		pr_err("Unable to connect, "
+			"Version %d not supported by Hyper-V\n",
+			version);
+		return -ECONNREFUSED;
+	}
+
+	return ret;
+}
+
+/*
  * vmbus_connect - Sends a connect request on the partition service connection
  */
 int vmbus_connect(void)
 {
 	int ret = 0;
-	int t;
 	struct vmbus_channel_msginfo *msginfo = NULL;
-	struct vmbus_channel_initiate_contact *msg;
-	unsigned long flags;
+	__u32 version;
 
 	/* Initialize the vmbus connection */
 	vmbus_connection.conn_state = CONNECTING;
@@ -99,64 +195,25 @@ int vmbus_connect(void)
 		goto cleanup;
 	}
 
-	init_completion(&msginfo->waitevent);
-
-	msg = (struct vmbus_channel_initiate_contact *)msginfo->msg;
-
-	msg->header.msgtype = CHANNELMSG_INITIATE_CONTACT;
-	msg->vmbus_version_requested = VMBUS_REVISION_NUMBER;
-	msg->interrupt_page = virt_to_phys(vmbus_connection.int_page);
-	msg->monitor_page1 = virt_to_phys(vmbus_connection.monitor_pages);
-	msg->monitor_page2 = virt_to_phys(
-			(void *)((unsigned long)vmbus_connection.monitor_pages +
-				 PAGE_SIZE));
-
 	/*
-	 * Add to list before we send the request since we may
-	 * receive the response before returning from this routine
+	 * Negotiate a compatible VMBUS version number with the
+	 * host. We start with the highest number we can support
+	 * and work our way down until we negotiate a compatible
+	 * version.
 	 */
-	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
-	list_add_tail(&msginfo->msglistentry,
-		      &vmbus_connection.chn_msg_list);
-
-	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 
-	ret = vmbus_post_msg(msg,
-			       sizeof(struct vmbus_channel_initiate_contact));
-	if (ret != 0) {
-		spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
-		list_del(&msginfo->msglistentry);
-		spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock,
-					flags);
-		goto cleanup;
-	}
+	version = VERSION_WS2008;
 
-	/* Wait for the connection response */
-	t =  wait_for_completion_timeout(&msginfo->waitevent, 5*HZ);
-	if (t == 0) {
-		spin_lock_irqsave(&vmbus_connection.channelmsg_lock,
-				flags);
-		list_del(&msginfo->msglistentry);
-		spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock,
-					flags);
-		ret = -ETIMEDOUT;
-		goto cleanup;
-	}
+	do {
+		ret = vmbus_negotiate_version(msginfo, version);
+		if (ret == 0)
+			break;
 
-	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
-	list_del(&msginfo->msglistentry);
-	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
+		version = vmbus_get_next_version(version);
+	} while (version != VERSION_INVAL);
 
-	/* Check if successful */
-	if (msginfo->response.version_response.version_supported) {
-		vmbus_connection.conn_state = CONNECTED;
-	} else {
-		pr_err("Unable to connect, "
-			"Version %d not supported by Hyper-V\n",
-			VMBUS_REVISION_NUMBER);
-		ret = -ECONNREFUSED;
+	if (version == VERSION_INVAL)
 		goto cleanup;
-	}
 
 	kfree(msginfo);
 	return 0;
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 1ffe84d..b097bf9 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -406,12 +406,6 @@ hv_get_ringbuffer_availbytes(struct hv_ring_buffer_info *rbi,
 #define HV_DRV_VERSION           "3.1"
 
 
-/*
- * A revision number of vmbus that is used for ensuring both ends on a
- * partition are using compatible versions.
- */
-#define VMBUS_REVISION_NUMBER		13
-
 /* Make maximum size of pipe payload of 16K */
 #define MAX_PIPE_DATA_PAYLOAD		(sizeof(u8) * 16384)
 
-- 
1.7.4.1

