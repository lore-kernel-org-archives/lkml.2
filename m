Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab2ILLqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 07:46:43 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:38323 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295Ab2ILLql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 07:46:41 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>
Subject: [PATCH 00/11] ASoC: OMAP: Convert to use dmaengine
Date: Wed, 12 Sep 2012 14:46:56 +0300
Message-Id: <1347450427-27627-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

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

I have tested the series on:
- BeagleBoard (audio via McBSP) with aplay/arecord. In element mode and in
  threshold mode with different period sizes
- OMAP4 Blaze (audio via McPDM and DMIC)

With this conversion the NO_PERIOD_WAKEUP is not supported at the moment. I'll
be looking at the dmaengine core and omap parts to add this feature back.

The patches has been generated against:
git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-3.7

Janusz: Can you retest this series on OMAP1 to be sure I have not broken it?
Ricardo: Can you test the omap-hmdi if it is still working?

Regards,
Peter
---
Peter Ujfalusi (11):
  dmaengine: omap: Support for element mode in cyclic DMA
  ASoC: omap-mcbsp: Use sDMA packet mode instead of frame mode
  ASoC: omap-pcm: Select sDMA synchronization based on packet_size
  ASoC: OMAP: Remove sync_mode from omap_pcm_dma_data struct
  ASoC: omap-pcm: Prepare to configure the DMA data_type based on
    stream properties
  ARM: OMAP4: hwmod_data: Add resource names to McPDM memory ranges
  ASoC: omap-mcpdm: Use platform_get_resource_* to get resources
  ASoC: OMAP: mcbsp, mcpdm, dmic: Let omap-pcm to pick the dma_type
  ASoC: omap-pcm, omap-hdmi: Change the use of
    omap_pcm_dma_data->data_type
  ASoC: OMAP: mcbsp, mcpdm, dmic, hdmi: Set dma_data at startup time
  ASoC: omap-pcm: Convert to use dmaengine

 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |   2 +
 drivers/dma/omap-dma.c                     |   5 +-
 sound/soc/omap/Kconfig                     |   3 +-
 sound/soc/omap/omap-dmic.c                 |   9 +-
 sound/soc/omap/omap-hdmi.c                 |  17 +-
 sound/soc/omap/omap-mcbsp.c                |  60 +++----
 sound/soc/omap/omap-mcpdm.c                |  41 +++--
 sound/soc/omap/omap-pcm.c                  | 246 ++++++++---------------------
 sound/soc/omap/omap-pcm.h                  |   4 +-
 9 files changed, 136 insertions(+), 251 deletions(-)

-- 
1.7.12

