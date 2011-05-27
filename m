Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab1E0MdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:33:24 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:60763 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab1E0McH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:32:07 -0400
From: Ankita Garg <ankita@in.ibm.com>
To: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: ankita@in.ibm.com, svaidy@linux.vnet.ibm.com, thomas.abraham@linaro.org
Subject: [PATCH 00/10] mm: Linux VM Infrastructure to support Memory Power Management
Date: Fri, 27 May 2011 18:01:28 +0530
Message-Id: <1306499498-14263-1-git-send-email-ankita@in.ibm.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Modern systems offer higher CPU performance and large amount of memory in
each generation in order to support application demands.  Memory subsystem has
began to offer wide range of capabilities for managing power consumption,
which is driving the need to relook at the way memory is managed by the
operating system. Linux VM subsystem has sophisticated algorithms to
optimally  manage the scarce resources for best overall system performance.
Apart from the capacity and location of memory areas, the VM subsystem tracks
special addressability restrictions in zones and relative distance from CPU as
NUMA nodes if necessary. Power management capabilities in the memory subsystem
and inclusion of different class of main memory like PCM, or non-volatile RAM,
brings in new boundaries and attributes that needs to be tagged within the
Linux VM subsystem for exploitation by the kernel and applications.

This patchset proposes a generic memory regions infrastructure that can be
used to tag boundaries of memory blocks which belongs to a specific memory
power management domain and further enable exploitation of platform memory
power management capabilities.

How can Linux VM help memory power savings?

o Consolidate memory allocations and/or references such that they are
not spread across the entire memory address space.  Basically area of memory
that is not being referenced, can reside in low power state.

o Support targeted memory reclaim, where certain areas of memory that can be
easily freed can be offlined, allowing those areas of memory to be put into
lower power states.

What is a Memory Region ?
-------------------------

Memory regions is a generic memory management framework that enables the
virtual memory manager to consider memory characteristics when making memory
allocation and deallocation decisions. It is a layer of abstraction under the
real NUMA nodes, that encapsulate knowledge of the underlying memory hardware.
This layer is created at boot time, with information from firmware regarding
the granularity at which memory power can be managed on the platform. For
example, on platforms with support for Partial Array Self-Refresh (PASR) [1],
regions could be aligned to memory unit that can be independently put into
self-refresh or turned off (content destructive power off). On the other hand,
platforms with support for multiple memory controllers that control the power
states of memory, one memory region could be created for all the memory under
a single memory controller.

The aim of the alignment is to ensure that memory allocations, deallocations
and reclaim are performed within a defined hardware boundary. By creating
zones under regions, the buddy allocator would operate at the level of
regions. The proposed data structure is as shown in the Figure below:


             -----------------------------
             |N0 |N1 |N2 |N3 |.. |.. |Nn |   
             -----------------------------   
             / \ \
            /   \  \
           /     \   \
 ------------    |  ------------
 | Mem Rgn0 |    |  | Mem Rgn3 |             
 ------------    |  ------------             
    |            |         |
    |      ------------    | ---------
    |      | Mem Rgn1 |    ->| zones |
    |      ------------      ---------
    |          |     ---------
    |          ----->| zones |
    | ---------      ---------
    ->| zones |
      ---------

Memory regions enable the following :

o Sequential allocation of memory in the order of memory regions, thus
  ensuring that greater number of memory regions are devoid of allocations to
  begin with
o With time however, the memory allocations will tend to be spread across
  different regions. But the notion of a region boundary and region level
  memory statistics will enable specific regions to be evacuated using
  targetted allocation and reclaim. 

Lumpy reclaim and other memory compaction work by Mel Gorman, would further
aid in consolidation of memory [4].

Memory regions is just a base infrastructure that would enable the Linux VM to
be aware of the physical memory hardware characterisitics, a pre-requisite to
implementing other sophisticated algorithms and techniques to actually
conserve power.

Advantages
-----------

Memory regions framework works with existing memory management data
structures and only adds one more layer of abstraction that is required to
capture special boundaries and properties.  Most VM code paths work similar
to current implementation with additional traversal of zone data structures
in pre-defined order.

