Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777Ab2BJAB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:01:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758700Ab2BJABq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:01:46 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, bp@amd64.org,
        tony.luck@intel.com
Subject: =?UTF-8?q?=5BPATCH=20v3=2000/31=5D=20Hardware=20Events=20Report=20Mecanism=20=28HERM=29?=
Date: Thu,  9 Feb 2012 22:00:59 -0200
Message-Id: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the third version of HERM patches.

This patch series is targeted on solving some problems found at the
hardware error report mecanisms at the Kernel:

	- MCE events generate processor specific messages. Decoding them
require to know arch-specific, CPU specific information. On some cases,
the same CPU output different things on different CPU stepping;

	- The EDAC core is outdated: it assumes that all drivers talk to
memories via a chip select signal, using one or two channels. Drivers
for modern architectures need to fake data to the EDAC core;

	- There are several error functions for memory errors on EDAC;
its usage is confusing, and some drivers could be providing more information,
but they're limited to the API rigid constraints. For example, single-channel
drivers could be reporting errors to a single DIMM, even on traditional
memory architecture, but the EDAC function call doesn't allow it;

	- When an error event arises on modern x86 processors, an MCE
event is generated. Such error could be enriched by a parsed information,
complemented by some additional data available on non-MCE registers,
generating just one event with the complete (MCE log + parsed info)
event information.

While HERM is meant to be generic, the current focus is to fix the issues
with the memory errors.

This series incorporates a feedback from Boris and Tony with regards to
integrate memory error events with MCE, where supported.

With regard to memory errors, HERM will allow specify any memory hierarchy
(currently limited to up to 3 layers after the memory controller, as it 
covers all currently supported memory architectures). Expanding it should
be easy, if later needed.

The old sysfs nodes are still supported. Latter patches will allow
disabling the old sysfs nodes.

All errors currently generate the printk events, as before, but they'll
also generate perf events like:

            bash-1680  [001]   152.349448: mc_error: [Hardware Error]: mce#0: Uncorrected error FAKE ERROR on label "mc#0channel#2slot#2 " (channel 2 slot 2  page 0x0 offset 0x0 grain 0 for EDAC testing only)
     kworker/u:5-198   [006]  1341.771535: mc_error_mce: mce#0: Corrected error memory read error on label "CPU_SrcID#0_Channel#3_DIMM#0 " (channel 0 slot 0  page 0x3a2db9 offset 0x7ac grain 32 syndrome 0x0 CPU: 0, MCGc/s: 1000c14/0, MC5: 8c00004000010090, ADDR/MISC: 00000003a2db97ac/00000020404c4c86, RIP: 00:<0000000000000000>, TSC: 0, PROCESSOR: 0:206d6, TIME: 1328829250, SOCKET: 0, APIC: 0 1 error(s): Unknown: Err=0001:0090 socket=0 channel=2/mask=4 rank=1)
     kworker/u:5-198   [006]  1341.792536: mc_error_mce: mce#0: Corrected error Can't discover the memory rank for ch addr 0x60f2a6d76 on label "any memory" ( page 0x0 offset 0x0 grain 32 syndrome 0x0 CPU: 0, MCGc/s: 1000c14/0, MC5: 8c00004000010090, ADDR/MISC: 0000000c1e54dab6/00000020404c4c86, RIP: 00:<0000000000000000>, TSC: 0, PROCESSOR: 0:206d6, TIME: 1328829250, SOCKET: 0, APIC: 0 )

New sysfs nodes are now provided, to match the real memory architecture.

For example, on a Sandy Bridge-EP machine, with up to 4 channels, and up
to 3 DIMMs per channel:

