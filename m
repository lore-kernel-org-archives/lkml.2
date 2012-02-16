Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab2BPLPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 06:15:17 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:49476 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab2BPLPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 06:15:15 -0500
Subject: [RFC PATCH v7 00/10] fadump: Firmware-assisted dump support for
 Powerpc.
To: linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
From: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Amerigo Wang <amwang@redhat.com>, Kexec-ml <kexec@lists.infradead.org>,
        Milton Miller <miltonm@bga.com>, Haren Myneni <hbabu@us.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Paul Mackerras <paulus@samba.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ananth Narayan <ananth@in.ibm.com>, Vivek Goyal <vgoyal@redhat.com>,
        Anton Blanchard <anton@samba.org>
Date: Thu, 16 Feb 2012 16:44:06 +0530
Message-ID: <20120216111050.4733.38034.stgit@mars>
User-Agent: StGit/0.15-4-g042f-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12021611-5816-0000-0000-00000152A24A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Please find the version 7 of the patchset that implements firmware-assisted
dump mechanism to capture kernel crash dump for Powerpc architecture.
Firmware-assisted dump is a robust mechanism to get reliable kernel crash
dump with the assistance of firmware. This approach does not use kexec,
instead firmware assists in booting the kdump kernel while preserving memory
contents.

- Firmware assisted dump (fadump) infrastructure is intended to replace
  the existing phyp assisted dump.
- Fadump uses the same firmware interfaces and memory reservation model
  as phyp assisted dump.
- Unlike phyp dump, fadump exports the memory dump through /proc/vmcore
  in the ELF format in the same way as kdump. This helps us reuse the
  kdump infrastructure for dump capture and filtering.
- Unlike phyp dump, userspace tool does not need to refer any sysfs
  interface while reading /proc/vmcore.
- Unlike phyp dump, fadump allows user to release all the memory reserved
  for dump, with a single operation of echo 1 > /sys/kernel/fadump_release_mem.
- Once enabled through kernel boot parameter, fadump can be
  started/stopped through /sys/kernel/fadump_registered interface and
  can be easily integrated with kdump service start/stop init scripts.
- Once the dump is copied out, the memory that held the dump is
  immediately available to the running kernel. And therefore, unlike
  kdump, fadump doesn't need a 2nd reboot to get back the system to
  the production configuration.

Fadump reuses much of the code written by Manish Ahuja and Linas Vepstas
for the phyp assisted dump.

I have tested the patches on following system configuration:
1. LPAR on Power6 with 4GB RAM and 8 CPUs
2. LPAR on Power7 with 2GB RAM and 20 CPUs
3. LPAR on Power7 with 1TB RAM and 896 CPUs

Please review the patchset and let me know your comments.


ChangeLog:

Change in v7:
-------------
- Updated the documentation explaining the enhancement in fadump over old
  phyp dump.
- Re-based patches to commit d65b4e98d7 (v3.3-rc3)

Change in v6:
-------------
- Use of_read_number and of_read_ulong while reading the dump sizes
  from rtas node ibm,configure-kernel-kdump-sizes and few minor changes.
- Kernel command line option 'fadump' now uses on/off values to
  enable/disable fadump.
- Added the last patch in this series 10/10 to remove phyp dump code.

Change in v5:
-------------
- Added 'fadump_' prefix to all static functions defined.

patch 02/10:
- Merged patch 10/10 which introduces a config option CONFIG_FA_DUMP
  for firmware assisted dump feature on Powerpc (ppc64) architecture.
- Increased MIN_BOOT_MEM by 64M to avoid OOM issue during network
  dump capture. When kdump infrastructure is configured to save vmcore
  over network, we run into OOM issue while loading modules related to
  network setup.

Changes in v4:
--------------
patch 04/10:
- Move the init_elfcore_header() function and 'memblock_num_regions' macro
 from generic code to power specific code as these are used only by
 firmware assisted dump implementation which is power specific feature.

patch 05/10:
- Fixes a issue where memblock_free() is invoked from build_cpu_notes()
  function during error_out path. Invoke cpu_notes_buf_free() in error_out
  path instead of memblock_free().

Changes in v3:
-------------
- Re-factored the implementation to work with kdump service start/stop.
  Introduce fadump_registered sysfs control file which will be used by
  kdump init scripts to start/stop firmware assisted dump. echo 1 to
  /sys/kernel/fadump_registered file for fadump registration and
  echo 0 to /sys/kernel/fadump_registered file for fadump un-registration.
- Introduced the locking mechanism to handle simultaneous writes to
  sysfs control files fadump_registered and fadump_release_mem

  Affected patches are: 01/10, 03/10, 08/10.

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
      fadump: Remove the phyp assisted dump code.


 Documentation/powerpc/firmware-assisted-dump.txt |  270 +++++
 Documentation/powerpc/phyp-assisted-dump.txt     |  127 --
 arch/powerpc/Kconfig                             |   17 
 arch/powerpc/include/asm/fadump.h                |  218 ++++
 arch/powerpc/include/asm/phyp_dump.h             |   47 -
 arch/powerpc/kernel/Makefile                     |    1 
 arch/powerpc/kernel/fadump.c                     | 1312 ++++++++++++++++++++++
 arch/powerpc/kernel/iommu.c                      |    8 
 arch/powerpc/kernel/prom.c                       |   98 --
 arch/powerpc/kernel/setup-common.c               |   14 
 arch/powerpc/kernel/traps.c                      |    3 
 arch/powerpc/mm/hash_utils_64.c                  |   11 
 arch/powerpc/platforms/pseries/Makefile          |    1 
 arch/powerpc/platforms/pseries/phyp_dump.c       |  513 ---------
 fs/proc/vmcore.c                                 |   23 
 15 files changed, 1881 insertions(+), 782 deletions(-)
 create mode 100644 Documentation/powerpc/firmware-assisted-dump.txt
 delete mode 100644 Documentation/powerpc/phyp-assisted-dump.txt
 create mode 100644 arch/powerpc/include/asm/fadump.h
 delete mode 100644 arch/powerpc/include/asm/phyp_dump.h
 create mode 100644 arch/powerpc/kernel/fadump.c
 delete mode 100644 arch/powerpc/platforms/pseries/phyp_dump.c

-- 
-Mahesh

