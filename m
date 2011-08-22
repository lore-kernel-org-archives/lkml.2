Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab1HVT4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 15:56:54 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17295 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab1HVT4w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 15:56:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 22 Aug 2011 12:56:30 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Olof Johansson <olof@lixom.net>
CC: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>
Date: Mon, 22 Aug 2011 12:56:28 -0700
Subject: RE: [RFC PATCH v2 00/13] arm/tegra: Initialize GPIO & pinmux from DT
Thread-Topic: [RFC PATCH v2 00/13] arm/tegra: Initialize GPIO & pinmux from
 DT
Thread-Index: AcxbiefKFzWm5BqERUyNT4NTGHMQIQFeQ51g
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04B24A3687@HQMAIL01.nvidia.com>
References: <1313440100-17131-1-git-send-email-swarren@nvidia.com>
In-Reply-To: <1313440100-17131-1-git-send-email-swarren@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Warren wrote at Monday, August 15, 2011 2:28 PM:
> ...
> This patch modifies Tegra's device tree support to remove the dependency
> on harmony_pinmux_init(), thus making it completely board-independent.

I had the good fortune of meeting Grant at LinuxCon last week and talked
through this patchset a little (thanks!)

The message I got from Grant was that the patches are basically OK. He
did have a couple of concerns:

* Does this cause the compiled DTB to blow up in size.

The DTB goes from ~3-4K to ~8-9K with these patches added. While that
is a large % increase, Grant said that as an absolute value, that size
shouldn't be an issue.

* There's lots of repetition in the .dts representation; can this be improved?

We discussed enhancing the syntax a little, so that you can configure
multiple pins/pingroups from a single node. In particular, the syntax
in my patches was:

ld0 {
    nvidia,function = "displaya";
    nvidia,pull-down;
};
ld1 {
    nvidia,function = "displaya";
    nvidia,pull-down;
};

Which we discussed enhancing to something like:

ld0 {
    additional-pins = "ld1", "ld2", ...;
    nvidia,function = "displaya";
    nvidia,pull-down;
};

or:

meaningless-name { // typically would just use the pin name
    pins = "ld0", "ld1", "ld2", ...;
    nvidia,function = "displaya";
    nvidia,pull-down;
};

* We also briefly discussed that dtc could be modified to support symbolic
constants, so we could use named integers for the function names (perhaps
pin names too). I'll look into how easy it is to modify dtc for this.

I'll look into implementing these enhancements, and others discussed in
this email thread, and repost.

> ...
> Stephen Warren (13):
>   arm/tegra: Prep boards for gpio/pinmux conversion to pdevs
>   arm/tegra: Avoid duplicate gpio/pinmux devices with dt
>   arm/tegra: board-dt: Add AUXDATA for tegra-gpio and tegra-pinmux
>   docs/dt: Document nvidia,tegra20-gpio's nvidia,enabled-gpios property
>   arm/dt: Tegra: Add nvidia,gpios property to GPIO controller
>   docs/dt: Document nvidia,tegra20-pinmux binding
>   arm/dt: Tegra: Add pinmux node
>   gpio/tegra: Convert to a platform device
>   gpio/tegra: Add device tree support
>   arm/tegra: Convert pinmux driver to a platform device
>   arm/tegra: Add device tree support to pinmux driver
>   arm/tegra: board-dt: Remove dependency on non-dt pinmux functions
>   arm/tegra: Remove temporary gpio/pinmux registration workaround
> 
>  .../devicetree/bindings/gpio/gpio_nvidia.txt       |   20 +
>  .../devicetree/bindings/pinmux/pinmux_nvidia.txt   |  294 ++++++++++++
>  arch/arm/boot/dts/tegra-harmony.dts                |  483 ++++++++++++++++++++
>  arch/arm/boot/dts/tegra-seaboard.dts               |  421 +++++++++++++++++
>  arch/arm/boot/dts/tegra20.dtsi                     |    5 +
>  arch/arm/mach-tegra/Makefile                       |    1 -
>  arch/arm/mach-tegra/board-dt.c                     |   12 +-
>  arch/arm/mach-tegra/board-harmony-pinmux.c         |    8 +
>  arch/arm/mach-tegra/board-paz00-pinmux.c           |    8 +
>  arch/arm/mach-tegra/board-seaboard-pinmux.c        |    9 +-
>  arch/arm/mach-tegra/board-trimslice-pinmux.c       |    7 +
>  arch/arm/mach-tegra/devices.c                      |   10 +
>  arch/arm/mach-tegra/devices.h                      |    2 +
>  arch/arm/mach-tegra/pinmux.c                       |  269 +++++++++++
>  drivers/gpio/gpio-tegra.c                          |   57 ++-
>  15 files changed, 1582 insertions(+), 24 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/pinmux/pinmux_nvidia.txt

-- 
nvpublic

