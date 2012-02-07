Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab2BGKxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 05:53:32 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:18978
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753706Ab2BGKxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 05:53:31 -0500
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzzz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Huang Shijie <b32955@freescale.com>
To: <vinod.koul@intel.com>
CC: <shawn.guo@linaro.org>, <artem.bityutskiy@intel.com>, <shijie8@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <w.sang@pengutronix.de>,
        <LW@KARO-electronics.de>, <alsa-devel@alsa-project.org>,
        <b29396@freescale.com>, Huang Shijie <b32955@freescale.com>
Subject: [PATCH v3 0/2] patch set about the MXS-DMA
Date: Tue, 7 Feb 2012 18:54:33 +0800
Message-ID: <1328612075-5825-1-git-send-email-b32955@freescale.com>
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

v2 --> v3:
	[1] remove the field gpmi_version, use GPMI_IS_MX6Q() instead.

v1 --> v2:
	[1] squash the trial patches into single patch.
	[2] use the dma_ctrl_flags.

Huang Shijie (2):
  mxs-dma : move the mxs dma.h to a more common place
  mxs-dma : rewrite the last parameter of mxs_dma_prep_slave_sg()

 drivers/dma/mxs-dma.c                              |   34 +++++++++++++++++---
 drivers/mmc/host/mxs-mmc.c                         |   12 +++---
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c              |   24 ++++++++++---
 drivers/mtd/nand/gpmi-nand/gpmi-nand.h             |    2 +-
 .../include/mach/dma.h => include/linux/mxs-dma.h  |    0
 sound/soc/mxs/mxs-pcm.c                            |    2 +-
 sound/soc/mxs/mxs-pcm.h                            |    2 +-
 sound/soc/mxs/mxs-saif.c                           |    2 +-
 8 files changed, 57 insertions(+), 21 deletions(-)
 rename arch/arm/mach-mxs/include/mach/dma.h => include/linux/mxs-dma.h (100%)


