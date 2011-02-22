Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab1BVXYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 18:24:21 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:46102
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753323Ab1BVXYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 18:24:19 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: hjanssen@microsoft.com, haiyangz@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 5/6] Staging: hv: ring_buffer.c Removed DPRINT replaced with pr_XX
Date: Tue, 22 Feb 2011 15:32:44 -0800
Message-Id: <1298417565-12356-5-git-send-email-hjanssen@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1298417565-12356-4-git-send-email-hjanssen@microsoft.com>
References: <1298417565-12356-1-git-send-email-hjanssen@microsoft.com>
 <1298417565-12356-2-git-send-email-hjanssen@microsoft.com>
 <1298417565-12356-3-git-send-email-hjanssen@microsoft.com>
 <1298417565-12356-4-git-send-email-hjanssen@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This group of patches removes all DPRINT from hv_vmbus.ko.
It is divided in several patches due to size.

All DPRINT calls have been removed, and where needed have been
replaced with pr_XX native calls. Many debug DPRINT calls have
been removed outright.

The amount of clutter this driver prints has been
significantly reduced.

Several DPRINT calls remain in this file, they will be removed
in a subsequent patch. They are designed to print out a common
debug stream that will be implemented differently.

Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

---
 drivers/staging/hv/ring_buffer.c |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/hv/ring_buffer.c b/drivers/staging/hv/ring_buffer.c
index 66688fb..95dd75c 100644
--- a/drivers/staging/hv/ring_buffer.c
+++ b/drivers/staging/hv/ring_buffer.c
@@ -372,19 +372,16 @@ int ringbuffer_write(struct hv_ring_buffer_info *outring_info,
 				&bytes_avail_toread,
 				&bytes_avail_towrite);
 
-	DPRINT_DBG(VMBUS, "Writing %u bytes...", totalbytes_towrite);
-
 	/* Dumpring_info(Outring_info, "BEFORE "); */
 
 	/* If there is only room for the packet, assume it is full. */
 	/* Otherwise, the next time around, we think the ring buffer */
 	/* is empty since the read index == write index */
 	if (bytes_avail_towrite <= totalbytes_towrite) {
-		DPRINT_DBG(VMBUS,
-			"No more space left on outbound ring buffer "
+		pr_debug("%s: %s No more space left on outbound ring buffer "
 			"(needed %u, avail %u)",
-			totalbytes_towrite,
-			bytes_avail_towrite);
+			 VMBUS_MOD, __func__, totalbytes_towrite,
+			 bytes_avail_towrite);
 
 		spin_unlock_irqrestore(&outring_info->ring_lock, flags);
 		return -1;
@@ -499,17 +496,13 @@ int ringbuffer_read(struct hv_ring_buffer_info *inring_info, void *buffer,
 				&bytes_avail_toread,
 				&bytes_avail_towrite);
 
-	DPRINT_DBG(VMBUS, "Reading %u bytes...", buflen);
-
 	/* Dumpring_info(Inring_info, "BEFORE "); */
 
 	/* Make sure there is something to read */
 	if (bytes_avail_toread < buflen) {
-		DPRINT_DBG(VMBUS,
-			"got callback but not enough to read "
-			"<avail to read %d read size %d>!!",
-			bytes_avail_toread,
-			buflen);
+		pr_debug("%s: %s got callback but not enough to read "
+			"<avail to read %d read size %d>",
+			 VMBUS_MOD, __func__, bytes_avail_toread, buflen);
 
 		spin_unlock_irqrestore(&inring_info->ring_lock, flags);
 
@@ -568,7 +561,8 @@ copyto_ringbuffer(
 
 	/* wrap-around detected! */
 	if (srclen > ring_buffer_size - start_write_offset) {
-		DPRINT_DBG(VMBUS, "wrap-around detected!");
+		pr_debug("%s: %s destination wrap-around detected!",
+			 VMBUS_MOD, __func__);
 
 		frag_len = ring_buffer_size - start_write_offset;
 		memcpy(ring_buffer + start_write_offset, src, frag_len);
@@ -607,7 +601,8 @@ copyfrom_ringbuffer(
 
 	/* wrap-around detected at the src */
 	if (destlen > ring_buffer_size - start_read_offset) {
-		DPRINT_DBG(VMBUS, "src wrap-around detected!");
+		pr_debug("%s: %s source wrap-around detected!",
+			 VMBUS_MOD, __func__);
 
 		frag_len = ring_buffer_size - start_read_offset;
 
-- 
1.6.0.2

