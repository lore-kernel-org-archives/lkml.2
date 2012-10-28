Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab2J1X1r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:27:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41986 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756618Ab2J1X1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:42 -0400
Message-Id: <20121028231600.885634903@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:53 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jason Wang <jasowang@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 077/105] Drivers: hv: Cleanup error handling in vmbus_open()
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 1392550240aaa72ce3a094a38bd23525cd67ce60 upstream.

Fix a memory leak  in the error handling path in the function vmbus_open().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Reported-by: Jason Wang <jasowang@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


