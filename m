Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab2LAO1j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:27:39 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:46800
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab2LAOXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:23:39 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 09/28] Drivers: hv: Extend/modify vmbus_channel_offer_channel for win7 and beyond
Date: Sat,  1 Dec 2012 06:46:40 -0800
Message-Id: <1354373219-31374-9-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354373219-31374-1-git-send-email-kys@microsoft.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "offfer" message sent by the host has been extended in win7 (ws2008 R2).
Add/modify state to reflect this extension. All these changes are backward
compatible.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 include/linux/hyperv.h |   36 +++++++++++++++++++++++++++++++-----
 1 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 2b54801..bee559a 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -440,9 +440,13 @@ hv_get_ringbuffer_availbytes(struct hv_ring_buffer_info *rbi,
 struct vmbus_channel_offer {
 	uuid_le if_type;
 	uuid_le if_instance;
-	u64 int_latency; /* in 100ns units */
-	u32 if_revision;
-	u32 server_ctx_size;	/* in bytes */
+
+	/*
+	 * These two fields are not currently used.
+	 */
+	u64 reserved1;
+	u64 reserved2;
+
 	u16 chn_flags;
 	u16 mmio_megabytes;		/* in bytes * 1024 * 1024 */
 
@@ -464,7 +468,11 @@ struct vmbus_channel_offer {
 			unsigned char user_def[MAX_PIPE_USER_DEFINED_BYTES];
 		} pipe;
 	} u;
-	u32 padding;
+	/*
+	 * The sub_channel_index is defined in win8.
+	 */
+	u16 sub_channel_index;
+	u16 reserved3;
 } __packed;
 
 /* Server Flags */
@@ -660,7 +668,25 @@ struct vmbus_channel_offer_channel {
 	struct vmbus_channel_offer offer;
 	u32 child_relid;
 	u8 monitorid;
-	u8 monitor_allocated;
+	/*
+	 * win7 and beyond splits this field into a bit field.
+	 */
+	u8 monitor_allocated:1;
+	u8 reserved:7;
+	/*
+	 * These are new fields added in win7 and later.
+	 * Do not access these fields without checking the
+	 * negotiated protocol.
+	 *
+	 * If "is_dedicated_interrupt" is set, we must not set the
+	 * associated bit in the channel bitmap while sending the
+	 * interrupt to the host.
+	 *
+	 * connection_id is to be used in signaling the host.
+	 */
+	u16 is_dedicated_interrupt:1;
+	u16 reserved1:15;
+	u32 connection_id;
 } __packed;
 
 /* Rescind Offer parameters */
-- 
1.7.4.1

