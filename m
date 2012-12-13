Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab2LMPOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:14:00 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19415 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab2LMOAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:00:47 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 13 Dec 2012 05:59:00 -0800
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <tbergstrom@nvidia.com>, <thierry.reding@avionic-design.de>,
        <dev@lynxeye.de>, <linux-tegra@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
CC: <amerilainen@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv3 0/7] Support for Tegra 2D hardware
Date: Thu, 13 Dec 2012 16:04:37 +0200
Message-ID: <1355407484-28904-1-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches adds support for Tegra20 and Tegra30 host1x and
2D. It is based on linux-next.

The third version has too many changes to list all of them. Here are
highlights:
 * Renamed to host1x, and moved to drivers/gpu/host1x
 * Greatly simplified the inner workings between physical and logical
   driver
 * Does not use AUXDATA for passing data to driver
 * Runtime power management removed - will replace with runtime PM
   later
 * IOCTLs padded and use __64 for passing pointers
 * DMABUF support removed, replaced with GEM CMA support
 * host1x driver validates command streams and copies them to kernel
   owned buffer
 * Generic interrupt support removed - only syncpt irq remains
 * Sync points are allocated now dynamically
 * IO register space handling rewritten to use helper functions
 * Other numerous fixes and simplifications to code

Some of the issues left open:
 * Register definitions still use static inline. There has been a
   debate about code style versus ability to use compiler type
   checking and code coverage analysis. There was no conclusion, so
   I left it as was.
 * tegradrm has a global variable. Plan was to hide that behind a
   virtual device, and use that as DRM root device. That plan went
   bad once the FB CMA helper used the device for trying to allocate
   memory.

host1x is the driver that controls host1x hardware. It supports
host1x command channels, synchronization, and memory management. It
is sectioned into logical driver under drivers/gpu/host1x and
physical driver under drivers/host1x/hw. The physical driver is
compiled with the hardware headers of the particular host1x version.

The hardware units are described (briefly) in the Tegra2 TRM. Wiki
page https://gitorious.org/linux-tegra-drm/pages/Host1xIntroduction
also contains a short description of the functionality.

The patch set removes responsibility of host1x from tegradrm. At the
same time, it moves all drm related infrastructure in
drivers/gpu/drm/tegra/host1x.c to drm.c.

The patch set adds 2D driver to tegradrm, which uses host1x for
communicating with host1x to access sync points and channels. We
expect to use the same infrastructure for other host1x clients, so
we have kept host1x and tegradrm separate.

The patch set also adds user space API to tegradrm for accessing
host1x and 2D. The user space parts are sent at the same time as
these patches.

Arto Merilainen (1):
  drm: tegra: Remove redundant host1x

