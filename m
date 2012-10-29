Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab2J2PGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:06:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:13284 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752265Ab2J2PGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:06:05 -0400
X-IronPort-AV: E=Sophos;i="4.80,673,1344182400"; 
   d="scan'208";a="6093217"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [V5 PATCH 00/26] mm, memory-hotplug: dynamic configure movable memory and introduce movable node
Date: Mon, 29 Oct 2012 23:07:55 +0800
Message-Id: <1351523301-20048-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/29 23:05:20,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/29 23:05:21,
	Serialize complete at 2012/10/29 23:05:21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Movable memory is a very important concept of memory-management,
we need to consolidate it and make use of it on systems.

Movable memory is needed for
o	anti-fragmentation(hugepage, big-order allocation...)
o	logic hot-remove(virtualization, Memory capacity on Demand)
o	physic hot-remove(power-saving, hardware partitioning, hardware fault management)

All these require dynamic configuring the memory and making better utilities of memories
and safer. We also need physic hot-remove, so we need movable node too.
(Although some systems support physic-memory-migration, we don't require all
memory on physic-node is movable, but movable node is still needed here
for logic-node if we want to make physic-migration is transparent)

We add dynamic configuration commands "online_movalbe" and "online_kernel".
We also add non-dynamic boot option kernelcore_max_addr.
We may add some more dynamic/non-dynamic configuration in future.


The patchset is based on 3.7-rc3 with these three patches already applied:
	https://lkml.org/lkml/2012/10/24/151
	https://lkml.org/lkml/2012/10/26/150

You can also simply pull all the patches from:
	git pull https://github.com/laijs/linux.git hotplug-next



Issues):

mempolicy(M_BIND) don't act well when the nodemask has movable nodes only,
the kernel allocation will fail and the task can't create new task or other
kernel objects.

So we change the strategy/policy
	when the bound nodemask has movable node(s) only, we only
	apply mempolicy for userspace allocation, don't apply it
	for kernel allocation.

CPUSET also has the same problem, but the code spread in page_alloc.c,
and we doesn't fix it yet, we can/will change allocation strategy to one of
these 3 strategies:
	1) the same strategy as mempolicy
	2) change cpuset, make nodemask always has at least a normal node
	3) split nodemask: nodemask_user and nodemask_kernel

Thoughts?



Patches):

patch1-3:     add online_movable and online_kernel, bot don't result movable node
Patch4        cleanup for node_state_attr
Patch5        introduce N_MEMORY
Patch6-17     use N_MEMORY instead N_HIGH_MEMORY.
              The patches are separated by subsystem,
              Patch18 also changes the node_states initialization
Patch18-20    Add  MOVABLE-dedicated node 
Patch21-25    Add kernelcore_max_addr
patch26:      mempolicy handle movable node




Changes):

change V5-V4:
	consolidate online_movable/online_kernel
	nodemask management

change V4-v3
	rebase.
	online_movable/online_kernel can create a zone from empty
	or empyt a zone

change V3-v2:
	Proper nodemask management

change V2-V1:

The original V1 patchset of MOVABLE-dedicated node is here:
http://comments.gmane.org/gmane.linux.kernel.mm/78122

The new V2 adds N_MEMORY and a notion of "MOVABLE-dedicated node".
And fix some related problems.

The orignal V1 patchset of "add online_movable" is here:
https://lkml.org/lkml/2012/7/4/145

The new V2 discards the MIGRATE_HOTREMOVE approach, and use a more straight
implementation(only 1 patch).



Lai Jiangshan (22):
  mm, memory-hotplug: dynamic configure movable memory and portion
    memory
  memory_hotplug: handle empty zone when online_movable/online_kernel
  memory_hotplug: ensure every online node has NORMAL memory
  node: cleanup node_state_attr
  node_states: introduce N_MEMORY
  cpuset: use N_MEMORY instead N_HIGH_MEMORY
  procfs: use N_MEMORY instead N_HIGH_MEMORY
  memcontrol: use N_MEMORY instead N_HIGH_MEMORY
  oom: use N_MEMORY instead N_HIGH_MEMORY
  mm,migrate: use N_MEMORY instead N_HIGH_MEMORY
  mempolicy: use N_MEMORY instead N_HIGH_MEMORY
  hugetlb: use N_MEMORY instead N_HIGH_MEMORY
  vmstat: use N_MEMORY instead N_HIGH_MEMORY
  kthread: use N_MEMORY instead N_HIGH_MEMORY
  init: use N_MEMORY instead N_HIGH_MEMORY
  vmscan: use N_MEMORY instead N_HIGH_MEMORY
  page_alloc: use N_MEMORY instead N_HIGH_MEMORY change the node_states
    initialization
  hotplug: update nodemasks management
  numa: add CONFIG_MOVABLE_NODE for movable-dedicated node
  memory_hotplug: allow online/offline memory to result movable node
  page_alloc: add kernelcore_max_addr
  mempolicy: fix is_valid_nodemask()

Yasuaki Ishimatsu (4):
  x86: get pg_data_t's memory from other node
  x86: use memblock_set_current_limit() to set memblock.current_limit
  memblock: limit memory address from memblock
  memblock: compare current_limit with end variable at
    memblock_find_in_range_node()

 Documentation/cgroups/cpusets.txt   |    2 +-
 Documentation/kernel-parameters.txt |    9 +
 Documentation/memory-hotplug.txt    |   19 ++-
 arch/x86/kernel/setup.c             |    4 +-
 arch/x86/mm/init_64.c               |    4 +-
 arch/x86/mm/numa.c                  |    8 +-
 drivers/base/memory.c               |   27 ++--
 drivers/base/node.c                 |   28 ++--
 fs/proc/kcore.c                     |    2 +-
 fs/proc/task_mmu.c                  |    4 +-
 include/linux/cpuset.h              |    2 +-
 include/linux/memblock.h            |    1 +
 include/linux/memory.h              |    1 +
 include/linux/memory_hotplug.h      |   13 ++-
 include/linux/nodemask.h            |    5 +
 init/main.c                         |    2 +-
 kernel/cpuset.c                     |   32 ++--
 kernel/kthread.c                    |    2 +-
 mm/Kconfig                          |    8 +
 mm/hugetlb.c                        |   24 ++--
 mm/memblock.c                       |   10 +-
 mm/memcontrol.c                     |   18 +-
 mm/memory_hotplug.c                 |  283 +++++++++++++++++++++++++++++++++--
 mm/mempolicy.c                      |   48 ++++---
 mm/migrate.c                        |    2 +-
 mm/oom_kill.c                       |    2 +-
 mm/page_alloc.c                     |   76 +++++++---
 mm/page_cgroup.c                    |    2 +-
 mm/vmscan.c                         |    4 +-
 mm/vmstat.c                         |    4 +-
 30 files changed, 508 insertions(+), 138 deletions(-)

-- 
1.7.4.4

cover-letter:

