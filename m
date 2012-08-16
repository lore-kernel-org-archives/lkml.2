Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab2HPS7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 14:59:47 -0400
Received: from relais.videotron.ca ([24.201.245.36]:15560 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab2HPS7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 14:59:45 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Thu, 16 Aug 2012 14:59:43 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 02/31] arm64: Kernel booting and initialisation
In-reply-to: <1344966752-16102-3-git-send-email-catalin.marinas@arm.com>
Message-id: <alpine.LFD.2.02.1208161438110.1541@xanadu.home>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-3-git-send-email-catalin.marinas@arm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2012, Catalin Marinas wrote:

> The patch adds the kernel booting and the initial setup code.
> Documentation/arm64/booting.txt describes the booting protocol on the
> AArch64 Linux kernel. This is subject to change following the work on
> boot standardisation, ACPI.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

A few minor comments below, otherwise...

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  Documentation/arm64/booting.txt |  141 +++++++++++
>  arch/arm64/include/asm/setup.h  |   26 ++
>  arch/arm64/kernel/head.S        |  521 +++++++++++++++++++++++++++++++++++++++
>  arch/arm64/kernel/setup.c       |  357 +++++++++++++++++++++++++++
>  4 files changed, 1045 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/arm64/booting.txt
>  create mode 100644 arch/arm64/include/asm/setup.h
>  create mode 100644 arch/arm64/kernel/head.S
>  create mode 100644 arch/arm64/kernel/setup.c
> 
> diff --git a/Documentation/arm64/booting.txt b/Documentation/arm64/booting.txt
> new file mode 100644
> index 0000000..3197820
> --- /dev/null
> +++ b/Documentation/arm64/booting.txt
> @@ -0,0 +1,141 @@
> +			Booting AArch64 Linux
> +			=====================
> +
> +Author: Will Deacon <will.deacon@arm.com>
> +Date  : 25 April 2012
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

It might be a good idea to specify the minimum information that should 
be contained in the DTB.  Memory size is certainly one such item.

> +3. Decompress the kernel image
> +------------------------------
> +
> +Requirement: OPTIONAL
> +
> +The AArch64 kernel does not provide a decompressor and therefore
> +requires gzip decompression to be performed by the boot loader if the
> +default Image.gz target is used.  For bootloaders that do not implement
> +this requirement, the larger Image target is available instead.

Some people will want to use bzip2 or whatever other decompressor du 
jour.  Maybe this shouldn't be gzip specific, or just presented as a 
possible option?

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
> +
> +The image must be placed at the specified offset (currently 0x80000)
> +from the start of the system RAM and called there. The start of the
> +system RAM must be aligned to 2MB.
> +
> +Before jumping into the kernel, the following conditions must be met:
> +
> +- Quiesce all DMA capable devices so that memory does not get
> +  corrupted by bogus network packets or disk data.  This will save
> +  you many hours of debug.
> +
> +- Primary CPU general-purpose register settings
> +  x0 = physical address of device tree blob (dtb) in system RAM.

I think you should mandate that some additional registers be explicitly 
initialized to 0 for possible future usage (and also mentioned in the 
corresponding code comment).  We have that issue on ARM32 where it is 
unclear if r2 contains a valid ATAG/DTB address or not as its content 
was not defined before.

[...]


Nicolas
