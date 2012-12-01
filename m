Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab2LAOZy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:25:54 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:43007
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209Ab2LAOXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:23:40 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 17/28] Drivers: hv: Add state to manage incoming channel interrupt load
Date: Sat,  1 Dec 2012 06:46:48 -0800
Message-Id: <1354373219-31374-17-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354373219-31374-1-git-send-email-kys@microsoft.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add state to bind a channel to a specific VCPU. This will help us better
distribute incoming interrupt load.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/channel.c      |    2 +-
 drivers/hv/channel_mgmt.c |    2 ++
 include/linux/hyperv.h    |   21 +++++++++++++++++++--
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 70a34da..9303252 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -181,7 +181,7 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 	open_msg->ringbuffer_gpadlhandle = newchannel->ringbuffer_gpadlhandle;
 	open_msg->downstream_ringbuffer_pageoffset = send_ringbuffer_size >>
 						  PAGE_SHIFT;
-	open_msg->server_contextarea_gpadlhandle = 0;
+	open_msg->target_vp = newchannel->target_vp;
 
 	if (userdatalen > MAX_USER_DEFINED_BYTES) {
 		err = -EINVAL;
diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index f4d9902..56ed45c 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -302,6 +302,8 @@ static void vmbus_onoffer(struct vmbus_channel_message_header *hdr)
 				offer->connection_id;
 	}
 
+	newchannel->target_vp = 0;
+
 	memcpy(&newchannel->offermsg, offer,
 	       sizeof(struct vmbus_channel_offer_channel));
 	newchannel->monitor_grp = (u8)offer->monitorid / 32;
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index c6e2c44..8c3cb1f 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -732,8 +732,15 @@ struct vmbus_channel_open_channel {
 	/* GPADL for the channel's ring buffer. */
 	u32 ringbuffer_gpadlhandle;
 
-	/* GPADL for the channel's server context save area. */
-	u32 server_contextarea_gpadlhandle;
+	/*
+	 * Starting with win8, this field will be used to specify
+	 * the target virtual processor on which to deliver the interrupt for
+	 * the host to guest communication.
+	 * Prior to win8, incoming channel interrupts would only
+	 * be delivered on cpu 0. Setting this value to 0 would
+	 * preserve the earlier behavior.
+	 */
+	u32 target_vp;
 
 	/*
 	* The upstream ring buffer begins at offset zero in the memory
@@ -971,6 +978,16 @@ struct vmbus_channel {
 	bool is_dedicated_interrupt;
 	struct hv_input_signal_event_buffer sig_buf;
 	struct hv_input_signal_event *sig_event;
+
+	/*
+	 * Starting with win8, this field will be used to specify
+	 * the target virtual processor on which to deliver the interrupt for
+	 * the host to guest communication.
+	 * Prior to win8, incoming channel interrupts would only
+	 * be delivered on cpu 0. Setting this value to 0 would
+	 * preserve the earlier behavior.
+	 */
+	u32 target_vp;
 };
 
 static inline void set_channel_read_state(struct vmbus_channel *c, bool state)
-- 
1.7.4.1

