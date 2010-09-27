Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760444Ab0I0W6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 18:58:05 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:35830 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760270Ab0I0W57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 18:57:59 -0400
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, linuxppc-dev@lists.ozlabs.org,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        =?UTF-8?q?Per=20Frid=C3=A9n?= <per.friden@stericsson.com>
Subject: [PATCH 4/4] ste_dma40: implement support for scatterlist to scatterlist copy
Date: Mon, 27 Sep 2010 15:57:57 -0700
Message-Id: <1285628277-26894-5-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285628277-26894-1-git-send-email-iws@ovro.caltech.edu>
References: <1285628277-26894-1-git-send-email-iws@ovro.caltech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Mon, 27 Sep 2010 15:57:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the DMAEngine API has support for scatterlist to scatterlist
copy, implement support for the STE DMA40 DMA controller.

Cc: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Per Fridén <per.friden@stericsson.com>
Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/dma/ste_dma40.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 17e2600..cd48859 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1857,6 +1857,18 @@ err:
 	return NULL;
 }
 
+static struct dma_async_tx_descriptor *
+d40_prep_sg(struct dma_chan *chan,
+	    struct scatterlist *dst_sg, unsigned int dst_nents,
+	    struct scatterlist *src_sg, unsigned int src_nents,
+	    unsigned long dma_flags)
+{
+	if (dst_nents != src_nents)
+		return -EINVAL;
+
+	return stedma40_memcpy_sg(chan, dst_sg, src_sg, dst_nents, dma_flags);
+}
+
 static int d40_prep_slave_sg_log(struct d40_desc *d40d,
 				 struct d40_chan *d40c,
 				 struct scatterlist *sgl,
@@ -2281,6 +2293,7 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 	base->dma_slave.device_alloc_chan_resources = d40_alloc_chan_resources;
 	base->dma_slave.device_free_chan_resources = d40_free_chan_resources;
 	base->dma_slave.device_prep_dma_memcpy = d40_prep_memcpy;
+	base->dma_slave.device_prep_dma_sg = d40_prep_sg;
 	base->dma_slave.device_prep_slave_sg = d40_prep_slave_sg;
 	base->dma_slave.device_tx_status = d40_tx_status;
 	base->dma_slave.device_issue_pending = d40_issue_pending;
@@ -2301,10 +2314,12 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 
 	dma_cap_zero(base->dma_memcpy.cap_mask);
 	dma_cap_set(DMA_MEMCPY, base->dma_memcpy.cap_mask);
+	dma_cap_set(DMA_SG, base->dma_slave.cap_mask);
 
 	base->dma_memcpy.device_alloc_chan_resources = d40_alloc_chan_resources;
 	base->dma_memcpy.device_free_chan_resources = d40_free_chan_resources;
 	base->dma_memcpy.device_prep_dma_memcpy = d40_prep_memcpy;
+	base->dma_slave.device_prep_dma_sg = d40_prep_sg;
 	base->dma_memcpy.device_prep_slave_sg = d40_prep_slave_sg;
 	base->dma_memcpy.device_tx_status = d40_tx_status;
 	base->dma_memcpy.device_issue_pending = d40_issue_pending;
@@ -2331,10 +2346,12 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 	dma_cap_zero(base->dma_both.cap_mask);
 	dma_cap_set(DMA_SLAVE, base->dma_both.cap_mask);
 	dma_cap_set(DMA_MEMCPY, base->dma_both.cap_mask);
+	dma_cap_set(DMA_SG, base->dma_slave.cap_mask);
 
 	base->dma_both.device_alloc_chan_resources = d40_alloc_chan_resources;
 	base->dma_both.device_free_chan_resources = d40_free_chan_resources;
 	base->dma_both.device_prep_dma_memcpy = d40_prep_memcpy;
+	base->dma_slave.device_prep_dma_sg = d40_prep_sg;
 	base->dma_both.device_prep_slave_sg = d40_prep_slave_sg;
 	base->dma_both.device_tx_status = d40_tx_status;
 	base->dma_both.device_issue_pending = d40_issue_pending;
-- 
1.7.1

