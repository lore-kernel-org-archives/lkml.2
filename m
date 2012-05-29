Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab2E2Lmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 07:42:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab2E2Lmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 07:42:32 -0400
Message-ID: <4FC4B622.9000302@redhat.com>
Date: Tue, 29 May 2012 08:42:26 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux EDAC Mailing List <linux-edac@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>
Subject: [GIT PULL for 3.5-rc1] EDAC internal API changes
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
	 git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git master

This changeset is the first part of a series of patches that fixes the EDAC
sybsystem. On this set, it changes the Kernel EDAC API in order to properly 
represent the Intel i3/i5/i7, Xeon 3xxx/5xxx/7xxx, and Intel E5-xxxx memory 
controllers.

The EDAC core used to assume that:

	- the DRAM chip select pin is directly accessed by the memory controller;

	- when multiple channels are used, they're all filled with the same type
	  of memory.

None of the above premises is true on Intel memory controllers since 2002, when
RAMBUS and FB-DIMMs were introduced, and Advanced Memory Buffer or by some similar
technologies hides the direct access to the DRAM pins.

So, the existing drivers for those chipsets had to lie to the EDAC core, in
general telling that just one channel is filled. That produces some hard to
understand error messages like:

	EDAC MC0: CE row 3, channel 0, label "DIMM1": 1 Unknown error(s): memory read error on FATAL area : cpu=0 Err=0008:00c2 (ch=2), addr = 0xad1f73480 => socket=0, Channel=0(mask=2), rank=1

The location information there (row3 channel 0) is completely bogus: it has no
physical meaning, and are just some random values that the driver uses to talk
with the EDAC core. The error actually happened at CPU socket 0, channel 0, slot 1,
but this is not reported anywhere, as the EDAC core doesn't know anything about
the memory layout. So, only advanced users that know how the EDAC driver works
and that tests their systems to see how DIMMs are mapped can actually benefit
for such error logs.

This patch series fixes the error report logic, in order to allow the EDAC
to expose the memory architecture used by them to the EDAC core. So, as the
EDAC core now understands how the memory is organized, it can provide an
useful report:

	EDAC MC0: CE memory read error on DIMM1 (channel:0 slot:1 page:0x364b1b offset:0x600 grain:32 syndrome:0x0 - count:1 area:DRAM err_code:0001:0090 socket:0 channel_mask:1 rank:4)

The location of the DIMM where the error happened is reported by 
"MC0" (cpu socket #0), at "channel:0 slot:1" location, and matches the
physical location of the DIMM.

There are two remaining issues not covered by this patch series:

	- The EDAC sysfs API will still report bogus values. So, userspace
tools like edac-utils will still use the bogus data;

	- Add a new tracepoint-based way to get the binary information about
the errors.

Those are on a second series of patches (also at -next), but will probably
miss the train for 3.5, due to the slow review process.

Thanks!
Mauro

-

Latest commit at the branch: 
0bf09e829dd4b07227ed5a8bc4ac85752a044458 i7core: fix ranks information at the per-channel struct
The following changes since commit 76e10d158efb6d4516018846f60c2ab5501900bc:

  Linux 3.4 (2012-05-20 15:29:13 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git master

Mauro Carvalho Chehab (42):
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
      i5400_edac: improve debug messages to better represent the filled memory
      i5000_edac: Fix the logic that retrieves memory information
      e752x_edac: provide more info about how DIMMS/ranks are mapped
      i82975x_edac: Test nr_pages earlier to save a few CPU cycles
      i5100_edac: Fix a warning when compiled with 32 bits
      i5000: Fix the fatal error handling
      i7core: fix ranks information at the per-channel struct

 drivers/edac/amd64_edac.c      |  200 +++++++-----
 drivers/edac/amd76x_edac.c     |   42 ++-
 drivers/edac/cell_edac.c       |   42 ++-
 drivers/edac/cpc925_edac.c     |   91 +++--
 drivers/edac/e752x_edac.c      |  116 +++++--
 drivers/edac/e7xxx_edac.c      |   86 ++++--
 drivers/edac/edac_core.h       |   47 +--
 drivers/edac/edac_device.c     |   27 +-
 drivers/edac/edac_mc.c         |  716 ++++++++++++++++++++++++++--------------
 drivers/edac/edac_mc_sysfs.c   |   70 +++--
 drivers/edac/edac_module.h     |    2 +-
 drivers/edac/edac_pci.c        |    6 +-
 drivers/edac/i3000_edac.c      |   49 ++-
 drivers/edac/i3200_edac.c      |   56 ++--
 drivers/edac/i5000_edac.c      |  236 +++++++------
 drivers/edac/i5100_edac.c      |  106 +++---
 drivers/edac/i5400_edac.c      |  265 ++++++++-------
 drivers/edac/i7300_edac.c      |  115 +++----
 drivers/edac/i7core_edac.c     |  270 +++++-----------
 drivers/edac/i82443bxgx_edac.c |   41 ++-
 drivers/edac/i82860_edac.c     |   55 ++-
 drivers/edac/i82875p_edac.c    |   51 ++-
 drivers/edac/i82975x_edac.c    |   58 +++-
 drivers/edac/mpc85xx_edac.c    |   37 ++-
 drivers/edac/mv64x60_edac.c    |   47 ++-
 drivers/edac/pasemi_edac.c     |   49 ++--
 drivers/edac/ppc4xx_edac.c     |   50 ++--
 drivers/edac/r82600_edac.c     |   40 ++-
 drivers/edac/sb_edac.c         |  212 +++++--------
 drivers/edac/tile_edac.c       |   33 ++-
 drivers/edac/x38_edac.c        |   52 ++--
 include/linux/edac.h           |  182 +++++++++--
 32 files changed, 1981 insertions(+), 1468 deletions(-)

