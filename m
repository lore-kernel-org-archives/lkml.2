Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab3ABObe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 09:31:34 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:60351 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab3ABObb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 09:31:31 -0500
Message-ID: <50E4449A.7010606@synopsys.com>
Date: Wed, 2 Jan 2013 20:00:50 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Gilad Ben Yossef <giladb@ezchip.com>, Noam Camus <noamc@ezchip.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 26/31] ARC: Build system: Makefiles, Kconfig, Linker
 script
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <1352281674-2186-27-git-send-email-vgupta@synopsys.com> <201211071413.49178.arnd@arndb.de>
In-Reply-To: <201211071413.49178.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 November 2012 07:43 PM, Arnd Bergmann wrote:
> On Wednesday 07 November 2012, Vineet Gupta wrote:
> 
>> +
>> +config ARC
>> +	def_bool y
>> +	select ARCH_WANT_IPC_PARSE_VERSION
>> +	# ARC Busybox based initramfs absolutely relies on DEVTMPFS for /dev
>> +	# DEVTMPS in turn needs HOTPLUG
>> +	select DEVTMPFS if !INITRAMFS_SOURCE=""
>> +	select GENERIC_ATOMIC64
>> +	select GENERIC_CLOCKEVENTS
>> +	select GENERIC_FIND_FIRST_BIT
>> +	# for now, we don't need GENERIC_IRQ_PROBE, CONFIG_GENERIC_IRQ_CHIP
>> +	select GENERIC_IRQ_SHOW
>> +	select GENERIC_PENDING_IRQ if SMP
>> +	select GENERIC_SMP_IDLE_THREAD
>> +	select HAVE_GENERIC_HARDIRQS
>> +	select HOTPLUG if !INITRAMFS_SOURCE=""
>> +	select MODULES_USE_ELF_RELA
> 
> You should not need ARCH_WANT_IPC_PARSE_VERSION

Done !

>> +# for old_[ug]id_t - do we need this ?
>> +config UID16
>> +	def_bool y
> 
> No, not needed either.

Done !

> 
>> +menu "ARC Architecture Configuration"
>> +
>> +choice
>> +	prompt "ARC Platform"
>> +	default ARC_PLAT_FPGA_LEGACY
>> +
>> +config ARC_PLAT_FPGA_LEGACY
>> +	bool "\"Legacy\" ARC FPGA dev platform"
>> +	help
>> +	  Support for ARC development platforms, provided by Synopsys.
>> +	  These are based on FPGA or ISS. e.g.
>> +	  - ARCAngel4
>> +	  - ML509
>> +	  - MetaWare ISS
>> +
>> +#New platform adds here
>> +endchoice
> 
> Platform selection should generally be non-exclusive. Just remove the
> "choice" statement here, and make sure that any platforms can be enabled
> together to build a single kernel.

So technically this is not in same league as usage of devicetree. Although it
seems to have it's own merits (single image, code coverage,..) but is this a hard
requirement for all arches. Here's my problem.