/sys/devices/system/edac/mc/mc0/
├── ce_channel0
├── ce_channel0_slot0
├── ce_channel0_slot1
├── ce_channel0_slot2
├── ce_channel1
├── ce_channel1_slot0
├── ce_channel1_slot1
├── ce_channel1_slot2
├── ce_channel2
├── ce_channel2_slot0
├── ce_channel2_slot1
├── ce_channel2_slot2
├── ce_channel3
├── ce_channel3_slot0
├── ce_channel3_slot1
├── ce_channel3_slot2
├── ce_count
├── ce_noinfo_count
├── dimm0
│   ├── dimm_dev_type
│   ├── dimm_edac_mode
│   ├── dimm_label
│   ├── dimm_location
│   ├── dimm_mem_type
│   └── dimm_size
├── dimm1
│   ├── dimm_dev_type
│   ├── dimm_edac_mode
│   ├── dimm_label
│   ├── dimm_location
│   ├── dimm_mem_type
│   └── dimm_size
├── fake_inject
├── ue_channel0
├── ue_channel0_slot0
├── ue_channel0_slot1
├── ue_channel0_slot2
├── ue_channel1
├── ue_channel1_slot0
├── ue_channel1_slot1
├── ue_channel1_slot2
├── ue_channel2
├── ue_channel2_slot0
├── ue_channel2_slot1
├── ue_channel2_slot2
├── ue_channel3
├── ue_channel3_slot0
├── ue_channel3_slot1
├── ue_channel3_slot2
├── ue_count
└── ue_noinfo_count

One of the above nodes allow testing the error report mechanism by
providing a simple driver-independent way to inject errors (fake_inject).
This node is enabled only when CONFIG_EDAC_DEBUG is enabled, and it
is limited to test the core EDAC report mechanisms, but it helps to
test if the tracing events are properly accredited to the right DIMMs.

There's currently one assumption on the above that it might not be
true: it assumes that the last element on the hierarchy will point to
a single memory stick, called at the sysfs hierarchy as "dimm". This
may not be true with dual/quad rank memories, on some memory controllers.
Further test is needed to double check it. I intend to do that, after
having access to csrow/channel based machines that I can equip with a mix
of single and dual or quad rank memories (still trying to obtain some
hardware).

The memory error handling function has now the capability of reporting
more than one dimm, when it is not possible to put the fingers into
a single place.

For example:
	# echo 1 >/sys/devices/system/edac/mc/mc0/fake_inject  && dmesg |tail -1
	[ 2878.130704] EDAC MC0: CE FAKE ERROR on mc#0channel#1slot#0 mc#0channel#1slot#1 mc#0channel#1slot#2  (channel 1 page 0x0 offset 0x0 grain 0 syndrome 0x0 for EDAC testing only)

All dimm memories present on channel 1 are pointed as one of them were
responsible for the error.

With regards to the output, the errors are now reported on a more 
user-friendly way, e. g. the EDAC core will output:

