Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab2LAO2m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:28:42 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:33177
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab2LAO2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:28:39 -0500
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Dec 2012 09:28:39 EST
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 04/28] Drivers: hv: Optimize signaling in the read path
Date: Sat,  1 Dec 2012 06:46:35 -0800
Message-Id: <1354373219-31374-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354373219-31374-1-git-send-email-kys@microsoft.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have the infratructure for correctly determining when we
should signal the host; optimize the signaling on the read side -
signaling the guest from the host.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/connection.c |   28 +++++++++++++++++++++++++---
 1 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 650c9f0..d1019a7 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -212,6 +212,9 @@ static void process_chn_event(u32 relid)
 {
 	struct vmbus_channel *channel;
 	unsigned long flags;
+	void *arg;
+	bool read_state;
+	u32 bytes_to_read;
 
 	/*
 	 * Find the channel based on this relid and invokes the
@@ -234,10 +237,29 @@ static void process_chn_event(u32 relid)
 	 */
 
 	spin_lock_irqsave(&channel->inbound_lock, flags);
-	if (channel->onchannel_callback != NULL)
-		channel->onchannel_callback(channel->channel_callback_context);
-	else
+	if (channel->onchannel_callback != NULL) {
+		arg = channel->channel_callback_context;
+		read_state = channel->batched_reading;
+		/*
+		 * This callback reads the messages sent by the host.
+		 * We can optimize host to guest signaling by ensuring:
+		 * 1. While reading the channel, we disable interrupts from
+		 *    host.
+		 * 2. Ensure that we process all posted messages from the host
+		 *    before returning from this callback.
+		 * 3. Once we return, enable signaling from the host. Once this
+		 *    state is set we check to see if additional packets are
+		 *    available to read. In this case we repeat the process.
+		 */
+
+		do {
+			hv_begin_read(&channel->inbound);
+			channel->onchannel_callback(arg);
+			bytes_to_read = hv_end_read(&channel->inbound);
+		} while (read_state && (bytes_to_read != 0));
+	} else {
 		pr_err("no channel callback for relid - %u\n", relid);
+	}
 
 	spin_unlock_irqrestore(&channel->inbound_lock, flags);
 }
-- 
1.7.4.1

