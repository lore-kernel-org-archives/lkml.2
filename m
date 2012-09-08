Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab2IHWGw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 18:06:52 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:38128 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab2IHWGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 18:06:50 -0400
X-Originating-IP: 217.70.178.143
X-Originating-IP: 50.43.46.74
Date: Sat, 8 Sep 2012 15:06:41 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Olof Johansson <olof@lixom.net>, Matthew Garrett <mjg@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-acpi@vger.kernel.org
Subject: [PATCHv3 0/4] Fix ACPI BGRT support for images located in EFI boot
 services memory
Message-ID: <cover.1347141698.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACPI BGRT lets the OS access the BIOS logo image and its position on the
screen at boot time, allowing it to maintain that image on the screen until
ready to display something else, making boot more seamless.  This series fixes
support for accessing the boot logo image via the BGRT when the BIOS stores it
in EFI boot services memory, as recommended by the ACPI 5.0 spec.  Linux needs
to copy the image out of boot services memory before reclaiming boot services
memory.

The first patch cleans up the existing x86-specific efi_enter_virtual_mode
function to have a stub version on non-x86 platforms, to eliminate an ifdef in
init/main.c.   The second patch refactors EFI initialization to defer freeing
boot services memory until much later in the boot process, and in particular
until after we have ACPI available.  The third patch adds a helper function to
look up existing EFI boot services mappings, to avoid re-mapping them.  The
fourth patch moves BGRT initialization to before the reclamation of boot
services memory, copies the logo at that point, and reworks the existing BGRT
driver to use that existing copy.

v2: Made the new internal function efi_unmap_memmap static.  Incorporated
    feedback from H. Peter Anvin and Matt Fleming: added stubs for
    x86-specific EFI functions called from init/main.c to eliminate the
    corresponding ifdefs in start_kernel; deferred
    efi_free_boot_services even later, to just before free_initmem.

v3: Moved efi_free_boot_services back to right after EFI initialization, to
    avoid a WARN from check_early_ioremap_leak about not calling
    early_iounmap soon enough.

Josh Triplett (4):
  efi: Add a stub for efi_enter_virtual_mode on non-x86
  efi: Defer freeing boot services memory until after ACPI init
  efi: Add a function to look up existing IO memory mappings
  efi: Fix the ACPI BGRT driver for images located in EFI boot services
    memory

 arch/x86/platform/efi/Makefile   |    1 +
 arch/x86/platform/efi/efi-bgrt.c |   76 ++++++++++++++++++++++++++++++++++++++
 arch/x86/platform/efi/efi.c      |   65 +++++++++++++++++++++++++-------
 drivers/acpi/Kconfig             |    4 +-
 drivers/acpi/bgrt.c              |   76 +++++---------------------------------
 include/linux/efi-bgrt.h         |   21 +++++++++++
 include/linux/efi.h              |    9 +++++
 init/main.c                      |    7 +++-
 8 files changed, 175 insertions(+), 84 deletions(-)
 create mode 100644 arch/x86/platform/efi/efi-bgrt.c
 create mode 100644 include/linux/efi-bgrt.h

-- 
1.7.10.4

