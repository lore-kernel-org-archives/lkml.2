Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab2LELLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 06:11:40 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:9540 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab2LELLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 06:11:34 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-83-50bf2be5998e
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: vinod.koul@intel.com
Cc: linux-kernel@vger.kernel.org, djbw@fb.com, dwmw2@infradead.org,
        hskinnemoen@gmail.com, iws@ovro.caltech.edu, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH resend 4/7] carma-fpga: pass correct flags to
 ->device_prep_dma_memcpy()
Date: Wed, 05 Dec 2012 12:10:42 +0100
Message-id: <1354705845-29439-5-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1354705845-29439-1-git-send-email-b.zolnierkie@samsung.com>
References: <1354705845-29439-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJMWRmVeSWpSXmKPExsVy+t9jAd2n2vsDDH7ut7S4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZH07eZi34wVXxaf9q9gbGDs4uRk4OCQETiT1HepkhbDGJC/fW
	s3UxcnEICSxilDi9sRHKWc0kcf76ARaQKjYBK4mJ7asYQWwRAQmJ7c/62EGKmAXeMUo0rfvL
	BJIQFoiSmPH5NFgDi4CqxKoja1lBbF4BD4nZB7axQayTl3h6vw/M5hTwlHgwdSZQPQfQNg+J
	WQdCJjDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kR7PNnUjsYVzZYHGIU4GBU4uHN
	0tsXIMSaWFZcmXuIUYKDWUmEd57M/gAh3pTEyqrUovz4otKc1OJDjNIcLErivM0eKQFCAumJ
	JanZqakFqUUwWSYOTqkGRmabuYevSbn/5db6fsBsJ+uPn43cd3WSuzOmMa+Yddhbqamy56A3
	41xTj0nbQg6z5Les3/Oxyc6ssrtuIher9tsslu6dSr3zVM+obmh179iS+0iyVlpijvu3fgef
	/D+RDHKNKzk/Xd9euehHl/eEBX3OOhdVWLZObFjm2TQvsdvgqNNN1VwVJZbijERDLeai4kQA
	ECuzNfUBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA unmapping is handled by a driver so tell fsldma.c driver
(which is the DMA engine driver used by carma-fpga) to skip
unmapping destination and source buffers.

Acked-by: Ira W. Snyder <iws@ovro.caltech.edu>
Acked-by: Dan Williams <djbw@fb.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/misc/carma/carma-fpga.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/carma/carma-fpga.c b/drivers/misc/carma/carma-fpga.c
index 8835eab..6b43f8c 100644
--- a/drivers/misc/carma/carma-fpga.c
+++ b/drivers/misc/carma/carma-fpga.c
@@ -631,6 +631,8 @@ static int data_submit_dma(struct fpga_device *priv, struct data_buf *buf)
 	struct dma_async_tx_descriptor *tx;
 	dma_cookie_t cookie;
 	dma_addr_t dst, src;
+	unsigned long dma_flags = DMA_COMPL_SKIP_DEST_UNMAP |
+				  DMA_COMPL_SKIP_SRC_UNMAP;
 
 	dst_sg = buf->vb.sglist;
 	dst_nents = buf->vb.sglen;
@@ -666,7 +668,7 @@ static int data_submit_dma(struct fpga_device *priv, struct data_buf *buf)
 	src = SYS_FPGA_BLOCK;
 	tx = chan->device->device_prep_dma_memcpy(chan, dst, src,
 						  REG_BLOCK_SIZE,
-						  0);
+						  dma_flags);
 	if (!tx) {
 		dev_err(priv->dev, "unable to prep SYS-FPGA DMA\n");
 		return -ENOMEM;
-- 
1.8.0

