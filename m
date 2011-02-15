Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab1BOHD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 02:03:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:6948 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab1BOHDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 02:03:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,473,1291622400"; 
   d="scan'208";a="657739032"
Subject: [GIT] dmaengine fixes for 2.6.38-rc5
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, vinod.koul@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 23:24:04 -0800
Message-ID: <1297754644.25776.32.camel@dwillia2-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git fixes

Here is a collection of pent up fixes for 2.6.38 across ipu_idmac,
amba-pl08x, imx-dma, and imx-sdma.  Some have not appeared in -next, but
they have passed my build regression tests and been pending for a few
weeks.

--
Dan

Anatolij Gustschin (1):
      dma: ipu_idmac: do not lose valid received data in the irq handler

Dan Williams (2):
      Merge branch 'imx' into dmaengine-fixes
      dmaengine: add slave-dma maintainer

Russell King - ARM Linux (2):
      DMA: PL08x: fix infinite wait when terminating transfers
      DMA: PL08x: fix channel pausing to timeout rather than lockup

Sascha Hauer (12):
      dmaengine i.MX SDMA: Fix firmware loading
      dmaengine i.MX sdma: set maximum segment size for our device
      dmaengine i.MX sdma: check sg entries for valid addresses and lengths
      dmaengine i.MX SDMA: do not initialize chan_id field
      dmaengine i.MX SDMA: initialize dma capabilities outside channel loop
      dmaengine i.MX SDMA: reserve channel 0 by not registering it
      dmaengine i.MX dma: set maximum segment size for our device
      dmaengine i.MX dma: check sg entries for valid addresses and lengths
      dmaengine i.MX DMA: do not initialize chan_id field
      dmaengine i.MX dma: initialize dma capabilities outside channel loop
      Merge branch 'dmaengine-sdma' into dmaengine
      Merge branch 'dmaengine-shawn' into dmaengine

Shawn Guo (7):
      dmaengine: imx-sdma: propagate error in sdma_probe() instead of returning 0
      dmaengine: imx-sdma: fix inconsistent naming in sdma_assign_cookie()
      dmaengine: imx-sdma: remove IMX_DMA_SG_LOOP handling in sdma_prep_slave_sg()
      dmaengine: imx-sdma: set sdmac->status to DMA_ERROR in err_out of sdma_prep_slave_sg()
      dmaengine: imx-sdma: return sdmac->status in sdma_tx_status()
      dmaengine: imx-sdma: correct sdmac->status in sdma_handle_channel_loop()
      dmaengine: imx-sdma: fix up param for the last BD in sdma_prep_slave_sg()

 MAINTAINERS                 |    1 +
 drivers/dma/amba-pl08x.c    |   53 ++++++++++++++++----------
 drivers/dma/imx-dma.c       |   26 +++++++++++--
 drivers/dma/imx-sdma.c      |   88 +++++++++++++++++++++++--------------------
 drivers/dma/ipu/ipu_idmac.c |   50 ------------------------
 5 files changed, 103 insertions(+), 115 deletions(-)

commit 4abed0af1e9bc911f28bb525eece522d94d047f2
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Feb 14 00:42:08 2011 -0800

    dmaengine: add slave-dma maintainer
    
    Slave-dma has become the predominant usage model for dmaengine and needs
    special attention.  Memory-to-memory dma usage cases will continue to be
    maintained by Dan.
    
    Cc: Alan Cox <alan@linux.intel.com>
    Acked-by: Vinod Koul <vinod.koul@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a646bd7f0824d3e0f02ff8d7410704f965de01bc
