Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab2KRHJy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 02:09:54 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38114 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab2KRHJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 02:09:52 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 00/13] x86, boot, 64bit: Add support for loading ramdisk and bzImage high
Date: Sat, 17 Nov 2012 23:09:18 -0800
Message-Id: <1353222571-31544-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have limit kdump reseved under 896M, because kexec has the limitation.
and also bzImage need to stay under 4g.

To make kexec/kdump could use range above 4g, we need to make bzImage and
ramdisk could be loaded above 4g.
During booting bzImage will be unpacked on same postion and stay high.

The patches add field in boot header to
1. get info about ramdisk position info above 4g from bootloader/kexec
2. set code64_start_offset in header for bzImage and bootloader/kexec load
   could check that to decide if need to put bzImage high.

This patches is tested with kexec tools with local changes and they are sent
to kexec list.

could be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-boot

and it is on top of for-x86-mm

-v2: add ext_cmd_line_ptr support, and handle boot_param/cmd_line is above
     4G case.

Thanks

Yinghai

Yinghai Lu (13):
  x86, boot: move verify_cpu.S after 0x200
  x86, boot: Move lldt/ltr out of 64bit code section
  x86: Add macro for 64bit entry startup_64
  x86, 64bit: set extra ident page table for whole kernel range
  x86, 64bit: add support for loading kernel above 512G
  x86: Merge early_reserve_initrd for 32bit and 64bit
  x86: add get_ramdisk_image/size
  x86, boot: add get_cmd_line_ptr()
  x86, boot: Don't check if cmd_line_ptr is accessible in misc/decompressor()
  x86, boot: update cmd_line_ptr to unsigned long
  x86: use io_remap to access real_mode_data
  x86, boot: add fields to support load bzImage and ramdisk high
  x86: remove 1024g limitation for kexec buffer on 64bit

 Documentation/x86/boot.txt         |   39 +++++++++++++++++++++++++
 arch/x86/boot/boot.h               |   18 +++++++++--
 arch/x86/boot/cmdline.c            |   12 ++++----
 arch/x86/boot/compressed/cmdline.c |   13 +++++++-
 arch/x86/boot/compressed/head_64.S |   16 ++++++----
 arch/x86/boot/header.S             |    8 ++++-
 arch/x86/include/asm/boot.h        |    2 +
 arch/x86/include/asm/bootparam.h   |    4 ++
 arch/x86/include/asm/kexec.h       |    6 ++--
 arch/x86/kernel/head32.c           |   11 -------
 arch/x86/kernel/head64.c           |   42 +++++++++++++++++----------
 arch/x86/kernel/head_64.S          |   49 +++++++++++++++++++++++++------
 arch/x86/kernel/setup.c            |   55 +++++++++++++++++++++++++++++------
 13 files changed, 207 insertions(+), 68 deletions(-)

-- 
1.7.7

