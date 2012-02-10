Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095Ab2BJFoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 00:44:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758982Ab2BJFoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 00:44:07 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@linuxdriverproject.org, devel@driverdev.osuosl.org
Subject: [PATCH 22/60] hv: remove the second argument of k[un]map_atomic()
Date: Fri, 10 Feb 2012 13:39:43 +0800
Message-Id: <1328852421-19678-23-git-send-email-amwang@redhat.com>
In-Reply-To: <1328852421-19678-1-git-send-email-amwang@redhat.com>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Cong Wang <amwang@redhat.com>
---
 drivers/staging/hv/storvsc_drv.c |   31 ++++++++++++++-----------------
 1 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index eb853f7..ddbdec8 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -941,15 +941,14 @@ static unsigned int copy_from_bounce_buffer(struct scatterlist *orig_sgl,
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
@@ -965,7 +964,7 @@ static unsigned int copy_from_bounce_buffer(struct scatterlist *orig_sgl,
 
 			if (bounce_sgl[j].offset == bounce_sgl[j].length) {
 				/* full */
-				kunmap_atomic((void *)bounce_addr, KM_IRQ0);
+				kunmap_atomic((void *)bounce_addr);
 				j++;
 
 				/*
@@ -990,15 +989,14 @@ static unsigned int copy_from_bounce_buffer(struct scatterlist *orig_sgl,
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
@@ -1024,15 +1022,14 @@ static unsigned int copy_to_bounce_buffer(struct scatterlist *orig_sgl,
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
@@ -1049,22 +1046,22 @@ static unsigned int copy_to_bounce_buffer(struct scatterlist *orig_sgl,
 
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
1.7.7.6

