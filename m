Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab2HBGAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 02:00:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:4504 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751982Ab2HBGAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 02:00:46 -0400
X-IronPort-AV: E=Sophos;i="4.77,698,1336320000"; 
   d="scan'208";a="5534616"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [RFC PATCH 00/23 V2] memory,numa: introduce MOVABLE-dedicated node and online_movable for hotplug
Date: Thu, 2 Aug 2012 14:01:05 +0800
Message-Id: <1343887288-8866-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/02 14:01:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/02 14:01:15,
	Serialize complete at 2012/08/02 14:01:15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	A) Introduction:

This patchset adds MOVABLE-dedicated node and online_movable for memory-management.

It is used for anti-fragmentation(hugepage, big-order allocation...),
hot-removal-of-memory(virtualization, power-conserve, move memory between systems
to make better utilities of memories).

	B) changed from V1:

The original V1 patchset of MOVABLE-dedicated node is here:
http://comments.gmane.org/gmane.linux.kernel.mm/78122

The new V2 adds N_MEMORY and a notion of "MOVABLE-dedicated node".
And fix some related problems.

The orignal V1 patchset of "add online_movable" is here:
https://lkml.org/lkml/2012/7/4/145

The new V2 discards the MIGRATE_HOTREMOVE approach, and use a more straight
implementation(only 1 patch).

	C) User Interface:

When users(big system manager) need config some node/memory as MOVABLE:
	1 Use kernelcore_max_addr=XX when boot
	2 Use movable_online hotplug action when running
We may introduce some more convenient interface, such as
	movable_node=NODE_LIST boot option.

	D) Patches

Patch1        introduce N_MEMORY
Patch2-13     use N_MEMORY instead N_HIGH_MEMORY.
              The patches are separated by subsystem,
              *these conversions was(must be) checked carefully*.
              Patch13 also changes the node_states initialization
Patch14,15,17 Fix problems of the current code.(all related with hotplug)
Patch18       Add config to allow MOVABLE-dedicated node
Patch19-22    Add kernelcore_max_addr
Patch23       Add online_movable


Lai Jiangshan (19):
  node_states: introduce N_MEMORY
  cpuset: use N_MEMORY instead N_HIGH_MEMORY
  procfs: use N_MEMORY instead N_HIGH_MEMORY
  oom: use N_MEMORY instead N_HIGH_MEMORY
  mm,migrate: use N_MEMORY instead N_HIGH_MEMORY
  mempolicy: use N_MEMORY instead N_HIGH_MEMORY
  memcontrol: use N_MEMORY instead N_HIGH_MEMORY
  hugetlb: use N_MEMORY instead N_HIGH_MEMORY
  vmstat: use N_MEMORY instead N_HIGH_MEMORY
  kthread: use N_MEMORY instead N_HIGH_MEMORY
  init: use N_MEMORY instead N_HIGH_MEMORY
  vmscan: use N_MEMORY instead N_HIGH_MEMORY
  page_alloc: use N_MEMORY instead N_HIGH_MEMORY and change the node_states initialization
  slub, hotplug: ignore unrelated node's hot-adding and hot-removing
  memory_hotplug: fix missing nodemask management
  numa: add CONFIG_MOVABLE_NODE for movable-dedicated node
  page_alloc.c: don't subtract unrelated memmap from zone's present pages
  page_alloc: add kernelcore_max_addr
  mm, memory-hotplug: add online_movable

Yasuaki Ishimatsu (4):
  x86: get pg_data_t's memory from other node
  x86: use memblock_set_current_limit() to set memblock.current_limit
  memblock: limit memory address from memblock
  memblock: compare current_limit with end variable at
    memblock_find_in_range_node()

 Documentation/cgroups/cpusets.txt   |    2 +-
 Documentation/kernel-parameters.txt |    9 +++
 Documentation/memory-hotplug.txt    |   16 ++++-
 arch/x86/kernel/setup.c             |    4 +-
 arch/x86/mm/init_64.c               |    4 +-
 arch/x86/mm/numa.c                  |    8 ++-
 drivers/base/memory.c               |   19 +++--
 drivers/base/node.c                 |    8 ++-
 fs/proc/kcore.c                     |    2 +-
 fs/proc/task_mmu.c                  |    4 +-
 include/linux/cpuset.h              |    2 +-
 include/linux/memblock.h            |    1 +
 include/linux/memory_hotplug.h      |   13 +++-
 include/linux/nodemask.h            |    5 ++
 init/main.c                         |    2 +-
 kernel/cpuset.c                     |   32 ++++----
 kernel/kthread.c                    |    2 +-
 mm/Kconfig                          |    8 ++
 mm/hugetlb.c                        |   24 +++---
 mm/memblock.c                       |   10 ++-
 mm/memcontrol.c                     |   18 +++---
 mm/memory_hotplug.c                 |  137 ++++++++++++++++++++++++++++++++---
 mm/mempolicy.c                      |   12 ++--
 mm/migrate.c                        |    2 +-
 mm/oom_kill.c                       |    2 +-
 mm/page_alloc.c                     |   96 +++++++++++++++----------
 mm/page_cgroup.c                    |    2 +-
 mm/slub.c                           |    6 ++
 mm/vmscan.c                         |    4 +-
 mm/vmstat.c                         |    4 +-
 30 files changed, 335 insertions(+), 123 deletions(-)