Author: Anatolij Gustschin <agust@denx.de>
Date:   Mon Jan 31 13:22:29 2011 +0100

    dma: ipu_idmac: do not lose valid received data in the irq handler
    
    Currently when two or more buffers are queued by the camera driver
    and so the double buffering is enabled in the idmac, we lose one
    frame comming from CSI since the reporting of arrival of the first
    frame is deferred by the DMAIC_7_EOF interrupt handler and reporting
    of the arrival of the last frame is not done at all. So when requesting
    N frames from the image sensor we actually receive N - 1 frames in
    user space.
    
    The reason for this behaviour is that the DMAIC_7_EOF interrupt
    handler misleadingly assumes that the CUR_BUF flag is pointing to the
    buffer used by the IDMAC. Actually it is not the case since the
    CUR_BUF flag will be flipped by the FSU when the FSU is sending the
    <TASK>_NEW_FRM_RDY signal when new frame data is delivered by the CSI.
    When sending this singal, FSU updates the DMA_CUR_BUF and the
    DMA_BUFx_RDY flags: the DMA_CUR_BUF is flipped, the DMA_BUFx_RDY
    is cleared, indicating that the frame data is beeing written by
    the IDMAC to the pointed buffer. DMA_BUFx_RDY is supposed to be
    set to the ready state again by the MCU, when it has handled the
    received data. DMAIC_7_CUR_BUF flag won't be flipped here by the
    IPU, so waiting for this event in the EOF interrupt handler is wrong.
    Actually there is no spurious interrupt as described in the comments,
    this is the valid DMAIC_7_EOF interrupt indicating reception of the
    frame from CSI.
    
    The patch removes code that waits for flipping of the DMAIC_7_CUR_BUF
    flag in the DMAIC_7_EOF interrupt handler. As the comment in the
    current code denotes, this waiting doesn't help anyway. As a result
    of this removal the reporting of the first arrived frame is not
    deferred to the time of arrival of the next frame and the drivers
    software flag 'ichan->active_buffer' is in sync with DMAIC_7_CUR_BUF
    flag, so the reception of all requested frames works.
    
    This has been verified on the hardware which is triggering the
    image sensor by the programmable state machine, allowing to
    obtain exact number of frames. On this hardware we do not tolerate
    losing frames.
    
    This patch also removes resetting the DMA_BUFx_RDY flags of
    all channels in ipu_disable_channel() since transfers on other
    DMA channels might be triggered by other running tasks and the
    buffers should always be ready for data sending or reception.
    
    Signed-off-by: Anatolij Gustschin <agust@denx.de>
    Reviewed-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
    Tested-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 341b9419a8c0a4cdb75773c576870f1eb655516d
Author: Shawn Guo <shawn.guo@freescale.com>
Date:   Thu Jan 20 05:50:39 2011 +0800

    dmaengine: imx-sdma: fix up param for the last BD in sdma_prep_slave_sg()
    
    As per the reference manual, bit "L" should be set while bit "C"
    should be cleared for the last buffer descriptor in the non-cyclic
    chain, so that sdma can stop trying to find the next BD and end
    the transfer.
    
    In case of sdma_prep_slave_sg(), BD_LAST needs to be set and BD_CONT
    be cleared for the last BD.
    
    Signed-off-by: Shawn Guo <shawn.guo@freescale.com>
    Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

commit 1e9cebb42de57f1243261939c77ab5b0f9bcf311
Author: Shawn Guo <shawn.guo@freescale.com>
Date:   Thu Jan 20 05:50:38 2011 +0800

    dmaengine: imx-sdma: correct sdmac->status in sdma_handle_channel_loop()
    
    sdma_handle_channel_loop() is the handler of cyclic tx.  One period
    success does not really mean the success of the tx.  Instead of
    DMA_SUCCESS, DMA_IN_PROGRESS should be the one to tell.
    
    Signed-off-by: Shawn Guo <shawn.guo@freescale.com>
    Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

commit 8a9659114c7be6f88253618252881ea6fe0588b4
Author: Shawn Guo <shawn.guo@freescale.com>
Date:   Thu Jan 20 05:50:37 2011 +0800

    dmaengine: imx-sdma: return sdmac->status in sdma_tx_status()
    
    The sdmac->status was designed to reflect the status of the tx,
    so simply return it in sdma_tx_status().  Then dma client can call
    dma_async_is_tx_complete() to know the status of the tx.
    
    Signed-off-by: Shawn Guo <shawn.guo@freescale.com>
    Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

