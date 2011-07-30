Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab1G3WV0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 18:21:26 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:47614 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab1G3WVW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 18:21:22 -0400
MIME-Version: 1.0
In-Reply-To: <1312059539.22074.16.camel@i7.infradead.org>
References: <1306707270.2029.377.camel@i7.infradead.org>
	<20110530072300.GA9802@elte.hu>
	<1306745835.2029.389.camel@i7.infradead.org>
	<20110530104231.GF17821@elte.hu>
	<20110530104656.GA19532@elte.hu>
	<E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
	<20110530105809.GA20133@elte.hu>
	<1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
	<alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6>
	<20110530195545.GG2890@dhcp-172-31-194-241.cam.corp.google.com>
	<alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6>
	<1306795186.2029.459.camel@i7.infradead.org>
	<BANLkTik=uHr1eX44XV1pAHUfVQ-MorzOnw@mail.gmail.com>
	<1306856937.27477.3.camel@i7.infradead.org>
	<BANLkTi=VoL8ze0AcdkG_QmEH5049X2K6Zw@mail.gmail.com>
	<4E0495F4.7080300@suse.cz>
	<1311986969.20983.52.camel@i7.infradead.org>
	<CACqU3MXeUiiQPc4t9bT7KuXuAjkN+t8eFn9SYOouPg-3hDgjWQ@mail.gmail.com>
	<alpine.LFD.2.02.1107301716430.21839@localhost6.localdomain6>
	<CACqU3MVY89L3B3=eFrmsgD2wzXtbQHssPm4D_-VZGEWNYBR4-Q@mail.gmail.com>
	<4E34548F.9040909@zytor.com>
	<1312059539.22074.16.camel@i7.infradead.org>
Date: Sat, 30 Jul 2011 18:21:22 -0400
Message-ID: <CACqU3MWDqyWGz72jTd01OdeVFT=X9+m-6AjNt6tTLj2oG2vB7w@mail.gmail.com>
Subject: Re: [PATCH v3] x86, kconfig: Default to ARCH=x86 to avoid overriding CONFIG_64BIT
From: Arnaud Lacombe <lacombar@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        "Ted Ts'o" <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jul 30, 2011 at 4:58 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Sat, 2011-07-30 at 11:59 -0700, H. Peter Anvin wrote:
>> For klibc integration, we ran into this problem as well: the set of
>> architectures for the kernel simply isn't the same set as the
>> architectures for userspace.  For the kernel, x86 is an architecture,
>> for userspace the architectures are x86_64 or i386 and they are
>> fundamentally different in many, many ways.
>>
>> The main problem with SUBARCH is that it is ill-defined in the general
>> case if SUBARCH contains a user space or a kernel space architecture.
>> In that sense I would much prefer it if was called, say, USERARCH and
>> was always available.  It could even be set by Kconfig
>> (CONFIG_USERARCH?)
>
> In the context of a kernel build that's meaningless though. One kernel
> can support *many* types of userspace.
>
> I've just been playing with ARCH=um. It looks like the current state,
> even before my patch, is that 'make ARCH=um SUBARCH=x86' is broken.
>
I fail to see how, to my understanding, something that has not been
thought to be used that way can be broken ...

> I'll work on a patch to fix that, and then it will be fine when the
> default for SUBARCH changes to be "x86".
>
I still fail to see why you want it that way... You want both ARCH and
SUBARCH to be 'x86' ?

This starts to be a hell lots of deep changes just to fix i386 build
under a fast x86-64 without having to specify ARCH=i386. That job
alone can be done a lot easier.

 - Arnaud

