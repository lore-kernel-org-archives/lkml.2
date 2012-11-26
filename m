Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934064Ab2KZROu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:14:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48165 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933958Ab2KZROi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:14:38 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 236/270] Drivers: hv: Cleanup error handling in vmbus_open()
Date: Mon, 26 Nov 2012 14:58:46 -0200
Message-Id: <1353949160-26803-237-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 1392550240aaa72ce3a094a38bd23525cd67ce60 upstream.

Fix a memory leak  in the error handling path in the function vmbus_open().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Reported-by: Jason Wang <jasowang@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/hv/channel.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 4065374..f4c3d28 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -146,14 +146,14 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 
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
 
 
@@ -168,7 +168,7 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 
 	if (ret != 0) {
 		err = ret;
-		goto errorout;
+		goto error0;
 	}
 
 	/* Create and init the channel open message */
@@ -177,7 +177,7 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 			   GFP_KERNEL);
 	if (!open_info) {
 		err = -ENOMEM;
-		goto errorout;
+		goto error0;
 	}
 
 	init_completion(&open_info->waitevent);
@@ -193,7 +193,7 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 
 	if (userdatalen > MAX_USER_DEFINED_BYTES) {
 		err = -EINVAL;
-		goto errorout;
+		goto error0;
 	}
 
 	if (userdatalen)
@@ -208,19 +208,18 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
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
@@ -228,9 +227,12 @@ cleanup:
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
1.7.9.5

