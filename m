Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab2LAOXl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:23:41 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:47958
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab2LAOXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:23:39 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 02/28] Drivers: hv: Add state to manage batched reading
Date: Sat,  1 Dec 2012 06:46:33 -0800
Message-Id: <1354373219-31374-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354373219-31374-1-git-send-email-kys@microsoft.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the "read" side signaling optimization, the reader has to completely
drain the queue before exiting. Add state to manage this "batched"
reading.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/channel_mgmt.c |    7 +++++++
 include/linux/hyperv.h    |   20 ++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 2f84c5c..7bf5917 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -275,6 +275,13 @@ static void vmbus_onoffer(struct vmbus_channel_message_header *hdr)
 		return;
 	}
 
+	/*
+	 * By default we setup state to enable batched
+	 * reading. A specific service can choose to
+	 * disable this prior to opening the channel.
+	 */
+	newchannel->batched_reading = true;
+
 	memcpy(&newchannel->offermsg, offer,
 	       sizeof(struct vmbus_channel_offer_channel));
 	newchannel->monitor_grp = (u8)offer->monitorid / 32;
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index e73b852..1ffe84d 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -882,8 +882,28 @@ struct vmbus_channel {
 
 	void (*onchannel_callback)(void *context);
 	void *channel_callback_context;
+
+	/*
+	 * A channel can be marked for efficient (batched)
+	 * reading:
+	 * If batched_reading is set to "true", we read until the
+	 * channel is empty and hold off interrupts from the host
+	 * during the entire read process.
+	 * If batched_reading is set to "false", the client is not
+	 * going to perform batched reading.
+	 *
+	 * By default we will enable batched reading; specific
+	 * drivers that don't want this behavior can turn it off.
+	 */
+
+	bool batched_reading;
 };
 
+static inline void set_channel_read_state(struct vmbus_channel *c, bool state)
+{
+	c->batched_reading = state;
+}
+
 void vmbus_onmessage(void *context);
 
 int vmbus_request_offers(void);
-- 
1.7.4.1

