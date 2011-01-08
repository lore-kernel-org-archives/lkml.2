Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750936Ab1AHFr1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 00:47:27 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:55829 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab1AHFrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 00:47:24 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "'Paul Mundt'" <lethal@linux-sh.org>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <00c601cba463$69533750$3bf9a5f0$@mprc.pku.edu.cn> <20110106075553.GC15914@linux-sh.org>
In-Reply-To: <20110106075553.GC15914@linux-sh.org>
Subject: RE: [PATCHv1 01/12] unicore32 core architecture: build infrastructure
Date: Sat, 8 Jan 2011 13:47:20 +0800
Message-ID: <023601cbaef7$850f2af0$8f2d80d0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQEfSwmwFZxtPXz+EiWqnhCTy4B4ZAEbQqKvlRZ7zLA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-arch-owner@vger.kernel.org [mailto:linux-arch-owner@vger.kernel.org] On Behalf Of Paul Mundt
> Sent: Thursday, January 06, 2011 3:56 PM
> To: Guan Xuetao
> Cc: linux-arch@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCHv1 01/12] unicore32 core architecture: build infrastructure
> 
> On Sun, Dec 26, 2010 at 02:41:58AM +0800, Guan Xuetao wrote:
> > diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
> > new file mode 100644
> > index 0000000..da59420
> > --- /dev/null
> > +++ b/arch/unicore32/Kconfig
> > @@ -0,0 +1,258 @@
> > +config UNICORE32
> > +	bool
> > +	default y
> > +	select HAVE_MEMBLOCK
> > +	select HAVE_GENERIC_DMA_COHERENT
> > +	select HAVE_DMA_ATTRS
> > +	select HAVE_KERNEL_GZIP
> > +	select HAVE_KERNEL_BZIP2
> > +	select HAVE_KERNEL_LZO
> > +	select HAVE_KERNEL_LZMA
> > +	select GENERIC_FIND_FIRST_BIT
> > +	select ARCH_WANT_FRAME_POINTERS
> 
> You want to select HAVE_GENERIC_HARDIRQS here.
Yes, changed.

> 
> > +config GENERIC_HARDIRQS
> > +	bool
> > +	default y
> > +
> > +config GENERIC_HARDIRQS_NO__DO_IRQ
> > +	def_bool y
> > +
> 
> Then you can get rid of these, and source kernel/irq/Kconfig.
Removed, and kernel/irq/Kconfig is included in init/Kconfig, just be ok.

