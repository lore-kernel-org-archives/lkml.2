Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab0I3AFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 20:05:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:26099 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab0I3AFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 20:05:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,257,1283756400"; 
   d="scan'208";a="662492443"
Subject: [GIT] dmaengine fixes for 2.6.36-rc7
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 17:05:33 -0700
Message-ID: <1285805133.8110.7.camel@dwillia2-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git fixes

...to receive some small fixes to drivers/dma/.  The mv_xor fix is
tagged for -stable.  Full changelog below.

Thanks,
Dan

Dan Carpenter (1):
      dma/shdma: move dereference below the NULL check

Mathieu Lacage (1):
      missing inline keyword for static function in linux/dmaengine.h

Simon Guinot (1):
      dmaengine: fix interrupt clearing for mv_xor

 drivers/dma/mv_xor.c      |    2 +-
 drivers/dma/shdma.c       |    3 ++-
 include/linux/dmaengine.h |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

commit cc60f8878eab892c03d06b10f389232b9b66bd83
Author: Simon Guinot <sguinot@lacie.com>
Date:   Fri Sep 17 23:33:51 2010 +0200

    dmaengine: fix interrupt clearing for mv_xor
    
    When using simultaneously the two DMA channels on a same engine, some
    transfers are never completed. For example, an endless lock can occur
    while writing heavily on a RAID5 array (with async-tx offload support
    enabled).
    
    Note that this issue can also be reproduced by using the DMA test
    client.
    
    On a same engine, the interrupt cause register is shared between two
    DMA channels. This patch make sure that the cause bit is only cleared
    for the requested channel.
    
    Signed-off-by: Simon Guinot <sguinot@lacie.com>
    Tested-by: Luc Saillard <luc@saillard.org>
    Acked-by: saeed bishara <saeed.bishara@gmail.com>
    Cc: <stable@kernel.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit d3f3cf859db17cc5f8156c5bfcd032413e44483b
Author: Mathieu Lacage <mathieu.lacage@sophia.inria.fr>
Date:   Sat Aug 14 15:02:44 2010 +0200

    missing inline keyword for static function in linux/dmaengine.h
    
    Add a missing inline keyword for static function in linux/dmaengine.h to
    avoid duplicate symbol definitions.
    
    Signed-off-by: Mathieu Lacage <mathieu.lacage@sophia.inria.fr>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 9f9ff20d46c6728b092f34b6a642e1e81ab5e254
Author: Dan Carpenter <error27@gmail.com>
Date:   Sat Aug 14 11:01:45 2010 +0200

    dma/shdma: move dereference below the NULL check
    
    "param" can be NULL here, so only dereference it after the check.
    
    Signed-off-by: Dan Carpenter <error27@gmail.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>


diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 86c5ae9..411d5bf 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -162,7 +162,7 @@ static int mv_is_err_intr(u32 intr_cause)
 
 static void mv_xor_device_clear_eoc_cause(struct mv_xor_chan *chan)
 {
-	u32 val = (1 << (1 + (chan->idx * 16)));
+	u32 val = ~(1 << (chan->idx * 16));
 	dev_dbg(chan->device->common.dev, "%s, val 0x%08x\n", __func__, val);
 	__raw_writel(val, XOR_INTR_CAUSE(chan));
 }
diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
index fb64cf3..eb6b54d 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/shdma.c
@@ -580,7 +580,6 @@ static struct dma_async_tx_descriptor *sh_dmae_prep_slave_sg(
 
 	sh_chan = to_sh_chan(chan);
 	param = chan->private;
-	slave_addr = param->config->addr;
 
 	/* Someone calling slave DMA on a public channel? */
 	if (!param || !sg_len) {
@@ -589,6 +588,8 @@ static struct dma_async_tx_descriptor *sh_dmae_prep_slave_sg(
 		return NULL;
 	}
 
+	slave_addr = param->config->addr;
+
 	/*
 	 * if (param != NULL), this is a successfully requested slave channel,
 	 * therefore param->config != NULL too.
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index c61d4ca..e210649 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -548,7 +548,7 @@ static inline bool dma_dev_has_pq_continue(struct dma_device *dma)
 	return (dma->max_pq & DMA_HAS_PQ_CONTINUE) == DMA_HAS_PQ_CONTINUE;
 }
 
-static unsigned short dma_dev_to_maxpq(struct dma_device *dma)
+static inline unsigned short dma_dev_to_maxpq(struct dma_device *dma)
 {
 	return dma->max_pq & ~DMA_HAS_PQ_CONTINUE;
 }


