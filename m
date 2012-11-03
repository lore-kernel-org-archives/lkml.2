Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab2KCXAP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 19:00:15 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:19082 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab2KCXAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 19:00:12 -0400
Message-ID: <1351983607.2773.9.camel@lorien2>
Subject: [PATCH] dma-debug: fix to not have dependency on get_dma_ops()
 interface
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>,
        kubakici@wp.pl, stern@rowland.harvard.edu,
        Greg KH <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Mark Salter <msalter@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Date: Sat, 03 Nov 2012 17:00:07 -0600
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma-debug depends on get_dma_ops() interface. Several architectures
do not define dma_ops and get_dma_ops(). When dma debug interfaces are
used on an architecture (e.g: c6x) that doesn't define get_dmap_ops(),
compilation fails. Changing dma-debug to call dma_mapping_error() instead
of defining its own that calls get_dma_ops(), such that the internal use of
dma_mapping_error() doesn't interfere with the debug_dma_mapping_error()
interface's mapping error checks. Moving dma_mapping_error() checks in
check_unmap() under the dma debug entry not found is sufficient to fix the
problem.

Reference: https://lkml.org/lkml/2012/10/26/367

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
Reported-by: Mark Salter <msalter@redhat.com>
---
 lib/dma-debug.c |   29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 59f4a1a..5e396ac 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -852,37 +852,22 @@ static __init int dma_debug_entries_cmdline(char *str)
 __setup("dma_debug=", dma_debug_cmdline);
 __setup("dma_debug_entries=", dma_debug_entries_cmdline);
 
-/* Calling dma_mapping_error() from dma-debug api will result in calling
-   debug_dma_mapping_error() - need internal mapping error routine to
-   avoid debug checks */
-#ifndef DMA_ERROR_CODE
-#define DMA_ERROR_CODE 0
-#endif
-static inline int has_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	const struct dma_map_ops *ops = get_dma_ops(dev);
-	if (ops->mapping_error)
-		return ops->mapping_error(dev, dma_addr);
-
-	return (dma_addr == DMA_ERROR_CODE);
-}
-
 static void check_unmap(struct dma_debug_entry *ref)
 {
 	struct dma_debug_entry *entry;
 	struct hash_bucket *bucket;
 	unsigned long flags;
 
-	if (unlikely(has_mapping_error(ref->dev, ref->dev_addr))) {
-		err_printk(ref->dev, NULL, "DMA-API: device driver tries "
-			   "to free an invalid DMA memory address\n");
-		return;
-	}
-
 	bucket = get_hash_bucket(ref, &flags);
 	entry = bucket_find_exact(bucket, ref);
 
 	if (!entry) {
+		if (dma_mapping_error(ref->dev, ref->dev_addr)) {
+			err_printk(ref->dev, NULL,
+				   "DMA-API: device driver tries "
+				   "to free an invalid DMA memory address\n");
+			return;
+		}
 		err_printk(ref->dev, NULL, "DMA-API: device driver tries "
 			   "to free DMA memory it has not allocated "
 			   "[device address=0x%016llx] [size=%llu bytes]\n",
@@ -1055,7 +1040,7 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
 	if (unlikely(global_disable))
 		return;
 
-	if (unlikely(has_mapping_error(dev, dma_addr)))
+	if (dma_mapping_error(dev, dma_addr))
 		return;
 
 	entry = dma_entry_alloc();
-- 
1.7.9.5



