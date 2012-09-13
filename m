Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab2IMNhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 09:37:39 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:38133 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750713Ab2IMNhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 09:37:37 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 00/15] ASoC: OMAP: Convert to use dmaengine
Date: Thu, 13 Sep 2012 16:37:50 +0300
Message-Id: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Changelog:
- Support for pause/resume for OMAP audio via dmaengine
- dmaengine: support for NO_PERIOD_WAKEUP in cyclic mode
 - OMAP to keep supporting NO_PERIOD_WAKEUP for audio
 - Other plaforms can also try to enable this mode since we have now generic
   interface to do so.

This series will switch the OMAP audio to use dmaengine.
The final patch which does the switch was based on Russell King's earlier patch.

The first 10 patch is to prepare the OMAP audio drivers for a smooth change to
dmaengine:
- sDMA FRAME sync mode is removed and replaced with PACKET mode
- dai drivers no longer need to configure sDMA sync mode
- dai drivers does not need to specify the DMA word length - with the exception
  of the omap-hdmi driver which requires 32bit word length regardless of the
  audio format in use
- the McPDM driver used (to my surprise) hackish way of getting the DMA channel
  and address - via defines from some header files

After the conversion OMAP audio support should have the same features as before,
no regressions expected.

I have tested the series on:
- BeagleBoard (audio via McBSP): 
 - aplay/arecord. In element mode and in threshold mode with different period
   sizes
 - mplayer -ao alsa: for direct ALSA access
 - mplayer -ao pulse: via PulseAudio to test NO_PERIOD_WAKEUP feature
- OMAP4 Blaze (audio via McPDM and DMIC)
 - aplay/arecord
 - mplayer -ao alsa: for direct ALSA access
 - mplayer -ao pulse: via PulseAudio to test NO_PERIOD_WAKEUP feature

The patches has been generated against:
git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-3.7

Janusz: Can you retest this series on OMAP1 to be sure I have not broken it?
Ricardo: Can you test the omap-hmdi if it is still working?

Regards,
Peter
---
Peter Ujfalusi (15):
  dmaengine: omap: Support for element mode in cyclic DMA
  dmaengine: omap: Add support for pause/resume in cyclic dma mode
  dmaengine: Add no_wakeup parameter to dmaengine_prep_dma_cyclic()
  dmaengine: Pass no_wakeup parameter via device_prep_dma_cyclic()
    callback
  dmaengine: omap-dma: Add support for no_wakeup in cyclic mode
  ASoC: omap-mcbsp: Use sDMA packet mode instead of frame mode
  ASoC: omap-pcm: Select sDMA synchronization based on packet_size
  ASoC: OMAP: Remove sync_mode from omap_pcm_dma_data struct
  ASoC: omap-pcm: Prepare to configure the DMA data_type based on
    stream properties
  ARM: OMAP4: hwmod_data: Add resource names to McPDM memory ranges
  ASoC: omap-mcpdm: Use platform_get_resource_* to get resources
  ASoC: OMAP: mcbsp, mcpdm, dmic: Let omap-pcm to pick the dma_type
  ASoC: omap-pcm, omap-dmic: Change the use of
    omap_pcm_dma_data->data_type
  ASoC: OMAP: mcbsp, mcpdm, dmic, hdmi: Set dma_data at startup time
  ASoC: omap-pcm: Convert to use dmaengine

 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |   2 +
 drivers/dma/at_hdmac.c                     |   3 +-
 drivers/dma/ep93xx_dma.c                   |   4 +-
 drivers/dma/imx-dma.c                      |   2 +-
 drivers/dma/imx-sdma.c                     |   2 +-
 drivers/dma/mmp_tdma.c                     |   2 +-
 drivers/dma/mxs-dma.c                      |   2 +-
 drivers/dma/omap-dma.c                     |  47 ++++--
 drivers/dma/pl330.c                        |   2 +-
 drivers/dma/sa11x0-dma.c                   |   2 +-
 drivers/dma/sirf-dma.c                     |   2 +-
 drivers/dma/ste_dma40.c                    |   3 +-
 drivers/dma/tegra20-apb-dma.c              |   2 +-
 include/linux/dmaengine.h                  |   8 +-
 sound/soc/omap/Kconfig                     |   3 +-
 sound/soc/omap/omap-dmic.c                 |   9 +-
 sound/soc/omap/omap-hdmi.c                 |  17 ++-
 sound/soc/omap/omap-mcbsp.c                |  60 +++-----
 sound/soc/omap/omap-mcpdm.c                |  40 +++--
 sound/soc/omap/omap-pcm.c                  | 236 ++++++++---------------------
 sound/soc/omap/omap-pcm.h                  |   4 +-
 sound/soc/soc-dmaengine-pcm.c              |   3 +-
 22 files changed, 186 insertions(+), 269 deletions(-)

-- 
1.7.12

