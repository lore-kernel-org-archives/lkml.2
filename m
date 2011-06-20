Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab1FTPC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 11:02:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60440 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab1FTPCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 11:02:55 -0400
Date: Mon, 20 Jun 2011 17:02:47 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: linux-sh@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: [PATCH] dmaengine: failure to get a specific DMA channel is not
 critical
Message-ID: <Pine.LNX.4.64.1106201657280.11365@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:brZ2ub55Ek3NcSTHy7REJ1Wg/vZXEimGlWns2n70YJu
 41bKTQEURNz1IqQIn+xdrXMFlQQ678gHeSbAsPkOtEVc5IKIAi
 sX9lukr7ogG0LXR0eJcsSD+d1bhPo0wjYlWAy6vcc3IioT3/S/
 J63Bh2XTKwYoC0RL4Qax2WvhTV5wB9Z8Mg74txHC+50hvegk8j
 g2N5GOvPuVfkYGo4xlSu4eTkToFQqSuj9x6u5P9QSg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There exist systems with multiple DMA controllers with different
capabilities. For example, on some sh-mobile / rmobile systems there are
DMA controllers, whose channels can be configured to be used with
SD- and MMC-host controllers, serial ports etc. Besides there are also
DMA controllers, that can only be used for one special function, e.g.,
for USB. In such cases the DMA client filter function can just choose
to specify to the DMA driver, which channel it needs. Then the
.device_alloc_chan_resources() method of the DMA driver will check,
whether it can provide that dunction. If not, it will fail and the loop
in __dma_request_channel() will continue to the next DMA device, until
it finds a suitable one. This works fine with just one minor glitch:
the kernel logs error messages like

dmaengine: failed to get <channel name>: (-<error code>)

after each such non-critical failure. This patch lowers priority of
this message to the debug level.

Reported-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Morimoto-san, I don't expect this patch to fail;), but if you like, you 
could give it a short spin and send your "tested-by" in reply to this 
mail.

Thanks
Guennadi

 drivers/dma/dmaengine.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 8bcb15f..f7f21a5 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -509,8 +509,8 @@ struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, v
 					 dma_chan_name(chan));
 				list_del_rcu(&device->global_node);
 			} else if (err)
-				pr_err("dmaengine: failed to get %s: (%d)\n",
-				       dma_chan_name(chan), err);
+				pr_debug("dmaengine: failed to get %s: (%d)\n",
+					 dma_chan_name(chan), err);
 			else
 				break;
 			if (--device->privatecnt == 0)
-- 
1.7.2.5

