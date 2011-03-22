Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab1CVXqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:46:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:15568 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562Ab1CVXqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:46:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,228,1299484800"; 
   d="scan'208";a="723119050"
Subject: Re: [GIT] dmaengine update for 2.6.39
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vinod Koul <vinod.koul@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1300823661.18112.72.camel@dwillia2-linux>
References: <1300823661.18112.72.camel@dwillia2-linux>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Mar 2011 16:51:31 -0700
Message-ID: <1300837891.22444.13.camel@dwillia2-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-22 at 12:54 -0700, Dan Williams wrote:
> Hi Linus, please pull from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next
> 
> ...to receive:
> 
> 1/ updates to ste_dma40, dw_dmac and fsldma
> 
> 2/ A new mxs-dma driver
> 
> 3/ minor updates and fixes to dmatest and pch_dma
> 
> Most of this has been in next for while, the few bits that have not
> (fsldma update and a couple fixes) pass my local build test.
> 
> The most prominent change from a process perspective is that Vinod Koul
> has taken over maintenance of the slave-dma usage model.  I expect that
> slave-dma (peripheral to host dma) will continue to grow as the
> predominant usage model for the dmaengine interface.  You might start to
> see pull requests from him directly in the coming release cycles.
> 

Appended one more fix, updated diffstat included below for verification
(but it is identical):

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next

commit 3ea205c449d2b5996d0256aa8b2894f7aea228a2
Author: Jamie Iles <jamie@jamieiles.com>
Date:   Tue Mar 22 15:34:56 2011 -0700

    avr32: at32ap700x: fix typo in DMA master configuration
    
    Commit 4aa5f366431fe (avr32: at32ap700x: specify DMA src and dst
    masters) specified the masters for the ac97c playback device
    but incorrectly set them in the capture slave information rather
    than playback.
    
    Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
    Reported-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Signed-off-by: Jamie Iles <jamie@jamieiles.com>
    Acked-by: Vinod Koul <vinod.koul@intel.com>
    [rebased on dmaengine for 2.6.39 (d42efe6b)]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index b4aaebd..bfc9d07 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -2061,8 +2061,8 @@ at32_add_device_ac97c(unsigned int id, struct ac97c_platform_data *data,
 		tx_dws->reg_width = DW_DMA_SLAVE_WIDTH_16BIT;
 		tx_dws->cfg_hi = DWC_CFGH_DST_PER(4);
 		tx_dws->cfg_lo &= ~(DWC_CFGL_HS_DST_POL | DWC_CFGL_HS_SRC_POL);
-		rx_dws->src_master = 0;
-		rx_dws->dst_master = 1;
+		tx_dws->src_master = 0;
+		tx_dws->dst_master = 1;
 		tx_dws->src_msize = DW_DMA_MSIZE_1;
 		tx_dws->dst_msize = DW_DMA_MSIZE_1;
 		tx_dws->fc = DW_DMA_FC_D_M2P;

 arch/arm/mach-mxs/include/mach/dma.h           |   26 +
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |   22 +-
 arch/avr32/mach-at32ap/at32ap700x.c            |   15 +
 drivers/dma/Kconfig                            |   12 +-
 drivers/dma/Makefile                           |    1 +
 drivers/dma/dmatest.c                          |   14 +-
 drivers/dma/dw_dmac.c                          |  103 ++-
 drivers/dma/dw_dmac_regs.h                     |   12 +-
 drivers/dma/fsldma.c                           |  551 +++++-----
 drivers/dma/fsldma.h                           |    6 +-
 drivers/dma/mxs-dma.c                          |  724 ++++++++++++
 drivers/dma/pch_dma.c                          |   35 +-
 drivers/dma/ste_dma40.c                        | 1402 +++++++++++-------------
 drivers/dma/ste_dma40_ll.c                     |  218 ++---
 drivers/dma/ste_dma40_ll.h                     |   66 +-
 include/linux/dw_dmac.h                        |   44 +-
 16 files changed, 1989 insertions(+), 1262 deletions(-)
 create mode 100644 arch/arm/mach-mxs/include/mach/dma.h
 create mode 100644 drivers/dma/mxs-dma.c


