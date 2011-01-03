Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab1ACKU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 05:20:57 -0500
Received: from mga11.intel.com ([192.55.52.93]:22914 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482Ab1ACKU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 05:20:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,266,1291622400"; 
   d="scan'208";a="642761739"
Subject: [GIT] dmaengine fixes for 2.6.37-rc8
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Jan 2011 02:28:56 -0800
Message-ID: <1294050536.26224.25.camel@dwillia2-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git fixes

...to receive:

A fix for a locking bug in the mv_xor driver, also tagged for -stable.
A compile fix for drivers sitting in -next.

--
Dan


Guennadi Liakhovetski (1):
      dmaengine: provide dummy functions for DMA_ENGINE=n

Saeed Bishara (1):
      mv_xor: fix race in tasklet function

 drivers/dma/mv_xor.c      |    2 +-
 include/linux/dmaengine.h |   13 ++++++++++---
 2 files changed, 11 insertions(+), 4 deletions(-)


commit 8f33d5277fada0291ea495f7fd44a3e7b7aa41d3
Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date:   Wed Dec 22 14:46:46 2010 +0100

    dmaengine: provide dummy functions for DMA_ENGINE=n
    
    This lets drivers, optionally using the dmaengine, build with DMA_ENGINE
    unselected.
    
    Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 9d8688b..8cd00ad 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -824,6 +824,8 @@ enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie);
 #ifdef CONFIG_DMA_ENGINE
 enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx);
 void dma_issue_pending_all(void);
+struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, void *fn_param);
+void dma_release_channel(struct dma_chan *chan);
 #else
 static inline enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
 {
@@ -831,7 +833,14 @@ static inline enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descript
 }
 static inline void dma_issue_pending_all(void)
 {
-	do { } while (0);
+}
+static inline struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask,
+					      dma_filter_fn fn, void *fn_param)
+{
+	return NULL;
+}
+static inline void dma_release_channel(struct dma_chan *chan)
+{
 }
 #endif
 
@@ -842,8 +851,6 @@ void dma_async_device_unregister(struct dma_device *device);
 void dma_run_dependencies(struct dma_async_tx_descriptor *tx);
 struct dma_chan *dma_find_channel(enum dma_transaction_type tx_type);
 #define dma_request_channel(mask, x, y) __dma_request_channel(&(mask), x, y)
-struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, void *fn_param);
-void dma_release_channel(struct dma_chan *chan);
 
 /* --- Helper iov-locking functions --- */
 

commit 8333f65ef094e47020cd01452b4637e7daf5a77f
Author: Saeed Bishara <saeed@marvell.com>
Date:   Tue Dec 21 16:53:39 2010 +0200

    mv_xor: fix race in tasklet function
    
    use mv_xor_slot_cleanup() instead of __mv_xor_slot_cleanup() as the former function
    aquires the spin lock that needed to protect the drivers data.
    
    Cc: <stable@kernel.org>
    Signed-off-by: Saeed Bishara <saeed@marvell.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 411d5bf..a25f5f6 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -449,7 +449,7 @@ mv_xor_slot_cleanup(struct mv_xor_chan *mv_chan)
 static void mv_xor_tasklet(unsigned long data)
 {
 	struct mv_xor_chan *chan = (struct mv_xor_chan *) data;
-	__mv_xor_slot_cleanup(chan);
+	mv_xor_slot_cleanup(chan);
 }
 
 static struct mv_xor_desc_slot *