We have default implementations of clocksource using in-core local TIMER1. This
however might not suffice for some SMP ARC SoCs which need cross-core synchronized
timers. Obviously they want to use their own versions. In orig code (not v1 - but
in my new v2) I have a platform specific hook local_counter_setup() called from
time_init(). With #def PLAT1 and #def PLAT2, there could be 2 mutually exclusive
versions of those. With the "all-platform-build-together" paradigm, this simple
design is not possible - not to mention the needless code bloat for a simple run
in simulator. So now using devicetree, I first need to find what platform we are
on and then need to setup a platform specific function pointer (and same applies
to several other platform specific stuff). Is there a better way of doing this -
maybe the long dy has taken toll on me :-(


>> +menu "ARC CPU Configuration"
>> +
>> +choice
>> +	prompt "ARC Core"
>> +	default ARC_CPU_770
>> +
>> +config ARC_CPU_750D
>> +	bool "ARC750D"
>> +	help
>> +	  Support for ARC750 core
>> +
>> +config ARC_CPU_770
>> +	bool "ARC770"
>> +	select ARC_CPU_REL_4_10
>> +	help
>> +	  Support for ARC770 core introduced with Rel 4.10 (Summer 2011)
>> +	  This core has a bunch of cool new features:
>> +	  -MMU-v3: Variable Page Sz (4k, 8k, 16k), bigger J-TLB (128x4)
>> +                   Shared Address Spaces (for sharing TLB entires in MMU)
>> +	  -Caches: New Prog Model, Region Flush
>> +	  -Insns: endian swap, load-locked/store-conditional, time-stamp-ctr
>> +
>> +endchoice
> 
> Same thing here: If the different CPUs can in theory run the same kernel
> code, they should allow that. It doesn't stop you from making the default
> to enable only one of them and optimize for that case.

Background: ARC770 supports newer instructions (LOCK/SCOND) + MMUv3 which are not
available on ARC750. So code needs to be built differently for each. Having said
that above config items don't have any code under them - they are just high level
selectors for correct MMU versions and e.g. whether we allow the usage of new insns.

> 
>> +
>> +choice
>> +	prompt "ARC700 MMU Version"
>> +	default ARC_MMU_V3 if ARC_CPU_770
>> +	default ARC_MMU_V2 if ARC_CPU_750D
>> +
> 
>> +endchoice
> 
>> +choice
>> +	prompt "MMU Page Size"
>> +	default ARC_PAGE_SIZE_8K
>> +
>>
>> +
>> +endchoice
> 
> For MMU, page size and endianess, I would not expect that to work though,
> so they probably need to remain mutually exclusive.

Ofcourse - given that PAGE_SIZE needs to be a compile time constant.

> 
>> +menu "Platform Board Configuration"
>> +
>> +source "arch/arc/plat-arcfpga/Kconfig"
>> +#New platform adds here
>> +
>> +config ARC_PLAT_CLK
>> +	int "Clk speed in Hz"
>> +	default "80000000"
>> +
>> +config LINUX_LINK_BASE
>> +	hex "Linux Link Address"
>> +	default "0x80000000"
>> +	help
>> +	  ARC700 divides the 32 bit phy address space into two equal halves
>> +	  -Lower 2G (0 - 0x7FFF_FFFF ) is user virtual, translated by MMU
>> +	  -Upper 2G (0x8000_0000 onwards) is untranslated, for kernel
>> +	  Typically Linux kernel is linked at the start of untransalted addr,
>> +	  hence the default value of 0x8zs.
>> +	  However some customers have peripherals mapped at this addr, so
>> +	  Linux needs to be scooted a bit.
>> +	  If you don't know what the above means, leave this setting alone.
>> +
>> +config ARC_PLAT_SDRAM_SIZE
>> +	hex "SD RAM Size"
>> +	default "0x10000000"
>> +	help
>> +	  Implies the amount of SDRAM/DRAM Linux is going to claim/own.
>> +	  The actual memory itself could be larger than this number. But for
>> +	  all software purposes, this is the amt of memory.
>> +
>> +endmenu # "Platform Board Configuration"
> 
> Clock speed and memory size are things that the kernel should normally
> be able to find out itself, if not from the hardware then from looking
> at the device tree binary that gets passed from the boot loader, or
> some other boot protocol that is already established.


Sure - both will come from devicetree. LINUX_LINK_BASE however is a fundamental
constant, used in linker script for final layout so it will have to be a .config item.

> 
>> +if ARC_PLAT_FPGA_LEGACY
>> +
>> +choice
>> +	prompt "FPGA Board"
>> +
>> +config ARC_BOARD_ANGEL4
>> +	bool "ARC Angel4"
>> +	help
>> +	  ARC Angel4 FPGA Ref Platform (Xilinx Virtex Based)
>> +
>> +config ARC_BOARD_ML509
>> +	bool "ML509"
>> +	help
>> +	  ARC ML509 FPGA Ref Platform (Xilinx Virtex-5 Based)
>> +
>> +endchoice
> 
> Board files again should not be mutually exclusive.

OK ! Actually this hunk should not be present in initial upstream submission as
these only differ in a peripheral which is not yet submitted. This will be dropped.

> 
> 	Arnd
> 

