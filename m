Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab2GCFtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 01:49:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39227 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab2GCFtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 01:49:20 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FF287C3.4030901@jp.fujitsu.com>
Date: Tue, 3 Jul 2012 14:48:51 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-acpi@vger.kernel.org>
CC: <rientjes@google.com>, <liuj97@gmail.com>, <len.brown@intel.com>,
        <benh@kernel.crashing.org>, <paulus@samba.org>, <cl@linux.com>,
        <minchan.kim@gmail.com>, <akpm@linux-foundation.org>,
        <kosaki.motohiro@jp.fujitsu.com>
Subject: [RFC PATCH v2 0/13] memory-hotplug : hot-remove physical memory
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series aims to support physical memory hot-remove.

  [RFC PATCH v2 1/13] memory-hotplug : rename remove_memory to offline_memory
  [RFC PATCH v2 2/13] memory-hotplug : add physical memory hotplug code to acpi_memory_device_remove
  [RFC PATCH v2 3/13] memory-hotplug : unify argument of firmware_map_add_early/hotplug
  [RFC PATCH v2 4/13] memory-hotplug : remove /sys/firmware/memmap/X sysfs
  [RFC PATCH v2 5/13] memory-hotplug : does not release memory region in PAGES_PER_SECTION chunks
  [RFC PATCH v2 6/13] memory-hotplug : add memory_block_release
  [RFC PATCH v2 7/13] memory-hotplug : remove_memory calls __remove_pages
  [RFC PATCH v2 8/13] memory-hotplug : check page type in get_page_bootmem
  [RFC PATCH v2 9/13] memory-hotplug : move register_page_bootmem_info_node and put_page_bootmem for
sparse-vmemmap
  [RFC PATCH v2 10/13] memory-hotplug : implement register_page_bootmem_info_section of sparse-vmemmap
  [RFC PATCH v2 11/13] memory-hotplug : free memmap of sparse-vmemmap
  [RFC PATCH v2 12/13] memory-hotplug : add node_device_release
  [RFC PATCH v2 13/13] memory-hotplug : remove sysfs file of node

Even if you apply these patches, you cannot remove the physical memory
completely since these patches are still under development. I want you to
cooperate to improve the physical memory hot-remove. So please review these
patches and give your comment/idea.

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
 drivers/base/memory.c                           |   53 ++++++++
 drivers/base/node.c                             |    7 +
 drivers/firmware/memmap.c                       |   70 +++++++++++
 include/linux/firmware-map.h                    |    6 +
 include/linux/memory.h                          |    5
 include/linux/memory_hotplug.h                  |   17 --
 include/linux/mm.h                              |    5
 mm/memory_hotplug.c                             |   98 ++++++++++++----
 mm/sparse.c                                     |    5
 12 files changed, 406 insertions(+), 48 deletions(-)


