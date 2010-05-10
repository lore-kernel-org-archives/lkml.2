Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab0EJXRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:17:11 -0400
Received: from kroah.org ([198.145.64.141]:51704 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932822Ab0EJW54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:57:56 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:37 2010
Message-Id: <20100510223537.829202297@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:34:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>, Dan Williams <dan.j.williams@intel.com>
Subject: [38/98] raid6: fix recovery performance regression
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 5157b4aa5b7de8787b6318e61bcc285031bb9088 upstream.

The raid6 recovery code should immediately drop back to the optimized
synchronous path when a p+q dma resource is not available.  Otherwise we
run the non-optimized/multi-pass async code in sync mode.

Verified with raid6test (NDISKS=255)

Applies to kernels >= 2.6.32.

Acked-by: NeilBrown <neilb@suse.de>
Reported-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 crypto/async_tx/async_raid6_recov.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -324,6 +324,7 @@ struct dma_async_tx_descriptor *
 async_raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
 			struct page **blocks, struct async_submit_ctl *submit)
 {
+	void *scribble = submit->scribble;
 	int non_zero_srcs, i;
 
 	BUG_ON(faila == failb);
@@ -332,11 +333,13 @@ async_raid6_2data_recov(int disks, size_
 
 	pr_debug("%s: disks: %d len: %zu\n", __func__, disks, bytes);
 
-	/* we need to preserve the contents of 'blocks' for the async
-	 * case, so punt to synchronous if a scribble buffer is not available
+	/* if a dma resource is not available or a scribble buffer is not
+	 * available punt to the synchronous path.  In the 'dma not
+	 * available' case be sure to use the scribble buffer to
+	 * preserve the content of 'blocks' as the caller intended.
 	 */
-	if (!submit->scribble) {
-		void **ptrs = (void **) blocks;
+	if (!async_dma_find_channel(DMA_PQ) || !scribble) {
+		void **ptrs = scribble ? scribble : (void **) blocks;
 
 		async_tx_quiesce(&submit->depend_tx);
 		for (i = 0; i < disks; i++)
@@ -406,11 +409,13 @@ async_raid6_datap_recov(int disks, size_
 
 	pr_debug("%s: disks: %d len: %zu\n", __func__, disks, bytes);
 
-	/* we need to preserve the contents of 'blocks' for the async
-	 * case, so punt to synchronous if a scribble buffer is not available
+	/* if a dma resource is not available or a scribble buffer is not
+	 * available punt to the synchronous path.  In the 'dma not
+	 * available' case be sure to use the scribble buffer to
+	 * preserve the content of 'blocks' as the caller intended.
 	 */
-	if (!scribble) {
-		void **ptrs = (void **) blocks;
+	if (!async_dma_find_channel(DMA_PQ) || !scribble) {
+		void **ptrs = scribble ? scribble : (void **) blocks;
 
 		async_tx_quiesce(&submit->depend_tx);
 		for (i = 0; i < disks; i++)


