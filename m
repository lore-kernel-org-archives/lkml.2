Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab2A1Pdx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 10:33:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749Ab2A1PdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 10:33:07 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lwang@redhat.com, bp@amd64.org, tony.luck@intel.com
Subject: =?UTF-8?q?=5BPATCH=20RFCv2=2000/16=5D=20This=20is=20the=20version=202=20of=20the=20HERM=20patches?=
Date: Sat, 28 Jan 2012 13:32:35 -0200
Message-Id: <1327764771-28649-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is there to address some troubles with the
EDAC subsystem.

There are two groups of change in this series:

a) a trace-based class of events for hardware errors is
added (Hardware Events Report Mecanism - HERM);

The need of moving for a tracepoint-based approach were
widely discussed already at the ML. Basically, it offers
more flexibility than message dumps at the console, allowing
events filtering and other sorts of improvements.

The long-term target is that memory errors will generate
events like:

	Corrected error: memory read error on DIMM_1A (row 1, channel 0, rank=5, cpu=0, Err=0001:0090, addr = 0x7a789f03e)
	Uncorrected error: memory write error on DIMM_2B (row 2, channel 3, rank=4, cpu=1, Err=0001:0091, addr = 0xdeadbeef)

E. g. putting the user-relevant information first while 
keeping the technical details that could help the 
hardware manufacturers and the ones that might want to replace
a DRAM chip in parenthesis.

b) the edac core was changed to better support memory
controllers that aren't able to see csrows.

The EDAC subsystem were originally written to work with 
memory controllers directly connected to the DIMM chips.
Not all memory architectures use this concept. For example,
FBDIMM memories are connected via a buffer, called AMB [1].

When an AMB is present, the memory controller only sees
its communication bus, called "channel". This has nothing
to do with the "csrow channel" concept, widely used at
the subsystem, and mandatory. All drivers that work with
such architectures currently need to fake data, lying to
the edac core, in order for them to work.

Lying to the subsystem in general is not a good idea ;)

So, this series addresses it by splitting the DIMM information
from the EDAC csrow_info struct, and creating a new set of
DIMM-oriented sysfs nodes:

/sys/devices/system/edac/mc/mc0
├── dimm0
│   ├── dimm_dev_type
│   ├── dimm_edac_mode
│   ├── dimm_label
│   ├── dimm_location
│   ├── dimm_mem_type
│   └── dimm_size
...
└── dimm3
    ├── dimm_dev_type
    ├── dimm_edac_mode
    ├── dimm_label
    ├── dimm_location
    ├── dimm_mem_type
    └── dimm_size

The DIMM description looks like:

	dimm_dev_type:x8
	dimm_edac_mode:S8ECD8ED
	dimm_label:DIMM_3A
	dimm_location:branch 1 channel 0 dimm 1
	dimm_mem_type:Unbuffered-DDR3
	dimm_size:1024

Currently, the existing struct was not touched. The next step
(as indicated at the last patch on this series) is to
create the error counters.

Currently, is still an RFC, as it is not complete, and some
changes will require more test. Also, didn't try to compile
it yet on non x86 archs.

[1] http://www.interfacebus.com/Memory_Module_DDR2_FB_DIMM.html 

Please review.

Thanks!
Mauro

-

Mauro Carvalho Chehab (16):
  events/hw_event: Create a Hardware Events Report Mecanism (HERM)
  events/hw_event: use __string() trace macros for events
  hw_event: Consolidate uncorrected/corrected error msgs into one
  drivers/edac: rename channel_info to csrow_channel_info
  edac: Create a dimm struct and move the labels into it
  edac_mc_sysfs: Fix error handling
  edac: Add per dimm's sysfs nodes
  edac: Prepare to push down to drivers the filling of the dimm_info
  i5400_edac: Convert it to report memory with the new location
  i7300_edac: Convert it to report memory with the new location
  edac: move dimm properties to struct dimm_info
  edac: Don't initialize csrow's first_page & friends when not needed
  edac: move nr_pages to dimm struct
  edac: Add per-dimm sysfs show nodes
  edac: DIMM location cleanup
  edac: Add an error scope logic

 drivers/edac/amd64_edac.c       |   72 +++-------
 drivers/edac/amd76x_edac.c      |   14 +-
 drivers/edac/cell_edac.c        |   18 ++-
 drivers/edac/cpc925_edac.c      |   70 +++++-----
 drivers/edac/e752x_edac.c       |   48 ++++---
 drivers/edac/e7xxx_edac.c       |   49 ++++---
 drivers/edac/edac_mc.c          |  168 ++++++++++++++++++-----
 drivers/edac/edac_mc_sysfs.c    |  283 ++++++++++++++++++++++++++++++++++++---
 drivers/edac/i3000_edac.c       |   24 ++--
 drivers/edac/i3200_edac.c       |   24 ++--
 drivers/edac/i5000_edac.c       |   31 ++---
 drivers/edac/i5100_edac.c       |   67 +++++-----
 drivers/edac/i5400_edac.c       |   46 +++----
 drivers/edac/i7300_edac.c       |   47 ++++---
 drivers/edac/i7core_edac.c      |   46 +++----
 drivers/edac/i82443bxgx_edac.c  |   15 ++-
 drivers/edac/i82860_edac.c      |   13 +-
 drivers/edac/i82875p_edac.c     |   22 ++-
 drivers/edac/i82975x_edac.c     |   28 +++--
 drivers/edac/mpc85xx_edac.c     |   16 ++-
 drivers/edac/mv64x60_edac.c     |   22 ++--
 drivers/edac/pasemi_edac.c      |   24 ++--
 drivers/edac/ppc4xx_edac.c      |   25 ++--
 drivers/edac/r82600_edac.c      |   13 +-
 drivers/edac/sb_edac.c          |   44 ++++---
 drivers/edac/tile_edac.c        |   17 +--
 drivers/edac/x38_edac.c         |   24 ++--
 include/linux/edac.h            |   90 +++++++++++--
 include/trace/events/hw_event.h |  133 ++++++++++++++++++
 29 files changed, 1018 insertions(+), 475 deletions(-)
 create mode 100644 include/trace/events/hw_event.h

-- 
1.7.8