commit 4b2ce9ddb370c4eb573540611c347d78ac4b54a0
Author: Shawn Guo <shawn.guo@freescale.com>
Date:   Thu Jan 20 05:50:36 2011 +0800

    dmaengine: imx-sdma: set sdmac->status to DMA_ERROR in err_out of sdma_prep_slave_sg()
    
    sdma_prep_dma_cyclic() sets sdmac->status to DMA_ERROR in err_out,
    and sdma_prep_slave_sg() needs to do the same.  Otherwise,
    sdmac->status stays at DMA_IN_PROGRESS, which will make the function
    return immediately next time it gets called.
    
    Signed-off-by: Shawn Guo <shawn.guo@freescale.com>
    Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

commit 1797c33f0edcdcc9a483c06233a203786666a97f
Author: Shawn Guo <shawn.guo@freescale.com>
Date:   Thu Jan 20 05:50:35 2011 +0800

    dmaengine: imx-sdma: remove IMX_DMA_SG_LOOP handling in sdma_prep_slave_sg()
    
    This is a leftover from the time that the driver did not have
    sdma_prep_dma_cyclic callback and implemented sound dma as a looped
    sg chain.  And it can be removed now.
    
    Signed-off-by: Shawn Guo <shawn.guo@freescale.com>
    Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

commit f8a356ff96a9070156f863e4f7716e2a0eb8c995
Author: Sascha Hauer <s.hauer@pengutronix.de>
Date:   Mon Jan 31 11:35:59 2011 +0100

    dmaengine i.MX dma: initialize dma capabilities outside channel loop
    
    The capabilities are device specific fields, not channel specific fields.
    
    Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

commit 97a43dfe84119528ec2576129b91d619219ab716
Author: Sascha Hauer <s.hauer@pengutronix.de>
Date:   Mon Jan 31 11:35:44 2011 +0100

    dmaengine i.MX DMA: do not initialize chan_id field
    
    Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

commit d07102a1bb0e759ce4571df30c62998ef5d8a8d3
Author: Sascha Hauer <s.hauer@pengutronix.de>
Date:   Wed Jan 12 14:13:23 2011 +0100

    dmaengine i.MX dma: check sg entries for valid addresses and lengths
    
    Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

commit 1e070a60997f5bbaadd498c34380e2aa110336cf
Author: Sascha Hauer <s.hauer@pengutronix.de>
Date:   Wed Jan 12 13:14:37 2011 +0100

    dmaengine i.MX dma: set maximum segment size for our device
    
    Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

commit 23889c6352ab4a842a30221bb412ff49954b2fb3
Author: Sascha Hauer <s.hauer@pengutronix.de>
Date:   Mon Jan 31 10:56:58 2011 +0100

    dmaengine i.MX SDMA: reserve channel 0 by not registering it
    
    We need channel 0 of the sdma engine for internal purposes. We
    accomplished this by calling dma_request_channel() in the probe
    function. This does not work when multiple dma engines are
    present which is the case when IPU support for i.MX31/35 is
    compiled in. So instead of registering channel 0 and reserving
    it afterwards simply do not register it in the first place.
    With this the dmaengine channel counting does not match sdma
    channel counting anymore, so we have to use sdma channel counting
    in the driver.
    
    Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

commit 7214a8b14f63a1603401124bc150e17b145aa476
Author: Sascha Hauer <s.hauer@pengutronix.de>
Date:   Mon Jan 31 10:21:35 2011 +0100

    dmaengine i.MX SDMA: initialize dma capabilities outside channel loop
    
    The capabilities are device specific fields, not channel specific fields.
    
    Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

