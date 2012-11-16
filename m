Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab2KPKdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 05:33:05 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50553 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab2KPKdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 05:33:02 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Javier Martin <javier.martin@vista-silicon.com>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH v6 0/4] Add generic driver for on-chip SRAM
Date: Fri, 16 Nov 2012 11:30:13 +0100
Message-Id: <1353061817-3207-1-git-send-email-p.zabel@pengutronix.de>
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
                };

A driver that needs to allocate SRAM buffers, like the video processing
unit on i.MX53, can retrieve the genalloc pool from a phandle in the
device tree using of_get_named_gen_pool(node, "iram", 0) from patch 1:

                vpu@63ff4000 {
                        /* ... */
                        iram = <&ocram>;
                };

Changes since v5:
 - Addressed Paul Gortmaker's comments, merging the clock patch
   into the SRAM driver patch.
 - Hard coded the allocation granularity to 512 bytes and dropped
   Matt Porter's patch for now. Whether or not this should be
   configured in the device tree could use further discussion.
 - Added a coda driver patch to use the genalloc API and, again,
   the i.MX53/i.MX6 device tree patch to show the whole picture.

regards
Philipp

---
 Documentation/devicetree/bindings/misc/sram.txt |   17 ++++
 arch/arm/boot/dts/imx53.dtsi                    |    5 +
 arch/arm/boot/dts/imx6q.dtsi                    |    6 ++
 drivers/media/platform/Kconfig                  |    3 +-
 drivers/media/platform/coda.c                   |   47 ++++++---
 drivers/misc/Kconfig                            |    9 ++
 drivers/misc/Makefile                           |    1 +
 drivers/misc/sram.c                             |  121 +++++++++++++++++++++++
 include/linux/genalloc.h                        |   14 +++
 lib/genalloc.c                                  |   67 +++++++++++++
 10 files changed, 274 insertions(+), 16 deletions(-)

