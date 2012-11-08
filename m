Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab2KHKIC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 05:08:02 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:13365 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab2KHKHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 05:07:35 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-75-509b845ae6bd
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: [PATCH] raid5: panic() on dma_wait_for_async_tx() error
Date: Thu, 08 Nov 2012 11:06:29 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: Neil Brown <neilb@suse.de>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
MIME-version: 1.0
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
Message-id: <201211081106.29980.b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jAd2oltkBBvOfcVlc3jWHzaJ9/i5G
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDLmr/3KVvCEo2L7r+lMDYyb2bsYOTkkBEwkbn2+BWWL
	SVy4t56ti5GLQ0hgEaNE35QNLBBOC5PE2cZmNpAqNgEriYntqxhBbBEBG4n1D68xgdjCAg4S
	L2e8ZAGxWQRUJXYeWgQWFwWKd06dADaVWWAdo8SZg7+YQRK8AoISPybfA2tgFtCSaH6ziRHC
	lpfYvOYtVI2lxOfvD9gnMPLNQtIyC0nLLCQtCxiZVzGKphYkFxQnpeca6hUn5haX5qXrJefn
	bmIEh9czqR2MKxssDjEKcDAq8fBqSM4OEGJNLCuuzD3EKMHBrCTCu8wZKMSbklhZlVqUH19U
	mpNafIhRmoNFSZy32SMlQEggPbEkNTs1tSC1CCbLxMEp1cBotHP1Us9ya6GAuk4tB+Wsc06s
	bMvVrtvOnG00YfOCRT/Kuy8oPX6W4lnzQY3D+9qeqb2Hk47Pbz0Ru3ZZUiKb/tp3u1TUuE+0
	aLDzx7Ks2lmyM+p8r3L0lYsC/Ts5Lv7U+MGbWWieb89Sazv12qX9107m7z7x/EGnh1nEpkez
	ApYIsoaYR3xUYinOSDTUYi4qTgQAV/2sjSsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH] raid5: panic() on dma_wait_for_async_tx() error

There is not much we can do on dma_wait_for_async_tx() error
so just panic() for now.

Cc: Neil Brown <neilb@suse.de>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/md/raid5.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: b/drivers/md/raid5.c
===================================================================
--- a/drivers/md/raid5.c	2012-11-07 16:25:19.480876012 +0100
+++ b/drivers/md/raid5.c	2012-11-07 16:27:46.244875992 +0100
@@ -3223,7 +3223,9 @@ static void handle_stripe_expansion(stru
 	/* done submitting copies, wait for them to complete */
 	if (tx) {
 		async_tx_ack(tx);
-		dma_wait_for_async_tx(tx);
+		if (dma_wait_for_async_tx(tx) != DMA_SUCCESS)
+			panic("%s: DMA error waiting for transaction\n",
+			      __func__);
 	}
 }
 