Alternative Approach:

There are other ways in which memory belonging to the same power domain could
be grouped together. Fake NUMA nodes under a real NUMA node could encapsulate
information about the memory hardware units that can be independently power
managed. With minimal code changes, the same functionality as memory regions
can be achieved. However, the fake NUMA nodes is a non-intuitive solution, 
that breaks the NUMA semantics and is not generic in nature. It would present
an incorrect view of the system to the administrator, by showing that it has a
greater number of NUMA nodes than actually present.

Challenges
----------

o Memory interleaving is typically used on all platforms to increase the
  memory bandwidth and hence memory performance. However, in the presence of
  interleaving, the amount of idle memory within the hardware domain reduces,
  impacting power savings. For a given platform, it is important to select an
  interleaving scheme that gives good performance with optimum power savings.

This is a RFC patchset with minimal functionality to demonstrate the
requirement and proposed implementation options. It has been tested on TI
OMAP4 Panda board with 1Gb RAM and the Samsung Exynos 4210 board. The patch
applies on kernel version 2.6.39-rc5, compiled with the default config files
for the two platforms. I have turned off cgroup, memory hotplug and kexec to
begin. Support to these framework can be easily extended. The u-boot
bootloader does not yet export information regarding the physical memory bank
boundaries and hence the regions are not correctly aligned to hardware and
hence hard coded for test/demo purposes. Also, the code assumes that atleast
one region is present in the node. Compile time exclusion of memory regions is
a todo.

Results
-------
Ran pagetest, a simple C program that allocates and touches a required number
of pages, on a Samsung Exynos 4210 board with ~2GB RAM, booted with 4 memory
regions, each with ~512MB. The allocation size used was 512MB. Below is the
free page statistics while running the benchmark:

		---------------------------------------
	 	|	   | start  | ~480MB |  512MB |	
		---------------------------------------
		| Region 0 | 124013 | 1129   | 484    |
		| Region 1 | 131072 | 131072 | 130824 |
		| Region 2 | 131072 | 131072 | 131072 |
		| Region 3 | 57332  | 57332  | 57332  |
		---------------------------------------

(The total number of pages in Region 3 is 57332, as it contains all the
remaining pages and hence the region size is not 512MB).

Column 1 indicates the number of free pages in each region at the start of the
benchmark, column 2 at about 480MB allocation and column 3 at 512MB
allocation. The memory in regions 1,2 & 3 is free and only region0 is
utilized. So if the regions are aligned to the hardware memory units, free
regions could potentially be put either into low power state or turned off. It
may be possible to allocate from lower address without regions, but once the
page reclaim comes into play, the page allocations will tend to get spread
around.

References
----------

[1] Partial Array Self Refresh
http://focus.ti.com/general/docs/wtbu/wtbudocumentcenter.tsp?templateId=6123&navigationId=12037
[2] TI OMAP$ Panda board
http://pandaboard.org/node/224/#manual
[3] Memory Regions discussion at Ubuntu Development Summit, May 2011
https://wiki.linaro.org/Specs/KernelGeneralPerformanceO?action=AttachFile&do=view&target=k81-memregions.odp
[4] Memory compaction
http://lwn.net/Articles/368869/

Ankita Garg (10):
  mm: Introduce the memory regions data structure
  mm: Helper routines
  mm: Init zones inside memory regions
  mm: Refer to zones from memory regions
  mm: Create zonelists
  mm: Verify zonelists
  mm: Modify vmstat
  mm: Modify vmscan
  mm: Reflect memory region changes in zoneinfo
  mm: Create memory regions at boot-up

 include/linux/mm.h     |   25 +++-
 include/linux/mmzone.h |   58 +++++++--
 include/linux/vmstat.h |   22 ++-
 mm/mm_init.c           |   51 ++++---
 mm/mmzone.c            |   36 ++++-
 mm/page_alloc.c        |  368 +++++++++++++++++++++++++++++++-----------------
 mm/vmscan.c            |  284 ++++++++++++++++++++-----------------
 mm/vmstat.c            |   77 ++++++----
 8 files changed, 581 insertions(+), 340 deletions(-)

-- 
1.7.4