> 
> > +# arch/unicore32/Makefile
> > +#
> > +# This file is included by the global makefile so that you can add your own
> > +# architecture-specific flags and dependencies.
> > +#
> > +# This file is subject to the terms and conditions of the GNU General Public
> > +# License.  See the file "COPYING" in the main directory of this archive
> > +# for more details.
> > +#
> > +# Copyright (C) 2002~2010 by Guan Xue-tao
> > +LOCALVERSION	:= -uc32
> > +
> > +CROSS_COMPILE	:= /usr/unicore/gnu-toolchain-unicore/uc4/bin/unicore32-linux-
> > +
> This isn't terribly portable. You can elect to tie in cc-cross-prefix
> like other architectures, or just drop it entirely and store it in your
> .config (see the top-level Makefile for generic CROSS_COMPILE handling
> options).
> 
> > +INSTALL_MOD_PATH := $(obj)/usr
> > +
> This and the LOCALVERSION specifications are pretty nasty surprises for
> users. This is all handled generically for a reason, so please kill off
> of this off.
> 
> > +LDFLAGS_vmlinux	:=-p --no-undefined -X
> > +
> > +OBJCOPYFLAGS	:=-O binary -R .note -R .note.gnu.build-id -R .comment -S
> > +GZFLAGS		:=-9
> > +#KBUILD_CFLAGS	+=-pipe
> > +# Explicitly specifiy 32-bit UniCore ISA:
> > +KBUILD_CFLAGS	+=$(call cc-option,-municore,)
> > +
> > +# Never generate .eh_frame
> > +KBUILD_CFLAGS	+= $(call cc-option,-fno-dwarf2-cfi-asm)
> > +
> > +ifeq ($(CONFIG_FRAME_POINTER),y)
> > +KBUILD_CFLAGS	+=-fno-omit-frame-pointer -mno-sched-prolog
> > +endif
> > +
> -fno-omit-frame-pointer is handled generically, so there is no need for
> it here.
> 
> > +KBUILD_CPPFLAGS	+= -mlittle-endian
> > +AS		+= -EL
> > +LD		+= -EL
> > +
> No. If you need to set AS and LD flags for endianness, then do so
> explicitly. See how every other architecture is doing this. You may also
> wish to read through Documentation/kbuild/makefiles.txt carefully.
> 
> > +comma = ,
> > +
> This is unused?
> 
> > +# Need -Uunicore32 for gcc < 3.x
> > +# delete -mstructure-size-boundary=32, and default being 8
> > +# delete -funsigned-char, and default being signed-char
> > +KBUILD_CFLAGS	+=$(call cc-option,-mshort-load-bytes,$(call cc-option,-malignment-traps,)) -msoft-float -Uunicore32
> > +KBUILD_AFLAGS	+=-msoft-float
> > +
> Is it realistic to even support gcc 2.x versions on a recent kernel?
> 
> > +drivers-$(CONFIG_ARCH_PUV3)	+= drivers/staging/puv3/
> > +
> > +libs-y				+= arch/unicore32/lib/
> > +libs-y				+= $(shell $(CC) $(KBUILD_CFLAGS) -print-file-name=libc.a)
> > +libs-y				+= $(shell $(CC) $(KBUILD_CFLAGS) -print-file-name=libgcc.a)
> > +
> The libgcc thing is not too surprising, but you do have
> -print-libgcc-file-name for this. That libc.a thing however needs some
> explaining.
All  above is corrected,  please see following  arch/unicore32/Makefile:

