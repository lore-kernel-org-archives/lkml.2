Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab2ILO7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:59:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54028 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab2ILO6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:58:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Colin Cross <ccross@android.com>,
        David Brown <davidb@codeaurora.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Magnus Damm <magnus.damm@gmail.com>, Nicolas Pitre <nico@fluxnic.net>,
        Paul Mundt <lethal@linux-sh.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Shawn Guo <shawn.guo@linaro.org>, Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.linux@gmail.com>, spear-devel@list.st.com
Subject: [PATCH v9 00/13] Per sub-architecture SMP operations
Date: Wed, 12 Sep 2012 16:58:13 +0200
Message-Id: <1347461906-13527-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
X-Provags-ID: V02:K0:tqSI4yJmlkgWyxfay+yXbbeg36ClvWdU1V272HE0b+1
 5aXqeysYIv056MEdwB1puyVRdLLP1vZFSLsJpJI8IktKCV8+Mn
 +nFq1tBYVA6Rd0kgr7KyszRft1VDyr+FdqWHQnKnk3m4NR3hJa
 LO2ntEhPgYDE1AlWMnJfawM6Jc2uJsOX+363a4mdoy85Gl+mwW
 vUMWvcKQOfqypUA2D5nebI2aWG1gOUMMzqlJJGMpM2QxedTbiH
 hvG/p+i34lSSllsDaQB7mY/z0L8Rho5UcbMP5txfVE0LeidukK
 necsZORBAZ62//YI+vdLvnvsVW+YkZE4HiANH0bZmra2GxHsxX
 Xb8URKXNLztQEOnMu8UPN/iw3IpfM/lITgf+RYBezzs7OTWA2G
 v6C88SVbZQEz33LlLr9dw/2e+WyjP9h85U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I promised at the ARM mini summit, I've updated Marc's series
for smp operations according to my complaints. Unfortunately,
I could not find version 7 of the patches when I started this,
so I based my work on version 6 and had to redo the same
changes.

The patches are also available on

git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git testing/smp_ops

	Arnd

Changelog:
>From v8:
- removed the string concatenating macros
- consolidated structures into a single smp_operations
- removed trivial instances of platform_cpu_kill and
  platform_cpu_disable, now handled by the default case
- split shmobile_cpu_kill into three separate functions,
  per soc

