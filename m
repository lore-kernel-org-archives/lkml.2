Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409Ab1FFWkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:40:22 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:37284
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758188Ab1FFWfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:35:01 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 35/49] Staging: hv: vmbus: Use the newly introduced state in closing the channel
Date: Mon,  6 Jun 2011 15:49:59 -0700
Message-Id: <1307400613-13234-35-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, use the newly introduced state in closing the channel and eliminate a 
potential failure condition (that currently was not being handled correctly).

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/channel.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 043fe25..5a2a947 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -549,22 +549,15 @@ EXPORT_SYMBOL_GPL(vmbus_teardown_gpadl);
 void vmbus_close(struct vmbus_channel *channel)
 {
 	struct vmbus_channel_close_channel *msg;
-	struct vmbus_channel_msginfo *info;
 	int ret;
 
 	/* Stop callback and cancel the timer asap */
 	channel->onchannel_callback = NULL;
 
 	/* Send a closing message */
-	info = kmalloc(sizeof(*info) +
-		       sizeof(struct vmbus_channel_close_channel), GFP_KERNEL);
-        /* FIXME: can't do anything other than return here because the
-	 *        function is void */
-	if (!info)
-		return;
 
+	msg = &channel->close_msg.msg;
 
-	msg = (struct vmbus_channel_close_channel *)info->msg;
 	msg->header.msgtype = CHANNELMSG_CLOSECHANNEL;
 	msg->child_relid = channel->offermsg.child_relid;
 
@@ -583,7 +576,6 @@ void vmbus_close(struct vmbus_channel *channel)
 	free_pages((unsigned long)channel->ringbuffer_pages,
 		get_order(channel->ringbuffer_pagecount * PAGE_SIZE));
 
-	kfree(info);
 
 }
 EXPORT_SYMBOL_GPL(vmbus_close);
-- 
1.7.4.1

