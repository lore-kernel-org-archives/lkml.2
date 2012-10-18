Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab2JRO1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:27:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42247 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab2JRO1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:27:50 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        kernel@pengutronix.de, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH v5 0/4] Add generic driver for on-chip SRAM 
Date: Thu, 18 Oct 2012 16:27:29 +0200
Message-Id: <1350570453-24546-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add support to configure on-chip SRAM via device-tree
node or platform data and to obtain the resulting genalloc pool from
the physical address or a phandle pointing at the device tree node.
This allows drivers to allocate SRAM with the genalloc API without
hard-coding the genalloc pool pointer.

The on-chip SRAM on i.MX53 and i.MX6q can be registered via device tree
and changed to use the simple generic SRAM driver:

		ocram: ocram@00900000 {
			compatible = "fsl,imx-ocram", "sram";
			reg = <0x00900000 0x3f000>;
			alloc-order = <12>;
 		};

A driver that needs to allocate SRAM buffers, like the video processing
unit on i.MX53, can retrieve the genalloc pool from a phandle in the
device tree using of_get_named_gen_pool(node, "iram", 0) from patch 1:

		vpu@63ff4000 {
			/* ... */
			iram = <&ocram>;
 		};

Changes since v4:
 - Added Matt Porter's patch to configure alloc order, so that the driver
   can be used for TI Davinci. 
 - Removed device tree patches as those should go through the ARM SoC tree.

regards
Philipp

---
 Documentation/devicetree/bindings/misc/sram.txt |   27 +++++
 drivers/misc/Kconfig                            |    9 ++
 drivers/misc/Makefile                           |    1 +
 drivers/misc/sram.c                             |  133 +++++++++++++++++++++++
 include/linux/genalloc.h                        |   14 +++
 include/linux/platform_data/sram.h              |   25 +++++
 lib/genalloc.c                                  |   67 ++++++++++++
 7 files changed, 276 insertions(+)

