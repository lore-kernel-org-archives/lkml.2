Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab2JLUCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 16:02:36 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:47939
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531Ab2JLUCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 16:02:34 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, Stable <stable@vger.kernel.org>
Subject: [PATCH 2/3] Drivers: hv: Cleanup error handling in vmbus_open()
Date: Fri, 12 Oct 2012 13:22:42 -0700
Message-Id: <1350073363-10614-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1350073363-10614-1-git-send-email-kys@microsoft.com>
References: <1350073335-10575-1-git-send-email-kys@microsoft.com>
 <1350073363-10614-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a memory leak  in the error handling path in the function vmbus_open().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Reported-by: Jason Wang <jasowang@redhat.com>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/hv/channel.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 1bb1a80..773a2f2 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -138,14 +138,14 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 
 	if (ret != 0) {
 		err = ret;
-		goto errorout;
+		goto error0;
 	}
 
 	ret = hv_ringbuffer_init(
 		&newchannel->inbound, in, recv_ringbuffer_size);
 	if (ret != 0) {
 		err = ret;
-		goto errorout;
+		goto error0;
 	}
 
 
@@ -160,7 +160,7 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 
 	if (ret != 0) {
 		err = ret;
-		goto errorout;
+		goto error0;
 	}
 
 	/* Create and init the channel open message */
@@ -169,7 +169,7 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 			   GFP_KERNEL);
 	if (!open_info) {
 		err = -ENOMEM;
-		goto errorout;
+		goto error0;
 	}
 
 	init_completion(&open_info->waitevent);
@@ -185,7 +185,7 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 
 	if (userdatalen > MAX_USER_DEFINED_BYTES) {
 		err = -EINVAL;
-		goto errorout;
+		goto error0;
 	}
 
 	if (userdatalen)
@@ -200,19 +200,18 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 			       sizeof(struct vmbus_channel_open_channel));
 
 	if (ret != 0)
-		goto cleanup;
+		goto error1;
 
 	t = wait_for_completion_timeout(&open_info->waitevent, 5*HZ);
 	if (t == 0) {
 		err = -ETIMEDOUT;
-		goto errorout;
+		goto error1;
 	}
 
 
 	if (open_info->response.open_result.status)
 		err = open_info->response.open_result.status;
 
-cleanup:
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 	list_del(&open_info->msglistentry);
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
@@ -220,9 +219,12 @@ cleanup:
 	kfree(open_info);
 	return err;
 
-errorout:
-	hv_ringbuffer_cleanup(&newchannel->outbound);
-	hv_ringbuffer_cleanup(&newchannel->inbound);
+error1:
+	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
+	list_del(&open_info->msglistentry);
+	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
+
+error0:
 	free_pages((unsigned long)out,
 		get_order(send_ringbuffer_size + recv_ringbuffer_size));
 	kfree(open_info);
-- 
1.7.4.1

