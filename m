Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab2LAOZ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:25:57 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42637
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200Ab2LAOXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:23:40 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 15/28] Drivers: hv: Cleanup vmbus_set_event() to support win7 and beyond
Date: Sat,  1 Dec 2012 06:46:46 -0800
Message-Id: <1354373219-31374-15-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354373219-31374-1-git-send-email-kys@microsoft.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On win7 (ws2008 R2) and beyond, we have the notion of having dedicated interrupts on
a per-channel basis. When a channel has a dedicated interrupt assigned, there is no need
to set the interrupt bit in the shared page. Implement this optimization.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/connection.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 56b14e5..114050d 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -383,10 +383,13 @@ int vmbus_post_msg(void *buffer, size_t buflen)
 int vmbus_set_event(struct vmbus_channel *channel)
 {
 	u32 child_relid = channel->offermsg.child_relid;
-	/* Each u32 represents 32 channels */
-	sync_set_bit(child_relid & 31,
-		(unsigned long *)vmbus_connection.send_int_page +
-		(child_relid >> 5));
 
-	return hv_signal_event(hv_context.signal_event_param);
+	if (!channel->is_dedicated_interrupt) {
+		/* Each u32 represents 32 channels */
+		sync_set_bit(child_relid & 31,
+			(unsigned long *)vmbus_connection.send_int_page +
+			(child_relid >> 5));
+	}
+
+	return hv_signal_event(channel->sig_event);
 }
-- 
1.7.4.1