- the timestamp;
- the memory controller;
- if the error is corrected, uncorrected or fatal;
- the error message (driver specific, for example "read error", "scrubbing
  error", etc)
- the affected memory labels.

Other technical details are provided, inside parenthesis, in order to
allow hardware manufacturers, OEM, etc to have more details on it, and
discover what DRAM has problems, if they want/need to.

Ah, now that the memory architecture is properly represented, the DIMM
labels are automatically filled by the mc_alloc function call, in order
to properly represent the memory architecture.

For example, in the case of Sandy Bridge, a memory can be described as:
	mc#0channel#1slot#0

This matches the way the memory is known inside the technical information,
and, hopefully, at the OEM manuals for the motherboard. So, it should
be simpler for OEM's and system administrators to identify what memory
is broken, and/or to relabel it with a tool like edac-utils with the
motherboard-specific nomenclature.

Currently tested on Nehalem and Sandy Bridge. On both, the memory hierarchy
is MC/Channel/Slot. I should be testing tomorrow with i5400, where the
hierarchy is MC/Branch/Channel/Slot.

This series should compile on all architectures (compile-tested the last
patch that changed some bits on all drivers on x86_64, i386, ppc32, ppc64
and tilepro). All drivers compiled fine, even the one marked as BROKEN.

Of course, tests and feedback are welcome!

Regards,
Mauro

Mauro Carvalho Chehab (31):
  events/hw_event: Create a Hardware Events Report Mecanism (HERM)
  events/hw_event: use __string() trace macros for events
  hw_event: Consolidate uncorrected/corrected error msgs into one
  drivers/edac: rename channel_info to csrow_channel_info
  edac: Create a dimm struct and move the labels into it
  edac: Add per dimm's sysfs nodes
  edac: Prepare to push down to drivers the filling of the dimm_info
  edac: Better describe the memory concepts     The memory terms
    changed along the time, since when EDAC were originally    
    written: new concepts were introduced, and some things have
    different     meanings, depending on the memory architecture.
    Better define those     terms, and better describe each supported
    memory type.
  i5400_edac: Convert it to report memory with the new location
  i7300_edac: Convert it to report memory with the new location
  edac: move dimm properties to struct dimm_info
  edac: Don't initialize csrow's first_page & friends when not needed
  edac: move nr_pages to dimm struct
  edac: Add per-dimm sysfs show nodes
  edac: DIMM location cleanup
  edac/ppc4xx_edac: Fix compilation
  edac-mc: Allow reporting errors on a non-csrow oriented way
  edac.h: Use kernel-doc-nano-HOWTO.txt notation for enums
  edac: rework memory layer hierarchy description
  edac: Export MC hierarchy counters for CE and UE
  hw_event: Add x86 MCE events on it
  amd64_edac: convert it to use the MCE log tracepoint where applicable
  edac: Simplify logs for i7core and sb edac drivers
  edac_mc: Some clenups at the log message
  edac: Add a sysfs node to test the EDAC error report facility
  edac_mc: Fix the enable label filter logic
  edac: Initialize the dimm label with the known information
  edac: don't OOPS if the csrow is not visible
  edac: Fix sysfs csrow?/*ce*count counters
  edac: Fix new error counts
  edac: Fix per layer error count counters

 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 drivers/edac/amd64_edac.c        |  217 +++++++-----
 drivers/edac/amd64_edac_dbg.c    |    6 +-
 drivers/edac/amd64_edac_inj.c    |   24 +-
 drivers/edac/amd76x_edac.c       |   44 ++-
 drivers/edac/cell_edac.c         |   42 ++-
 drivers/edac/cpc925_edac.c       |   93 +++--
 drivers/edac/e752x_edac.c        |   94 +++--
 drivers/edac/e7xxx_edac.c        |   88 +++--
 drivers/edac/edac_core.h         |   48 +--
 drivers/edac/edac_device.c       |   27 +-
 drivers/edac/edac_mc.c           |  719 ++++++++++++++++++++++++--------------
 drivers/edac/edac_mc_sysfs.c     |  560 +++++++++++++++++++++++++++---
 drivers/edac/edac_module.h       |    2 +-
 drivers/edac/edac_pci.c          |    7 +-
 drivers/edac/i3000_edac.c        |   51 ++-
 drivers/edac/i3200_edac.c        |   57 ++--
 drivers/edac/i5000_edac.c        |   89 +++--
 drivers/edac/i5100_edac.c        |   98 +++---
 drivers/edac/i5400_edac.c        |   99 ++----
 drivers/edac/i7300_edac.c        |  114 +++----
 drivers/edac/i7core_edac.c       |  265 ++++----------
 drivers/edac/i82443bxgx_edac.c   |   43 ++-
 drivers/edac/i82860_edac.c       |   57 ++-
 drivers/edac/i82875p_edac.c      |   53 ++-
 drivers/edac/i82975x_edac.c      |   58 +++-
 drivers/edac/mpc85xx_edac.c      |   45 ++-
 drivers/edac/mv64x60_edac.c      |   47 ++-
 drivers/edac/pasemi_edac.c       |   51 ++--
 drivers/edac/ppc4xx_edac.c       |   62 ++--
 drivers/edac/r82600_edac.c       |   42 ++-
 drivers/edac/sb_edac.c           |  201 ++++-------
 drivers/edac/tile_edac.c         |   33 ++-
 drivers/edac/x38_edac.c          |   54 ++--
 include/linux/edac.h             |  518 ++++++++++++++++++++--------
 include/trace/events/hw_event.h  |  370 ++++++++++++++++++++
 include/trace/events/mce.h       |   69 ----
 37 files changed, 2868 insertions(+), 1581 deletions(-)
 create mode 100644 include/trace/events/hw_event.h
 delete mode 100644 include/trace/events/mce.h

-- 
1.7.8

