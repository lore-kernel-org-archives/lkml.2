Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab1HMNBK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 09:01:10 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:33895 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab1HMNBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 09:01:08 -0400
X-SpamScore: -14
X-BigFish: VS-14(zz148cM1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944h64h)
X-Spam-TCS-SCL: 3:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Sat, 13 Aug 2011 21:08:59 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 00/12] arm/tegra: Initialize GPIO & pinmux from DT
Message-ID: <20110813130858.GC7244@S2100-06.ap.freescale.net>
References: <1313189697-21287-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1313189697-21287-1-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 04:54:45PM -0600, Stephen Warren wrote:
> This patch modifies Tegra's device tree support to remove the dependency
> on harmony_pinmux_init(), thus making it completely board-independent.
> 
> Some notes:
> 
> * This series is built on top of linux-next with a bunch of patches
>   applied, in particular the removal of irq_to_gpio and custom gpio_to_irq
>   that I'm in the process of sending to Russell. I haven't yet thought
>   through how/where to merge this without causing all kinds of conflicts.
> 
> * I took care to preserve bisectability of Tegra DT support. However,
>   linux-next doesn't yet have entirely useful Tegra DT support; some stuff
>   from Grant's devicetree/next hasn't been pushed into linux-next yet. If
>   we don't care about bisectability, I can remove a couple commits and
>   possibly squash some others.
> 
> * The approach taken here is to have a custom semantic SoC-specific
>   binding for each the gpio and pinmux drivers. Other alternatives
>   suggested included:
> 
>   1) A generic "list of register writes" to be performed at boot. This has
>      the advantage of reusability across different SoCs. However, this
>      approach isn't semantic, and requires detailed knowledge of pinmux
>      registers and potentially fiddly calculations when constructing the
>      device tree.
> 
>   2) The ability to define disabled child nodes of the pinmux controller
>      that are not processed by tegra_pinmux_probe_dt(). Other devices may
>      refer to those using phandles, and later enable/disable them, thus
>      representing dynamic pinmuxing in the device tree. I wasn't convinced
>      whether we should represent dynamic pinmuxing using phandles.
> 
>   I discussed in more detail why I prefer the current proposal in various
>   email threads.
> 
Glad to see the second soc specific pinmux binding besides the one
below for i.mx.

  http://permalink.gmane.org/gmane.linux.drivers.devicetree/6962

> * tegra_pinmux_probe_dt() enumerates all legal pingroup names, and searches
>   for a pinmux controller subnode of that name, then processes each one
>   that is found. An alternative that some may prefer would be to enumerate
>   each child node of the pinmux controller, and have each node contain an
>   explicit pingroup name property instead. Does anyone have any preference
>   here? I suppose the latter option would obviate the need to add
>   of_find_child_node_by_name().
> 
I agree with Jamie that the latter option seems better/simper.

> Thanks for reading!
> 
> Stephen Warren (12):
>   dt: Add of_find_child_node_by_name()
>   arm/tegra: Prep boards for gpio/pinmux conversion to pdevs
>   arm/tegra: Avoid duplicate gpio/pinmux devices with dt
>   arm/tegra: board-dt: Add AUXDATA for tegra-gpio and tegra-pinmux
>   arm/dt: Tegra: Add nvidia,gpios property to GPIO controller
>   arm/dt: Tegra: Add pinmux node
>   gpio/tegra: Convert to a platform device
>   gpio/tegra: Add device tree support
>   arm/tegra: Convert pinmux driver to a platform device
>   arm/tegra: Add device tree support to pinmux driver
>   arm/tegra: board-dt: Remove dependency on non-dt pinmux functions
>   arm/tegra: Remove temporary gpio/pinmux registration workaround
> 
>  arch/arm/boot/dts/tegra-harmony.dts          |  479 ++++++++++++++++++++++++++
>  arch/arm/boot/dts/tegra-seaboard.dts         |  409 ++++++++++++++++++++++
>  arch/arm/boot/dts/tegra20.dtsi               |    5 +
>  arch/arm/mach-tegra/Makefile                 |    1 -
>  arch/arm/mach-tegra/board-dt.c               |   12 +-
>  arch/arm/mach-tegra/board-harmony-pinmux.c   |    8 +
>  arch/arm/mach-tegra/board-paz00-pinmux.c     |    8 +
>  arch/arm/mach-tegra/board-seaboard-pinmux.c  |    9 +-
>  arch/arm/mach-tegra/board-trimslice-pinmux.c |    7 +
>  arch/arm/mach-tegra/devices.c                |   10 +
>  arch/arm/mach-tegra/devices.h                |    2 +
>  arch/arm/mach-tegra/pinmux.c                 |  136 ++++++++
>  drivers/gpio/gpio-tegra.c                    |   56 +++-
>  drivers/of/base.c                            |   18 +
>  include/linux/of.h                           |    2 +
>  15 files changed, 1138 insertions(+), 24 deletions(-)
> 
Generally, you need to document the bindings you come with in
Documentation/devicetree/bindings/

-- 
Regards,
Shawn

