Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314Ab2IGMoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 08:44:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56465 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933048Ab2IGMn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 08:43:58 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH v4 0/6] Add device tree support for on-chip SRAM 
Date: Fri,  7 Sep 2012 14:43:42 +0200
Message-Id: <1347021828-23034-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add support to configure on-chip SRAM via device-tree
node and to obtain the resulting genalloc pool from a phandle pointing
at the node.
This allows drivers to allocate SRAM with the genalloc API without
hard-coding the genalloc pool address.

The on-chip SRAM on i.MX53 and i.MX6q is registered via device tree and
changed to use the simple generic SRAM driver:

		ocram: ocram@00900000 {
			compatible = "fsl,imx-ocram", "sram";
			reg = <0x00900000 0x3f000>;
 		};

A driver that needs to allocate SRAM buffers, like the video processing
unit on i.MX53, can retrieve the genalloc pool from a phandle in the
device tree using of_get_named_gen_pool(node, "iram", 0) from patch 1:

		vpu@63ff4000 {
			/* ... */
			iram = <&ocram>;
 		};

Changes since v3:
 - Added devicetree binding documentation
 - Register platform driver early with postcore_initcall
 - Added optional SRAM clock support.

regards
Philipp

---
 Documentation/devicetree/bindings/misc/sram.txt |   17 ++++
 arch/arm/boot/dts/imx53.dtsi                    |    5 +
 arch/arm/boot/dts/imx6q.dtsi                    |    5 +
 arch/arm/mach-imx/clk-imx6q.c                   |    1 +
 arch/arm/plat-mxc/Kconfig                       |    4 -
 arch/arm/plat-mxc/Makefile                      |    1 -
 arch/arm/plat-mxc/include/mach/iram.h           |   41 --------
 arch/arm/plat-mxc/iram_alloc.c                  |   73 --------------
 drivers/misc/Kconfig                            |    9 ++
 drivers/misc/Makefile                           |    1 +
 drivers/misc/sram.c                             |  121 +++++++++++++++++++++++
 include/linux/genalloc.h                        |   14 +++
 lib/genalloc.c                                  |   67 +++++++++++++
 13 files changed, 240 insertions(+), 119 deletions(-)

