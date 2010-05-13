Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745Ab0EMLSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 07:18:43 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36070 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758697Ab0EMLSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 07:18:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fN9L1bJJqK0BG11ChKYcW8PwIFgs/EZGn0//n7n1dpZwf/5RkZ8vK7YjUlPIdxDf68
         HKekAyYRG+yfMBgFTPVzkWp5lL3YFl74za9x7+ToZnxT9NOAcOGUtacAxzBauU/LRq5/
         8j796XqcmFmyszCPzoKu0rWrxTi8m0GPyUr8g=
From: Changli Gao <xiaosuo@gmail.com>
To: akpm@linux-foundation.org
Cc: Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>, Roland Dreier <rolandd@cisco.com>,
       Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
       linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH 9/9] ehca: use kvcalloc and kvfree
Date: Thu, 13 May 2010 19:18:15 +0800
Message-Id: <1273749495-10526-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use kvcalloc and kvfree

use kvcalloc and kvfree, but I haven't test it, as I don't have that machine.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 drivers/infiniband/hw/ehca/ipz_pt_fn.c |   22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)
diff --git a/drivers/infiniband/hw/ehca/ipz_pt_fn.c b/drivers/infiniband/hw/ehca/ipz_pt_fn.c
index 1596e30..f0e7bd4 100644
--- a/drivers/infiniband/hw/ehca/ipz_pt_fn.c
+++ b/drivers/infiniband/hw/ehca/ipz_pt_fn.c
@@ -38,8 +38,6 @@
  * POSSIBILITY OF SUCH DAMAGE.
  */
 
-#include <linux/slab.h>
-
 #include "ehca_tools.h"
 #include "ipz_pt_fn.h"
 #include "ehca_classes.h"
@@ -222,15 +220,11 @@ int ipz_queue_ctor(struct ehca_pd *pd, struct ipz_queue *queue,
 	queue->small_page = NULL;
 
 	/* allocate queue page pointers */
-	queue->queue_pages = kmalloc(nr_of_pages * sizeof(void *), GFP_KERNEL);
+	queue->queue_pages = kvcalloc(nr_of_pages, sizeof(void *));
 	if (!queue->queue_pages) {
-		queue->queue_pages = vmalloc(nr_of_pages * sizeof(void *));
-		if (!queue->queue_pages) {
-			ehca_gen_err("Couldn't allocate queue page list");
-			return 0;
-		}
+		ehca_gen_err("Couldn't allocate queue page list");
+		return 0;
 	}
-	memset(queue->queue_pages, 0, nr_of_pages * sizeof(void *));
 
 	/* allocate actual queue pages */
 	if (is_small) {
@@ -245,10 +239,7 @@ int ipz_queue_ctor(struct ehca_pd *pd, struct ipz_queue *queue,
 ipz_queue_ctor_exit0:
 	ehca_gen_err("Couldn't alloc pages queue=%p "
 		 "nr_of_pages=%x",  queue, nr_of_pages);
-	if (is_vmalloc_addr(queue->queue_pages))
-		vfree(queue->queue_pages);
-	else
-		kfree(queue->queue_pages);
+	kvfree(queue->queue_pages);
 
 	return 0;
 }
@@ -270,10 +261,7 @@ int ipz_queue_dtor(struct ehca_pd *pd, struct ipz_queue *queue)
 			free_page((unsigned long)queue->queue_pages[i]);
 	}
 
-	if (is_vmalloc_addr(queue->queue_pages))
-		vfree(queue->queue_pages);
-	else
-		kfree(queue->queue_pages);
+	kvfree(queue->queue_pages);
 
 	return 1;
 }
