Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab2LZGcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 01:32:08 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:44046 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab2LZGcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 01:32:05 -0500
Date: Tue, 25 Dec 2012 22:32:01 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        dwmw2@infradead.org, tglx@linutronix.de,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
cc: linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/build] x86: Default to ARCH= x86 to avoid overriding
 CONFIG_64BIT
In-Reply-To: <tip-ffee0de411fd4f74f3b788892eeb075abbf26c52@git.kernel.org>
Message-ID: <alpine.DEB.2.00.1212252222450.24528@chino.kir.corp.google.com>
References: <1356040315.3198.51.camel@shinybook.infradead.org> <tip-ffee0de411fd4f74f3b788892eeb075abbf26c52@git.kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2012, tip-bot for David Woodhouse wrote:

> diff --git a/Makefile b/Makefile
> index 540f7b2..9a07340 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -165,7 +165,8 @@ export srctree objtree VPATH
>  # then ARCH is assigned, getting whatever value it gets normally, and 
>  # SUBARCH is subsequently ignored.
>  
> -SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
> +SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
> +				  -e s/sun4u/sparc64/ \
>  				  -e s/arm.*/arm/ -e s/sa110/arm/ \
>  				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
>  				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 46c3bff..9084c7b 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1,7 +1,7 @@
>  # Select 32 or 64 bit
>  config 64BIT
>  	bool "64-bit kernel" if ARCH = "x86"
> -	default ARCH = "x86_64"
> +	default ARCH != "i386"
>  	---help---
>  	  Say yes to build a 64-bit kernel - formerly known as x86_64
>  	  Say no to build a 32-bit kernel - formerly known as i386
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index 05afcca..fa981ca 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -2,7 +2,11 @@
>  
>  # select defconfig based on actual architecture
>  ifeq ($(ARCH),x86)
> +  ifeq ($(shell uname -m),x86_64)
> +        KBUILD_DEFCONFIG := x86_64_defconfig
> +  else
>          KBUILD_DEFCONFIG := i386_defconfig
> +  endif
>  else
>          KBUILD_DEFCONFIG := $(ARCH)_defconfig
>  endif
> diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
> index 5598547..9444708 100644
> --- a/arch/x86/configs/i386_defconfig
> +++ b/arch/x86/configs/i386_defconfig
> @@ -1,3 +1,4 @@
> +# CONFIG_64BIT is not set
>  CONFIG_EXPERIMENTAL=y
>  # CONFIG_LOCALVERSION_AUTO is not set
>  CONFIG_SYSVIPC=y

This creates quite a few build failures on auto-latest:

arch/x86/built-in.o: In function `hpet_setup_msi_irq':
hpet.c:(.text+0x34638): undefined reference to `arch_setup_hpet_msi'
hpet.c:(.text+0x34651): undefined reference to `destroy_irq'
arch/x86/built-in.o: In function `hpet_msi_capability_lookup':
hpet.c:(.text+0x347ff): undefined reference to `create_irq_nr'
arch/x86/built-in.o:(.data+0xd1c): undefined reference to `native_setup_msi_irqs'
arch/x86/built-in.o:(.data+0xd20): undefined reference to `native_teardown_msi_irq'
drivers/built-in.o: In function `dmar_set_interrupt':
(.text+0x89eec0): undefined reference to `create_irq'
drivers/built-in.o: In function `dmar_set_interrupt':
(.text+0x89ef0b): undefined reference to `arch_setup_dmar_msi'
drivers/built-in.o: In function `dmar_set_interrupt':
(.text+0x89ef44): undefined reference to `destroy_irq'
drivers/built-in.o: In function `free_dmar_iommu':
(.text+0x8a6ae8): undefined reference to `destroy_irq'

These functions require CONFIG_X86_IO_APIC, which is only possible with 
X86_64 or X86_32_NON_STANDARD.  CONFIG_HPET_TIMER, however, can be enabled 
with X86_32, and CONFIG_DMAR_TABLE can be enabled with any X86 via 
CONFIG_INTEL_IOMMU.

That said, I didn't try to fix this up because I believe the commit itself 
is wrong.  When I do "make randconfig" and uname -m is x86_64, I expect 
CONFIG_64BIT to always be set.  This commit makes this random for all x86 
so that "make randconfig" may result in a 32-bit build.  That should be 
the behavior for "make ARCH=i386 randconfig" but not "make randconfig" on 
a 64-bit machine.
