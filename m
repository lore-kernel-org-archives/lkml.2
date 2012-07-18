Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab2GRKCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 06:02:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34331 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab2GRKCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 06:02:08 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50068974.1070409@jp.fujitsu.com>
Date: Wed, 18 Jul 2012 19:01:24 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-acpi@vger.kernel.org>
CC: <rientjes@google.com>, <liuj97@gmail.com>, <len.brown@intel.com>,
        <benh@kernel.crashing.org>, <paulus@samba.org>, <cl@linux.com>,
        <minchan.kim@gmail.com>, <akpm@linux-foundation.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <wency@cn.fujitsu.com>
Subject: [RFC PATCH v4 0/13] memory-hotplug : hot-remove physical memory
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series aims to support physical memory hot-remove.

  [RFC PATCH v4 1/13] memory-hotplug : rename remove_memory to offline_memory
  [RFC PATCH v4 2/13] memory-hotplug : add physical memory hotplug code to acpi_memory_device_remove
  [RFC PATCH v4 3/13] memory-hotplug : check whether memory is present or not
  [RFC PATCH v4 4/13] memory-hotplug : remove /sys/firmware/memmap/X sysfs
  [RFC PATCH v4 5/13] memory-hotplug : does not release memory region in PAGES_PER_SECTION chunks
  [RFC PATCH v4 6/13] memory-hotplug : add memory_block_release
  [RFC PATCH v4 7/13] memory-hotplug : remove_memory calls __remove_pages
  [RFC PATCH v4 8/13] memory-hotplug : check page type in get_page_bootmem
  [RFC PATCH v4 9/13] memory-hotplug : move register_page_bootmem_info_node and put_page_bootmem for
sparse-vmemmap4
  [RFC PATCH v4 10/13] memory-hotplug : implement register_page_bootmem_info_section of sparse-vmemmap
  [RFC PATCH v4 11/13] memory-hotplug : free memmap of sparse-vmemmap
  [RFC PATCH v4 12/13] memory-hotplug : add node_device_release
  [RFC PATCH v4 13/13] memory-hotplug : remove sysfs file of node

Even if you apply these patches, you cannot remove the physical memory
completely since these patches are still under development. But other
components can be removed. I want you to cooperate to improve the
physical memory hot-remove. So please review these patches and give
your comment/idea.

The patches can free/remove following things:

  - acpi_memory_info                          : [RFC PATCH 2/13]
  - /sys/firmware/memmap/X/{end, start, type} : [RFC PATCH 4/13]
  - iomem_resource                            : [RFC PATCH 5/13]
  - mem_section and related sysfs files       : [RFC PATCH 6-11/13]
  - node and related sysfs files              : [RFC PATCH 12-13/13]

The patches cannot do following things yet:

  - page table of removed memory

If you find lack of function for physical memory hot-remove, please let me
know.

change log of v4:
 * remove "memory-hotplug : unify argument of firmware_map_add_early/hotplug"
   from the patch series, since the patch is a bugfix. It is being disccussed
   on other thread. But for testing the patch series, the patch is needed.
   So I added the patch as [PATCH 0/13].

 [RFC PATCH v4 2/13]
   * check memory is online or not at remove_memory()
   * add memory_add_physaddr_to_nid() to acpi_memory_device_remove() for
     getting node id
 
 [RFC PATCH v4 3/13]
   * create new patch : check memory is online or not at online_pages()

 [RFC PATCH v4 4/13]
   * add __ref section to remove_memory()
   * call firmware_map_remove_entry() before remove_sysfs_fw_map_entry()

 [RFC PATCH v4 11/13]
   * rewrite register_page_bootmem_memmap() for removing page used as PT/PMD

change log of v3:
 * rebase to 3.5.0-rc6

 [RFC PATCH v2 2/13]
   * remove extra kobject_put()

   * The patch was commented by Wen. Wen's comment is
     "acpi_memory_device_remove() should ignore a return value of
     remove_memory() since caller does not care the return value".
     But I did not change it since I think caller should care the
     return value. And I am trying to fix it as follow:

     https://lkml.org/lkml/2012/7/5/624

 [RFC PATCH v2 4/13]
   * remove a firmware_memmap_entry allocated by kzmalloc()

change log of v2:
 [RFC PATCH v2 2/13]
   * check whether memory block is offline or not before calling offline_memory()
   * check whether section is valid or not in is_memblk_offline()
   * call kobject_put() for each memory_block in is_memblk_offline()

 [RFC PATCH v2 3/13]
   * unify the end argument of firmware_map_add_early/hotplug

 [RFC PATCH v2 4/13]
   * add release_firmware_map_entry() for freeing firmware_map_entry

 [RFC PATCH v2 6/13]
  * add release_memory_block() for freeing memory_block

 [RFC PATCH v2 11/13]
  * fix wrong arguments of free_pages()

---
 arch/powerpc/platforms/pseries/hotplug-memory.c |   16 +-
 arch/x86/mm/init_64.c                           |  144 ++++++++++++++++++++++++
 drivers/acpi/acpi_memhotplug.c                  |   28 ++++
 drivers/base/memory.c                           |   54 ++++++++-
 drivers/base/node.c                             |    7 +
 drivers/firmware/memmap.c                       |   78 ++++++++++++-
 include/linux/firmware-map.h                    |    6 +
 include/linux/memory.h                          |    5 
 include/linux/memory_hotplug.h                  |   17 --
 include/linux/mm.h                              |    5 
 mm/memory_hotplug.c                             |   98 ++++++++++++----
 mm/sparse.c                                     |    5 
 12 files changed, 414 insertions(+), 49 deletions(-)

