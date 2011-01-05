Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab1AEMAC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 07:00:02 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:35591 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751716Ab1AEL77 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 06:59:59 -0500
From: Carmelo AMOROSO <carmelo.amoroso@st.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Filippo ARCIDIACONO <filippo.arcidiacono@st.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "vapier@gentoo.org" <vapier@gentoo.org>,
        "nico@fluxnic.net" <nico@fluxnic.net>
Date: Wed, 5 Jan 2011 12:59:18 +0100
Subject: Re: [PATCH 1/2] stackprotector: add stack smashing protector
 generic implementation
Thread-Topic: [PATCH 1/2] stackprotector: add stack smashing protector
 generic implementation
Thread-Index: Acusz/wCt1NLUlNjT4Sk9FyFl9MPdA==
Message-ID: <4D245D16.5010702@st.com>
References: <1293111851-7175-1-git-send-email-filippo.arcidiacono@st.com>
In-Reply-To: <1293111851-7175-1-git-send-email-filippo.arcidiacono@st.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-enigmail-version: 1.1.1
user-agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13)
 Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/23/2010 2:44 PM, Filippo ARCIDIACONO wrote:
> The current implementation of SSP used for ARM architecture is based
> on the global variable __stack_chk_guard
> (see commit c743f38013aeff58ef6252601e397b5ba281c633 by Nicolas Pitre).
> This implementation should be generic enough to be used for all
> architectures that rely upon that global variable (i.e. SH), so the
> ARM code can be widely used for all those architectures.
> The kbuild uses a script to check if the architecture does actually
> need to define the __stack_chk_guard, so it will use the generic SSP
> code, otherwise it will fall back to the architecture specific one
> (i.e. x86, x86_64).
> 
> Signed-off-by: Filippo Arcidiacono <filippo.arcidiacono@st.com>
> Signed-off-by: Carmelo Amoroso <carmelo.amoroso@st.com>
> ---
>  Makefile                                   |   14 ++++++++-
>  arch/Kconfig                               |   16 +++++++++++
>  arch/arm/Kconfig                           |   12 --------
>  arch/arm/Makefile                          |    4 ---
>  arch/arm/include/asm/stackprotector.h      |   38 ---------------------------
>  arch/arm/kernel/process.c                  |    6 ----
>  arch/x86/Kconfig                           |   16 -----------
>  include/asm-generic/stackprotector.h       |   39 ++++++++++++++++++++++++++++
>  include/linux/stackprotector.h             |    6 +++-
>  init/main.c                                |    5 +++
>  scripts/gcc-generic-has-stack-protector.sh |    9 ++++++
>  11 files changed, 86 insertions(+), 79 deletions(-)
>  delete mode 100644 arch/arm/include/asm/stackprotector.h
>  create mode 100644 include/asm-generic/stackprotector.h
>  create mode 100755 scripts/gcc-generic-has-stack-protector.sh
> 
> diff --git a/Makefile b/Makefile
> index 77044b7..7530650 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -550,8 +550,18 @@ KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
>  endif
>  
>  # Force gcc to behave correct even for buggy distributions
> -ifndef CONFIG_CC_STACKPROTECTOR
> -KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
> +ifdef CONFIG_CC_STACKPROTECTOR
> +stackp-y := $(call cc-option,-fstack-protector)
> +ifeq ($(stackp-y),)
> +  $(warning stack protector enabled but no compiler support)
> +else
> +cc_has_sp := $(srctree)/scripts/gcc-generic-has-stack-protector.sh
> +ifeq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC)), y)
> +  KBUILD_CFLAGS += $(stackp-y) -D__ARCH_WANT_STACK_CHK_GUARD
> +endif
> +endif
> +else
> +  KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
>  endif
>  
>  ifdef CONFIG_FRAME_POINTER
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 8bf0fa6..083245d 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -175,4 +175,20 @@ config HAVE_PERF_EVENTS_NMI
>  config HAVE_ARCH_JUMP_LABEL
>  	bool
>  
> +config CC_STACKPROTECTOR
> +	bool "Enable -fstack-protector buffer overflow detection"
> +	help
> +	  This option turns on the -fstack-protector GCC feature. This
> +	  feature puts, at the beginning of functions, a canary value on
> +	  the stack just before the return address, and validates
> +	  the value just before actually returning.  Stack based buffer
> +	  overflows (that need to overwrite this return address) now also
> +	  overwrite the canary, which gets detected and the attack is then
> +	  neutralized via a kernel panic.
> +
> +	  This feature requires gcc version 4.2 or above, or a distribution
> +	  gcc with the feature backported. Older versions are automatically
> +	  detected and for those versions, this configuration option is
> +	  ignored. (and a warning is printed during bootup)
> +
>  source "kernel/gcov/Kconfig"
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index d56d21c..58c29a5 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1522,18 +1522,6 @@ config SECCOMP
>  	  and the task is only allowed to execute a few safe syscalls
>  	  defined by each seccomp mode.
>  
> -config CC_STACKPROTECTOR
> -	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
> -	help
> -	  This option turns on the -fstack-protector GCC feature. This
> -	  feature puts, at the beginning of functions, a canary value on
> -	  the stack just before the return address, and validates
> -	  the value just before actually returning.  Stack based buffer
> -	  overflows (that need to overwrite this return address) now also
> -	  overwrite the canary, which gets detected and the attack is then
> -	  neutralized via a kernel panic.
> -	  This feature requires gcc version 4.2 or above.
> -
>  config DEPRECATED_PARAM_STRUCT
>  	bool "Provide old way to pass kernel parameters"
>  	help
> diff --git a/arch/arm/Makefile b/arch/arm/Makefile
> index b87aed0..ebbd003 100644
> --- a/arch/arm/Makefile
> +++ b/arch/arm/Makefile
> @@ -37,10 +37,6 @@ ifeq ($(CONFIG_FRAME_POINTER),y)
>  KBUILD_CFLAGS	+=-fno-omit-frame-pointer -mapcs -mno-sched-prolog
>  endif
>  
> -ifeq ($(CONFIG_CC_STACKPROTECTOR),y)
> -KBUILD_CFLAGS	+=-fstack-protector
> -endif
> -
>  ifeq ($(CONFIG_CPU_BIG_ENDIAN),y)
>  KBUILD_CPPFLAGS	+= -mbig-endian
>  AS		+= -EB
> diff --git a/arch/arm/include/asm/stackprotector.h b/arch/arm/include/asm/stackprotector.h
> deleted file mode 100644
> index de00332..0000000
> --- a/arch/arm/include/asm/stackprotector.h
> +++ /dev/null
> @@ -1,38 +0,0 @@
> -/*
> - * GCC stack protector support.
> - *
> - * Stack protector works by putting predefined pattern at the start of
> - * the stack frame and verifying that it hasn't been overwritten when
> - * returning from the function.  The pattern is called stack canary
> - * and gcc expects it to be defined by a global variable called
> - * "__stack_chk_guard" on ARM.  This unfortunately means that on SMP
> - * we cannot have a different canary value per task.
> - */
> -
> -#ifndef _ASM_STACKPROTECTOR_H
> -#define _ASM_STACKPROTECTOR_H 1
> -
> -#include <linux/random.h>
> -#include <linux/version.h>
> -
> -extern unsigned long __stack_chk_guard;
> -
> -/*
> - * Initialize the stackprotector canary value.
> - *
> - * NOTE: this must only be called from functions that never return,
> - * and it must always be inlined.
> - */
> -static __always_inline void boot_init_stack_canary(void)
> -{
> -	unsigned long canary;
> -
> -	/* Try to get a semi random initial value. */
> -	get_random_bytes(&canary, sizeof(canary));
> -	canary ^= LINUX_VERSION_CODE;
> -
> -	current->stack_canary = canary;
> -	__stack_chk_guard = current->stack_canary;
> -}
> -
> -#endif	/* _ASM_STACKPROTECTOR_H */
> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> index e76fcaa..067b4de 100644
> --- a/arch/arm/kernel/process.c
> +++ b/arch/arm/kernel/process.c
> @@ -39,12 +39,6 @@
>  #include <asm/stacktrace.h>
>  #include <asm/mach/time.h>
>  
> -#ifdef CONFIG_CC_STACKPROTECTOR
> -#include <linux/stackprotector.h>
> -unsigned long __stack_chk_guard __read_mostly;
> -EXPORT_SYMBOL(__stack_chk_guard);
> -#endif
> -
>  static const char *processor_modes[] = {
>    "USER_26", "FIQ_26" , "IRQ_26" , "SVC_26" , "UK4_26" , "UK5_26" , "UK6_26" , "UK7_26" ,
>    "UK8_26" , "UK9_26" , "UK10_26", "UK11_26", "UK12_26", "UK13_26", "UK14_26", "UK15_26",
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index e330da2..b8704dd 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1455,22 +1455,6 @@ config SECCOMP
>  
>  	  If unsure, say Y. Only embedded should say N here.
>  
> -config CC_STACKPROTECTOR
> -	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
> -	---help---
> -	  This option turns on the -fstack-protector GCC feature. This
> -	  feature puts, at the beginning of functions, a canary value on
> -	  the stack just before the return address, and validates
> -	  the value just before actually returning.  Stack based buffer
> -	  overflows (that need to overwrite this return address) now also
> -	  overwrite the canary, which gets detected and the attack is then
> -	  neutralized via a kernel panic.
> -
> -	  This feature requires gcc version 4.2 or above, or a distribution
> -	  gcc with the feature backported. Older versions are automatically
> -	  detected and for those versions, this configuration option is
> -	  ignored. (and a warning is printed during bootup)
> -
>  source kernel/Kconfig.hz
>  
>  config KEXEC
> diff --git a/include/asm-generic/stackprotector.h b/include/asm-generic/stackprotector.h
> new file mode 100644
> index 0000000..2cf9c65
> --- /dev/null
> +++ b/include/asm-generic/stackprotector.h
> @@ -0,0 +1,39 @@
> +/*
> + * GCC stack protector support.
> + * (Generic implementation based on __stack_chk_guard)
> + *
> + * Stack protector works by putting predefined pattern at the start of
> + * the stack frame and verifying that it hasn't been overwritten when
> + * returning from the function.  The pattern is called stack canary
> + * and gcc expects it to be defined by a global variable called
> + * "__stack_chk_guard". This unfortunately means that on SMP
> + * we cannot have a different canary value per task.
> + */
> +
> +#ifndef _LINUX_STACKPROTECTOR_H
> +#error "Never use <asm-generic/stackprotector.h> directly; \
> +include <linux/stackprotector.h> instead."
> +#endif
> +
> +#include <linux/random.h>
> +#include <linux/version.h>
> +
> +extern unsigned long __stack_chk_guard;
> +
> +/*
> + * Initialize the stackprotector canary value.
> + *
> + * NOTE: this must only be called from functions that never return,
> + * and it must always be inlined.
> + */
> +static __always_inline void boot_init_stack_canary(void)
> +{
> +	unsigned long canary;
> +
> +	/* Try to get a semi random initial value. */
> +	get_random_bytes(&canary, sizeof(canary));
> +	canary ^= LINUX_VERSION_CODE;
> +
> +	current->stack_canary = canary;
> +	__stack_chk_guard = current->stack_canary;
> +}
> diff --git a/include/linux/stackprotector.h b/include/linux/stackprotector.h
> index 6f3e54c..d71a437 100644
> --- a/include/linux/stackprotector.h
> +++ b/include/linux/stackprotector.h
> @@ -6,7 +6,11 @@
>  #include <linux/random.h>
>  
>  #ifdef CONFIG_CC_STACKPROTECTOR
> -# include <asm/stackprotector.h>
> +#ifdef __ARCH_WANT_STACK_CHK_GUARD
> +#include <asm-generic/stackprotector.h>
> +#else
> +#include <asm/stackprotector.h>
> +#endif
>  #else
>  static inline void boot_init_stack_canary(void)
>  {
> diff --git a/init/main.c b/init/main.c
> index 8646401..8b2e070 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -78,6 +78,11 @@
>  #include <asm/smp.h>
>  #endif
>  
> +#if defined CONFIG_CC_STACKPROTECTOR && defined __ARCH_WANT_STACK_CHK_GUARD
> +unsigned long __stack_chk_guard __read_mostly;
> +EXPORT_SYMBOL(__stack_chk_guard);
> +#endif
> +
>  static int kernel_init(void *);
>  
>  extern void init_IRQ(void);
> diff --git a/scripts/gcc-generic-has-stack-protector.sh b/scripts/gcc-generic-has-stack-protector.sh
> new file mode 100755
> index 0000000..11cc914
> --- /dev/null
> +++ b/scripts/gcc-generic-has-stack-protector.sh
> @@ -0,0 +1,9 @@
> +#!/bin/sh
> +
> +echo "int foo(void) { char X[200]; return 3; }" | $1 -S -xc -c -O0 \
> +-fstack-protector - -o - 2> /dev/null | grep -q __stack_chk_guard
> +if [ "$?" -eq "0" ] ; then
> +	echo y
> +else
> +	echo n
> +fi

Is someone interested into this stuff ?

Thanks,
Carmelo
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk0kXRYACgkQoRq/3BrK1s+ZOwCfdZ80u8gdnA9fJikmL+uxsX5I
RWkAn2KUqB4F/RSQ6stRj4ajoPgvCRCa
=ub67
-----END PGP SIGNATURE-----
