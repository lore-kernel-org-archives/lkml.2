Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab2DYSsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 14:48:35 -0400
Received: from smtp-out-106.synserver.de ([212.40.185.106]:1135 "EHLO
	smtp-out-098.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757446Ab2DYSse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 14:48:34 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1421
From: Lars-Peter Clausen <lars@metafoo.de>
To: Vinod Koul <vinod.koul@intel.com>, Russell King <linux@arm.linux.org.uk>
Cc: Viresh Kumar <viresh.kumar@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Javier Martin <javier.martin@vista-silicon.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Yong Wang <yong.y.wang@intel.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 3/3] dmaengine: Fixup dmaengine_prep_slave_single() to be actually useful
Date: Wed, 25 Apr 2012 20:50:53 +0200
Message-Id: <1335379853-10122-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1335379853-10122-1-git-send-email-lars@metafoo.de>
References: <1335379853-10122-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

dmaengine_prep_slave_single() is a helper function which is supposed to be used
to prepare a transfer of a single contingous buffer. Currently the function
takes a pointer to such a buffer from which it builds a scatterlist and passes
it on to device_prep_slave_sg. The dmaengine framework requires that any
scatterlist that is passed to device_prep_slave_sg is mapped and it may not be
unmapped until the DMA operation has completed. This is not the here and any use
of dmaengine_prep_slave_single() will lead to undefined behaviour (Most likely a
system crash).

This patch changes dmaengine_prep_slave_single() to take a dma_addr_t instead of
a pointer to a buffer and moves the responsibility of mapping and unmapping the
buffer up to the caller.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

---
Changes since v1:
	* Drop call to sg_set_page
	* Slightly reword commit message
---
 include/linux/dmaengine.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 676f967..0e6b595 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -615,11 +615,13 @@ static inline int dmaengine_slave_config(struct dma_chan *chan,
 }
 
 static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_single(
-	struct dma_chan *chan, void *buf, size_t len,
+	struct dma_chan *chan, dma_addr_t buf, size_t len,
 	enum dma_transfer_direction dir, unsigned long flags)
 {
 	struct scatterlist sg;
-	sg_init_one(&sg, buf, len);
+	sg_init_table(&sg, 1);
+	sg_dma_address(&sg) = buf;
+	sg_dma_len(&sg) = len;
 
 	return chan->device->device_prep_slave_sg(chan, &sg, 1,
 						  dir, flags, NULL);
-- 
1.7.9.5

