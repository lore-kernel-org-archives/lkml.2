Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab2KEKCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:02:01 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:46872 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab2KEKB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:01:59 -0500
X-AuditID: cbfee61b-b7f616d00000319b-8f-50978e92f224
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: djbw@fb.com, dwmw2@infradead.org, hskinnemoen@gmail.com,
        iws@ovro.caltech.edu, vinod.koul@intel.com, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 14/20] async_tx: do DMA unmap in core for XOR_VAL operations
Date: Mon, 05 Nov 2012 11:00:25 +0100
Message-id: <1352109631-3385-15-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
References: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsVy+t9jAd1JfdMDDF4vkrO4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZl1+9ZyrYKFBxe9lGpgbGFbxdjJwcEgImEhuu9bJA2GISF+6t
	Z+ti5OIQEljEKLFkwmImCGc1k8TRf9uYQKrYBKwkJravYgSxRQQUJDb3PmMFKWIWeMYoMeN2
	NzNIQljAR+LuvkmsIDaLgKrEtNOv2UBsXgEPiUurG1gh1slLPL3fBxbnBIo3NkwBiwsJuEtc
	7jzOPIGRdwEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2MYK8/k97BuKrB4hCjAAejEg/v
	J4npAUKsiWXFlbmHGCU4mJVEeDkYgEK8KYmVValF+fFFpTmpxYcYpTlYlMR5mz1SAoQE0hNL
	UrNTUwtSi2CyTBycUg2Mdmk/rLLD6750L/VMy1LtWbpFS5+TceGjVx8cnr7cLNRVflWl4seS
	kxpzBfZuU3F1/GMoob/uXEBgsenvo16fYv7m/VueonlI8jOnc15En9uLn9cPf/Q7m17reEU3
	fJHXFvXLL9JTLEMm9Pw+ZNCns/5eysqDsn+Uvv/8dudkal/6usgVlxk5lFiKMxINtZiLihMB
	OGvzrvYBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert core async_tx code (async_xor_val()) to do DMA unmapping
itself using the ->callback functionality.

Cc: Dan Williams <djbw@fb.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 crypto/async_tx/async_xor.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 59a4af3..d44da16 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -284,6 +284,20 @@ xor_val_chan(struct async_submit_ctl *submit, struct page *dest,
 				     src_cnt, len);
 }
 
+static void async_xor_val_cb(void *dma_async_param)
+{
+	struct dma_async_tx_descriptor *tx = dma_async_param;
+	struct dma_device *dev = tx->chan->device;
+	int i;
+
+	for (i = 0; i < tx->dma_src_cnt; i++)
+		dma_unmap_page(dev->dev, tx->dma_src[i], tx->dma_len,
+			       DMA_TO_DEVICE);
+
+	if (tx->orig_callback)
+		tx->orig_callback(tx->orig_callback_param);
+}
+
 /**
  * async_xor_val - attempt a xor parity check with a dma engine.
  * @dest: destination page used if the xor is performed synchronously
@@ -319,7 +333,8 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 
 	if (dma_src && device && src_cnt <= device->max_xor &&
 	    is_dma_xor_aligned(device, offset, 0, len)) {
-		unsigned long dma_prep_flags = 0;
+		unsigned long dma_prep_flags = DMA_COMPL_SKIP_SRC_UNMAP |
+					       DMA_COMPL_SKIP_DEST_UNMAP;
 		int i;
 
 		pr_debug("%s: (async) len: %zu\n", __func__, len);
@@ -346,7 +361,12 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 			}
 		}
 
-		async_tx_submit(chan, tx, submit);
+		for (i = 0; i < src_cnt; i++)
+			tx->dma_src[i] = dma_src[i];
+		tx->dma_src_cnt = src_cnt;
+		tx->dma_len = len;
+
+		__async_tx_submit(chan, tx, async_xor_val_cb, tx, submit);
 	} else {
 		enum async_tx_flags flags_orig = submit->flags;
 
-- 
1.8.0

