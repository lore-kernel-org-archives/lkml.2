Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab2BPGPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 01:15:48 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:16968
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753411Ab2BPGPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 01:15:45 -0500
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzzz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Huang Shijie <b32955@freescale.com>
To: <vinod.koul@intel.com>
CC: <shawn.guo@linaro.org>, <artem.bityutskiy@intel.com>,
        <w.sang@pengutronix.de>, <LW@KARO-electronics.de>,
        <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>, <cjb@laptop.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <linux-mmc@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH v6 0/2] patch set about the MXS-DMA
Date: Thu, 16 Feb 2012 14:17:31 +0800
Message-ID: <1329373053-19494-1-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

patch 1: move the mxs dma header to a more common place.
	Beside the mx23/mx28, the apbh-dma is also used by MX50 and MX6Q.
	So move the mxs dma header file to a more common place, and rename
	it to mxs-dma.h

patch 2: rewrite the last parameter of mxs_dma_prep_slave_sg().
	In the new GPMI version, some hardware behavior changes.
	The WAIT4END bit should be set in the middle one of the ECC READ page DMA chain.
	The DMA chain should be set like this:

          +-----+               +-----+                      +-----+
          | cmd | ------------> | cmd | ------------------>  | cmd |
          +-----+               +-----+                      +-----+
                                   ^                            ^
                                   |                            |
                                   |                            |
                              set WAIT4END here too        set WAIT4END here

        So rewrite the last parameter of mxs_dma_prep_slave_sg(), use the
	dma_ctrl_flags to set the proper DMA bit for DMA Command Structure.
	And change the relative drivers with the dma_ctrl_flags.

TEST:
	Tested the mxs-mmc driver and gpmi-nand drive with the two patches
	in MX28 board.

v5 --> v6:
	[1] create this patch set based on the mainline.

v4 --> v5:
	[1] remove GPMI_IS_MX6Q(), make the mxs and mx6q use the same code.
		
v3 --> v4:
	[1] create a new folder include/linux/fsl/ for store the Freescale's
	    header files.
	[2] add more CCs.

v2 --> v3:
	[1] remove field gpmi_version, use GPMI_IS_MX6Q() instead.

v1 --> v2:
	[1] squash the trial patches into single patch.
	[2] use the dma_ctrl_flags.


Huang Shijie (2):
  mxs-dma : move the mxs dma.h to a more common place
  mxs-dma : rewrite the last parameter of mxs_dma_prep_slave_sg()

 drivers/dma/mxs-dma.c                              |   34 +++++++++++++++++---
 drivers/mmc/host/mxs-mmc.c                         |   12 +++---
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c              |   19 +++++++---
 drivers/mtd/nand/gpmi-nand/gpmi-nand.h             |    2 +-
 .../mach/dma.h => include/linux/fsl/mxs-dma.h      |    0
 sound/soc/mxs/mxs-pcm.c                            |    2 +-
 sound/soc/mxs/mxs-pcm.h                            |    2 +-
 sound/soc/mxs/mxs-saif.c                           |    2 +-
 8 files changed, 52 insertions(+), 21 deletions(-)
 rename arch/arm/mach-mxs/include/mach/dma.h => include/linux/fsl/mxs-dma.h (100%)

-- 
1.7.3.2


