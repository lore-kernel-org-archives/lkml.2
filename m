Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab3ADA4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:56:35 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26707 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab3ADAta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:49:30 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v7u1 00/31] x86, boot, 64bit: Add support for loading ramdisk and bzImage above 4G
Date: Thu,  3 Jan 2013 16:48:20 -0800
Message-Id: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
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

and it is on top of linus's tree 2013-01-03
plus tip:x86/mm, tip:x86/mm2

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
-v7u1: update changelog and comments, so it could break KGDB...

H. Peter Anvin (1):
  x86, 64bit: early #PF handler set page table

Yinghai Lu (30):
  x86, mm: Fix page table early allocation offset checking
  x86, 64bit, mm: make pgd next calculation consistent with pud/pmd
  x86, realmode: set real_mode permissions early
  x86, 64bit, mm: add generic kernel/ident mapping helper
  x86, 64bit: copy zero-page early
  x86, 64bit, realmode: use init_level4_pgt to set trapmoline_pgt directly
  x86, realmode: Separate real_mode reserve and setup
  x86, 64bit: #PF handler set page to cover 2M only
  x86, 64bit: Don't set max_pfn_mapped wrong value early on native path
  x86: Merge early_reserve_initrd for 32bit and 64bit
  x86: add get_ramdisk_image/size()
  x86, boot: add get_cmd_line_ptr()
  x86, boot: move checking of cmd_line_ptr out of common path
  x86, boot: pass cmd_line_ptr with unsigned long instead
  x86, boot: move verify_cpu.S and no_longmode down
  x86, boot: Move lldt/ltr out of 64bit code section
  x86, kexec: remove 1024G limitation for kexec buffer on 64bit
  x86, kexec: set ident mapping for kernel that is above max_pfn
  x86, kexec: replace ident_mapping_init and init_level4_page
  x86, kexec: only set ident mapping for ram.
  x86, boot: add fields to support load bzImage and ramdisk above 4G
  x86, boot: update comments about entries for 64bit image
  x86, boot: Not need to check setup_header version for setup_data
  memblock: add memblock_mem_size()
  x86: Don't enable swiotlb if there is not enough ram for it
  x86, kdump: remove crashkernel range find limit for 64bit
  x86: add Crash kernel low reservation
  x86: Merge early kernel reserve for 32bit and 64bit
  x86, 64bit, mm: Mark data/bss/brk to nx
  x86, 64bit, mm: hibernate use generic mapping_init

 Documentation/kernel-parameters.txt     |    3 +
 Documentation/x86/boot.txt              |   53 +++++++-
 Documentation/x86/zero-page.txt         |    4 +
 arch/x86/boot/boot.h                    |   18 ++-
 arch/x86/boot/cmdline.c                 |   12 +-
 arch/x86/boot/compressed/cmdline.c      |   12 +-
 arch/x86/boot/compressed/head_64.S      |   48 ++++---
 arch/x86/boot/compressed/misc.c         |   12 ++
 arch/x86/boot/header.S                  |   12 +-
 arch/x86/boot/setup.ld                  |    7 ++
 arch/x86/include/asm/init.h             |   12 ++
 arch/x86/include/asm/kexec.h            |    6 +-
 arch/x86/include/asm/page.h             |    4 +
 arch/x86/include/asm/pgtable_64_types.h |    4 +
 arch/x86/include/asm/processor.h        |    1 +
 arch/x86/include/asm/realmode.h         |    3 +-
 arch/x86/include/uapi/asm/bootparam.h   |   13 +-
 arch/x86/kernel/head32.c                |   20 ---
 arch/x86/kernel/head64.c                |  131 ++++++++++++++-----
 arch/x86/kernel/head_64.S               |  210 +++++++++++++++++++------------
 arch/x86/kernel/machine_kexec_64.c      |  171 ++++++++-----------------
 arch/x86/kernel/pci-swiotlb.c           |   14 ++-
 arch/x86/kernel/setup.c                 |  128 ++++++++++++++-----
 arch/x86/kernel/traps.c                 |    9 ++
 arch/x86/mm/init.c                      |   11 +-
 arch/x86/mm/init_64.c                   |  109 ++++++++++++++--
 arch/x86/power/hibernate_64.c           |   66 ++++------
 arch/x86/realmode/init.c                |   42 ++++---
 include/linux/kexec.h                   |    3 +
 include/linux/memblock.h                |    1 +
 kernel/kexec.c                          |   34 ++++-
 mm/memblock.c                           |   17 +++
 32 files changed, 778 insertions(+), 412 deletions(-)

-- 
1.7.10.4

