Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab2KIU5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 15:57:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:63522 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511Ab2KIU5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 15:57:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,747,1344236400"; 
   d="scan'208";a="239690697"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Subject: [PATCH] dmatest: Fix NULL pointer dereference on ioat
Date: Fri,  9 Nov 2012 13:57:40 -0700
Message-Id: <1352494660-6650-1-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_control is an optional and not implemented in all DMA drivers.
Any calls to these will result in a NULL pointer dereference.  dmatest
makes two of these calls when completing the kernel thread and removing
the module.  These are corrected by calling the dmaengine_device_control
wrapper and checking for a non-existant device_control function pointer
there.

Signed-off-by: Jon Mason <jon.mason@intel.com>
CC: Vinod Koul <vinod.koul@intel.com>
CC: Dan Williams <djbw@fb.com>
---
 drivers/dma/dmatest.c     |    4 ++--
 include/linux/dmaengine.h |    5 ++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 24225f0..6ef9465 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -499,7 +499,7 @@ err_srcs:
 			thread_name, total_tests, failed_tests, ret);
 
 	/* terminate all transfers on specified channels */
-	chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
+	dmaengine_terminate_all(chan);
 	if (iterations > 0)
 		while (!kthread_should_stop()) {
 			DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wait_dmatest_exit);
@@ -524,7 +524,7 @@ static void dmatest_cleanup_channel(struct dmatest_chan *dtc)
 	}
 
 	/* terminate all transfers on specified channels */
-	dtc->chan->device->device_control(dtc->chan, DMA_TERMINATE_ALL, 0);
+	dmaengine_terminate_all(dtc->chan);
 
 	kfree(dtc);
 }
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index d3201e4..e0004fb 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -608,7 +608,10 @@ static inline int dmaengine_device_control(struct dma_chan *chan,
 					   enum dma_ctrl_cmd cmd,
 					   unsigned long arg)
 {
-	return chan->device->device_control(chan, cmd, arg);
+	if (chan->device->device_control)
+		return chan->device->device_control(chan, cmd, arg);
+	else
+		return -EINVAL;
 }
 
 static inline int dmaengine_slave_config(struct dma_chan *chan,
-- 
1.7.9.5

