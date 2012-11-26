Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab2KZNQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:16:20 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3707 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab2KZNQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:16:16 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 26 Nov 2012 05:16:12 -0800
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <thierry.reding@avionic-design.de>, <linux-tegra@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
CC: <linux-kernel@vger.kernel.org>, Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [RFC v2 0/8] Support for Tegra 2D hardware
Date: Mon, 26 Nov 2012 15:19:06 +0200
Message-ID: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches adds support for Tegra20 and Tegra30 host1x and
2D. It is based on Thierry Reding's tegra/next branch. We still have
unresolved issues, so I don't expect these patches to be merged, but
act as a way to get the code out for public review.

The first version was sent only to linux-tegra@vger.kernel.org. The
second version has the following changes:
* nvhost split into smaller pieces
* "graphics host" and "grhost" renamed to host1x
* patch to tegradrm exit is removed
* nvhost mem_mgr usage dropped
* public power management API prefix changed to host1x
* fixed some other code style issues

nvhost is the driver that controls host1x hardware. It supports
host1x command channels, synchronization, run-time power management
and memory management. It is sectioned into logical driver under
drivers/video/tegra/host and physical driver under
drivers/video/tegra/host/host1x. The physical driver is compiled with
the hardware headers of the particular host1x version.

The hardware units are described (briefly) in the Tegra2 TRM.

The patch set removes responsibility of host1x from tegradrm. At the
same time, it moves all drm related infrastructure in
drivers/gpu/drm/tegra/host1x.c to other files.

The patch set adds 2D driver to tegradrm, which uses nvhost for
communicating with host1x to access sync points and channels. We
expect to use the same infrastructure for other host1x clients, so
we have kept nvhost and tegradrm separate.

The patch set also adds user space API to tegradrm for accessing
host1d and 2D. We are preparing also patches to libdrm, but they are
not yet in condition that they could be sent out.

TODO:
 * tegradrm IOMMU support has been disabled
 * Prime support is still tegradrm specific - to be generalized when
   we find a way for dma mapping API to handle double mapping
 * Find a home for the data in auxdata if they are troublesome
 * nvhost is still called nvhost - there's a request to rename to
   host1x to reflect the hardware name
 * Write an article about host1x and how we use it
 * Send out 2D user space code
 * Rebase on linux-next

Arto Merilainen (2):
  gpu: drm: tegra: Remove redundant host1x
  gpu: drm: tegra: Prime support

