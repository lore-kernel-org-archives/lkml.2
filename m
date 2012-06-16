Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab2FPFCA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 01:02:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43906 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab2FPFB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 01:01:59 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Milton Miller <miltonm@bga.com>
Subject: [PATCH 00/12] irqdomain cleanup and refactoring
Date: Fri, 15 Jun 2012 23:01:25 -0600
Message-Id: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey folks,

This is some of the refactoring that I've been wanting to do for
irqdomains.  Lots of patches here, but the major changes are:
- eliminate the legacy mapping by replacing it with a pre-populated linear map,
- Get rid of the slow-path setup for mapping, and
- to merge the linear and tree mapping into a single domain type.

The last change still needs some investigation and review, I'm not as
confident that this is correct and it hasn't been tested much.

Milton, the last version of these patches that I posted broke one of
your powerpc machines.  Can you please retest?  I've pushed this
series out into my irqdomain/test branch (see below)

For further work, I'd like to find a way to eliminate the nomap revmap
too so I can get rid of the irqdomain type entirely and simplify the
code even further.  I've not applied many brain cells towards doing
this yet though.  This is an area for further research.

Also, Paul tells me that there are some platforms that want to use
something like a linear mapping, but there are large holes in the
ranges of hwirq numbers which is a little wasteful of memory.  Another
area of investigation is to figure out how to be more memory-efficient
here without slowing down the linear revmap path.

g.

The following changes since commit cfaf025112d3856637ff34a767ef785ef5cf2ca9:

  Linux 3.5-rc2 (2012-06-08 18:40:09 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 irqdomain/test

for you to fetch changes up to ca2f744b40214645e0274e8681023ee6d2387f9d:

  irqdomain: merge linear and tree reverse mappings. (2012-06-15 22:36:24 -0600)

Grant Likely (13):
      devicetree: add helper inline for retrieving a node's full name
      irqdomain: Remove unnecessary test for IRQ_DOMAIN_MAP_LEGACY
      irqdomain: Split disassociating code into separate function
      irqdomain: Always update revmap when setting up a virq
      irqdomain: Eliminate dedicated radix lookup functions
      irqdomain: Fix irq_create_direct_mapping() to test irq_domain type.
      irqdomain: eliminate slow-path revmap lookups
      irqdomain: Make ops->map hook optional
      irqdomain: Replace LEGACY mapping with LINEAR
      irqdomain: Reserve IRQs for legacy domain
      irqdomain: Add debugging message
      irqdomain: reorganize revmap data.
      irqdomain: merge linear and tree reverse mappings.

Paul Mundt (2):
      irqdomain: Simple NUMA awareness.
      irqdomain: Support for static IRQ mapping and association.

 arch/arm/plat-versatile/fpga-irq.c     |    2 +-
 arch/microblaze/pci/pci-common.c       |    6 +-
 arch/powerpc/kernel/pci-common.c       |    6 +-
 arch/powerpc/kernel/vio.c              |    5 +-
 arch/powerpc/platforms/cell/iommu.c    |    3 +-
 arch/powerpc/platforms/pseries/iommu.c |    2 +-
 arch/powerpc/sysdev/xics/icp-hv.c      |    2 +-
 arch/powerpc/sysdev/xics/icp-native.c  |    2 +-
 arch/powerpc/sysdev/xics/xics-common.c |    3 -
 arch/sparc/kernel/of_device_64.c       |    2 +-
 drivers/of/base.c                      |    2 +-
 drivers/of/irq.c                       |    2 +-
 drivers/pinctrl/pinctrl-nomadik.c      |    4 +-
 include/linux/irqdomain.h              |   55 ++--
 include/linux/of.h                     |   23 +-
 kernel/irq/irqdomain.c                 |  472 +++++++++++++-------------------
 16 files changed, 251 insertions(+), 340 deletions(-)


