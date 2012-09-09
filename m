Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab2IIRrL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 13:47:11 -0400
Received: from 4.mo2.mail-out.ovh.net ([87.98.172.75]:35979 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754043Ab2IIRrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 13:47:09 -0400
X-Greylist: delayed 1422 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Sep 2012 13:47:09 EDT
Date: Sun, 9 Sep 2012 19:20:46 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH v3 02/31] arm64: Kernel booting and initialisation
Message-ID: <20120909172046.GB31430@game.jcrosoft.org>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
 <1347035226-18649-3-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347035226-18649-3-git-send-email-catalin.marinas@arm.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 15026823108321717059
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehtddrheegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehtddrheegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:26 Fri 07 Sep     , Catalin Marinas wrote:
> The patch adds the kernel booting and the initial setup code.
> Documentation/arm64/booting.txt describes the booting protocol on the
> AArch64 Linux kernel. This is subject to change following the work on
> boot standardisation, ACPI.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Nicolas Pitre <nico@linaro.org>
> Acked-by: Tony Lindgren <tony@atomide.com>
> ---
>  Documentation/arm64/booting.txt |  152 ++++++++++++
>  arch/arm64/include/asm/setup.h  |   26 ++
>  arch/arm64/kernel/head.S        |  510 +++++++++++++++++++++++++++++++++++++++
>  arch/arm64/kernel/setup.c       |  351 +++++++++++++++++++++++++++
>  4 files changed, 1039 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/arm64/booting.txt
>  create mode 100644 arch/arm64/include/asm/setup.h
>  create mode 100644 arch/arm64/kernel/head.S
>  create mode 100644 arch/arm64/kernel/setup.c
> 
> diff --git a/Documentation/arm64/booting.txt b/Documentation/arm64/booting.txt
> new file mode 100644
> index 0000000..9c4d388
> --- /dev/null
> +++ b/Documentation/arm64/booting.txt
> @@ -0,0 +1,152 @@
> +			Booting AArch64 Linux
> +			=====================
> +
> +Author: Will Deacon <will.deacon@arm.com>
> +Date  : 07 September 2012
> +
> +This document is based on the ARM booting document by Russell King and
> +is relevant to all public releases of the AArch64 Linux kernel.
> +
> +The AArch64 exception model is made up of a number of exception levels
> +(EL0 - EL3), with EL0 and EL1 having a secure and a non-secure
> +counterpart.  EL2 is the hypervisor level and exists only in non-secure
> +mode. EL3 is the highest priority level and exists only in secure mode.
> +
> +For the purposes of this document, we will use the term `boot loader'
> +simply to define all software that executes on the CPU(s) before control
> +is passed to the Linux kernel.  This may include secure monitor and
> +hypervisor code, or it may just be a handful of instructions for
> +preparing a minimal boot environment.
> +
> +Essentially, the boot loader should provide (as a minimum) the
> +following:
> +
> +1. Setup and initialise the RAM
> +2. Setup the device tree
> +3. Decompress the kernel image
> +4. Call the kernel image
> +
> +
> +1. Setup and initialise RAM
> +---------------------------
> +
> +Requirement: MANDATORY
> +
> +The boot loader is expected to find and initialise all RAM that the
> +kernel will use for volatile data storage in the system.  It performs
> +this in a machine dependent manner.  (It may use internal algorithms
> +to automatically locate and size all RAM, or it may use knowledge of
> +the RAM in the machine, or any other method the boot loader designer
> +sees fit.)
> +
> +
> +2. Setup the device tree
> +-------------------------
> +
> +Requirement: MANDATORY
> +
> +The device tree blob (dtb) must be no bigger than 2 megabytes in size
> +and placed at a 2-megabyte boundary within the first 512 megabytes from
> +the start of the kernel image. This is to allow the kernel to map the
> +blob using a single section mapping in the initial page tables.
why do you want to restrict the DT to be less tahn 2MiB?
> +
> +
> +3. Decompress the kernel image
> +------------------------------
> +
> +Requirement: OPTIONAL
> +
> +The AArch64 kernel does not currently provide a decompressor and
> +therefore requires decompression (gzip etc.) to be performed by the boot
> +loader if a compressed Image target (e.g. Image.gz) is used.  For
> +bootloaders that do not implement this requirement, the uncompressed
> +Image target is available instead.
> +
> +
> +4. Call the kernel image
> +------------------------
> +
> +Requirement: MANDATORY
> +
> +The decompressed kernel image contains a 32-byte header as follows:
> +
> +  u32 magic	= 0x14000008;	/* branch to stext, little-endian */
> +  u32 res0	= 0;		/* reserved */
> +  u64 text_offset;		/* Image load offset */
> +  u64 res1	= 0;		/* reserved */
> +  u64 res2	= 0;		/* reserved */
we need to have a magic to known it's a arm64 kernel
> +
> +The image must be placed at the specified offset (currently 0x80000)
> +from the start of the system RAM and called there. The start of the
> +system RAM must be aligned to 2MB.
can we drop this
> +
> +Before jumping into the kernel, the following conditions must be met:
> +
> +- Quiesce all DMA capable devices so that memory does not get
> +  corrupted by bogus network packets or disk data.  This will save
> +  you many hours of debug.
> +
> +- Primary CPU general-purpose register settings
> +  x0 = physical address of device tree blob (dtb) in system RAM.
> +  x1 = 0 (reserved for future use)
> +  x2 = 0 (reserved for future use)
> +  x3 = 0 (reserved for future use)
> +
> +- CPU mode
> +  All forms of interrupts must be masked in PSTATE.DAIF (Debug, SError,
> +  IRQ and FIQ).
> +  The CPU must be in either EL2 (RECOMMENDED in order to have access to
> +  the virtualisation extensions) or non-secure EL1.
> +
> +- Caches, MMUs
> +  The MMU must be off.
> +  Instruction cache may be on or off.
> +  Data cache must be off and invalidated.
> +  External caches (if present) must be configured and disabled.
> +
> +- Architected timers
> +  CNTFRQ must be programmed with the timer frequency.
> +  If entering the kernel at EL1, CNTHCTL_EL2 must have EL1PCTEN (bit 0)
> +  set where available.
can you explain why?
> +
> +- Coherency
> +  All CPUs to be booted by the kernel must be part of the same coherency
> +  domain on entry to the kernel.  This may require IMPLEMENTATION DEFINED
> +  initialisation to enable the receiving of maintenance operations on
> +  each CPU.
> +
> +- System registers
> +  All writable architected system registers at the exception level where
> +  the kernel image will be entered must be initialised by software at a
> +  higher exception level to prevent execution in an UNKNOWN state.
> +
> +The boot loader is expected to enter the kernel on each CPU in the
> +following manner:
> +
> +- The primary CPU must jump directly to the first instruction of the
> +  kernel image.  The device tree blob passed by this CPU must contain
> +  for each CPU node:
> +
> +    1. An 'enable-method' property. Currently, the only supported value
> +       for this field is the string "spin-table".
> +
> +    2. A 'cpu-release-addr' property identifying a 64-bit,
> +       zero-initialised memory location.
> +
> +  It is expected that the bootloader will generate these device tree
> +  properties and insert them into the blob prior to kernel entry.
> +
> +- Any secondary CPUs must spin outside of the kernel in a reserved area
> +  of memory (communicated to the kernel by a /memreserve/ region in the
> +  device tree) polling their cpu-release-addr location, which must be
> +  contained in the reserved region.  A wfe instruction may be inserted
> +  to reduce the overhead of the busy-loop and a sev will be issued by
> +  the primary CPU.  When a read of the location pointed to by the
> +  cpu-release-addr returns a non-zero value, the CPU must jump directly
> +  to this value.
do you plan AMP boot?

Best Regards,
J.
