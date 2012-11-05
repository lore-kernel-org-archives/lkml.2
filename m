Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab2KEKBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:01:00 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:46611 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab2KEKA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:00:56 -0500
X-AuditID: cbfee61b-b7f616d00000319b-d8-50978e576c4b
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: djbw@fb.com, dwmw2@infradead.org, hskinnemoen@gmail.com,
        iws@ovro.caltech.edu, vinod.koul@intel.com, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 01/20] async_tx: add missing DMA unmap to async_memcpy()
Date: Mon, 05 Nov 2012 11:00:12 +0100
Message-id: <1352109631-3385-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
References: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsVy+t9jAd3wvukBBncXSVpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MLS+esRYsZK948uQ4awPjN9YuRk4OCQETiRvtr9kgbDGJC/fW
	A9lcHEICixglVk9sZ4ZwVjNJNB27zgRSxSZgJTGxfRUjiC0ioCCxufcZK0gRs8AzRokZt7uZ
	QRLCAh4SGw79AlvBIqAqsebxfDCbV8Bdom3yKmaIdfIST+/3ga3mBKpvbJgCViMEVHO58zjz
	BEbeBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCvf5MegfjqgaLQ4wCHIxKPLyfJKYH
	CLEmlhVX5h5ilOBgVhLh5WAACvGmJFZWpRblxxeV5qQWH2KU5mBREudt9kgJEBJITyxJzU5N
	LUgtgskycXBKNTBqTvCZPF1D62ot69yFOqw/pAwvOf58/ymA/4T39HUv1FqcVeV3L2GbUr7+
	rmvYMmPRoqdJmpsm29nf/5V8NTuz7Y0QS0Cr0xaXlCn3vQ74cy5/br9i/SG/3EeL/83QObXJ
	NC9NSWG/zf0ZDz7v3ic/74wI9035kGd5VX93tiVMuLTrQV/bO/VpSizFGYmGWsxFxYkAHE4K
	DPYBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do DMA unmap on ->device_prep_dma_memcpy failure.

Cc: Dan Williams <djbw@fb.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 crypto/async_tx/async_memcpy.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 361b5e8..9e62fef 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -67,6 +67,12 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 
 		tx = device->device_prep_dma_memcpy(chan, dma_dest, dma_src,
 						    len, dma_prep_flags);
+		if (!tx) {
+			dma_unmap_page(device->dev, dma_dest, len,
+				       DMA_FROM_DEVICE);
+			dma_unmap_page(device->dev, dma_src, len,
+				       DMA_TO_DEVICE);
+		}
 	}
 
 	if (tx) {
-- 
1.8.0

