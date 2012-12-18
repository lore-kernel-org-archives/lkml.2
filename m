Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab2LRHVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 02:21:34 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:38989 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab2LRHQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 02:16:27 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v7 00/27] x86, boot, 64bit: Add support for loading ramdisk and bzImage above 4G
Date: Mon, 17 Dec 2012 23:15:32 -0800
Message-Id: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have limit kdump reseved under 896M, because kexec has the limitation.
and also bzImage need to stay under 4g.

To make kexec/kdump could use range above 4g, we need to make bzImage and
ramdisk could be loaded above 4g.
During booting bzImage will be unpacked on same postion and stay high.

The patches add fields in setup_header and boot_params to
1. get info about ramdisk position info above 4g from bootloader/kexec
2. get info about cmd_line_ptr info above 4g from bootloader/kexec
3. set xloadflags bit0 in header for bzImage and bootloader/kexec load
   could check that to decide if it could to put bzImage high.
4. use sentinel to make sure ext_* fields in boot_params could be used.

This patches is tested with kexec tools with local changes and they are sent
to kexec list later.

could be found at:

        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-boot

and it is on top of linus's tree 2012-12-17
plus tip:x86/mm, tip:x86/urgent, tip:x86/mm2

-v2: add ext_cmd_line_ptr support, and handle boot_param/cmd_line is above
     4G case.
-v3: according to hpa, use xloadflags instead code32_start_offset.
     0x200 will not be changed...
-v4: move ext_ramdisk_image/ext_ramdisk_size/ext_cmd_line_ptr to boot_params.
     add handling cross GB boundary case.
-v5: put spare pages in BRK,so could avoid wasting about 4 pages.
     add check for bit USE_EXT_BOOT_PARAMS in xloadflags
-v6: use sentinel according to HPA
     add kdump load high support.
-v7: move sentinel from 0x1f0 to 0x1ef... according to HPA.
     Use HPA's #PF handler version instead of ioremap.

H. Peter Anvin (1):
  x86, 64bit: early #PF handler set page table

Yinghai Lu (26):
  x86, mm: Fix page table early allocation offset checking
  x86, mm: make pgd next calculation consistent with pud/pmd
  x86, realmode: set real_mode permissions early
  x86, realmode: use init_level4_pgt to set trapmoline_pgt directly
  x86, realmode: Separate real_mode reserve and setup
  x86, 64bit: Print init kernel lowmap correctly
  x86: Merge early_reserve_initrd for 32bit and 64bit
  x86: add get_ramdisk_image/size()
  x86, boot: add get_cmd_line_ptr()
  x86, boot: move checking of cmd_line_ptr out of common path
  x86, boot: pass cmd_line_ptr with unsigned long
  x86, boot: move verify_cpu.S and no_longmode after 0x200
  x86, boot: Move lldt/ltr out of 64bit code section
  x86, kexec: remove 1024G limitation for kexec buffer on 64bit
  x86, kexec: set ident mapping for kernel that is above max_pfn
  x86, kexec: Merge ident_mapping_init and init_level4_page
  x86, kexec: only set ident mapping for ram.
  x86, boot: add fields to support load bzImage and ramdisk above 4G
  x86, boot: update comments about entries for 64bit image
  x86, boot: Not need to check setup_header version
  mm: Add alloc_bootmem_low_pages_nopanic()
  x86: Don't panic if can not alloc buffer for swiotlb
  x86: Add swiotlb force off support
  x86, kdump: remove crashkernel range find limit for 64bit
  x86: add Crash kernel low reservation
  x86: Merge early kernel reserve for 32bit and 64bit

 Documentation/kernel-parameters.txt     |   10 ++
 Documentation/x86/boot.txt              |   53 ++++++-
 Documentation/x86/zero-page.txt         |    4 +
 arch/x86/boot/boot.h                    |   18 ++-
 arch/x86/boot/cmdline.c                 |   12 +-
 arch/x86/boot/compressed/cmdline.c      |   12 +-
 arch/x86/boot/compressed/head_64.S      |   48 ++++---
 arch/x86/boot/compressed/misc.c         |   12 ++
 arch/x86/boot/header.S                  |   12 +-
 arch/x86/boot/setup.ld                  |    7 +
 arch/x86/include/asm/kexec.h            |    6 +-
 arch/x86/include/asm/page.h             |    4 +
 arch/x86/include/asm/pgtable_64_types.h |    4 +
 arch/x86/include/asm/processor.h        |    1 +
 arch/x86/include/asm/realmode.h         |    3 +-
 arch/x86/include/uapi/asm/bootparam.h   |   13 +-
 arch/x86/kernel/head32.c                |   20 ---
 arch/x86/kernel/head64.c                |  115 +++++++++++-----
 arch/x86/kernel/head_64.S               |  202 +++++++++++++++------------
 arch/x86/kernel/machine_kexec_64.c      |  228 ++++++++++++++-----------------
 arch/x86/kernel/pci-swiotlb.c           |   15 +-
 arch/x86/kernel/setup.c                 |  140 ++++++++++++++-----
 arch/x86/kernel/traps.c                 |    9 ++
 arch/x86/mm/init.c                      |   11 +-
 arch/x86/mm/init_64.c                   |   12 +-
 arch/x86/realmode/init.c                |   37 +++--
 drivers/iommu/amd_iommu.c               |    1 +
 include/linux/bootmem.h                 |    5 +
 include/linux/kexec.h                   |    3 +
 include/linux/swiotlb.h                 |    3 +-
 kernel/kexec.c                          |   34 ++++-
 lib/swiotlb.c                           |   20 ++-
 mm/bootmem.c                            |    8 ++
 mm/nobootmem.c                          |    8 ++
 34 files changed, 713 insertions(+), 377 deletions(-)

-- 
1.7.10.4

