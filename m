Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab1K0FdP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:33:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884Ab1K0FdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:33:13 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>, devel@driverdev.osuosl.org
Subject: [PATCH 23/62] hv: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:27:03 +0800
Message-Id: <1322371662-26166-24-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 drivers/staging/hv/netvsc_drv.c   |    5 ++---
 drivers/staging/hv/rndis_filter.c |    4 ++--
 drivers/staging/hv/storvsc_drv.c  |   31 ++++++++++++++-----------------
 3 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 93b0e91..1c61a7d 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -261,8 +261,7 @@ int netvsc_recv_callback(struct hv_device *device_obj,
 	 * hv_netvsc_packet cannot be deallocated
 	 */
 	for (i = 0; i < packet->page_buf_cnt; i++) {
-		data = kmap_atomic(pfn_to_page(packet->page_buf[i].pfn),
-					       KM_IRQ1);
+		data = kmap_atomic(pfn_to_page(packet->page_buf[i].pfn));
 		data = (void *)(unsigned long)data +
 				packet->page_buf[i].offset;
 
@@ -270,7 +269,7 @@ int netvsc_recv_callback(struct hv_device *device_obj,
 		       packet->page_buf[i].len);
 
 		kunmap_atomic((void *)((unsigned long)data -
-				       packet->page_buf[i].offset), KM_IRQ1);
+				       packet->page_buf[i].offset));
 	}
 
 	local_irq_restore(flags);
diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index bafccb3..5e209e7 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -388,7 +388,7 @@ int rndis_filter_receive(struct hv_device *dev,
 	}
 
 	rndis_hdr = (struct rndis_message *)kmap_atomic(
-			pfn_to_page(pkt->page_buf[0].pfn), KM_IRQ0);
+			pfn_to_page(pkt->page_buf[0].pfn));
 
 	rndis_hdr = (void *)((unsigned long)rndis_hdr +
 			pkt->page_buf[0].offset);
@@ -407,7 +407,7 @@ int rndis_filter_receive(struct hv_device *dev,
 			sizeof(struct rndis_message) :
 			rndis_hdr->msg_len);
 
-	kunmap_atomic(rndis_hdr - pkt->page_buf[0].offset, KM_IRQ0);
+	kunmap_atomic(rndis_hdr - pkt->page_buf[0].offset);
 
 	dump_rndis_message(dev, &rndis_msg);
 
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index ae8c33e..05b8bdc 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -847,15 +847,14 @@ static unsigned int copy_from_bounce_buffer(struct scatterlist *orig_sgl,
 	local_irq_save(flags);
 
 	for (i = 0; i < orig_sgl_count; i++) {
-		dest_addr = (unsigned long)kmap_atomic(sg_page((&orig_sgl[i])),
-					KM_IRQ0) + orig_sgl[i].offset;
+		dest_addr = (unsigned long)kmap_atomic(sg_page((&orig_sgl[i])))
+					+ orig_sgl[i].offset;
 		dest = dest_addr;
 		destlen = orig_sgl[i].length;
 
 		if (bounce_addr == 0)
 			bounce_addr =
-			(unsigned long)kmap_atomic(sg_page((&bounce_sgl[j])),
-							KM_IRQ0);
+			(unsigned long)kmap_atomic(sg_page((&bounce_sgl[j])));
 
 		while (destlen) {
 			src = bounce_addr + bounce_sgl[j].offset;
@@ -871,22 +870,21 @@ static unsigned int copy_from_bounce_buffer(struct scatterlist *orig_sgl,
 
 			if (bounce_sgl[j].offset == bounce_sgl[j].length) {
 				/* full */
-				kunmap_atomic((void *)bounce_addr, KM_IRQ0);
+				kunmap_atomic((void *)bounce_addr);
 				j++;
 
 				/* if we need to use another bounce buffer */
 				if (destlen || i != orig_sgl_count - 1)
 					bounce_addr =
 					(unsigned long)kmap_atomic(
-					sg_page((&bounce_sgl[j])), KM_IRQ0);
+					sg_page((&bounce_sgl[j])));
 			} else if (destlen == 0 && i == orig_sgl_count - 1) {
 				/* unmap the last bounce that is < PAGE_SIZE */
-				kunmap_atomic((void *)bounce_addr, KM_IRQ0);
+				kunmap_atomic((void *)bounce_addr);
 			}
 		}
 
-		kunmap_atomic((void *)(dest_addr - orig_sgl[i].offset),
-			      KM_IRQ0);
+		kunmap_atomic((void *)(dest_addr - orig_sgl[i].offset));
 	}
 
 	local_irq_restore(flags);
@@ -912,15 +910,14 @@ static unsigned int copy_to_bounce_buffer(struct scatterlist *orig_sgl,
 	local_irq_save(flags);
 
 	for (i = 0; i < orig_sgl_count; i++) {
-		src_addr = (unsigned long)kmap_atomic(sg_page((&orig_sgl[i])),
-				KM_IRQ0) + orig_sgl[i].offset;
+		src_addr = (unsigned long)kmap_atomic(sg_page((&orig_sgl[i])))
+				+ orig_sgl[i].offset;
 		src = src_addr;
 		srclen = orig_sgl[i].length;
 
 		if (bounce_addr == 0)
 			bounce_addr =
-			(unsigned long)kmap_atomic(sg_page((&bounce_sgl[j])),
-						KM_IRQ0);
+			(unsigned long)kmap_atomic(sg_page((&bounce_sgl[j])));
 
 		while (srclen) {
 			/* assume bounce offset always == 0 */
@@ -937,22 +934,22 @@ static unsigned int copy_to_bounce_buffer(struct scatterlist *orig_sgl,
 
 			if (bounce_sgl[j].length == PAGE_SIZE) {
 				/* full..move to next entry */
-				kunmap_atomic((void *)bounce_addr, KM_IRQ0);
+				kunmap_atomic((void *)bounce_addr);
 				j++;
 
 				/* if we need to use another bounce buffer */
 				if (srclen || i != orig_sgl_count - 1)
 					bounce_addr =
 					(unsigned long)kmap_atomic(
-					sg_page((&bounce_sgl[j])), KM_IRQ0);
+					sg_page((&bounce_sgl[j])));
 
 			} else if (srclen == 0 && i == orig_sgl_count - 1) {
 				/* unmap the last bounce that is < PAGE_SIZE */
-				kunmap_atomic((void *)bounce_addr, KM_IRQ0);
+				kunmap_atomic((void *)bounce_addr);
 			}
 		}
 
-		kunmap_atomic((void *)(src_addr - orig_sgl[i].offset), KM_IRQ0);
+		kunmap_atomic((void *)(src_addr - orig_sgl[i].offset));
 	}
 
 	local_irq_restore(flags);
-- 
1.7.4.4

