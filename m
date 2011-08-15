Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab1HOU2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 16:28:33 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47584 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab1HOU2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 16:28:32 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: [RFC PATCH v2 00/13] arm/tegra: Initialize GPIO & pinmux from DT
Date: Mon, 15 Aug 2011 14:28:07 -0600
Message-Id: <1313440100-17131-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:
* Enhanced pinmux code to handle "drive pingroups" as well as "mux
  pingroups". This altered the pinmux binding a little; shifting each
  type of pingroup into a sub-node in the pinmux node.
* Enumerate pingroups by enumerating DT child nodes, and mapping them to
  pingroups, rather than the other way around. Hence also removed
  modifications to <linux/of.h> and drivers/of/base.c.
* Included documentation of the bindings.
* Represent pingroup names and function names, as lower case in DT.
* Used a better name for GPIO binding GPIO list.
* Switched to boolean properties for pinmux pull-up/down.
* s/dev_err/dev_dbg/ in DT parsing debug code.
* Various minor cleanups (e.g. typos, white-space).

This patch modifies Tegra's device tree support to remove the dependency
on harmony_pinmux_init(), thus making it completely board-independent.

Some notes:

* This series is built on top of linux-next with a bunch of patches
  applied, in particular the removal of irq_to_gpio and custom gpio_to_irq
  that I'm in the process of sending to Russell. I haven't yet thought
  through how/where to merge this without causing all kinds of conflicts.

* I took care to preserve bisectability of Tegra DT support. However,
  linux-next doesn't yet have entirely useful Tegra DT support; some stuff
  from Grant's devicetree/next hasn't been pushed into linux-next yet. If
  we don't care about bisectability, I can remove a couple commits and
  possibly squash some others.

* The approach taken here is to have a custom semantic SoC-specific
  binding for each the gpio and pinmux drivers. Other alternatives
  suggested included:

  1) A generic "list of register writes" to be performed at boot. This has
     the advantage of reusability across different SoCs. However, this
     approach isn't semantic, and requires detailed knowledge of pinmux
     registers and potentially fiddly calculations when constructing the
     device tree.

  2) The ability to define disabled child nodes of the pinmux controller
     that are not processed by tegra_pinmux_probe_dt(). Other devices may
     refer to those using phandles, and later enable/disable them, thus
     representing dynamic pinmuxing in the device tree. I wasn't convinced
     whether we should represent dynamic pinmuxing using phandles.

  I discussed in more detail why I prefer the current proposal in various
  email threads.

Thanks for reading!

Stephen Warren (13):
  arm/tegra: Prep boards for gpio/pinmux conversion to pdevs
  arm/tegra: Avoid duplicate gpio/pinmux devices with dt
  arm/tegra: board-dt: Add AUXDATA for tegra-gpio and tegra-pinmux
  docs/dt: Document nvidia,tegra20-gpio's nvidia,enabled-gpios property
  arm/dt: Tegra: Add nvidia,gpios property to GPIO controller
  docs/dt: Document nvidia,tegra20-pinmux binding
  arm/dt: Tegra: Add pinmux node
  gpio/tegra: Convert to a platform device
  gpio/tegra: Add device tree support
  arm/tegra: Convert pinmux driver to a platform device
  arm/tegra: Add device tree support to pinmux driver
  arm/tegra: board-dt: Remove dependency on non-dt pinmux functions
  arm/tegra: Remove temporary gpio/pinmux registration workaround

 .../devicetree/bindings/gpio/gpio_nvidia.txt       |   20 +
 .../devicetree/bindings/pinmux/pinmux_nvidia.txt   |  294 ++++++++++++
 arch/arm/boot/dts/tegra-harmony.dts                |  483 ++++++++++++++++++++
 arch/arm/boot/dts/tegra-seaboard.dts               |  421 +++++++++++++++++
 arch/arm/boot/dts/tegra20.dtsi                     |    5 +
 arch/arm/mach-tegra/Makefile                       |    1 -
 arch/arm/mach-tegra/board-dt.c                     |   12 +-
 arch/arm/mach-tegra/board-harmony-pinmux.c         |    8 +
 arch/arm/mach-tegra/board-paz00-pinmux.c           |    8 +
 arch/arm/mach-tegra/board-seaboard-pinmux.c        |    9 +-
 arch/arm/mach-tegra/board-trimslice-pinmux.c       |    7 +
 arch/arm/mach-tegra/devices.c                      |   10 +
 arch/arm/mach-tegra/devices.h                      |    2 +
 arch/arm/mach-tegra/pinmux.c                       |  269 +++++++++++
 drivers/gpio/gpio-tegra.c                          |   57 ++-
 15 files changed, 1582 insertions(+), 24 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinmux/pinmux_nvidia.txt

