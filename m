Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab1EIWEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:04:47 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54154
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754726Ab1EIVop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:45 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 045/206] Staging: hv: Get rid of the forward declaration of copy_from_bounce_buffer()
Date: Mon,  9 May 2011 14:55:27 -0700
Message-Id: <1304978288-22999-45-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration by moving the code around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |  129 +++++++++++++++++++-------------------
 1 files changed, 65 insertions(+), 64 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 551c48c..4e3e9ca 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -219,15 +219,77 @@ cleanup:
 	return NULL;
 }
 
+
+/* Assume the original sgl has enough room */
+static unsigned int copy_from_bounce_buffer(struct scatterlist *orig_sgl,
+					    struct scatterlist *bounce_sgl,
+					    unsigned int orig_sgl_count)
+{
+	int i;
+	int j = 0;
+	unsigned long src, dest;
+	unsigned int srclen, destlen, copylen;
+	unsigned int total_copied = 0;
+	unsigned long bounce_addr = 0;
+	unsigned long dest_addr = 0;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	for (i = 0; i < orig_sgl_count; i++) {
+		dest_addr = (unsigned long)kmap_atomic(sg_page((&orig_sgl[i])),
+					KM_IRQ0) + orig_sgl[i].offset;
+		dest = dest_addr;
+		destlen = orig_sgl[i].length;
+
+		if (bounce_addr == 0)
+			bounce_addr =
+			(unsigned long)kmap_atomic(sg_page((&bounce_sgl[j])),
+							KM_IRQ0);
+
+		while (destlen) {
+			src = bounce_addr + bounce_sgl[j].offset;
+			srclen = bounce_sgl[j].length - bounce_sgl[j].offset;
+
+			copylen = min(srclen, destlen);
+			memcpy((void *)dest, (void *)src, copylen);
+
+			total_copied += copylen;
+			bounce_sgl[j].offset += copylen;
+			destlen -= copylen;
+			dest += copylen;
+
+			if (bounce_sgl[j].offset == bounce_sgl[j].length) {
+				/* full */
+				kunmap_atomic((void *)bounce_addr, KM_IRQ0);
+				j++;
+
+				/* if we need to use another bounce buffer */
+				if (destlen || i != orig_sgl_count - 1)
+					bounce_addr =
+					(unsigned long)kmap_atomic(
+					sg_page((&bounce_sgl[j])), KM_IRQ0);
+			} else if (destlen == 0 && i == orig_sgl_count - 1) {
+				/* unmap the last bounce that is < PAGE_SIZE */
+				kunmap_atomic((void *)bounce_addr, KM_IRQ0);
+			}
+		}
+
+		kunmap_atomic((void *)(dest_addr - orig_sgl[i].offset),
+			      KM_IRQ0);
+	}
+
+	local_irq_restore(flags);
+
+	return total_copied;
+}
+
 /* Static decl */
 static int storvsc_probe(struct hv_device *dev);
 static int storvsc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd);
 static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd);
 static int storvsc_remove(struct hv_device *dev);
 
-static unsigned int copy_from_bounce_buffer(struct scatterlist *orig_sgl,
-					    struct scatterlist *bounce_sgl,
-					    unsigned int orig_sgl_count);
 static unsigned int copy_to_bounce_buffer(struct scatterlist *orig_sgl,
 					  struct scatterlist *bounce_sgl,
 					  unsigned int orig_sgl_count);
@@ -613,67 +675,6 @@ static unsigned int copy_to_bounce_buffer(struct scatterlist *orig_sgl,
 	return total_copied;
 }
 
-/* Assume the original sgl has enough room */
-static unsigned int copy_from_bounce_buffer(struct scatterlist *orig_sgl,
-					    struct scatterlist *bounce_sgl,
-					    unsigned int orig_sgl_count)
-{
-	int i;
-	int j = 0;
-	unsigned long src, dest;
-	unsigned int srclen, destlen, copylen;
-	unsigned int total_copied = 0;
-	unsigned long bounce_addr = 0;
-	unsigned long dest_addr = 0;
-	unsigned long flags;
-
-	local_irq_save(flags);
-
-	for (i = 0; i < orig_sgl_count; i++) {
-		dest_addr = (unsigned long)kmap_atomic(sg_page((&orig_sgl[i])),
-					KM_IRQ0) + orig_sgl[i].offset;
-		dest = dest_addr;
-		destlen = orig_sgl[i].length;
-		/* ASSERT(orig_sgl[i].offset + orig_sgl[i].length <= PAGE_SIZE); */
-
-		if (bounce_addr == 0)
-			bounce_addr = (unsigned long)kmap_atomic(sg_page((&bounce_sgl[j])), KM_IRQ0);
-
-		while (destlen) {
-			src = bounce_addr + bounce_sgl[j].offset;
-			srclen = bounce_sgl[j].length - bounce_sgl[j].offset;
-
-			copylen = min(srclen, destlen);
-			memcpy((void *)dest, (void *)src, copylen);
-
-			total_copied += copylen;
-			bounce_sgl[j].offset += copylen;
-			destlen -= copylen;
-			dest += copylen;
-
-			if (bounce_sgl[j].offset == bounce_sgl[j].length) {
-				/* full */
-				kunmap_atomic((void *)bounce_addr, KM_IRQ0);
-				j++;
-
-				/* if we need to use another bounce buffer */
-				if (destlen || i != orig_sgl_count - 1)
-					bounce_addr = (unsigned long)kmap_atomic(sg_page((&bounce_sgl[j])), KM_IRQ0);
-			} else if (destlen == 0 && i == orig_sgl_count - 1) {
-				/* unmap the last bounce that is < PAGE_SIZE */
-				kunmap_atomic((void *)bounce_addr, KM_IRQ0);
-			}
-		}
-
-		kunmap_atomic((void *)(dest_addr - orig_sgl[i].offset),
-			      KM_IRQ0);
-	}
-
-	local_irq_restore(flags);
-
-	return total_copied;
-}
-
 /*
  * storvsc_queuecommand - Initiate command processing
  */
-- 
1.7.4.1

