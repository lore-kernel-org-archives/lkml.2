Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761573Ab2J2Vwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:52:54 -0400
Received: from mail.kernel.org ([198.145.19.201]:48575 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761549Ab2J2VlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:41:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [ 19/54] Drivers: hv: Cleanup error handling in vmbus_open()
Date: Mon, 29 Oct 2012 14:40:20 -0700
Message-Id: <20121029213804.905370727@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213802.697479610@linuxfoundation.org>
References: <20121029213802.697479610@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 1392550240aaa72ce3a094a38bd23525cd67ce60 upstream.

Fix a memory leak  in the error handling path in the function vmbus_open().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Reported-by: Jason Wang <jasowang@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hv/channel.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -146,14 +146,14 @@ int vmbus_open(struct vmbus_channel *new
 
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
 
 
@@ -168,7 +168,7 @@ int vmbus_open(struct vmbus_channel *new
 
 	if (ret != 0) {
 		err = ret;
-		goto errorout;
+		goto error0;
 	}
 
 	/* Create and init the channel open message */
@@ -177,7 +177,7 @@ int vmbus_open(struct vmbus_channel *new
 			   GFP_KERNEL);
 	if (!open_info) {
 		err = -ENOMEM;
-		goto errorout;
+		goto error0;
 	}
 
 	init_completion(&open_info->waitevent);
@@ -193,7 +193,7 @@ int vmbus_open(struct vmbus_channel *new
 
 	if (userdatalen > MAX_USER_DEFINED_BYTES) {
 		err = -EINVAL;
-		goto errorout;
+		goto error0;
 	}
 
 	if (userdatalen)
@@ -208,19 +208,18 @@ int vmbus_open(struct vmbus_channel *new
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