Terje Bergstrom (6):
  video: tegra: Add nvhost driver
  video: tegra: Add syncpoint wait and interrupts
  video: tegra: host: Add channel and client support
  video: tegra: Add debug support
  ARM: tegra: Add auxiliary data for nvhost
  drm: tegra: Add gr2d device

 arch/arm/mach-tegra/board-dt-tegra20.c             |   38 +-
 arch/arm/mach-tegra/board-dt-tegra30.c             |   38 +-
 arch/arm/mach-tegra/tegra20_clocks_data.c          |    8 +-
 arch/arm/mach-tegra/tegra30_clocks_data.c          |    2 +
 drivers/gpu/drm/tegra/Kconfig                      |    8 +-
 drivers/gpu/drm/tegra/Makefile                     |    4 +-
 drivers/gpu/drm/tegra/dc.c                         |   22 +-
 drivers/gpu/drm/tegra/dmabuf.c                     |  150 ++++++
 drivers/gpu/drm/tegra/drm.c                        |  445 ++++++++++++++++--
 drivers/gpu/drm/tegra/drm.h                        |   89 ++--
 drivers/gpu/drm/tegra/dsi.c                        |   24 +-
 drivers/gpu/drm/tegra/fb.c                         |   26 +-
 drivers/gpu/drm/tegra/gr2d.c                       |  224 +++++++++
 drivers/gpu/drm/tegra/hdmi.c                       |   24 +-
 drivers/gpu/drm/tegra/host1x.c                     |  343 --------------
 drivers/gpu/drm/tegra/tvo.c                        |   33 +-
 drivers/video/Kconfig                              |    2 +
 drivers/video/Makefile                             |    2 +
 drivers/video/tegra/host/Kconfig                   |    5 +
 drivers/video/tegra/host/Makefile                  |   18 +
 drivers/video/tegra/host/bus_client.c              |   97 ++++
 drivers/video/tegra/host/chip_support.c            |   48 ++
 drivers/video/tegra/host/chip_support.h            |  149 ++++++
 drivers/video/tegra/host/debug.c                   |  252 ++++++++++
 drivers/video/tegra/host/debug.h                   |   50 ++
 drivers/video/tegra/host/dev.c                     |  170 +++++++
 drivers/video/tegra/host/dev.h                     |   33 ++
 drivers/video/tegra/host/dmabuf.c                  |  151 ++++++
 drivers/video/tegra/host/dmabuf.h                  |   45 ++
 drivers/video/tegra/host/host1x/Makefile           |    7 +
 drivers/video/tegra/host/host1x/host1x.c           |  257 +++++++++++
 drivers/video/tegra/host/host1x/host1x.h           |   86 ++++
 drivers/video/tegra/host/host1x/host1x01.c         |   70 +++
 drivers/video/tegra/host/host1x/host1x01.h         |   29 ++
 .../video/tegra/host/host1x/host1x01_hardware.h    |  157 +++++++
 drivers/video/tegra/host/host1x/host1x_cdma.c      |  486 ++++++++++++++++++++
 drivers/video/tegra/host/host1x/host1x_cdma.h      |   39 ++
 drivers/video/tegra/host/host1x/host1x_channel.c   |  150 ++++++
 drivers/video/tegra/host/host1x/host1x_debug.c     |  405 ++++++++++++++++
 drivers/video/tegra/host/host1x/host1x_intr.c      |  263 +++++++++++
 drivers/video/tegra/host/host1x/host1x_syncpt.c    |  168 +++++++
 .../video/tegra/host/host1x/hw_host1x01_channel.h  |  182 ++++++++
 drivers/video/tegra/host/host1x/hw_host1x01_sync.h |  398 ++++++++++++++++
 .../video/tegra/host/host1x/hw_host1x01_uclass.h   |  474 +++++++++++++++++++
 drivers/video/tegra/host/nvhost_acm.c              |  481 +++++++++++++++++++
 drivers/video/tegra/host/nvhost_acm.h              |   45 ++
 drivers/video/tegra/host/nvhost_cdma.c             |  430 +++++++++++++++++
 drivers/video/tegra/host/nvhost_cdma.h             |  109 +++++
 drivers/video/tegra/host/nvhost_channel.c          |  126 +++++
 drivers/video/tegra/host/nvhost_channel.h          |   65 +++
 drivers/video/tegra/host/nvhost_intr.c             |  384 ++++++++++++++++
 drivers/video/tegra/host/nvhost_intr.h             |  110 +++++
 drivers/video/tegra/host/nvhost_job.c              |  390 ++++++++++++++++
 drivers/video/tegra/host/nvhost_memmgr.c           |  160 +++++++
 drivers/video/tegra/host/nvhost_memmgr.h           |   65 +++
 drivers/video/tegra/host/nvhost_syncpt.c           |  452 ++++++++++++++++++
 drivers/video/tegra/host/nvhost_syncpt.h           |  148 ++++++
 include/drm/tegra_drm.h                            |  129 ++++++
 include/linux/nvhost.h                             |  294 ++++++++++++
 59 files changed, 8549 insertions(+), 510 deletions(-)
 create mode 100644 drivers/gpu/drm/tegra/dmabuf.c
 create mode 100644 drivers/gpu/drm/tegra/gr2d.c
 delete mode 100644 drivers/gpu/drm/tegra/host1x.c
 create mode 100644 drivers/video/tegra/host/Kconfig
 create mode 100644 drivers/video/tegra/host/Makefile
 create mode 100644 drivers/video/tegra/host/bus_client.c
 create mode 100644 drivers/video/tegra/host/chip_support.c
 create mode 100644 drivers/video/tegra/host/chip_support.h
 create mode 100644 drivers/video/tegra/host/debug.c
 create mode 100644 drivers/video/tegra/host/debug.h
 create mode 100644 drivers/video/tegra/host/dev.c
 create mode 100644 drivers/video/tegra/host/dev.h
 create mode 100644 drivers/video/tegra/host/dmabuf.c
 create mode 100644 drivers/video/tegra/host/dmabuf.h
 create mode 100644 drivers/video/tegra/host/host1x/Makefile
 create mode 100644 drivers/video/tegra/host/host1x/host1x.c
 create mode 100644 drivers/video/tegra/host/host1x/host1x.h
 create mode 100644 drivers/video/tegra/host/host1x/host1x01.c
 create mode 100644 drivers/video/tegra/host/host1x/host1x01.h
 create mode 100644 drivers/video/tegra/host/host1x/host1x01_hardware.h
 create mode 100644 drivers/video/tegra/host/host1x/host1x_cdma.c
 create mode 100644 drivers/video/tegra/host/host1x/host1x_cdma.h
 create mode 100644 drivers/video/tegra/host/host1x/host1x_channel.c
 create mode 100644 drivers/video/tegra/host/host1x/host1x_debug.c
 create mode 100644 drivers/video/tegra/host/host1x/host1x_intr.c
 create mode 100644 drivers/video/tegra/host/host1x/host1x_syncpt.c
 create mode 100644 drivers/video/tegra/host/host1x/hw_host1x01_channel.h
 create mode 100644 drivers/video/tegra/host/host1x/hw_host1x01_sync.h
 create mode 100644 drivers/video/tegra/host/host1x/hw_host1x01_uclass.h
 create mode 100644 drivers/video/tegra/host/nvhost_acm.c
 create mode 100644 drivers/video/tegra/host/nvhost_acm.h
 create mode 100644 drivers/video/tegra/host/nvhost_cdma.c
 create mode 100644 drivers/video/tegra/host/nvhost_cdma.h
 create mode 100644 drivers/video/tegra/host/nvhost_channel.c
 create mode 100644 drivers/video/tegra/host/nvhost_channel.h
 create mode 100644 drivers/video/tegra/host/nvhost_intr.c
 create mode 100644 drivers/video/tegra/host/nvhost_intr.h
 create mode 100644 drivers/video/tegra/host/nvhost_job.c
 create mode 100644 drivers/video/tegra/host/nvhost_memmgr.c
 create mode 100644 drivers/video/tegra/host/nvhost_memmgr.h
 create mode 100644 drivers/video/tegra/host/nvhost_syncpt.c
 create mode 100644 drivers/video/tegra/host/nvhost_syncpt.h
 create mode 100644 include/drm/tegra_drm.h
 create mode 100644 include/linux/nvhost.h

-- 
1.7.9.5