> (Another option is to make SUBARCH default to x86 *only* if ARCH!=um,
> and still use the legacy SUBARCH values when ARCH=um. But I'm not overly
> keen on that approach.)
>
> Fixing um to work with ARCH=x86 *ought* to be as simple as doing
> something like this:
>
> --- a/arch/um/Makefile
> +++ b/arch/um/Makefile
> @@ -12,6 +12,15 @@ OS := $(shell uname -s)
>  # features.
>  SHELL := /bin/bash
>
> +# The i386/x86_64 merge hasn't really happened in um-land yet. Fake it.
> +ifeq ($(SUBARCH),x86)
> +ifeq ($(CONFIG_64BIT),y)
> +SUBARCH := x86_64
> +else
> +SUBARCH := i386
> +endif
> +endif
> +
>  filechk_gen_header = $<
>
>  core-y                 += $(ARCH_DIR)/kernel/          \
>
> .. but that gives me weird behaviour where it just keeps running
> silentoldconfig over and over again.
>
> This patch *does* work, but I'll see if I can make it simpler...
>
> diff --git a/arch/um/Kconfig.x86 b/arch/um/Kconfig.x86
> index d31ecf3..576b732 100644
> --- a/arch/um/Kconfig.x86
> +++ b/arch/um/Kconfig.x86
> @@ -19,8 +19,8 @@ config UML_X86
>        select GENERIC_FIND_FIRST_BIT
>
>  config 64BIT
> -       bool
> -       default SUBARCH = "x86_64"
> +       bool "64-bit kernel" if SUBARCH = "x86"
> +       default SUBARCH != "i386"
>
>  config X86_32
>        def_bool !64BIT
> diff --git a/arch/um/Makefile b/arch/um/Makefile
> index fab8121..562c6cb 100644
> --- a/arch/um/Makefile
> +++ b/arch/um/Makefile
> @@ -12,6 +12,17 @@ OS := $(shell uname -s)
>  # features.
>  SHELL := /bin/bash
>
> +# The i386/x86_64 merge hasn't really happened in um-land yet. Fake it.
> +ifeq ($(SUBARCH),x86)
> +ifeq ($(CONFIG_64BIT),y)
> +UMSUBARCH := x86_64
> +else
> +UMSUBARCH := i386
> +endif
> +else
> +UMSUBARCH := $(SUBARCH)
> +endif
> +
>  filechk_gen_header = $<
>
>  core-y                 += $(ARCH_DIR)/kernel/          \
> @@ -24,11 +35,11 @@ include $(srctree)/$(ARCH_DIR)/Makefile-skas
>
>  SHARED_HEADERS := $(ARCH_DIR)/include/shared
>  ARCH_INCLUDE   := -I$(srctree)/$(SHARED_HEADERS)
> -ARCH_INCLUDE   += -I$(srctree)/$(ARCH_DIR)/sys-$(SUBARCH)/shared
> +ARCH_INCLUDE   += -I$(srctree)/$(ARCH_DIR)/sys-$(UMSUBARCH)/shared
>  ifneq ($(KBUILD_SRC),)
>  ARCH_INCLUDE   += -I$(SHARED_HEADERS)
>  endif
> -KBUILD_CPPFLAGS += -I$(srctree)/$(ARCH_DIR)/sys-$(SUBARCH)
> +KBUILD_CPPFLAGS += -I$(srctree)/$(ARCH_DIR)/sys-$(UMSUBARCH)
>
>  # -Dvmap=kernel_vmap prevents anything from referencing the libpcap.o symbol so
>  # named - it's a common symbol in libpcap, so we get a binary which crashes.
> @@ -38,7 +49,7 @@ KBUILD_CPPFLAGS += -I$(srctree)/$(ARCH_DIR)/sys-$(SUBARCH)
>  #
>  # These apply to USER_CFLAGS to.
>
> -KBUILD_CFLAGS += $(CFLAGS) $(CFLAGS-y) -D__arch_um__ -DSUBARCH=\"$(SUBARCH)\" \
> +KBUILD_CFLAGS += $(CFLAGS) $(CFLAGS-y) -D__arch_um__ -DSUBARCH=\"$(UMSUBARCH)\" \
>        $(ARCH_INCLUDE) $(MODE_INCLUDE) -Dvmap=kernel_vmap      \
>        -Din6addr_loopback=kernel_in6addr_loopback \
>        -Din6addr_any=kernel_in6addr_any
> @@ -49,7 +60,7 @@ USER_CFLAGS = $(patsubst $(KERNEL_DEFINES),,$(patsubst -D__KERNEL__,,\
>        $(patsubst -I%,,$(KBUILD_CFLAGS)))) $(ARCH_INCLUDE) $(MODE_INCLUDE) \
>        $(filter -I%,$(CFLAGS)) -D_FILE_OFFSET_BITS=64
>
> -include $(srctree)/$(ARCH_DIR)/Makefile-$(SUBARCH)
> +include $(srctree)/$(ARCH_DIR)/Makefile-$(UMSUBARCH)
>
>  #This will adjust *FLAGS accordingly to the platform.
>  include $(srctree)/$(ARCH_DIR)/Makefile-os-$(OS)
> @@ -128,8 +139,8 @@ archclean:
>
>  # Generated files
>
> -$(ARCH_DIR)/sys-$(SUBARCH)/user-offsets.s: FORCE
> -       $(Q)$(MAKE) $(build)=$(ARCH_DIR)/sys-$(SUBARCH) $@
> +$(ARCH_DIR)/sys-$(UMSUBARCH)/user-offsets.s: FORCE
> +       $(Q)$(MAKE) $(build)=$(ARCH_DIR)/sys-$(UMSUBARCH) $@
>
>  define filechk_gen-asm-offsets
>         (set -e; \
> @@ -144,11 +155,11 @@ define filechk_gen-asm-offsets
>          echo ""; )
>  endef
>
> -$(SHARED_HEADERS)/user_constants.h: $(ARCH_DIR)/sys-$(SUBARCH)/user-offsets.s
> +$(SHARED_HEADERS)/user_constants.h: $(ARCH_DIR)/sys-$(UMSUBARCH)/user-offsets.s
>        $(call filechk,gen-asm-offsets)
>
>  $(SHARED_HEADERS)/kern_constants.h:
>        $(Q)mkdir -p $(dir $@)
>        $(Q)echo '#include "../../../../include/generated/asm-offsets.h"' >$@
>
> -export SUBARCH USER_CFLAGS CFLAGS_NO_HARDENING OS HEADER_ARCH DEV_NULL_PATH
> +export SUBARCH UMSUBARCH USER_CFLAGS CFLAGS_NO_HARDENING OS HEADER_ARCH DEV_NULL_PATH
> diff --git a/arch/um/Makefile-i386 b/arch/um/Makefile-i386
> index 302cbe5..b66063b 100644
> --- a/arch/um/Makefile-i386
> +++ b/arch/um/Makefile-i386
> @@ -5,22 +5,22 @@ TOP_ADDR := $(CONFIG_TOP_ADDR)
>  START := 0x8048000
>
>  LDFLAGS                        += -m elf_i386
> -ELF_ARCH               := $(SUBARCH)
> -ELF_FORMAT             := elf32-$(SUBARCH)
> +ELF_ARCH               := $(UMSUBARCH)
> +ELF_FORMAT             := elf32-$(UMSUBARCH)
>  OBJCOPYFLAGS           := -O binary -R .note -R .comment -S
>  HEADER_ARCH            := x86
>  CHECKFLAGS     += -D__i386__
>
> -ifeq ("$(origin SUBARCH)", "command line")
> -ifneq ("$(shell uname -m | sed -e s/i.86/i386/)", "$(SUBARCH)")
> +#ifeq ("$(origin SUBARCH)", "command line")
> +#ifneq ("$(shell uname -m | sed -e s/i.86/i386/)", "$(SUBARCH)")
>  KBUILD_CFLAGS          += $(call cc-option,-m32)
>  KBUILD_AFLAGS          += $(call cc-option,-m32)
>  LINK-y                 += $(call cc-option,-m32)
>  UML_OBJCOPYFLAGS       += -F $(ELF_FORMAT)
>
>  export LDFLAGS HOSTCFLAGS HOSTLDFLAGS UML_OBJCOPYFLAGS
> -endif
> -endif
> +#endif
> +#endif
>
>  # First of all, tune CFLAGS for the specific CPU. This actually sets cflags-y.
>  include $(srctree)/arch/x86/Makefile_32.cpu
> diff --git a/arch/um/os-Linux/Makefile b/arch/um/os-Linux/Makefile
> index b33f4df..c1a2ca3 100644
> --- a/arch/um/os-Linux/Makefile
> +++ b/arch/um/os-Linux/Makefile
> @@ -5,7 +5,7 @@
>
>  obj-y = aio.o execvp.o file.o helper.o irq.o main.o mem.o process.o \
>        registers.o sigio.o signal.o start_up.o time.o tty.o uaccess.o \
> -       umid.o tls.o user_syms.o util.o drivers/ sys-$(SUBARCH)/ skas/
> +       umid.o tls.o user_syms.o util.o drivers/ sys-$(UMSUBARCH)/ skas/
>
>  obj-$(CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA) += elf_aux.o
>
>
> --
> dwmw2
>
>
