Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab2KSKC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 05:02:56 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45855 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753315Ab2KSKCz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 05:02:55 -0500
X-Greylist: delayed 608 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Nov 2012 05:02:55 EST
From: Dan Williams <djbw@fb.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "hskinnemoen@gmail.com" <hskinnemoen@gmail.com>,
        "iws@ovro.caltech.edu" <iws@ovro.caltech.edu>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "vipin.kumar@st.com" <vipin.kumar@st.com>,
        "t.figa@samsung.com" <t.figa@samsung.com>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Subject: Re: [PATCH 13/20] async_tx: do DMA unmap in core for XOR operations
Thread-Topic: [PATCH 13/20] async_tx: do DMA unmap in core for XOR operations
Thread-Index: AQHNuzya4tEGsUdWwEeeo8hGsPFfxJfw7+kA
Date: Mon, 19 Nov 2012 09:52:33 +0000
Message-ID: <84A937D219C2B44EB8EA44831ACA1E49166C7492@SC-MBX02-3.TheFacebook.com>
In-Reply-To: <1352109631-3385-14-git-send-email-b.zolnierkie@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.18.254]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8DAFD683C1743B46A5A65BB995260B5E@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Reason: safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8185,1.0.431,0.0.0000
 definitions=2012-11-19_03:2012-11-19,2012-11-19,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/5/12 2:00 AM, "Bartlomiej Zolnierkiewicz" <b.zolnierkie@samsung.com>
wrote:

