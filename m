Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081Ab2CGMAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:00:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281Ab2CGMAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:00:21 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] Add proper support for FB-DIMM and for the modern Intel DDR2/DDR3 memory controllers
Date: Wed,  7 Mar 2012 09:00:14 -0300
Message-Id: <1331121616-27719-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EDAC core support for RAMBUS, FB-DIMM and for most Intel DDR2/DDR3 is broken
since... ever.

The EDAC core assumes that all memory controllers work at the same way, with just
2 channels working with the same memory type on both channels. The memory properties
are stored there on a common structure that sees all channels, and a DIMM with
multiple ranks should be mapped per rank.

Modern memory controllers may have more than 2 channels, generally grouped into
a branch. They don't offer per-rank visibility (or, when they offer, this is
just a DIMM property, as the registers are per-DIMM).

Due to that, all modern Intel drivers have to lie to the EDAC core, passing some 
fake data there, using some tricks to appear to userspace that everything is ok.

Well, those tricks are inconsistent among the drivers, and each driver used
a different approach. Worse than that, the information to what memory
channel/slot/branch is masked by the drivers, creating a nightmare to someone
that wants to map a motherboard silkscreen DIMM's into something useful.

This patch series change the internal model, allowing those modern memory
controllers to be properly represented.

The existing per-rank broken userspace sysfs API was kept, in order to keep the
existing userspace programs to work.

A new sysfs API is added, allowing to report per-DIMM information.

PS.: This patch series require the "Add a per-dimm structure" patchset.

Mauro Carvalho Chehab (2):
  edac: Fix core support for MC's that see DIMMS instead of ranks
  edac: Export MC hierarchy counters for CE and UE

 drivers/edac/amd64_edac.c      |  139 ++++++---
 drivers/edac/amd64_edac_dbg.c  |    6 +-
 drivers/edac/amd64_edac_inj.c  |   24 +-
 drivers/edac/amd76x_edac.c     |   30 ++-
 drivers/edac/cell_edac.c       |   26 ++-
 drivers/edac/cpc925_edac.c     |   25 ++-
 drivers/edac/e752x_edac.c      |   46 ++-
 drivers/edac/e7xxx_edac.c      |   39 ++-
 drivers/edac/edac_core.h       |   48 +--
 drivers/edac/edac_device.c     |   27 +-
 drivers/edac/edac_mc.c         |  669 ++++++++++++++++++++++++----------------
 drivers/edac/edac_mc_sysfs.c   |  256 +++++++++++++---
 drivers/edac/edac_module.h     |    2 +-
 drivers/edac/edac_pci.c        |    7 +-
 drivers/edac/i3000_edac.c      |   27 ++-
 drivers/edac/i3200_edac.c      |   33 ++-
 drivers/edac/i5000_edac.c      |   58 +++--
 drivers/edac/i5100_edac.c      |  107 +++----
 drivers/edac/i5400_edac.c      |  217 +++++++------
 drivers/edac/i7300_edac.c      |   81 ++---
 drivers/edac/i7core_edac.c     |  231 ++++----------
 drivers/edac/i82443bxgx_edac.c |   28 +-
 drivers/edac/i82860_edac.c     |   44 ++-
 drivers/edac/i82875p_edac.c    |   31 ++-
 drivers/edac/i82975x_edac.c    |   30 ++-
 drivers/edac/mpc85xx_edac.c    |   29 ++-
 drivers/edac/mv64x60_edac.c    |   25 ++-
 drivers/edac/pasemi_edac.c     |   27 +-
 drivers/edac/ppc4xx_edac.c     |   33 ++-
 drivers/edac/r82600_edac.c     |   29 ++-
 drivers/edac/sb_edac.c         |  161 ++++-------
 drivers/edac/tile_edac.c       |   16 +-
 drivers/edac/x38_edac.c        |   30 ++-
 include/linux/edac.h           |  137 ++++++++-
 34 files changed, 1624 insertions(+), 1094 deletions(-)

-- 
1.7.8