diff --git a/arch/unicore32/Makefile b/arch/unicore32/Makefile
new file mode 100644
index 0000000..8718152
--- /dev/null
+++ b/arch/unicore32/Makefile
@@ -0,0 +1,144 @@
+#
+# arch/unicore32/Makefile
+#
+# This file is included by the global makefile so that you can add your own
+# architecture-specific flags and dependencies.
+#
+# This file is subject to the terms and conditions of the GNU General Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+# Copyright (C) 2002~2010 by Guan Xue-tao
+ifneq ($(SUBARCH),$(ARCH))
+	ifeq ($(CROSS_COMPILE),)
+		CROSS_COMPILE := $(call cc-cross-prefix, unicore32-linux-)
+	endif
+endif
+
+LDFLAGS_vmlinux	:=-p --no-undefined -X
+
+OBJCOPYFLAGS	:=-O binary -R .note -R .note.gnu.build-id -R .comment -S
+GZFLAGS		:=-9
+
+# Explicitly specifiy 32-bit UniCore ISA:
+KBUILD_CFLAGS	+=$(call cc-option,-municore32)
+
+# Never generate .eh_frame
+KBUILD_CFLAGS	+=$(call cc-option,-fno-dwarf2-cfi-asm)
+
+KBUILD_CFLAGS	+=-msoft-float
+
+ifeq ($(CONFIG_FRAME_POINTER),y)
+KBUILD_CFLAGS	+=-mno-sched-prolog
+endif
+
+CHECKFLAGS	+= -D__unicore32__
+
+#Default value
+head-y		:= arch/unicore32/kernel/head.o arch/unicore32/kernel/init_task.o
+textofs-y	:= 0x00408000
+
+# The byte offset of the kernel image in RAM from the start of RAM.
+TEXT_OFFSET := $(textofs-y)
+
+export	TEXT_OFFSET GZFLAGS
+
+core-y				+= arch/unicore32/kernel/ arch/unicore32/mm/
+core-$(CONFIG_UNICORE_FPU_F64)	+= arch/unicore32/uc-f64/
+
+drivers-$(CONFIG_ARCH_PUV3)	+= drivers/staging/puv3/
+
+libs-y				+= arch/unicore32/lib/
+# include libc.a in libs-y for string functions, like memcpy and so on.
+libs-y				+= $(shell $(CC) $(KBUILD_CFLAGS) -print-file-name=libc.a)
+libs-y				+= $(shell $(CC) $(KBUILD_CFLAGS) -print-file-name=libgcc.a)
+
+# Default target when executing plain make
+KBUILD_IMAGE := zImage
+
+all:	$(KBUILD_IMAGE)
+
+boot := arch/unicore32/boot
+
+ASM_GENERIC_HEADERS	:= arch/unicore32/include/asm/atomic.h			\
+			   arch/unicore32/include/asm/auxvec.h			\
+			   arch/unicore32/include/asm/bitsperlong.h		\
+			   arch/unicore32/include/asm/bug.h			\
+			   arch/unicore32/include/asm/bugs.h			\
+			   arch/unicore32/include/asm/cputime.h			\
+			   arch/unicore32/include/asm/current.h			\
+			   arch/unicore32/include/asm/device.h			\
+			   arch/unicore32/include/asm/div64.h			\
+			   arch/unicore32/include/asm/emergency-restart.h	\
+			   arch/unicore32/include/asm/errno.h			\
+			   arch/unicore32/include/asm/fb.h			\
+			   arch/unicore32/include/asm/fcntl.h			\
+			   arch/unicore32/include/asm/hardirq.h			\
+			   arch/unicore32/include/asm/hw_irq.h			\
+			   arch/unicore32/include/asm/ioctl.h			\
+			   arch/unicore32/include/asm/ioctls.h			\
+			   arch/unicore32/include/asm/ipcbuf.h			\
+			   arch/unicore32/include/asm/irq_regs.h		\
+			   arch/unicore32/include/asm/kdebug.h			\
+			   arch/unicore32/include/asm/kmap_types.h		\
+			   arch/unicore32/include/asm/local.h			\
+			   arch/unicore32/include/asm/mman.h			\
+			   arch/unicore32/include/asm/module.h			\
+			   arch/unicore32/include/asm/msgbuf.h			\
+			   arch/unicore32/include/asm/param.h			\
+			   arch/unicore32/include/asm/parport.h			\
+			   arch/unicore32/include/asm/percpu.h			\
+			   arch/unicore32/include/asm/poll.h			\
+			   arch/unicore32/include/asm/posix_types.h		\
+			   arch/unicore32/include/asm/resource.h		\
+			   arch/unicore32/include/asm/scatterlist.h		\
+			   arch/unicore32/include/asm/sections.h		\
+			   arch/unicore32/include/asm/sembuf.h			\
+			   arch/unicore32/include/asm/serial.h			\
+			   arch/unicore32/include/asm/shmbuf.h			\
+			   arch/unicore32/include/asm/shmparam.h		\
+			   arch/unicore32/include/asm/siginfo.h			\
+			   arch/unicore32/include/asm/signal.h			\
+			   arch/unicore32/include/asm/socket.h			\
+			   arch/unicore32/include/asm/sockios.h			\
+			   arch/unicore32/include/asm/statfs.h			\
+			   arch/unicore32/include/asm/termbits.h		\
+			   arch/unicore32/include/asm/termios.h			\
+			   arch/unicore32/include/asm/topology.h		\
+			   arch/unicore32/include/asm/types.h			\
+			   arch/unicore32/include/asm/ucontext.h		\
+			   arch/unicore32/include/asm/unaligned.h		\
+			   arch/unicore32/include/asm/user.h			\
+			   arch/unicore32/include/asm/vga.h			\
+			   arch/unicore32/include/asm/xor.h
+
+%.h:
+	$(Q)echo '#include <asm-generic/$(notdir $@)>' > $@
+
+archprepare: $(ASM_GENERIC_HEADERS)
+
+# Convert bzImage to zImage
+bzImage: zImage
+
+zImage Image uImage: vmlinux
+	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
+
+zinstall install: vmlinux
+	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $@
+
+CLEAN_FILES += $(ASM_GENERIC_HEADERS)
+
+# We use MRPROPER_FILES and CLEAN_FILES now
+archclean:
+	$(Q)$(MAKE) $(clean)=$(boot)
+
+define archhelp
+  echo  '* zImage        - Compressed kernel image (arch/$(ARCH)/boot/zImage)'
+  echo  '  Image         - Uncompressed kernel image (arch/$(ARCH)/boot/Image)'
+  echo  '  uImage        - U-Boot wrapped zImage'
+  echo  '  install       - Install uncompressed kernel'
+  echo  '  zinstall      - Install compressed kernel'
+  echo  '                  Install using (your) ~/bin/$(INSTALLKERNEL) or'
+  echo  '                  (distribution) /sbin/$(INSTALLKERNEL) or'
+  echo  '                  install to $$(INSTALL_PATH) and run lilo'
+endef

