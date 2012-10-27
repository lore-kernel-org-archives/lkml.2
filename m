Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231Ab2J0PuL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 11:50:11 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45626 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759134Ab2J0PuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 11:50:06 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Subject: [PATCH] dmatest: adjust invalid module parameters for number of source buffers
Date: Sun, 28 Oct 2012 00:49:32 +0900
Message-Id: <1351352973-3719-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351352973-3719-1-git-send-email-akinobu.mita@gmail.com>
References: <1351352973-3719-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA Engine test module has module parameters to set the number of source
buffers for xor and pq operations.  We can set these values larger than the
maximum number of sources that the device can support.  These values are
not adjusted and the unsupported number of source buffers are passed to the
device.  But most drivers don't check it, so unexpected results will happen.

This makes an appropriate adjustment for these module parameters before use.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
---
 drivers/dma/dmatest.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 24225f0..8f130d4e 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -228,6 +228,13 @@ static void dmatest_callback(void *arg)
 	wake_up_all(done->wait);
 }
 
+static unsigned int min_odd(unsigned int x, unsigned int y)
+{
+	unsigned int val = min(x, y);
+
+	return val % 2 ? val : val - 1;
+}
+
 /*
  * This function repeatedly tests DMA transfers of various lengths and
  * offsets for a given operation type until it is told to exit by
@@ -248,6 +255,7 @@ static int dmatest_func(void *data)
 	struct dmatest_thread	*thread = data;
 	struct dmatest_done	done = { .wait = &done_wait };
 	struct dma_chan		*chan;
+	struct dma_device	*dev;
 	const char		*thread_name;
 	unsigned int		src_off, dst_off, len;
 	unsigned int		error_count;
@@ -269,13 +277,16 @@ static int dmatest_func(void *data)
 
 	smp_rmb();
 	chan = thread->chan;
+	dev = chan->device;
 	if (thread->type == DMA_MEMCPY)
 		src_cnt = dst_cnt = 1;
 	else if (thread->type == DMA_XOR) {
-		src_cnt = xor_sources | 1; /* force odd to ensure dst = src */
+		/* force odd to ensure dst = src */
+		src_cnt = min_odd(xor_sources | 1, dev->max_xor);
 		dst_cnt = 1;
 	} else if (thread->type == DMA_PQ) {
-		src_cnt = pq_sources | 1; /* force odd to ensure dst = src */
+		/* force odd to ensure dst = src */
+		src_cnt = min_odd(pq_sources | 1, dma_maxpq(dev, 0));
 		dst_cnt = 2;
 		for (i = 0; i < src_cnt; i++)
 			pq_coefs[i] = 1;
@@ -313,7 +324,6 @@ static int dmatest_func(void *data)
 
 	while (!kthread_should_stop()
 	       && !(iterations && total_tests >= iterations)) {
-		struct dma_device *dev = chan->device;
 		struct dma_async_tx_descriptor *tx = NULL;
 		dma_addr_t dma_srcs[src_cnt];
 		dma_addr_t dma_dsts[dst_cnt];
-- 
1.7.11.7

