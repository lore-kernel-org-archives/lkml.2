Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326Ab2I2Azq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 20:55:46 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:49104 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759228Ab2I2Azo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 20:55:44 -0400
X-Originating-IP: 217.70.178.151
X-Originating-IP: 50.43.46.74
Date: Fri, 28 Sep 2012 17:55:36 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Olof Johansson <olof@lixom.net>, Matthew Garrett <mjg@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pawel Moll <pawel.moll@arm.com>, linux-acpi@vger.kernel.org
Subject: [PATCHv4 0/3] Fix ACPI BGRT support for images located in EFI boot
 services memory
Message-ID: <cover.1348876882.git.josh@joshtriplett.org>
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

The first patch refactors EFI initialization to defer freeing boot services
memory until much later in the boot process, and in particular until after we
have ACPI available.  The second patch adds a helper function to look up
existing EFI boot services mappings, to avoid re-mapping them.  The third patch
moves BGRT initialization to before the reclamation of boot services memory,
copies the logo at that point, and reworks the existing BGRT driver to use that
existing copy.

v2: Made the new internal function efi_unmap_memmap static.  Incorporated
    feedback from H. Peter Anvin and Matt Fleming: added stubs for
    x86-specific EFI functions called from init/main.c to eliminate the
    corresponding ifdefs in start_kernel; deferred
    efi_free_boot_services even later, to just before free_initmem.

v3: Moved efi_free_boot_services back to right after EFI initialization, to
    avoid a WARN from check_early_ioremap_leak about not calling
    early_iounmap soon enough.

v4: Cast the integral phys_addr through unsigned long before casting it to a
    pointer, to avoid a warning "cast to pointer from integer of
    different size" on 32-bit x86.  Don't define efi_enter_virtual_mode
    as a stub on non-x86, because a different function exists on ia64
    with that name, and ia64 calls that function in a different point in
    its initialiation; instead, go back to calling
    efi_enter_virtual_mode in init/main.c under an #ifdef CONFIG_X86.
    Define the stubs for efi_late_init and efi_free_boot_services using
    "static inline" to avoid unused function warnings.

v4 should replace the version currently in tip x86/efi.

Josh Triplett (3):
  efi: Defer freeing boot services memory until after ACPI init
  efi: Add a function to look up existing IO memory mappings
  efi: Fix the ACPI BGRT driver for images located in EFI boot services memory

 arch/x86/platform/efi/Makefile   |    1 +
 arch/x86/platform/efi/efi-bgrt.c |   76 ++++++++++++++++++++++++++++++++++++++
 arch/x86/platform/efi/efi.c      |   65 +++++++++++++++++++++++++-------
 drivers/acpi/Kconfig             |    4 +-
 drivers/acpi/bgrt.c              |   76 +++++---------------------------------
 include/linux/efi-bgrt.h         |   21 +++++++++++
 include/linux/efi.h              |    8 ++++
 init/main.c                      |    5 +++
 8 files changed, 174 insertions(+), 82 deletions(-)
 create mode 100644 arch/x86/platform/efi/efi-bgrt.c
 create mode 100644 include/linux/efi-bgrt.h

-- 
1.7.10.4

