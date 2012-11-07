Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab2KGON4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 09:13:56 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:55459 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab2KGONy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 09:13:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [RFC PATCH v1 26/31] ARC: Build system: Makefiles, Kconfig, Linker script
Date: Wed, 7 Nov 2012 14:13:49 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <1352281674-2186-27-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1352281674-2186-27-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211071413.49178.arnd@arndb.de>
X-Provags-ID: V02:K0:BrJS1tV783hF0AMS32ziZhYYjeTDjilYibtte2Jr2qa
 q4vXg/TuiiHr3f111B5EPi4ajXzUo31HIsHq404OxXeoceFD13
 bk11xZHYC//PVGh8XNUBMrS9zqaORQz3//7vaDSJ3OCMLEgDX6
 S2VWr95g1L+yOHRZZAQahNWiPzN7Mv/QWAxi1onvR/zczF0Sug
 jo/G2I6ADJy7gq5A2pMDn+FkN04CHG1C7Bxd9CkevC0GKKHKjH
 1qReS8zgsN6JnKjsIysDK0Kv37lvdzBV0n7rkXksuvhVkgrsRw
 hM4lRQMZEwvGwfNcIgTvqKr/Fhi6h31xVKFRY3RfGK1KpMAArH
 NPqi2rvd9eOf4IGg8FU8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 November 2012, Vineet Gupta wrote:

> +
> +config ARC
> +	def_bool y
> +	select ARCH_WANT_IPC_PARSE_VERSION
> +	# ARC Busybox based initramfs absolutely relies on DEVTMPFS for /dev
> +	# DEVTMPS in turn needs HOTPLUG
> +	select DEVTMPFS if !INITRAMFS_SOURCE=""
> +	select GENERIC_ATOMIC64
> +	select GENERIC_CLOCKEVENTS
> +	select GENERIC_FIND_FIRST_BIT
> +	# for now, we don't need GENERIC_IRQ_PROBE, CONFIG_GENERIC_IRQ_CHIP
> +	select GENERIC_IRQ_SHOW
> +	select GENERIC_PENDING_IRQ if SMP
> +	select GENERIC_SMP_IDLE_THREAD
> +	select HAVE_GENERIC_HARDIRQS
> +	select HOTPLUG if !INITRAMFS_SOURCE=""
> +	select MODULES_USE_ELF_RELA

You should not need ARCH_WANT_IPC_PARSE_VERSION

> +# for old_[ug]id_t - do we need this ?
> +config UID16
> +	def_bool y

No, not needed either.

> +menu "ARC Architecture Configuration"
> +
> +choice
> +	prompt "ARC Platform"
> +	default ARC_PLAT_FPGA_LEGACY
> +
> +config ARC_PLAT_FPGA_LEGACY
> +	bool "\"Legacy\" ARC FPGA dev platform"
> +	help
> +	  Support for ARC development platforms, provided by Synopsys.
> +	  These are based on FPGA or ISS. e.g.
> +	  - ARCAngel4
> +	  - ML509
> +	  - MetaWare ISS
> +
> +#New platform adds here
> +endchoice

Platform selection should generally be non-exclusive. Just remove the
"choice" statement here, and make sure that any platforms can be enabled
together to build a single kernel.

> +menu "ARC CPU Configuration"
> +
> +choice
> +	prompt "ARC Core"
> +	default ARC_CPU_770
> +
> +config ARC_CPU_750D
> +	bool "ARC750D"
> +	help
> +	  Support for ARC750 core
> +
> +config ARC_CPU_770
> +	bool "ARC770"
> +	select ARC_CPU_REL_4_10
> +	help
> +	  Support for ARC770 core introduced with Rel 4.10 (Summer 2011)
> +	  This core has a bunch of cool new features:
> +	  -MMU-v3: Variable Page Sz (4k, 8k, 16k), bigger J-TLB (128x4)
> +                   Shared Address Spaces (for sharing TLB entires in MMU)
> +	  -Caches: New Prog Model, Region Flush
> +	  -Insns: endian swap, load-locked/store-conditional, time-stamp-ctr
> +
> +endchoice

Same thing here: If the different CPUs can in theory run the same kernel
code, they should allow that. It doesn't stop you from making the default
to enable only one of them and optimize for that case.

> +
> +choice
> +	prompt "ARC700 MMU Version"
> +	default ARC_MMU_V3 if ARC_CPU_770
> +	default ARC_MMU_V2 if ARC_CPU_750D
> +

> +endchoice

> +choice
> +	prompt "MMU Page Size"
> +	default ARC_PAGE_SIZE_8K
> +
>
> +
> +endchoice

For MMU, page size and endianess, I would not expect that to work though,
so they probably need to remain mutually exclusive.

> +menu "Platform Board Configuration"
> +
> +source "arch/arc/plat-arcfpga/Kconfig"
> +#New platform adds here
> +
> +config ARC_PLAT_CLK
> +	int "Clk speed in Hz"
> +	default "80000000"
> +
> +config LINUX_LINK_BASE
> +	hex "Linux Link Address"
> +	default "0x80000000"
> +	help
> +	  ARC700 divides the 32 bit phy address space into two equal halves
> +	  -Lower 2G (0 - 0x7FFF_FFFF ) is user virtual, translated by MMU
> +	  -Upper 2G (0x8000_0000 onwards) is untranslated, for kernel
> +	  Typically Linux kernel is linked at the start of untransalted addr,
> +	  hence the default value of 0x8zs.
> +	  However some customers have peripherals mapped at this addr, so
> +	  Linux needs to be scooted a bit.
> +	  If you don't know what the above means, leave this setting alone.
> +
> +config ARC_PLAT_SDRAM_SIZE
> +	hex "SD RAM Size"
> +	default "0x10000000"
> +	help
> +	  Implies the amount of SDRAM/DRAM Linux is going to claim/own.
> +	  The actual memory itself could be larger than this number. But for
> +	  all software purposes, this is the amt of memory.
> +
> +endmenu # "Platform Board Configuration"

Clock speed and memory size are things that the kernel should normally
be able to find out itself, if not from the hardware then from looking
at the device tree binary that gets passed from the boot loader, or
some other boot protocol that is already established.

> +if ARC_PLAT_FPGA_LEGACY
> +
> +choice
> +	prompt "FPGA Board"
> +
> +config ARC_BOARD_ANGEL4
> +	bool "ARC Angel4"
> +	help
> +	  ARC Angel4 FPGA Ref Platform (Xilinx Virtex Based)
> +
> +config ARC_BOARD_ML509
> +	bool "ML509"
> +	help
> +	  ARC ML509 FPGA Ref Platform (Xilinx Virtex-5 Based)
> +
> +endchoice

Board files again should not be mutually exclusive.

	Arnd
