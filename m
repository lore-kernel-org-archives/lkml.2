Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab2FKUsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 16:48:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59760 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab2FKUsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 16:48:09 -0400
Date: Mon, 11 Jun 2012 22:48:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: wallak@free.fr
Cc: linux-kernel@vger.kernel.org
Subject: Re: File copy is very slow on linux-3.4.2 (or linux-3.3x) on a
 specific hardware: AMD FX-8150 + 990FX
Message-ID: <20120611204804.GA18967@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, wallak@free.fr,
	linux-kernel@vger.kernel.org
References: <1108815600.134531433.1339443818361.JavaMail.root@zimbra44-e7.priv.proxad.net>
 <437497008.134549481.1339444456294.JavaMail.root@zimbra44-e7.priv.proxad.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <437497008.134549481.1339444456294.JavaMail.root@zimbra44-e7.priv.proxad.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's something very wrong with this mail

On Mon, Jun 11, 2012 at 09:54:16PM +0200, wallak@free.fr wrote:
> 
> I've a very annoying issue on recent kernel (linux-3.4.2-SMP) with my main motherboard (AMD FX-8150 + 990FX - 8 cores 4.1GHz), file copy is very slow (see below). The same kernel works flawlessly on an AMD E450 2 cores motherboard.
> 
> Linux-3.2.20 works properly on this hardware.
> hdparm -t gives good results on both kernels.
> 
> I've no idea where this bug come from. Do you have this issue on your hardware ? A patch is available ?
> 
> 
> *linux-3.4.2
> dd if=../in/file_8gb.tmp of=tmp.tmp bs=1024k count=100
> 100+0 records in
> 100+0 records out
> 104857600 bytes (105 MB) copied, 132.884 s, 789 kB/s
> 
> 
> *linux-3.2.20
> dd if=../in/file_8gb.tmp of=tmp.tmp bs=1024k count=100
> 100+0 records in
> 100+0 records out
> 104857600 bytes (105 MB) copied, 3.30793 s, 31.7 MB/sa

First of all, the above shows that 3.4.2 is roughly 20 times better than
3.2.20.

But even if that were so, this is a wrong test to do since once you
run it for the first time, the 100MB land in the page cache and every
subsequent time you run the same thing, the same 100MB will come from
memory so no I/O at all.

What are you trying to achieve actually?

And, if I assume you've sent the right config below, then there are some
major issues with it:

> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/i386 3.4.2 Kernel Configuration
> #
> # CONFIG_64BIT is not set
> CONFIG_X86_32=y
> # CONFIG_X86_64 is not set

Why in the hell are you using 32-bit kernel on an AMD64 processor? Any
real reason?

> CONFIG_X86=y
> CONFIG_INSTRUCTION_DECODER=y
> CONFIG_OUTPUT_FORMAT="elf32-i386"
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
> CONFIG_GENERIC_CMOS_UPDATE=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_MMU=y

[ … ]

> #
> # Processor type and features
> #
> CONFIG_ZONE_DMA=y
> CONFIG_TICK_ONESHOT=y
> # CONFIG_NO_HZ is not set
> CONFIG_HIGH_RES_TIMERS=y
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
> CONFIG_SMP=y
> CONFIG_X86_MPPARSE=y
> # CONFIG_X86_BIGSMP is not set
> CONFIG_X86_EXTENDED_PLATFORM=y
> # CONFIG_X86_WANT_INTEL_MID is not set
> # CONFIG_X86_RDC321X is not set
> # CONFIG_X86_32_NON_STANDARD is not set
> CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
> # CONFIG_X86_32_IRIS is not set
> CONFIG_SCHED_OMIT_FRAME_POINTER=y
> # CONFIG_PARAVIRT_GUEST is not set
> CONFIG_NO_BOOTMEM=y
> # CONFIG_MEMTEST is not set
> # CONFIG_M386 is not set
> # CONFIG_M486 is not set
> # CONFIG_M586 is not set
> # CONFIG_M586TSC is not set
> # CONFIG_M586MMX is not set
> # CONFIG_M686 is not set
> # CONFIG_MPENTIUMII is not set
> # CONFIG_MPENTIUMIII is not set
> # CONFIG_MPENTIUMM is not set
> # CONFIG_MPENTIUM4 is not set
> # CONFIG_MK6 is not set
> # CONFIG_MK7 is not set
> # CONFIG_MK8 is not set
> # CONFIG_MCRUSOE is not set
> # CONFIG_MEFFICEON is not set
> # CONFIG_MWINCHIPC6 is not set
> # CONFIG_MWINCHIP3D is not set
> # CONFIG_MELAN is not set
> # CONFIG_MGEODEGX1 is not set
> # CONFIG_MGEODE_LX is not set
> # CONFIG_MCYRIXIII is not set
> # CONFIG_MVIAC3_2 is not set
> # CONFIG_MVIAC7 is not set
> # CONFIG_MCORE2 is not set
> CONFIG_MATOM=y

You have a 64-bit AMD processor but you're enabling 32-bit Intel Atom
optimizations, wtf?

Why not CONFIG_MK8?

Also, I noticed below you have IDE stuff enabled. Why? Why not AHCI and
the corresponding ATA_SFF options?

...

> # CONFIG_X86_GENERIC is not set
> CONFIG_X86_INTERNODE_CACHE_SHIFT=6
> CONFIG_X86_CMPXCHG=y
> CONFIG_X86_L1_CACHE_SHIFT=6
> CONFIG_X86_XADD=y
> CONFIG_X86_WP_WORKS_OK=y
> CONFIG_X86_INVLPG=y
> CONFIG_X86_BSWAP=y
> CONFIG_X86_POPAD_OK=y
> CONFIG_X86_USE_PPRO_CHECKSUM=y
> CONFIG_X86_TSC=y
> CONFIG_X86_CMPXCHG64=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=5
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_CPU_SUP_INTEL=y
> CONFIG_CPU_SUP_AMD=y
> CONFIG_CPU_SUP_CENTAUR=y
> CONFIG_CPU_SUP_TRANSMETA_32=y
> CONFIG_HPET_TIMER=y
> CONFIG_HPET_EMULATE_RTC=y
> CONFIG_DMI=y
> # CONFIG_IOMMU_HELPER is not set
> CONFIG_NR_CPUS=8
> # CONFIG_SCHED_SMT is not set
> CONFIG_SCHED_MC=y
> # CONFIG_IRQ_TIME_ACCOUNTING is not set
> CONFIG_PREEMPT_NONE=y
> # CONFIG_PREEMPT_VOLUNTARY is not set
> # CONFIG_PREEMPT is not set
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> # CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
> CONFIG_X86_MCE=y
> CONFIG_X86_MCE_INTEL=y
> CONFIG_X86_MCE_AMD=y
> # CONFIG_X86_ANCIENT_MCE is not set
> CONFIG_X86_MCE_THRESHOLD=y
> # CONFIG_X86_MCE_INJECT is not set
> CONFIG_X86_THERMAL_VECTOR=y
> CONFIG_VM86=y
> # CONFIG_TOSHIBA is not set
> CONFIG_I8K=m
> # CONFIG_X86_REBOOTFIXUPS is not set
> CONFIG_MICROCODE=y
> CONFIG_MICROCODE_INTEL=y
> CONFIG_MICROCODE_AMD=y

This should be =m because otherwise you can't load microcode from
userspace.

All I'm saying is, take some time to configure your kernel properly by
reading the help text of every option and enable only the ones you need.

And search the net for more info on how to configure your kernel
properly.

HTH.

-- 
Regards/Gruss,
    Boris.
