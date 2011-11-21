Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab1KUQHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 11:07:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:25704 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab1KUQHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 11:07:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,547,1315206000"; 
   d="scan'208";a="93629735"
Subject: Re: [PATCH 02/10] dmaengine: move drivers to dma_transfer_direction
From: Vinod Koul <vinod.koul@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        jaswinder.singh@linaro.org, 21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Viresh Kumar <viresh.kumar@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Li Yang <leoli@freescale.com>, Zhang Wei <zw@zh-kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Shawn Guo <shawn.guo@freescale.com>, Yong Wang <yong.y.wang@intel.com>,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Boojin Kim <boojin.kim@samsung.com>, Barry Song <Baohua.Song@csr.com>
In-Reply-To: <20111121122029.GA4814@mwanda>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
	 <1318570705-17595-3-git-send-email-vinod.koul@intel.com>
	 <20111121122029.GA4814@mwanda>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Nov 2011 21:33:20 +0530
Message-ID: <1321891400.1516.215.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 15:20 +0300, Dan Carpenter wrote:
> I haven't followed this discussion at all so perhaps you were aware
> but this introduces a Sparse warning in linux-next.
> 
> drivers/dma/timb_dma.c:168:17: warning: mixing different enum types
> drivers/dma/timb_dma.c:168:17:     int enum dma_transfer_direction  versus
> drivers/dma/timb_dma.c:168:17:     int enum dma_data_direction 
> drivers/dma/timb_dma.c:172:32: warning: mixing different enum types
> drivers/dma/timb_dma.c:172:32:     int enum dma_transfer_direction  versus
> drivers/dma/timb_dma.c:172:32:     int enum dma_data_direction 

Thanks, below should fix this

diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index 8c88072..d142ae1 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -166,10 +166,10 @@ static void __td_unmap_desc(struct timb_dma_chan *td_chan, const u8 *dma_desc,
 
 	if (single)
 		dma_unmap_single(chan2dev(&td_chan->chan), addr, len,
-			td_chan->direction);
+			DMA_TO_DEVICE);
 	else
 		dma_unmap_page(chan2dev(&td_chan->chan), addr, len,
-			td_chan->direction);
+			DMA_TO_DEVICE);
 }
 
 static void __td_unmap_descs(struct timb_dma_desc *td_desc, bool single)
@@ -398,7 +398,7 @@ static struct timb_dma_desc *td_alloc_init_desc(struct timb_dma_chan *td_chan)
 	td_desc->txd.flags = DMA_CTRL_ACK;
 
 	td_desc->txd.phys = dma_map_single(chan2dmadev(chan),
-		td_desc->desc_list, td_desc->desc_list_len, DMA_MEM_TO_DEV);
+		td_desc->desc_list, td_desc->desc_list_len, DMA_TO_DEVICE);
 
 	err = dma_mapping_error(chan2dmadev(chan), td_desc->txd.phys);
 	if (err) {
@@ -419,7 +419,7 @@ static void td_free_desc(struct timb_dma_desc *td_desc)
 {
 	dev_dbg(chan2dev(td_desc->txd.chan), "Freeing desc: %p\n", td_desc);
 	dma_unmap_single(chan2dmadev(td_desc->txd.chan), td_desc->txd.phys,
-		td_desc->desc_list_len, DMA_MEM_TO_DEV);
+		td_desc->desc_list_len, DMA_TO_DEVICE);
 
 	kfree(td_desc->desc_list);
 	kfree(td_desc);



-- 
~Vinod

