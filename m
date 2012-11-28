Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab2K1Hv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 02:51:29 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40370 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab2K1Hv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 02:51:26 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 00/13] x86, boot, 64bit: Add support for loading ramdisk and bzImage above 4G
Date: Tue, 27 Nov 2012 23:50:29 -0800
Message-Id: <1354089042-10023-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
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
4. set xloadflags bit15 in header for bootloader to notify if new added
   ext_* fields in boot_params could be used.

This patches is tested with kexec tools with local changes and they are sent
to kexec list later.

could be found at:

        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-boot

and it is on top of for-x86-mm

-v2: add ext_cmd_line_ptr support, and handle boot_param/cmd_line is above
     4G case.
-v3: according to hpa, use xloadflags instead code32_start_offset.
     0x200 will not be changed...
-v4: move ext_ramdisk_image/ext_ramdisk_size/ext_cmd_line_ptr to boot_params.
     add handling cross GB boundary case.
-v5: put spare pages in BRK,so could avoid wasting about 4 pages.
     add check for bit USE_EXT_BOOT_PARAMS in xloadflags


Yinghai Lu (13):
  x86, boot: move verify_cpu.S after 0x200
  x86, boot: Move lldt/ltr out of 64bit code section
  x86, 64bit: Set extra ident mapping for whole kernel range
  x86: Merge early_reserve_initrd for 32bit and 64bit
  x86: add get_ramdisk_image/size()
  x86, boot: add get_cmd_line_ptr()
  x86, boot: move checking of cmd_line_ptr out of common path
  x86, boot: update cmd_line_ptr to unsigned long
  x86: use io_remap to access real_mode_data
  x86, boot: add fields to support load bzImage and ramdisk above 4G
  x86: remove 1024G limitation for kexec buffer on 64bit
  x86, 64bit: Print init kernel lowmap correctly
  x86, mm: Fix page table early allocation offset checking

 Documentation/x86/boot.txt         |   19 +++-
 Documentation/x86/zero-page.txt    |    3 +
 arch/x86/boot/boot.h               |   18 +++-
 arch/x86/boot/cmdline.c            |   12 +-
 arch/x86/boot/compressed/cmdline.c |   13 ++-
 arch/x86/boot/compressed/head_64.S |   14 ++-
 arch/x86/boot/header.S             |   12 ++-
 arch/x86/include/asm/bootparam.h   |   10 ++-
 arch/x86/include/asm/kexec.h       |    6 +-
 arch/x86/kernel/head32.c           |   11 --
 arch/x86/kernel/head64.c           |   44 +++++---
 arch/x86/kernel/head_64.S          |  207 ++++++++++++++++++++++++++++++++---
 arch/x86/kernel/setup.c            |   78 ++++++++++++--
 arch/x86/mm/init.c                 |    4 +-
 arch/x86/mm/init_64.c              |    6 +-
 15 files changed, 372 insertions(+), 85 deletions(-)

-- 
1.7.7

