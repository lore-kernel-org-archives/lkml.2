Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab2LELL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 06:11:28 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:60573 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2LELLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 06:11:22 -0500
X-AuditID: cbfee61b-b7f616d00000319b-55-50bf2bd97c38
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: vinod.koul@intel.com
Cc: linux-kernel@vger.kernel.org, djbw@fb.com, dwmw2@infradead.org,
        hskinnemoen@gmail.com, iws@ovro.caltech.edu, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH resend 1/7] async_tx: add missing DMA unmap to async_memcpy()
Date: Wed, 05 Dec 2012 12:10:39 +0100
Message-id: <1354705845-29439-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1354705845-29439-1-git-send-email-b.zolnierkie@samsung.com>
References: <1354705845-29439-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJMWRmVeSWpSXmKPExsVy+t9jAd2b2vsDDG78lrK4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZHw9+ZCrYwF7x88QNlgbGVrYuRk4OCQETibN3djBC2GISF+6t
	B4pzcQgJLGKU6D72mh3CWc0kcWrva2aQKjYBK4mJ7avAOkQEJCS2P+sDK2IWeMco0bTuLxNI
	QljAV+LHykdgRSwCqhJP/3xhB7F5BTwkDj+/yw6xTl7i6f0+sDM4BTwlHkydydLFyAG0zUNi
	1oGQCYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIE+/yZ9A7GVQ0WhxgFOBiVeHgl
	jPcFCLEmlhVX5h5ilOBgVhLhnSezP0CINyWxsiq1KD++qDQntfgQozQHi5I4b7NHSoCQQHpi
	SWp2ampBahFMlomDU6qBkc/j8gG9O7/b/ESyDnD+eyzaP2lVxVt17ZbW2iXMrtv6m88bKVvu
	M7h1Y8tvn6f6c+vK+Jd+tnTysL69N2On1rsFe/d0bIhOOtShu7hTqlGN9WNlqZ7NWbM7qzQP
	SLw44Pnl38vFe5cqTdW5vbuklPfU6cWSnL9bk3SXhh7d0y/AlOrNfP7OMyWW4oxEQy3mouJE
	ALbcfSf1AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do DMA unmap on ->device_prep_dma_memcpy failure.

Acked-by: Dan Williams <djbw@fb.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
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

