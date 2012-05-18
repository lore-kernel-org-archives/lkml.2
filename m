Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499Ab2ERQdD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:33:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754965Ab2ERQc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:32:59 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC v26 00/66] EDAC patches for v3.5
Date: Fri, 18 May 2012 13:31:47 -0300
Message-Id: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a long series of patches to fix the EDAC subsystem,
and is being under discussions since Jan.

The current EDAC subsystem has several serious issues with regards
to all Intel Xeon and i3/i5/i7 processors. The EDAC subsystem used
to assume that all DIMM memory sticks have the same topology as the
initial PC designs, e. g:

	- the DRAM chips inside the DIMM slots are directly
	  accessible by the memory controller;

	- there's no Advanced Memory Bufffer chips between DIMMs
	  and the memory controller;

	- if the memory controller has more than one channel, all
	  channels are filled with the same memory type/size;

Due to that, all Intel drivers for hardware newer than 2005 (and
some older Intel hardware) have to lie to the EDAC core, providing
fake memory location information.

Also, the memory errors are reported via snprintk/printk's. As the
printk ABI is not preserved among Kernel versions, applications can't
(and don't) rely on it.

So, userspace applications rely, instead, on error counter sysfs
nodes, with don't allow them to do decay and burst detection, nor
to correlate errors among the same address range (with might help
userspace to distinguish between a real error from a temporary
interference.

-

v.26: 

- "RAS: Add a tracepoint for reporting memory..." patch was re-written
   in order to send to userspace ABI integer fields as such;
- added a fixup atch from Dan.
- The other patches weren't touched on this version.

TODO: improve per-driver error message and error details.

Dan Carpenter (1):
  edac_mc: check for allocation failure in edac_mc_alloc()

Joe Perches (2):
  edac: Use more normal debugging macro style
  edac: Convert debugfX to edac_dbg(X,

Mauro Carvalho Chehab (63):
  edac: Create a dimm struct and move the labels into it
  edac: move dimm properties to struct dimm_info
  edac: Don't initialize csrow's first_page & friends when not needed
  edac: move nr_pages to dimm struct
  edac: rewrite edac_align_ptr()
  edac.h: Add generic layers for describing a memory location
  edac: Change internal representation to work with layers
  amd64_edac: convert driver to use the new edac ABI
  amd76x_edac: convert driver to use the new edac ABI
  cell_edac: convert driver to use the new edac ABI
  cpc925_edac: convert driver to use the new edac ABI
  e752x_edac: convert driver to use the new edac ABI
  e7xxx_edac: convert driver to use the new edac ABI
  i3000_edac: convert driver to use the new edac ABI
  i3200_edac: convert driver to use the new edac ABI
  i5000_edac: convert driver to use the new edac ABI
  i5100_edac: convert driver to use the new edac ABI
  i5400_edac: convert driver to use the new edac ABI
  i7300_edac: convert driver to use the new edac ABI
  i7core_edac: convert driver to use the new edac ABI
  i82443bxgx_edac: convert driver to use the new edac ABI
  i82860_edac: convert driver to use the new edac ABI
  i82875p_edac: convert driver to use the new edac ABI
  i82975x_edac: convert driver to use the new edac ABI
  mpc85xx_edac: convert driver to use the new edac ABI
  mv64x60_edac: convert driver to use the new edac ABI
  pasemi_edac: convert driver to use the new edac ABI
  ppc4xx_edac: convert driver to use the new edac ABI
  r82600_edac: convert driver to use the new edac ABI
  sb_edac: convert driver to use the new edac ABI
  tile_edac: convert driver to use the new edac ABI
  x38_edac: convert driver to use the new edac ABI
  edac: Remove the legacy EDAC ABI
  edac: Initialize the dimm label with the known information
  edac: Cleanup the logs for i7core and sb edac drivers
  i5400_edac: improve debug messages to better represent the filled
    memory
  RAS: Add a tracepoint for reporting memory controller events
  i5000_edac: Fix the logic that retrieves memory information
  e752x_edac: provide more info about how DIMMS/ranks are mapped
  edac: Rename the parent dev to pdev
  edac: use Documentation-nano format for some data structs
  edac: rewrite the sysfs code to use struct device
  mpc85xx_edac: convert sysfs logic to use struct device
  amd64_edac: convert sysfs logic to use struct device
  i7core_edac: convert it to use struct device
  edac: Get rid of the old kobj's from the edac mc code
  edac: add a new per-dimm API and make the old per-virtual-rank API
    obsolete
  edac: add a sysfs node to report the maximum location for the system
  edac: Add debufs nodes to allow doing fake error inject
  edac: Move grain/dtype/edac_type calculus to be out of channel loop
  i82975x_edac: Test nr_pages earlier to save a few CPU cycles
  i5100_edac: Fix a warning when compiled with 32 bits
  i7300_edac: Get rid of some wrongly-solved rebase conflict
  edac: Only expose csrows/channels on legacy API if they're populated
  edac: change the mem allocation scheme to make
    Documentation/kobject.txt happy
  i7core_edac: change the mem allocation scheme to make
    Documentation/kobject.txt happy
  edac: move documentation ABI to ABI/testing/sysfs-devices-edac
  Edac: Add ABI Documentation for the new device nodes
  i5000: Fix the fatal error handling
  i7core: fix ranks information at the per-channel struct
  edac: Don't add __func__ or __FILE__ for debugf[0-9] msgs
  edac_mc: Cleanup per-dimm_info debug messages
  edac: Increase version to 3.0.0

 Documentation/ABI/testing/sysfs-devices-edac |  140 +++
 Documentation/edac.txt                       |  112 +--
 drivers/edac/Kconfig                         |    8 +
 drivers/edac/amd64_edac.c                    |  513 ++++++-----
 drivers/edac/amd64_edac.h                    |   29 +-
 drivers/edac/amd64_edac_dbg.c                |   89 +-
 drivers/edac/amd64_edac_inj.c                |  134 ++--
 drivers/edac/amd76x_edac.c                   |   62 +-
 drivers/edac/cell_edac.c                     |   60 +-
 drivers/edac/cpc925_edac.c                   |   93 ++-
 drivers/edac/e752x_edac.c                    |  140 ++-
 drivers/edac/e7xxx_edac.c                    |  109 ++-
 drivers/edac/edac_core.h                     |   76 +-
 drivers/edac/edac_device.c                   |   74 +-
 drivers/edac/edac_device_sysfs.c             |   71 +-
 drivers/edac/edac_mc.c                       |  914 ++++++++++++------
 drivers/edac/edac_mc_sysfs.c                 | 1341 ++++++++++++++------------
 drivers/edac/edac_module.c                   |   17 +-
 drivers/edac/edac_module.h                   |   14 +-
 drivers/edac/edac_pci.c                      |   32 +-
 drivers/edac/edac_pci_sysfs.c                |   49 +-
 drivers/edac/i3000_edac.c                    |   82 +-
 drivers/edac/i3200_edac.c                    |   90 +-
 drivers/edac/i5000_edac.c                    |  399 ++++----
 drivers/edac/i5100_edac.c                    |  108 +--
 drivers/edac/i5400_edac.c                    |  424 ++++----
 drivers/edac/i7300_edac.c                    |  280 +++---
 drivers/edac/i7core_edac.c                   |  749 +++++++--------
 drivers/edac/i82443bxgx_edac.c               |   82 +-
 drivers/edac/i82860_edac.c                   |   84 +-
 drivers/edac/i82875p_edac.c                  |   91 +-
 drivers/edac/i82975x_edac.c                  |   95 ++-
 drivers/edac/mpc85xx_edac.c                  |  158 ++--
 drivers/edac/mv64x60_edac.c                  |   77 +-
 drivers/edac/pasemi_edac.c                   |   57 +-
 drivers/edac/ppc4xx_edac.c                   |   58 +-
 drivers/edac/r82600_edac.c                   |   78 +-
 drivers/edac/sb_edac.c                       |  460 ++++-----
 drivers/edac/tile_edac.c                     |   39 +-
 drivers/edac/x38_edac.c                      |   86 +-
 include/linux/edac.h                         |  357 ++++++--
 include/ras/ras_event.h                      |  100 ++
 42 files changed, 4465 insertions(+), 3566 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-edac
 create mode 100644 include/ras/ras_event.h

-- 
1.7.8

