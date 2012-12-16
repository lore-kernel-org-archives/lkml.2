Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab2LPRYz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 12:24:55 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:43750 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab2LPRYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 12:24:53 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: Hideki EIRAKU <hdk@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Katsuya MATSUBARA <matsu@igel.co.jp>,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [PATCH/WIP/RFC 00/14] Renesas IPMMU driver work in progress
Date: Sun, 16 Dec 2012 18:25:46 +0100
Message-Id: <1355678760-27357-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1350290093-998-1-git-send-email-hdk@igel.co.jp>
References: <1350290093-998-1-git-send-email-hdk@igel.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Eiraku-san,

Here's a couple of patches that rework your IPMMU driver in the direction
pointed to by my comments. Feel free to use them as a base, squash them into
your code (my name doesn't need to be kept in commit messages) or even ignore
them completely where they make no sense.

Patch 5/14 has been sent to the linux-arm-kernel mailing list already as it's
an independent fix (but required by the next patches in the series).

After these 14 patches I ran into the issue of matching devices with a
particular IPMMU instance. This turned out to be more complex than I initially
thought. There's currently no driver in mainline that performs that task, and
I'm not sure whether the core infrastructure allows for doing so without
resorting to hacks.

The problem has been discussed very recently on the iommu list, you can find
more information at http://patchwork.ozlabs.org/patch/203717/. No solution has
been agreed on so far, maybe you could reply to the mail thread. Feel free to
CC me.

I'm unsure whether we should use a single ARM IOMMU mapping or one mapping per
device. This needs to be investigated as there's little documentation on the
subject. I would advice contacting Marek Szyprowski (the author of the ARM DMA
IOMMU code) to discuss this matter. Once again feel free to CC me, as well as
the appropriate mailing lists.

In my opinion the shmobile_iommu_attach_all_devices() function should be
removed, and devices should be attached with an IOMMU either as they are added
to the system, or as they are probed. Bus notifiers might be usable to achieve
that, as implemented in the above Tegra SMMU patch. This requires the IOMMU
being registered and fully operational at attachment time, so explicit IOMMU
attachment in driver code might be a better solution for now. That would
likely require one ARM DMA IOMMU mapping per device, device drivers would
explicitly call arm_iommu_create_mapping() and arm_iommu_attach_device().

Laurent Pinchart (14):
  ARM: sh-mobile: Protect ipmmu.h header with ifndef/define
  shmobile-iommu: Move IPMMU driver to drivers/iommu
  shmobile-iommu: Remove __devinit
  shmobile-iommu: Use devm_* managed functions
  ARM: iommu: Include linux/kref.h in asm/dma-iommu.h
  shmobile-iommu: Sort header files alphabetically
  shmobile-iommu: Move header file from arch/ to drivers/iommu/
  shmobile-iommu: Rename shmobile_iommu_priv to shmobile_iommu_domain
  shmobile-ipmmu: Rename ipmmu_priv to shmobile_ipmmu
  shmobile-ipmmu: Pass a struct shmobile_ipmmu to IPMMU functions
  shmobile-ipmmu: Store a struct shmobile_iommu_arch_data in
    archdata.iommu
  shmobile-ipmmu: Store ipmmu pointer in iommu arch data and iommu
    domain
  shmobile-ipmmu: Remove unneeded lock_add spinlock
  shmobile-ipmmu: Store iommu_mapping in struct shmobile_ipmmu

 arch/arm/include/asm/dma-iommu.h                   |    1 +
 arch/arm/mach-shmobile/Kconfig                     |    6 -
 arch/arm/mach-shmobile/Makefile                    |    3 -
 arch/arm/mach-shmobile/board-ap4evb.c              |    2 +-
 arch/arm/mach-shmobile/board-mackerel.c            |    2 +-
 arch/arm/mach-shmobile/include/mach/ipmmu.h        |   16 --
 arch/arm/mach-shmobile/setup-sh7372.c              |    2 +-
 drivers/iommu/Kconfig                              |    6 +
 drivers/iommu/Makefile                             |    1 +
 drivers/iommu/shmobile-iommu.c                     |  259 +++++++++++---------
 .../ipmmu.c => drivers/iommu/shmobile-ipmmu.c      |  107 ++++-----
 drivers/iommu/shmobile-ipmmu.h                     |   27 ++
 include/linux/sh_iommu.h                           |   20 ++
 13 files changed, 248 insertions(+), 204 deletions(-)
 delete mode 100644 arch/arm/mach-shmobile/include/mach/ipmmu.h
 rename arch/arm/mach-shmobile/ipmmu.c => drivers/iommu/shmobile-ipmmu.c (51%)
 create mode 100644 drivers/iommu/shmobile-ipmmu.h
 create mode 100644 include/linux/sh_iommu.h

-- 
Regards,

Laurent Pinchart

