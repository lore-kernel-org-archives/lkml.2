Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab1AaVDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:03:55 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56870 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab1AaVDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:03:54 -0500
Subject: [PATCH v2 0/6] Basic ARM device support
To: nicolas.pitre@linaro.org, Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        buytenh@wantstofly.org, Olof Johansson <olof@lixom.net>,
        john.linn@xilinx.com, linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 31 Jan 2011 14:03:50 -0700
Message-ID: <20110131203626.15105.64302.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Second posting.  v2 reworks the handling of the dtb during early init.
Instead of trying to reserve the memory region containing the dtb,
this version instead copies it into an allocated buffer because the
dtb may have been loaded by firmware into an unsafe region (like the
interrupt vectors at the base of RAM).  Nicolas, can you please
take a look at patch #4 and commenting on whether or not I'm
handling it safely?

Once again, I'm not looking to get these patches merged into mainline
yet.

...

This patch series allows CONFIG_OF to be enabled on ARM and allows the
kernel to accept a dtb pointer from boot firmware instead of atags.
If a dtb is passed, then the kernel will use the root 'compatible'
property to find a matching machine_desc, and it will use it to obtain
the memory layout, initrd location and kernel parameters string.

Only limited device tree support is enabled here.  It does not perform
any kind of device registration from device tree data.  That support
will be enabled in a later patch set.  Rather, this series is a stable
base that other engineers can use to start working on device tree
support for their platforms.

Tested on Versatile (qemu) and nVidia Tegra Harmony.  Kernel compiles
an boot with CONFIG_OF both on and off, both with and without passing
a device tree blob.

This series is reflected in the following branch:

 git://git.secretlab.ca/git/linux-2.6 devicetree/arm

The 'clean' patches (rebased) can be found here:

 git://git.secretlab.ca/git/linux-2.6 devicetree/test

The way I've managed the devicetree/test branch in the past has made
it hard for other engineers to work with the device tree support, so
I'm changing the way I'm handling it.  I will *not* rebase this new
branch.  My intention is to keep it in essentially 'merge-ready' state
at all times.  ie. I'm only going to put patches into this branch that
I consider complete and are required to enable arm device tree
support.  ie. core dt infrastructure and dt board support.  Device
drivers should be submitted directly to their respective
lists/maintainers.  I'll also be soliciting acks from platform
maintainers before I pick up board support patches into this branch.

Cheers,
g.


---

Grant Likely (5):
      arm/dt: Make __vet_atags also accept a dtb image
      arm/dt: consolidate atags setup into setup_machine_atags
      arm/dt: probe for platforms via the device tree
      arm/dt: Basic versatile devicetree support
      arm/dt: Basic tegra devicetree support

Jeremy Kerr (1):
      arm/dt: Allow CONFIG_OF on ARM


 arch/arm/Kconfig                       |    7 ++
 arch/arm/include/asm/mach/arch.h       |    2 
 arch/arm/include/asm/prom.h            |   36 +++++++++
 arch/arm/include/asm/setup.h           |    3 +
 arch/arm/kernel/Makefile               |    1 
 arch/arm/kernel/devtree.c              |  134 ++++++++++++++++++++++++++++++++
 arch/arm/kernel/head-common.S          |   24 ++++--
 arch/arm/kernel/head.S                 |    8 +-
 arch/arm/kernel/setup.c                |   78 ++++++++++---------
 arch/arm/mach-tegra/board-harmony.c    |    6 +
 arch/arm/mach-tegra/gpio.c             |    4 -
 arch/arm/mach-versatile/versatile_ab.c |    6 +
 arch/arm/mach-versatile/versatile_pb.c |    6 +
 arch/arm/mm/init.c                     |    8 ++
 14 files changed, 276 insertions(+), 47 deletions(-)
 create mode 100644 arch/arm/include/asm/prom.h
 create mode 100644 arch/arm/kernel/devtree.c

-- 
Signature
