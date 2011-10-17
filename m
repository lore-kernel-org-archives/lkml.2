Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab1JQKkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 06:40:32 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:42697 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549Ab1JQKk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 06:40:29 -0400
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH v5 00/10] x86 EFI boot stub
Date: Mon, 17 Oct 2011 11:40:07 +0100
Message-Id: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

This series adds support for an EFI boot stub, similar to the existing
BIOS boot stub. The result is that you can boot a bzImage on an EFI
machine without the use of a boot loader by making the bzImage appear
to the EFI firmware to be an EFI application. Also, a single bzImage
can be booted on either a BIOS or EFI machine.

Using the EFI boot stub has the advantage that the kernel is
responsible for configuring the machine to the point where we can
fully boot the kernel, so we are no longer at the mercy of the boot
loader.

Changes in v5:

 - load_options_size is UTF-16, which needs dividing by 2 to convert
   to the corresponding ASCII size. Otherwise we could potentially
   read more than load_options_size because we're comparing UTF-16 and
   ASCII (reported by Maarten Lankhorst).

Changes in v4:

 - Don't read more than image->load_options_size when reading
   command-line args.

Changes in v3:

 - Fix compiler warnings when compiling CONFIG_EFI_STUB=n
 - Fix GOP search as suggested by Matthew Garrett.
 - Fix initrd memory allocation.
 - Fix various bugs pointed out by Maarten Lankhorst.

Changes in v2:

  - Added PATCH 01/10 because we now need to access hdr.pref_address
    and hdr.init_size when relocating the bzImage

  - Added relocation support to the stub because the firmware might
    load the bzImage at a very high physical address

  - Fixed the alignment of some u64 fields on x86

  - Now we dynamically write some fields in the bzImage EFI header at
    arch/x86/boot/tools/build time.

  - Added UGA support

  - Replaced some magic numbers with constants

Matt Fleming (10):
  x86: Add missing bzImage fields to struct setup_header
  x86, efi: Make efi_call_phys_prelog() CONFIG_RELOCATABLE-aware
  x86: Don't use magic strings for EFI loader signature
  efi.h: Add struct definition for boot time services
  efi.h: Add efi_image_loaded_t
  efi.h: Add allocation types for boottime->allocate_pages()
  efi.h: Add graphics protocol guids
  efi.h: Add boottime->locate_handle search types
  efi: Add EFI file I/O data types
  x86, efi: EFI boot stub support

 arch/x86/Kconfig                       |    7 +
 arch/x86/boot/compressed/Makefile      |   10 +-
 arch/x86/boot/compressed/eboot.c       |  975 ++++++++++++++++++++++++++++++++
 arch/x86/boot/compressed/efi_stub_32.S |   87 +++
 arch/x86/boot/compressed/efi_stub_64.S |    1 +
 arch/x86/boot/compressed/head_32.S     |   22 +
 arch/x86/boot/compressed/head_64.S     |   20 +
 arch/x86/boot/compressed/string.c      |    9 +
 arch/x86/boot/header.S                 |  158 +++++
 arch/x86/boot/string.c                 |   35 ++
 arch/x86/boot/tools/build.c            |   39 ++
 arch/x86/include/asm/bootparam.h       |    2 +
 arch/x86/include/asm/efi.h             |    4 +
 arch/x86/kernel/asm-offsets.c          |    2 +
 arch/x86/kernel/setup.c                |    7 +-
 arch/x86/platform/efi/efi_32.c         |   22 +-
 include/linux/efi.h                    |  136 +++++-
 17 files changed, 1519 insertions(+), 17 deletions(-)
 create mode 100644 arch/x86/boot/compressed/eboot.c
 create mode 100644 arch/x86/boot/compressed/efi_stub_32.S
 create mode 100644 arch/x86/boot/compressed/efi_stub_64.S

-- 
1.7.4.4