> 
> > diff --git a/arch/unicore32/kernel/asm-offsets.c b/arch/unicore32/kernel/asm-offsets.c
> > new file mode 100644
> > index 0000000..ffcbe75
> > --- /dev/null
> > +++ b/arch/unicore32/kernel/asm-offsets.c
> > +/*
> > + * GCC 3.0, 3.1: general bad code generation.
> > + * GCC 3.2.0: incorrect function argument offset calculation.
> > + * GCC 3.2.x: miscompiles NEW_AUX_ENT in fs/binfmt_elf.c
> > + *	(http://gcc.gnu.org/PR8896) and incorrect structure
> > + *		initialisation in fs/jffs2/erase.c
> > + */
> > +#if (__GNUC__ < 4)
> > +#error Your compiler should upgrade to uc4
> > +#error	Known good compilers: 4.2.2
> > +#endif
> > +
> If your compiler situation is this screwed up, then you need to be
> erroring out in the Makefile, and you can most certainly kill off that
> gcc 2.x cruft.
OK.

> 
> > +++ b/arch/unicore32/kernel/vmlinux.lds.S
> > @@ -0,0 +1,120 @@
> > +/*
> > + * linux/arch/unicore32/kernel/vmlinux.lds.S
> > + *
> > + * Code specific to PKUnity SoC and UniCore ISA
> > + *
> > + * Copyright (C) 2001-2010 GUAN Xue-tao
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#include <asm-generic/vmlinux.lds.h>
> > +#include <asm/thread_info.h>
> > +#include <asm/memory.h>
> > +#include <asm/page.h>
> > +
> > +OUTPUT_ARCH(unicore32)
> > +ENTRY(stext)
> > +
> > +jiffies = jiffies_64;
> > +
> > +SECTIONS
> > +{
> > +	. = PAGE_OFFSET + TEXT_OFFSET;
> > +
> > +	.init : {			/* Init code and data		*/
> > +		_stext = .;
> > +		_sinittext = .;
> > +			HEAD_TEXT
> > +			INIT_TEXT
> > +		_einittext = .;
> > +
> > +		INIT_SETUP(16)
> > +
> > +		INIT_CALLS
> > +		CON_INITCALL
> > +		SECURITY_INITCALL
> > +		INIT_RAM_FS
> > +
> > +		__init_begin = _stext;
> > +		INIT_DATA
> > +	}
> > +
> This looks really broken, please take a look at asm-generic/vmlinux.lds.h
> and use that as a model. Any reasons you have for needing to deviate from
> that should be thoroughly explained.
Ok, I will rewrite this file lator.

Thanks paul.

Guan Xuetao


