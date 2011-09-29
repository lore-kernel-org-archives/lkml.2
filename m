Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab1I2PDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:03:39 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:55605 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab1I2PDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:03:37 -0400
Subject: [RFC PATCH v2 00/10] fadump: Firmware-assisted dump support for
	Powerpc.
To: linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
From: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Haren Myneni <hbabu@us.ibm.com>, Anton Blanchard <anton@samba.org>,
        Milton Miller <miltonm@bga.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Thu, 29 Sep 2011 20:32:46 +0530
Message-ID: <20110929150117.26689.62053.stgit@mars.in.ibm.com>
User-Agent: StGit/0.15-1-ged5e-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Please find the version 2 of the patchset that implements firmware-assisted
dump mechanism to capture kernel crash dump for Powerpc architecture. The
firmware-assisted dump is a robust mechanism to get reliable kernel crash
dump with assistance from firmware. This approach does not use kexec, instead
firmware assists in booting the kdump kernel while preserving memory contents.

Changes in v2:
-------------
patch 01/10:
- Modified the documentation to reflect the change of fadump_region
  file under debugfs filesystem.

patch 02/10:
- Modified to use standard pr_debug() macro.
- Modified early_init_dt_scan_fw_dump() to get the size of
  "ibm,configure-kernel-dump-sizes" property and use it to iterate through
  an array of dump sections.
- Introduced boot option 'fadump_reserve_mem=' to let user specify the
  fadump boot memory to be reserved.

patch 03/10:
- Removed few debug print statements.
- Moved the setup_fadump() call from setup_system() and now calling it
  subsys_initcall.
- Moved fadump_region attribute under debugfs.
- Clear the TCE entries if firmware assisted dump is active.

patch 05/10:
- Moved the crash_fadump() invocation from generic code to panic notifier.
- Introduced cpu_notes_buf_alloc() function to allocate cpu notes buffer
  using get_free_pages().

patch 08/10:
- Introduced cpu_notes_buf_free() function to free memory allocated for
  cpu notes buffer.

The most of the code implementation has been adapted from phyp assisted dump
implementation written by Linas Vepstas and Manish Ahuja.

The first patch is a documentation that talks about firmware-assisted dump
mechanism, implementation details and TODO list.

One of the important item from TODO list where I am looking forward for more
ideas/suggestions is regarding fadump crash info structure in the scratch
area before the ELF core header (see patch 4/10 and 5/10). The idea of
introducing this structure is to pass some important crash info data to the
second kernel which will help second kernel to populate ELF core header with
correct data before it gets exported through /proc/vmcore. The current design
implementation does not address the possibility of introducing additional
fields (in future) to this structure without affecting compatibility.
Following are the possible approaches I have in mind:
    1. Introduce version field for version tracking, bump up the version
       whenever a new field is added to the structure in future. The version
       field can be used to find out what fields are valid for the current
       version of the structure.
    2. Reserve the area of predefined size (say PAGE_SIZE) for this
       structure and have unused area as reserved (initialized to zero)
       for future field additions.
The advantage of the approach 1 over 2 is, we don't need to reserve extra
space.
Please let me know if there is better solution available.

I have tested the patches on following system configuration:
1. LPAR on Power6 with 4GB RAM and 8 CPUs
2. LPAR on Power7 with 2GB RAM and 20 CPUs
3. LPAR on Power7 with 1TB RAM and 896 CPUs

These patches cleanly apply on commit 9e79e3e9 in linux-2.6 git tree.

Please review the patchset and let me know your comments.

Thanks,
-Mahesh.
---

Mahesh Salgaonkar (10):
      fadump: Add documentation for firmware-assisted dump.
      fadump: Reserve the memory for firmware assisted dump.
      fadump: Register for firmware assisted dump.
      fadump: Initialize elfcore header and add PT_LOAD program headers.
      fadump: Convert firmware-assisted cpu state dump data into elf notes.
      fadump: Add PT_NOTE program header for vmcoreinfo
      fadump: Introduce cleanup routine to invalidate /proc/vmcore.
      fadump: Invalidate registration and release reserved memory for general use.
      fadump: Invalidate the fadump registration during machine shutdown.
      fadump: Introduce config option for firmware assisted dump feature


 Documentation/powerpc/firmware-assisted-dump.txt |  237 ++++
 arch/powerpc/Kconfig                             |   13 
 arch/powerpc/include/asm/fadump.h                |  205 ++++
 arch/powerpc/kernel/Makefile                     |    1 
 arch/powerpc/kernel/fadump.c                     | 1200 ++++++++++++++++++++++
 arch/powerpc/kernel/iommu.c                      |    8 
 arch/powerpc/kernel/prom.c                       |   15 
 arch/powerpc/kernel/setup-common.c               |   16 
 arch/powerpc/kernel/traps.c                      |    5 
 arch/powerpc/mm/hash_utils_64.c                  |   11 
 fs/proc/vmcore.c                                 |   23 
 include/linux/crash_dump.h                       |    1 
 include/linux/memblock.h                         |    1 
 kernel/crash_dump.c                              |   33 +
 14 files changed, 1767 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/powerpc/firmware-assisted-dump.txt
 create mode 100644 arch/powerpc/include/asm/fadump.h
 create mode 100644 arch/powerpc/kernel/fadump.c

-- 
Signature
