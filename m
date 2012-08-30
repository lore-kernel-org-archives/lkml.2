Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab2H3V21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:28:27 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:43998 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab2H3V2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:28:25 -0400
X-Originating-IP: 217.70.178.144
X-Originating-IP: 173.246.103.110
Date: Thu, 30 Aug 2012 14:28:17 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Olof Johansson <olof@lixom.net>, Matthew Garrett <mjg@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jim Cromie <jim.cromie@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pawel Moll <pawel.moll@arm.com>, linux-acpi@vger.kernel.org
Subject: [PATCH 0/3] Fix ACPI BGRT support for images located in EFI boot
 services memory
Message-ID: <cover.1346361959.git.josh@joshtriplett.org>
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
memory until later in the boot process, after we have ACPI available.  The
second patch adds a helper function to look up existing EFI boot services
mappings, to avoid re-mapping them.  The third patch moves BGRT initialization
to before the reclamation of boot services memory, copies the logo at that
point, and reworks the existing BGRT driver to use that existing copy.

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
 include/linux/efi.h              |    3 ++
 init/main.c                      |    7 ++++
 8 files changed, 171 insertions(+), 82 deletions(-)
 create mode 100644 arch/x86/platform/efi/efi-bgrt.c
 create mode 100644 include/linux/efi-bgrt.h

-- 
1.7.10.4
