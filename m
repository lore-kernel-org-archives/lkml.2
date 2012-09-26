Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab2IZNof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 09:44:35 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:49412 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756522Ab2IZNoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 09:44:32 -0400
From: Matt Porter <mporter@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Benoit Cousson <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Cc: Tony Lindgren <tony@atomide.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 0/3] uio_pruss support for AM33xx
Date: Wed, 26 Sep 2012 09:44:28 -0400
Message-Id: <1348667071-12631-1-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series enables uio_pruss on AM33xx and it mostly intended to look
for the proper solution to handling this particular OMAP hwmod which
contains hardware reset lines.

The comment in arch/arm/mach-omap2/omap_hwmod.c:
	/*
	 * If an IP block contains HW reset lines and any of them are
	 * asserted, we let integration code associated with that
	 * block handle the enable.  We've received very little
	 * information on what those driver authors need, and until
	 * detailed information is provided and the driver code is
	 * posted to the public lists, this is probably the best we
	 * can do.
	 */
is waiting for some information which is at least partially available
with this uio_pruss driver example.

The series has some ifdefery to get uio_pruss to build without the
DaVinci specific sram API, and then some needed DT, pinctrl, and
runtime PM support so I could actually use the driver on AM33xx.

The approach to deal with the hardware reset (for at least the pruss
hwmod) was to add a generic omap property to properly define this
hardware. The implementation simply deasserts any rst lines that
are called out in the property when the omap_device is
instantiated. This is not the right implementation as the sequence is
a bit wrong for pruss since the busy check during the hard reset
will fail, even though it fails in a benign manner. Ideally, we would
want the implementation to observe the ti,deassert-hard-reset property
and use that in omap_hwmod.c:_enable() *after* the module is unidled
and the clocks active. However, this is actually functional for purposes
of getting the uio_pruss driver up and running.


Matt Porter (3):
  uio: uio_pruss: port to AM33xx
  ARM: omap: add DT support for deasserting hardware reset lines
  ARM: dts: AM33xx PRUSS support

 .../devicetree/bindings/arm/omap/omap.txt          |    2 +
 Documentation/devicetree/bindings/uio/pruss.txt    |   17 ++++++
 .../devicetree/bindings/uio/uio_pruss.txt          |   17 ++++++
 arch/arm/boot/dts/am335x-bone.dts                  |    4 ++
 arch/arm/boot/dts/am33xx.dtsi                      |   11 ++++
 arch/arm/plat-omap/omap_device.c                   |   25 +++++++-
 drivers/uio/Kconfig                                |    4 +-
 drivers/uio/uio_pruss.c                            |   63 +++++++++++++++++++-
 8 files changed, 138 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/uio/pruss.txt
 create mode 100644 Documentation/devicetree/bindings/uio/uio_pruss.txt

-- 
1.7.9.5

