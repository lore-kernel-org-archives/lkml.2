Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab1FBWbD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 18:31:03 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35943 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab1FBWbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 18:31:01 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: <laurent.pinchart@ideasonboard.com>, <Hiroshi.DOYU@nokia.com>,
        <arnd@arndb.de>, <davidb@codeaurora.org>, <Joerg.Roedel@amd.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [RFC 0/6] iommu: generic api migration and grouping
Date: Fri,  3 Jun 2011 01:27:37 +0300
Message-Id: <1307053663-24572-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First stab at iommu consolidation:

- Migrate OMAP's iommu driver to the generic iommu API. With this in hand,
  users can now start using the generic iommu layer instead of calling
  omap-specific iommu API.

  New code that requires functionality missing from the generic iommu api,
  will add that functionality in the generic framework (e.g. adding framework
  awareness to multi page sizes, supported by the underlying hardware, will
  avoid the otherwise-inevitable code duplication when mapping a memory
  region).

  OMAP-specific api that is still exposed in the omap iommu driver can
  now be either moved to the generic iommu framework, or just removed (if not
  used).

  This api (and other omap-specific primitives like struct iommu) needs to
  be omapified (i.e. renamed to include an 'omap_' prefix). At this early
  point of this patch set this is too much churn though, so I'll do that
  in the following iteration, after (and if), the general direction is
  accepted.
  
- Migrate OMAP's iovmm (virtual memory manager) driver to the generic
  iommu API. With this in hand, iovmm no longer uses omap-specific api
  for mapping/unmapping operations. Nevertheless, iovmm is still coupled
  with omap's iommu even with this change: it assumes omap page sizes,
  and it uses omap's iommu objects to maintain its internal state.

  Further generalizing of iovmm strongly depends on our broader plans for
  providing a generic virtual memory manager and allocation framework
  (which, as discussed, should be separated from a specific mapper).

  iovmm has a mainline user: omap3isp, and therefore must be maintained,
  but new potential users will either have to generalize it, or come up
  with a different generic framework that will replace it.

- Migrate OMAP's iommu mainline user, omap3isp, to the generic API as well
  (so it doesn't break). As with iovmm, omap3isp still depends on
  omap's iommu, mainly because iovmm depends on it, but also for
  iommu context saving and restoring.

  It is definitely desirable to completely remove omap3isp's dependency
  on the omap-specific iommu layer, and that will be possible as the
  required functionality will be added to generic framework.

- Create a dedicated iommu drivers folder (and put the base iommu code there)
- Move OMAP's and MSM's iommu drivers to that drivers iommu folder

  Putting all iommu drivers together will ease finding similarities
  between different platforms, with the intention of solving problems once,
  in a generic framework which everyone can use.

  I've only moved the omap and msm implementations for now, to demonstrate
  the idea (and support the ARM diet :), but if this is found desirable,
  we can bring in intel-iommu.c and amd_iommu.c as well.

Meta:

- This patch set is not bisectable; it was splitted (and ordered) this way
  to ease its review. Later iterations of this patch set will fix that
  (most likely by squashing the first three patches)
- Based on and tested with 3.0-rc1
- OMAP's iommu code was tested on both OMAP3 and OMAP4
- omap3isp code was tested with a sensor-less OMAP3 (memory-to-memory only)
  (thanks Laurent Pinchart for showing me the magic needed to test omap3isp :)
- MSM code was only compile tested

Ohad Ben-Cohen (6):
  omap: iommu: generic iommu api migration
  omap: iovmm: generic iommu api migration
  media: omap3isp: generic iommu api migration
  drivers: iommu: move to a dedicated folder
  omap: iommu/iovmm: move to dedicated iommu folder
  msm: iommu: move to dedicated iommu drivers folder

 arch/arm/mach-msm/Kconfig                          |   15 -
 arch/arm/mach-msm/Makefile                         |    2 +-
 arch/arm/plat-omap/Kconfig                         |   12 -
 arch/arm/plat-omap/Makefile                        |    2 -
 arch/arm/plat-omap/include/plat/iommu.h            |    3 +-
 arch/arm/plat-omap/{ => include/plat}/iopgtable.h  |   18 ++
 arch/arm/plat-omap/include/plat/iovmm.h            |   27 +-
 arch/x86/Kconfig                                   |    5 +-
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    1 +
 drivers/base/Makefile                              |    1 -
 drivers/iommu/Kconfig                              |   32 +++
 drivers/iommu/Makefile                             |    5 +
 drivers/{base => iommu}/iommu.c                    |    0
 .../mach-msm/iommu.c => drivers/iommu/msm-iommu.c  |    0
 .../iommu/omap-iommu-debug.c                       |    2 +-
 .../iommu.c => drivers/iommu/omap-iommu.c          |  290 +++++++++++++++++---
 .../iovmm.c => drivers/iommu/omap-iovmm.c          |  113 +++++---
 drivers/media/video/Kconfig                        |    2 +-
 drivers/media/video/omap3isp/isp.c                 |   41 +++-
 drivers/media/video/omap3isp/isp.h                 |    3 +
 drivers/media/video/omap3isp/ispccdc.c             |   16 +-
 drivers/media/video/omap3isp/ispstat.c             |    6 +-
 drivers/media/video/omap3isp/ispvideo.c            |    4 +-
 24 files changed, 451 insertions(+), 151 deletions(-)
 rename arch/arm/plat-omap/{ => include/plat}/iopgtable.h (84%)
 create mode 100644 drivers/iommu/Kconfig
 create mode 100644 drivers/iommu/Makefile
 rename drivers/{base => iommu}/iommu.c (100%)
 rename arch/arm/mach-msm/iommu.c => drivers/iommu/msm-iommu.c (100%)
 rename arch/arm/plat-omap/iommu-debug.c => drivers/iommu/omap-iommu-debug.c (99%)
 rename arch/arm/plat-omap/iommu.c => drivers/iommu/omap-iommu.c (77%)
 rename arch/arm/plat-omap/iovmm.c => drivers/iommu/omap-iovmm.c (85%)