commit 7a0e9b2557902bdca563a5eb1bbac87560bd7d20
Author: Sascha Hauer <s.hauer@pengutronix.de>
Date:   Mon Jan 31 10:19:53 2011 +0100

    dmaengine i.MX SDMA: do not initialize chan_id field
    
    This is bogus as the dmaengine core will overwrite this field.
    
    Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

commit 1fa81c270da4d8dffa84fcca448654a10ed0a5dc
Author: Sascha Hauer <s.hauer@pengutronix.de>
Date:   Wed Jan 12 13:02:28 2011 +0100

    dmaengine i.MX sdma: check sg entries for valid addresses and lengths
    
    This patch lets sdma_prep_slave_sg fail if the entries of an
    sg list do not start on multiples of the word size or if the
    lengths are not multiple of the word size.
    Also, catch the previously unhandled DMA_SLAVE_BUSWIDTH_8_BYTES
    and DMA_SLAVE_BUSWIDTH_UNDEFINED cases.
    
    Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

commit b9b3f82f94b52ebb0bbdf6cd77ccc5e8ee3f53b5
Author: Sascha Hauer <s.hauer@pengutronix.de>
Date:   Wed Jan 12 12:12:31 2011 +0100

    dmaengine i.MX sdma: set maximum segment size for our device
    
    Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

commit 8179661694595eb3a4f2ff9bb0b73acbb7d2f4a9
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Thu Jan 27 12:37:44 2011 +0000

    DMA: PL08x: fix channel pausing to timeout rather than lockup
    
    If a transfer is initiated from memory to a peripheral, then data is
    fetched and the channel is marked busy.  This busy status persists until
    the HALT bit is set and the queued data has been transfered to the
    peripheral.  Waiting indefinitely after setting the HALT bit results in
    system lockups.  Timeout this operation, and print an error when this
    happens.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit fb526210b2b961b5d590b89fd8f45c0ca5769688
Author: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date:   Thu Jan 27 12:32:53 2011 +0000

    DMA: PL08x: fix infinite wait when terminating transfers
    
    If we try to pause a channel when terminating a transfer, we could end
    up spinning for it to become inactive indefinitely, and can result in
    an uninterruptible wait requiring a reset to recover from.
    
    Terminating a transfer is supposed to take effect immediately, but may
    result in data loss.
    
    To make this clear, rename the function to pl08x_terminate_phy_chan().
    Also, make sure it is always consistently called - with the spinlock
    held and IRQs disabled, and ensure that the TC and ERR interrupt status
    is always cleared.
    
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit d718f4ebddcb0bebdbf771a6672756b666e5c31b
Author: Shawn Guo <shawn.guo@freescale.com>
Date:   Mon Jan 17 22:39:24 2011 +0800

    dmaengine: imx-sdma: fix inconsistent naming in sdma_assign_cookie()
    
    Variable name sdma and sdmac are consistently used as the pointer to
    sdma_engine and sdma_channel respectively throughout the file.  The
    patch fixes the inconsistency seen in function sdma_assign_cookie().
    
    Signed-off-by: Shawn Guo <shawn.guo@freescale.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 939fd4f077269dd863cd630a3b3195a20acf7d02
Author: Shawn Guo <shawn.guo@freescale.com>
Date:   Wed Jan 19 19:13:06 2011 +0800

    dmaengine: imx-sdma: propagate error in sdma_probe() instead of returning 0
    
    Signed-off-by: Shawn Guo <shawn.guo@freescale.com>
    Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 6866fd3b7289a283741752b73e0e09f410b7639d
Author: Sascha Hauer <s.hauer@pengutronix.de>
Date:   Wed Jan 12 11:18:14 2011 +0100

    dmaengine i.MX SDMA: Fix firmware loading
    
    When loading the microcode to the SDMA engine we have to use
    the ram_code_start_addr found in the firmware image. The copy
    in the sdma engine is not initialized correctly. This is broken
    since:
    5b28aa3 dmaengine i.MX SDMA: Allow to run without firmware
    
    Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>