Terje Bergstrom (6):
  gpu: host1x: Add host1x driver
  gpu: host1x: Add syncpoint wait and interrupts
  gpu: host1x: Add channel support
  gpu: host1x: Add debug support
  ARM: tegra: Add board data and 2D clocks
  drm: tegra: Add gr2d device

 arch/arm/mach-tegra/board-dt-tegra20.c      |    1 +
 arch/arm/mach-tegra/board-dt-tegra30.c      |    1 +
 arch/arm/mach-tegra/tegra20_clocks_data.c   |    2 +-
 arch/arm/mach-tegra/tegra30_clocks_data.c   |    1 +
 drivers/gpu/Makefile                        |    1 +
 drivers/gpu/drm/tegra/Kconfig               |    2 +-
 drivers/gpu/drm/tegra/Makefile              |    2 +-
 drivers/gpu/drm/tegra/dc.c                  |   20 +-
 drivers/gpu/drm/tegra/drm.c                 |  428 ++++++++++++++++++-
 drivers/gpu/drm/tegra/drm.h                 |   67 ++-
 drivers/gpu/drm/tegra/fb.c                  |   17 +-
 drivers/gpu/drm/tegra/gr2d.c                |  300 +++++++++++++
 drivers/gpu/drm/tegra/hdmi.c                |   24 +-
 drivers/gpu/drm/tegra/host1x.c              |  325 --------------
 drivers/gpu/host1x/Kconfig                  |   28 ++
 drivers/gpu/host1x/Makefile                 |   16 +
 drivers/gpu/host1x/cdma.c                   |  475 ++++++++++++++++++++
 drivers/gpu/host1x/cdma.h                   |  107 +++++
 drivers/gpu/host1x/channel.c                |  137 ++++++
 drivers/gpu/host1x/channel.h                |   64 +++
 drivers/gpu/host1x/cma.c                    |  116 +++++
 drivers/gpu/host1x/cma.h                    |   43 ++
 drivers/gpu/host1x/debug.c                  |  207 +++++++++
 drivers/gpu/host1x/debug.h                  |   49 +++
 drivers/gpu/host1x/dev.c                    |  242 +++++++++++
 drivers/gpu/host1x/dev.h                    |  165 +++++++
 drivers/gpu/host1x/hw/Makefile              |    6 +
 drivers/gpu/host1x/hw/cdma_hw.c             |  480 +++++++++++++++++++++
 drivers/gpu/host1x/hw/cdma_hw.h             |   37 ++
 drivers/gpu/host1x/hw/channel_hw.c          |  147 +++++++
 drivers/gpu/host1x/hw/debug_hw.c            |  399 +++++++++++++++++
 drivers/gpu/host1x/hw/host1x01.c            |   46 ++
 drivers/gpu/host1x/hw/host1x01.h            |   25 ++
 drivers/gpu/host1x/hw/host1x01_hardware.h   |  150 +++++++
 drivers/gpu/host1x/hw/hw_host1x01_channel.h |   98 +++++
 drivers/gpu/host1x/hw/hw_host1x01_sync.h    |  179 ++++++++
 drivers/gpu/host1x/hw/hw_host1x01_uclass.h  |  130 ++++++
 drivers/gpu/host1x/hw/intr_hw.c             |  175 ++++++++
 drivers/gpu/host1x/hw/syncpt_hw.c           |  157 +++++++
 drivers/gpu/host1x/intr.c                   |  377 ++++++++++++++++
 drivers/gpu/host1x/intr.h                   |  106 +++++
 drivers/gpu/host1x/job.c                    |  618 +++++++++++++++++++++++++++
 drivers/gpu/host1x/memmgr.c                 |  174 ++++++++
 drivers/gpu/host1x/memmgr.h                 |   53 +++
 drivers/gpu/host1x/syncpt.c                 |  397 +++++++++++++++++
 drivers/gpu/host1x/syncpt.h                 |  134 ++++++
 drivers/video/Kconfig                       |    2 +
 include/drm/tegra_drm.h                     |  131 ++++++
 include/linux/host1x.h                      |  215 ++++++++++
 include/trace/events/host1x.h               |  296 +++++++++++++
 50 files changed, 6980 insertions(+), 392 deletions(-)
 create mode 100644 drivers/gpu/drm/tegra/gr2d.c
 delete mode 100644 drivers/gpu/drm/tegra/host1x.c
 create mode 100644 drivers/gpu/host1x/Kconfig
 create mode 100644 drivers/gpu/host1x/Makefile
 create mode 100644 drivers/gpu/host1x/cdma.c
 create mode 100644 drivers/gpu/host1x/cdma.h
 create mode 100644 drivers/gpu/host1x/channel.c
 create mode 100644 drivers/gpu/host1x/channel.h
 create mode 100644 drivers/gpu/host1x/cma.c
 create mode 100644 drivers/gpu/host1x/cma.h
 create mode 100644 drivers/gpu/host1x/debug.c
 create mode 100644 drivers/gpu/host1x/debug.h
 create mode 100644 drivers/gpu/host1x/dev.c
 create mode 100644 drivers/gpu/host1x/dev.h
 create mode 100644 drivers/gpu/host1x/hw/Makefile
 create mode 100644 drivers/gpu/host1x/hw/cdma_hw.c
 create mode 100644 drivers/gpu/host1x/hw/cdma_hw.h
 create mode 100644 drivers/gpu/host1x/hw/channel_hw.c
 create mode 100644 drivers/gpu/host1x/hw/debug_hw.c
 create mode 100644 drivers/gpu/host1x/hw/host1x01.c
 create mode 100644 drivers/gpu/host1x/hw/host1x01.h
 create mode 100644 drivers/gpu/host1x/hw/host1x01_hardware.h
 create mode 100644 drivers/gpu/host1x/hw/hw_host1x01_channel.h
 create mode 100644 drivers/gpu/host1x/hw/hw_host1x01_sync.h
 create mode 100644 drivers/gpu/host1x/hw/hw_host1x01_uclass.h
 create mode 100644 drivers/gpu/host1x/hw/intr_hw.c
 create mode 100644 drivers/gpu/host1x/hw/syncpt_hw.c
 create mode 100644 drivers/gpu/host1x/intr.c
 create mode 100644 drivers/gpu/host1x/intr.h
 create mode 100644 drivers/gpu/host1x/job.c
 create mode 100644 drivers/gpu/host1x/memmgr.c
 create mode 100644 drivers/gpu/host1x/memmgr.h
 create mode 100644 drivers/gpu/host1x/syncpt.c
 create mode 100644 drivers/gpu/host1x/syncpt.h
 create mode 100644 include/drm/tegra_drm.h
 create mode 100644 include/linux/host1x.h
 create mode 100644 include/trace/events/host1x.h

-- 
1.7.9.5

