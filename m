Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab2GRQvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 12:51:32 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51371 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754225Ab2GRQv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 12:51:29 -0400
Message-ID: <1342630288.9551.19.camel@joe2Laptop>
Subject: [PATCH] dmaengine: Cleanup logging messages
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 18 Jul 2012 09:51:28 -0700
In-Reply-To: <1342611251-16935-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1342611251-16935-1-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a more current logging style.

Add pr_fmt to prefix dmaengine: to messages.
Convert printk(KERN_ERR to pr_err(.
Convert embedded function name use to "%s: ", __func__
Align arguments.

Original-patch-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Joe Perches <joe@perches.com>
---

Hi Andy.  Maybe a slightly larger patch is better.

 drivers/dma/dmaengine.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 2397f6f..eb51f43 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -45,6 +45,8 @@
  * See Documentation/dmaengine.txt for more details
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/dma-mapping.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -261,7 +263,7 @@ enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie)
 	do {
 		status = dma_async_is_tx_complete(chan, cookie, NULL, NULL);
 		if (time_after_eq(jiffies, dma_sync_wait_timeout)) {
-			printk(KERN_ERR "dma_sync_wait_timeout!\n");
+			pr_err("%s: timeout!\n", __func__);
 			return DMA_ERROR;
 		}
 	} while (status == DMA_IN_PROGRESS);
@@ -312,7 +314,7 @@ static int __init dma_channel_table_init(void)
 	}
 
 	if (err) {
-		pr_err("dmaengine: initialization failure\n");
+		pr_err("initialization failure\n");
 		for_each_dma_cap_mask(cap, dma_cap_mask_all)
 			if (channel_table[cap])
 				free_percpu(channel_table[cap]);
@@ -520,12 +522,12 @@ struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, v
 			err = dma_chan_get(chan);
 
 			if (err == -ENODEV) {
-				pr_debug("%s: %s module removed\n", __func__,
-					 dma_chan_name(chan));
+				pr_debug("%s: %s module removed\n",
+					 __func__, dma_chan_name(chan));
 				list_del_rcu(&device->global_node);
 			} else if (err)
 				pr_debug("%s: failed to get %s: (%d)\n",
-					__func__, dma_chan_name(chan), err);
+					 __func__, dma_chan_name(chan), err);
 			else
 				break;
 			if (--device->privatecnt == 0)
@@ -535,8 +537,10 @@ struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, v
 	}
 	mutex_unlock(&dma_list_mutex);
 
-	pr_debug("%s: %s (%s)\n", __func__, chan ? "success" : "fail",
-		 chan ? dma_chan_name(chan) : NULL);
+	pr_debug("%s: %s (%s)\n",
+		 __func__,
+		 chan ? "success" : "fail",
+		 chan ? dma_chan_name(chan) : NULL);
 
 	return chan;
 }
@@ -579,7 +583,7 @@ void dmaengine_get(void)
 				break;
 			} else if (err)
 				pr_err("%s: failed to get %s: (%d)\n",
-					__func__, dma_chan_name(chan), err);
+				       __func__, dma_chan_name(chan), err);
 		}
 	}
 
@@ -1015,7 +1019,7 @@ dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
 	while (tx->cookie == -EBUSY) {
 		if (time_after_eq(jiffies, dma_sync_wait_timeout)) {
 			pr_err("%s timeout waiting for descriptor submission\n",
-				__func__);
+			       __func__);
 			return DMA_ERROR;
 		}
 		cpu_relax();


