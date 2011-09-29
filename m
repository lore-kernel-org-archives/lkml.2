Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab1I2KJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 06:09:07 -0400
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:49991 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab1I2KJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 06:09:06 -0400
X-SENDER-IP: [85.230.28.149]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoBgAIRChE5V5hyVPGdsb2JhbABBhGSER55fCwEBAQE3MoFTAQEFIwQLASMRAgEPEAgDFQMCAiYCAhQlChoTh3ymLJFnDoEehFUxYQSZB4wL
X-IronPort-AV: E=Sophos;i="4.68,460,1312149600"; 
   d="scan'208";a="121724020"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 29 Sep 2011 12:14:18 +0200
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        MikeWaychiso@bitmath.org
Subject: Re: [PATCH v3 10/10] x86, efi: EFI boot stub support
Message-ID: <20110929101418.GA2215@polaris.bitmath.org>
References: <1315838094-2307-11-git-send-email-matt@console-pimps.org>
 <1316607036-9235-1-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1316607036-9235-1-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 01:10:36PM +0100, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> There is currently a large divide between kernel development and the
> development of EFI boot loaders. The idea behind this patch is to give
> the kernel developers full control over the EFI boot process. As
> H. Peter Anvin put it,
> 
> "The 'kernel carries its own stub' approach been very successful in
> dealing with BIOS, and would make a lot of sense to me for EFI as
> well."
> 
> This patch introduces an EFI boot stub that allows an x86 bzImage to
> be loaded and executed by EFI firmware. The bzImage appears to the
> firmware as an EFI application. Luckily there are enough free bits
> within the bzImage header so that it can masquerade as an EFI
> application, thereby coercing the EFI firmware into loading it and
> jumping to its entry point. The beauty of this masquerading approach
> is that both BIOS and EFI boot loaders can still load and run the same
> bzImage, thereby allowing a single kernel image to work in any boot
> environment.
> 
> The EFI boot stub supports multiple initrds, but they must exist on
> the same partition as the bzImage. Command-line arguments for the
> kernel can be appended after the bzImage name when run from the EFI
> shell, e.g.
> 
> Shell> bzImage console=ttyS0 root=/dev/sdb initrd=initrd.img
> 
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Mike Waychison <mikew@google.com>
> Cc: Matthew Garrett <mjg@redhat.com>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
> 
> v3:
>  - Fix following warnings when compiling CONFIG_EFI_STUB=n
> 
>    arch/x86/boot/tools/build.c: In function ‘main’:
>    arch/x86/boot/tools/build.c:138:24: warning: unused variable ‘pe_header’
>    arch/x86/boot/tools/build.c:138:15: warning: unused variable ‘file_sz’
> 
>  - As reported by Matthew Garrett, some Apple machines have GOPs that
>    don't have hardware attached. We need to weed these out by
>    searching for ones that handle the PCIIO protocol.
> 
>  - Don't allocate memory if no initrds are on cmdline
>  - Don't trust image->load_options_size
> 
>  - Maarten Lankhorst suggested:
>    - Don't strip first argument when booted from efibootmgr
>    - Don't allocate too much memory for cmdline
>    - Don't update cmdline_size, the kernel considers it read-only
>    - Don't accept '\n' for initrd names
> 
> v2:
> 
>  - File alignment was too large, was 8192 should be 512. Reported by
>    Maarten Lankhorst on LKML.
>  - Added UGA support for graphics
>  - Use VIDEO_TYPE_EFI instead of hard-coded number.
>  - Move linelength assignment until after we've assigned depth
>  - Dynamically fill out AddressOfEntryPoint in tools/build.c
>  - Don't use magic number for GDT/TSS stuff. Requested by Andi Kleen
>  - The bzImage may need to be relocated as it may have been loaded at
>    a high address address by the firmware. This was required to get my
>    macbook booting because the firmware loaded it at 0x7cxxxxxx, which
>    triggers this error in decompress_kernel(),
> 
> 	if (heap > ((-__PAGE_OFFSET-(128<<20)-1) & 0x7fffffff))
> 		error("Destination address too large");
> 
>  arch/x86/Kconfig                       |    7 +
>  arch/x86/boot/compressed/Makefile      |   10 +-
>  arch/x86/boot/compressed/eboot.c       |  974 ++++++++++++++++++++++++++++++++
>  arch/x86/boot/compressed/efi_stub_32.S |   87 +++
>  arch/x86/boot/compressed/efi_stub_64.S |    1 +
>  arch/x86/boot/compressed/head_32.S     |   22 +
>  arch/x86/boot/compressed/head_64.S     |   20 +
>  arch/x86/boot/compressed/string.c      |    9 +
>  arch/x86/boot/header.S                 |  158 ++++++
>  arch/x86/boot/string.c                 |   35 ++
>  arch/x86/boot/tools/build.c            |   39 ++
>  arch/x86/kernel/asm-offsets.c          |    2 +
>  12 files changed, 1363 insertions(+), 1 deletions(-)
>  create mode 100644 arch/x86/boot/compressed/eboot.c
>  create mode 100644 arch/x86/boot/compressed/efi_stub_32.S
>  create mode 100644 arch/x86/boot/compressed/efi_stub_64.S

Using this version 3 of the patch, and a builtin commandline, I am
able to boot a MacBookAir3,1 directly into a blessed bzImage. The
screen comes up correctly.

Tested-by: Henrik Rydberg <rydberg@euromail.se>

As a side note, resume from suspend seems to leave the screen blank.

Thanks,
Henrik
