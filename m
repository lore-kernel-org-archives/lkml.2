Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab2LAO1i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:27:38 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:34431
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab2LAOXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:23:39 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 08/28] Drivers: hv: Update the ring buffer structure to match win8 functionality
Date: Sat,  1 Dec 2012 06:46:39 -0800
Message-Id: <1354373219-31374-8-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354373219-31374-1-git-send-email-kys@microsoft.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the ringbuffer structure to support win8 functionality.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 include/linux/hyperv.h |   28 +++++++++++++++++++++-------
 1 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index b097bf9..2b54801 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -325,14 +325,28 @@ struct hv_ring_buffer {
 
 	u32 interrupt_mask;
 
-	/* Pad it to PAGE_SIZE so that data starts on page boundary */
-	u8	reserved[4084];
-
-	/* NOTE:
-	 * The interrupt_mask field is used only for channels but since our
-	 * vmbus connection also uses this data structure and its data starts
-	 * here, we commented out this field.
+	/*
+	 * Win8 uses some of the reserved bits to implement
+	 * interrupt driven flow management. On the send side
+	 * we can request that the receiver interrupt the sender
+	 * when the ring transitions from being full to being able
+	 * to handle a message of size "pending_send_sz".
+	 *
+	 * Add necessary state for this enhancement.
 	 */
+	u32 pending_send_sz;
+
+	u32 reserved1[12];
+
+	union {
+		struct {
+			u32 feat_pending_send_sz:1;
+		};
+		u32 value;
+	} feature_bits;
+
+	/* Pad it to PAGE_SIZE so that data starts on page boundary */
+	u8	reserved2[4028];
 
 	/*
 	 * Ring data starts here + RingDataStartOffset
-- 
1.7.4.1