>From v7:
- Dropped soc_desc, and focussed only on smp_ops
- Fixed CONFIG_HOTPLUG_CPU typo (courtesy of Shawn Guo)
- Marked {realview,vexpress}_cpu_die() as __cpuinit
- Added support for spear13xx
- Added pen_release consolidation (based on Arnd Bergman's patch)

>From v6:
- Dropped the dummy_* stuff
- Support for a number of new platforms
- Added the soc_hotplug_ops() macro to hide some #ifdef-ery away
- More exynos[ 45] churn
- Fixed section mismatches

>From v5:
- Added support for highbank and imx6q
- Added support for new shmobile SMP platform
- Add dummy_cpu_kill, dummy_cpu_disable and cpu_lowpower

>From v4:
- Added an SMP registration interface and moved all SMP structures to
  smp.c. The end result is much cleaner.
- Cleaned up patch 2 (leftovers from a previous rework)
- NVIDIA/EXYNOS4 naming cleanup.

>From v3:
- Converted all SMP platforms
- Added some cleanup as a last patch

>From v2:
- Split the SMP ops between init and runtime operations in order to
  have separate lifetimes for the different structures. This is not
  perfect though, as it still allows an __init function to make it to
  a runtime structure (all smp_*_ops structures are __initdata in
  order to be able to discard them). Thanks to Nico for pointing this
  out.
- Use macros to hide the #ifdef-ery in the SoC descriptor init,
  courtesy of Arnd.

>From v1:
- Move the SMP ops out of the descriptor, which makes the structure
  init a bit cleaner (thanks to Arnd).
- Mark all structures __initdata and keep a copy of the used ones.
- Keep a global pointer for the SMP ops.

Arnd Bergmann (1):
  ARM: SoC: convert spear13xx to SoC descriptor

Marc Zyngier (12):
  ARM: SoC: add per-platform SMP operations
  ARM: SoC: convert VExpress/RealView to SoC descriptor
  ARM: SoC: convert OMAP4 to SoC descriptor
  ARM: SoC: convert Tegra to SoC descriptor
  ARM: SoC: convert Exynos4 to SoC descriptor
  ARM: SoC: convert MSM SMP to SoC descriptor
  ARM: SoC: convert ux500 to SoC descriptor
  ARM: SoC: convert shmobile SMP to SoC descriptor
  ARM: SoC: convert highbank to SoC descriptor
  ARM: SoC: convert imx6q to SoC descriptor
  ARM: smp: Make SoC descriptor mandatory for SMP platforms
  ARM: consolidate pen_release instead of having per platform
    definitions

 arch/arm/include/asm/mach/arch.h               |    7 ++
 arch/arm/include/asm/smp.h                     |   48 ++++++++----
 arch/arm/kernel/setup.c                        |    5 +-
 arch/arm/kernel/smp.c                          |   72 +++++++++++++++++-
 arch/arm/mach-exynos/common.h                  |    5 ++
 arch/arm/mach-exynos/hotplug.c                 |   18 +----
 arch/arm/mach-exynos/mach-armlex4210.c         |    1 +
 arch/arm/mach-exynos/mach-exynos5-dt.c         |    1 +
 arch/arm/mach-exynos/mach-nuri.c               |    1 +
 arch/arm/mach-exynos/mach-origen.c             |    1 +
 arch/arm/mach-exynos/mach-smdk4x12.c           |    2 +
 arch/arm/mach-exynos/mach-smdkv310.c           |    2 +
 arch/arm/mach-exynos/mach-universal_c210.c     |    1 +
 arch/arm/mach-exynos/platsmp.c                 |   27 ++++---
 arch/arm/mach-highbank/core.h                  |    3 +
 arch/arm/mach-highbank/highbank.c              |    1 +
 arch/arm/mach-highbank/hotplug.c               |   16 +---
 arch/arm/mach-highbank/platsmp.c               |   18 ++++-
 arch/arm/mach-imx/hotplug.c                    |   16 +---
 arch/arm/mach-imx/mach-imx6q.c                 |    1 +
 arch/arm/mach-imx/platsmp.c                    |   18 ++++-
 arch/arm/mach-msm/board-msm8960.c              |    3 +
 arch/arm/mach-msm/board-msm8x60.c              |    7 ++
 arch/arm/mach-msm/core.h                       |    2 +
 arch/arm/mach-msm/hotplug.c                    |   18 +----
 arch/arm/mach-msm/platsmp.c                    |   24 +++---
 arch/arm/mach-omap2/board-4430sdp.c            |    1 +
 arch/arm/mach-omap2/board-generic.c            |    2 +
 arch/arm/mach-omap2/board-omap4panda.c         |    1 +
 arch/arm/mach-omap2/common.h                   |    5 ++
 arch/arm/mach-omap2/omap-hotplug.c             |   16 +---
 arch/arm/mach-omap2/omap-smp.c                 |   18 ++++-
 arch/arm/mach-realview/core.h                  |    3 +
 arch/arm/mach-realview/hotplug.c               |   18 +----
 arch/arm/mach-realview/platsmp.c               |   18 ++++-
 arch/arm/mach-realview/realview_pb11mp.c       |    1 +
 arch/arm/mach-realview/realview_pbx.c          |    1 +
 arch/arm/mach-shmobile/board-ag5evm.c          |    1 +
 arch/arm/mach-shmobile/board-kota2.c           |    1 +
 arch/arm/mach-shmobile/board-kzm9d.c           |    1 +
 arch/arm/mach-shmobile/board-kzm9g.c           |    1 +
 arch/arm/mach-shmobile/board-marzen.c          |    1 +
 arch/arm/mach-shmobile/hotplug.c               |   31 +++-----
 arch/arm/mach-shmobile/include/mach/common.h   |   24 +++---
 arch/arm/mach-shmobile/include/mach/emev2.h    |    7 +-
 arch/arm/mach-shmobile/include/mach/r8a7779.h  |    2 +
 arch/arm/mach-shmobile/include/mach/sh73a0.h   |    2 +
 arch/arm/mach-shmobile/platsmp.c               |   96 +-----------------------
 arch/arm/mach-shmobile/setup-emev2.c           |    1 +
 arch/arm/mach-shmobile/smp-emev2.c             |   47 ++++++++++--
 arch/arm/mach-shmobile/smp-r8a7779.c           |   48 ++++++++++--
 arch/arm/mach-shmobile/smp-sh73a0.c            |   48 +++++++++++-
 arch/arm/mach-spear13xx/hotplug.c              |   22 +-----
 arch/arm/mach-spear13xx/include/mach/generic.h |    3 +
 arch/arm/mach-spear13xx/platsmp.c              |   25 +++---
 arch/arm/mach-spear13xx/spear1310.c            |    1 +
 arch/arm/mach-spear13xx/spear1340.c            |    1 +
 arch/arm/mach-tegra/board-dt-tegra20.c         |    2 +
 arch/arm/mach-tegra/board-dt-tegra30.c         |    2 +
 arch/arm/mach-tegra/board-harmony.c            |    2 +
 arch/arm/mach-tegra/board-paz00.c              |    2 +
 arch/arm/mach-tegra/board-trimslice.c          |    2 +
 arch/arm/mach-tegra/common.c                   |    1 +
 arch/arm/mach-tegra/common.h                   |    3 +
 arch/arm/mach-tegra/hotplug.c                  |   16 +---
 arch/arm/mach-tegra/platsmp.c                  |   20 ++++-
 arch/arm/mach-ux500/board-mop500.c             |    4 +
 arch/arm/mach-ux500/hotplug.c                  |   36 ++-------
 arch/arm/mach-ux500/include/mach/setup.h       |    3 +
 arch/arm/mach-ux500/platsmp.c                  |   24 +++---
 arch/arm/mach-vexpress/core.h                  |    4 +
 arch/arm/mach-vexpress/hotplug.c               |   18 +----
 arch/arm/mach-vexpress/platsmp.c               |   18 ++++-
 arch/arm/mach-vexpress/v2m.c                   |    4 +
 arch/arm/plat-mxc/include/mach/common.h        |    4 +
 arch/arm/plat-versatile/include/plat/platsmp.h |   14 ++++
 arch/arm/plat-versatile/platsmp.c              |   10 +--
 77 files changed, 545 insertions(+), 409 deletions(-)
 create mode 100644 arch/arm/mach-msm/core.h
 create mode 100644 arch/arm/mach-tegra/common.h
 create mode 100644 arch/arm/plat-versatile/include/plat/platsmp.h

Cc: Colin Cross <ccross@android.com>
Cc: David Brown <davidb@codeaurora.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Shiraz Hashim <shiraz.hashim@st.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>
Cc: spear-devel@list.st.com

-- 
1.7.10

