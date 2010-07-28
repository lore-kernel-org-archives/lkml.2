Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab0G1XsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 19:48:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33096 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab0G1XsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 19:48:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=I/aIt7ccNX4kJ14PoSMPvRU9QfrhTghhM4vrvC4rQ2ZT2Xoncnq2dSPM7LgvUKDqDh
         bwOFdimVlYk9DozOdgcIgOpT97xpMVVr91U8ozdqKSmKO55eJufLkZ9iiysOGvxJPfZE
         cHlq2DRiIrFm6OqrZAKwhtgS9e3IPsP/JnZO8=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        linux-arch@vger.kernel.org, Parisc List <linux-parisc@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
        Tim Abbott <tabbott@ksplice.com>, Tim Bird <tim.bird@am.sony.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Matt Fleming <matt@console-pimps.org>, Arnd Bergmann <arnd@arndb.de>,
        Anders Kaseorg <andersk@mit.edu>, Andi Kleen <andi@firstfloor.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 0/4] function/data-sections
Date: Thu, 29 Jul 2010 01:47:52 +0200
Message-Id: <1280360876-2571-1-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

Please take this patch series onto linux-kbuild.

Most of work needed for working -ffunction-sections -fdata-sections build
is already in the mainline, but a few bits are still missing.
In order to have a working kernel with this make invocation:
    make KCFLAGS="-ffunction-sections -fdata-sections"
we need these patches:

modpost: support objects with more than 64k sections
    This patch is in -mm, it still did not reach mainline,
    thus resending. Sam suggested some readability improvements.
module linker script: coalesce function and data sections
kernel linker stripts: accomodate function and data sections
boot linker stripts: accomodate function and data sections

Please see individual patches for more detailed changelogs.

A rough idea what sort of size savings are achievable
with section garbage collection:
Kernel:
   text   data    bss     dec    hex filename
8299299 857324 785348 9941971 97b3d3 2.6.35-rc4/vmlinux
7566908 832388 717844 9117140 8b1dd4 2.6.35-rc4-fsgs/vmlinux
  -9.2%  -2.9%  -9.0%   -8.6%
The largest module in the build:
 451009  54640   2224  507873  7bfe1 2.6.35-rc4/fs/xfs/xfs.ko
 450521  54292   2202  507015  7bc87 2.6.35-rc4-fsgs/fs/xfs/xfs.ko
(negligible size change since section garbage collection
for modules is not done. TODO: figure out how to do it)

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>


Denys Vlasenko (4):
  modpost: support objects with more than 64k sections
  module linker script: coalesce sections
  kernel linker stripts: accomodate function and data sections
  boot linker stripts: accomodate function and data sections

 arch/alpha/boot/bootloader.lds               |    6 +-
 arch/arm/boot/bootp/bootp.lds                |    1 +
 arch/cris/boot/compressed/decompress_v10.lds |    3 +
 arch/cris/boot/compressed/decompress_v32.lds |    3 +
 arch/cris/boot/rescue/rescue_v10.lds         |    2 +
 arch/cris/boot/rescue/rescue_v32.lds         |    3 +
 arch/frv/kernel/vmlinux.lds.S                |    1 -
 arch/h8300/boot/compressed/vmlinux.lds       |    2 +
 arch/h8300/boot/compressed/vmlinux.scr       |    1 +
 arch/ia64/hp/sim/boot/bootloader.lds         |    6 +-
 arch/ia64/scripts/check-segrel.lds           |    4 +-
 arch/m32r/boot/compressed/vmlinux.lds.S      |    6 +-
 arch/m32r/boot/compressed/vmlinux.scr        |    1 +
 arch/m68knommu/kernel/vmlinux.lds.S          |    1 +
 arch/mips/lasat/image/romscript.normal       |    1 +
 arch/mn10300/boot/compressed/vmlinux.lds     |    1 +
 arch/parisc/kernel/vmlinux.lds.S             |    1 +
 arch/powerpc/boot/zImage.coff.lds.S          |    2 +
 arch/powerpc/boot/zImage.lds.S               |    2 +
 arch/powerpc/boot/zImage.ps3.lds.S           |    2 +
 arch/sh/boot/compressed/vmlinux.scr          |    1 +
 arch/sh/kernel/vsyscall/vsyscall.lds.S       |    2 +-
 arch/x86/boot/setup.ld                       |    3 +-
 arch/x86/kernel/acpi/realmode/wakeup.lds.S   |    1 +
 arch/x86/kernel/vmlinux.lds.S                |    1 +
 arch/xtensa/boot/boot-elf/boot.lds.S         |    5 +-
 arch/xtensa/boot/boot-redboot/boot.ld        |    5 +-
 include/asm-generic/vmlinux.lds.h            |   18 ++++-
 scripts/mod/file2alias.c                     |    6 +-
 scripts/mod/modpost.c                        |  102 +++++++++++++++++++-------
 scripts/mod/modpost.h                        |   43 +++++++++++
 scripts/module-common.lds                    |   23 ++++++
 32 files changed, 213 insertions(+), 46 deletions(-)

