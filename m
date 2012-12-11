Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab2LKCem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 21:34:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:34496 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752163Ab2LKCe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 21:34:28 -0500
X-IronPort-AV: E=Sophos;i="4.84,256,1355068800"; 
   d="scan'208";a="6371863"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: jiang.liu@huawei.com, wujianguo@huawei.com, hpa@zytor.com,
        akpm@linux-foundation.org, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, yinghai@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, rusty@rustcorp.com.au, lliubbo@gmail.com,
        jaegeuk.hanse@gmail.com, tony.luck@intel.com, glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v3 0/5] Add movablecore_map boot option
Date: Tue, 11 Dec 2012 10:33:22 +0800
Message-Id: <1355193207-21797-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/11 10:33:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/11 10:33:37,
	Serialize complete at 2012/12/11 10:33:37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[What we are doing]
This patchset provide a boot option for user to specify ZONE_MOVABLE memory
map for each node in the system.

movablecore_map=nn[KMG]@ss[KMG]

This option make sure memory range from ss to ss+nn is movable memory.


[Why we do this]
If we hot remove a memroy, the memory cannot have kernel memory,
because Linux cannot migrate kernel memory currently. Therefore,
we have to guarantee that the hot removed memory has only movable
memoroy.

Linux has two boot options, kernelcore= and movablecore=, for
creating movable memory. These boot options can specify the amount
of memory use as kernel or movable memory. Using them, we can
create ZONE_MOVABLE which has only movable memory.

But it does not fulfill a requirement of memory hot remove, because
even if we specify the boot options, movable memory is distributed
in each node evenly. So when we want to hot remove memory which
memory range is 0x80000000-0c0000000, we have no way to specify
the memory as movable memory.

So we proposed a new feature which specifies memory range to use as
movable memory.


[Ways to do this]
There may be 2 ways to specify movable memory.
 1. use firmware information
 2. use boot option

1. use firmware information
  According to ACPI spec 5.0, SRAT table has memory affinity structure
  and the structure has Hot Pluggable Filed. See "5.2.16.2 Memory
  Affinity Structure". If we use the information, we might be able to
  specify movable memory by firmware. For example, if Hot Pluggable
  Filed is enabled, Linux sets the memory as movable memory.

2. use boot option
  This is our proposal. New boot option can specify memory range to use
  as movable memory.


[How we do this]
We chose second way, because if we use first way, users cannot change
memory range to use as movable memory easily. We think if we create
movable memory, performance regression may occur by NUMA. In this case,
user can turn off the feature easily if we prepare the boot option.
And if we prepare the boot optino, the user can select which memory
to use as movable memory easily. 


[How to use]
Specify the following boot option:
movablecore_map=nn[KMG]@ss[KMG]

That means physical address range from ss to ss+nn will be allocated as
ZONE_MOVABLE.

And the following points should be considered.

1) If the range is involved in a single node, then from ss to the end of
   the node will be ZONE_MOVABLE.
2) If the range covers two or more nodes, then from ss to the end of
   the node will be ZONE_MOVABLE, and all the other nodes will only
   have ZONE_MOVABLE.
3) If no range is in the node, then the node will have no ZONE_MOVABLE
   unless kernelcore or movablecore is specified.
4) This option could be specified at most MAX_NUMNODES times.
5) If kernelcore or movablecore is also specified, movablecore_map will have
   higher priority to be satisfied.
6) This option has no conflict with memmap option.


Change log:

v2 -> v3:
1) Use memblock_alloc_try_nid() instead of memblock_alloc_nid() to allocate
   memory twice if a whole node is ZONE_MOVABLE.
2) Add DMA, DMA32 addresses check, make sure ZONE_MOVABLE won't use these addresses.
   Suggested by Wu Jianguo <wujianguo@huawei.com>
3) Add lowmem addresses check, when the system has highmem, make sure ZONE_MOVABLE
   won't use lowmem. Suggested by Liu Jiang <jiang.liu@huawei.com>
4) Fix misuse of pfns in movablecore_map.map[] as physical addresses.

Tang Chen (4):
  page_alloc: add movable_memmap kernel parameter
  page_alloc: Introduce zone_movable_limit[] to keep movable limit for
    nodes
  page_alloc: Make movablecore_map has higher priority
  page_alloc: Bootmem limit with movablecore_map

Yasuaki Ishimatsu (1):
  x86: get pg_data_t's memory from other node

 Documentation/kernel-parameters.txt |   17 +++
 arch/x86/mm/numa.c                  |    5 +-
 include/linux/memblock.h            |    1 +
 include/linux/mm.h                  |   11 ++
 mm/memblock.c                       |   18 +++-
 mm/page_alloc.c                     |  238 ++++++++++++++++++++++++++++++++++-
 6 files changed, 282 insertions(+), 8 deletions(-)