>In struct dma_async_tx_descriptor convert dma_[src,dst] fields to
>arrays and also add dma_src_cnt field.  Then convert core async_tx
>code (do_async_xor()) to do DMA unmapping itself using the ->callback
>functionality.
>
>Cc: Dan Williams <djbw@fb.com>
>Cc: Tomasz Figa <t.figa@samsung.com>
>Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>---
> crypto/async_tx/async_memcpy.c |  8 ++---
> crypto/async_tx/async_xor.c    | 80
>+++++++++++++++++++++++++++++++-----------
> drivers/dma/dmaengine.c        | 26 +++++++-------
> include/linux/dmaengine.h      | 14 +++++---
> 4 files changed, 87 insertions(+), 41 deletions(-)
>
>diff --git a/crypto/async_tx/async_memcpy.c
>b/crypto/async_tx/async_memcpy.c
>index b6d5dab..cb0628e 100644
>--- a/crypto/async_tx/async_memcpy.c
>+++ b/crypto/async_tx/async_memcpy.c
>@@ -35,8 +35,8 @@ static void async_memcpy_cb(void *dma_async_param)
> 	struct dma_async_tx_descriptor *tx = dma_async_param;
> 	struct dma_device *dev = tx->chan->device;
> 
>-	dma_unmap_page(dev->dev, tx->dma_src, tx->dma_len, DMA_TO_DEVICE);
>-	dma_unmap_page(dev->dev, tx->dma_dst, tx->dma_len, DMA_FROM_DEVICE);
>+	dma_unmap_page(dev->dev, tx->dma_src[0], tx->dma_len, DMA_TO_DEVICE);
>+	dma_unmap_page(dev->dev, tx->dma_dst[0], tx->dma_len, DMA_FROM_DEVICE);
> 
> 	if (tx->orig_callback)
> 		tx->orig_callback(tx->orig_callback_param);
>@@ -91,8 +91,8 @@ async_memcpy(struct page *dest, struct page *src,
>unsigned int dest_offset,
> 	if (tx) {
> 		pr_debug("%s: (async) len: %zu\n", __func__, len);
> 
>-		tx->dma_src = dma_src;
>-		tx->dma_dst = dma_dest;
>+		tx->dma_src[0] = dma_src;
>+		tx->dma_dst[0] = dma_dest;
> 		tx->dma_len = len;
> 
> 		__async_tx_submit(chan, tx, async_memcpy_cb, tx, submit);
>diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
>index 154cc84..59a4af3 100644
>--- a/crypto/async_tx/async_xor.c
>+++ b/crypto/async_tx/async_xor.c
>@@ -31,6 +31,26 @@
> #include <linux/raid/xor.h>
> #include <linux/async_tx.h>
> 
>+static void do_async_xor_cb(void *dma_async_param)
>+{
>+	struct dma_async_tx_descriptor *tx = dma_async_param;
>+	struct dma_device *dev = tx->chan->device;
>+	int i;
>+
>+	dma_unmap_page(dev->dev, tx->dma_dst[0], tx->dma_len,
>+		       DMA_BIDIRECTIONAL);
>+
>+	for (i = 0; i < tx->dma_src_cnt; i++) {
>+		if (tx->dma_src[i] == tx->dma_dst[0])
>+			continue;
>+		dma_unmap_page(dev->dev, tx->dma_src[i], tx->dma_len,
>+			       DMA_TO_DEVICE);
>+	}
>+
>+	if (tx->orig_callback)
>+		tx->orig_callback(tx->orig_callback_param);
>+}
>+
> /* do_async_xor - dma map the pages and perform the xor with an engine */
> static __async_inline struct dma_async_tx_descriptor *
> do_async_xor(struct dma_chan *chan, struct page *dest, struct page
>**src_list,
>@@ -39,42 +59,34 @@ do_async_xor(struct dma_chan *chan, struct page
>*dest, struct page **src_list,
> {
> 	struct dma_device *dma = chan->device;
> 	struct dma_async_tx_descriptor *tx = NULL;
>-	int src_off = 0;
>-	int i;
>+	int i, j;
> 	dma_async_tx_callback cb_fn_orig = submit->cb_fn;
> 	void *cb_param_orig = submit->cb_param;
> 	enum async_tx_flags flags_orig = submit->flags;
> 	enum dma_ctrl_flags dma_flags;
> 	int xor_src_cnt = 0;
>+	int src_list_cnt = 0;
>+	int extra_ent = 0;
> 	dma_addr_t dma_dest;
> 
>-	/* map the dest bidrectional in case it is re-used as a source */
>-	dma_dest = dma_map_page(dma->dev, dest, offset, len, DMA_BIDIRECTIONAL);
> 	for (i = 0; i < src_cnt; i++) {
>-		/* only map the dest once */
> 		if (!src_list[i])
> 			continue;
>-		if (unlikely(src_list[i] == dest)) {
>-			dma_src[xor_src_cnt++] = dma_dest;
>-			continue;
>-		}
>-		dma_src[xor_src_cnt++] = dma_map_page(dma->dev, src_list[i], offset,
>-						      len, DMA_TO_DEVICE);
>+		xor_src_cnt++;
> 	}
> 	src_cnt = xor_src_cnt;
> 
> 	while (src_cnt) {
> 		submit->flags = flags_orig;
>-		dma_flags = 0;
>+		dma_flags = DMA_COMPL_SKIP_SRC_UNMAP |
>+			    DMA_COMPL_SKIP_DEST_UNMAP;
> 		xor_src_cnt = min(src_cnt, (int)dma->max_xor);
>-		/* if we are submitting additional xors, leave the chain open,
>-		 * clear the callback parameters, and leave the destination
>-		 * buffer mapped
>+		/* if we are submitting additional xors, leave the chain open
>+		 * and clear the callback parameters
> 		 */
> 		if (src_cnt > xor_src_cnt) {
> 			submit->flags &= ~ASYNC_TX_ACK;
> 			submit->flags |= ASYNC_TX_FENCE;
>-			dma_flags = DMA_COMPL_SKIP_DEST_UNMAP;
> 			submit->cb_fn = NULL;
> 			submit->cb_param = NULL;
> 		} else {
>@@ -85,11 +97,32 @@ do_async_xor(struct dma_chan *chan, struct page
>*dest, struct page **src_list,
> 			dma_flags |= DMA_PREP_INTERRUPT;
> 		if (submit->flags & ASYNC_TX_FENCE)
> 			dma_flags |= DMA_PREP_FENCE;
>+
>+		/* map it bidirectional as it can be re-used as a source */
>+		dma_dest = dma_map_page(dma->dev, dest, offset, len,
>+					DMA_BIDIRECTIONAL);

This maps the destination unconditionally multiple times.  More critically
it gets unmapped at the first completion, but it needs to remain mapped
until all operations complete.

So, we need a separate unmap object with a different lifetime than the
descriptor.  I'm putting together some patches along those lines to
dynamically allocate some unmap data and hang it off the descriptor.

--
Dan


