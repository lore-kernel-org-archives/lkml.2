Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751112Ab1AHHU5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 02:20:57 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:48972 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1AHHU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 02:20:56 -0500
Date: Sat, 8 Jan 2011 08:20:53 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
Cc: "'Paul Mundt'" <lethal@linux-sh.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv1 01/12] unicore32 core architecture: build
	infrastructure
Message-ID: <20110108072053.GA10552@merkur.ravnborg.org>
References: <00c601cba463$69533750$3bf9a5f0$@mprc.pku.edu.cn> <20110106075553.GC15914@linux-sh.org> <023601cbaef7$850f2af0$8f2d80d0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <023601cbaef7$850f2af0$8f2d80d0$@mprc.pku.edu.cn>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guan.

A few nits.

> +# Explicitly specifiy 32-bit UniCore ISA:
> +KBUILD_CFLAGS	+=$(call cc-option,-municore32)

If gcc does not support -municore32 then I assume it
is a wrong gcc version used.
So just add it unconditionally.

The cc-option macro is used to add options to gcc iff gcc
supports this option. So each time you use cc-option we
actually run gcc to determine if the opton is supported.


Also as a general rule add a space after the equal sign:
> +KBUILD_CFLAGS	+= -municore32
                          ^
> +
> +#Default value
> +head-y		:= arch/unicore32/kernel/head.o arch/unicore32/kernel/init_task.o
Break longer lines in two like this:
> +head-y		:= arch/unicore32/kernel/head.o
> +head-y		+= arch/unicore32/kernel/init_task.o

Note: I see lots of Makefile where longer lines are continued on
the next line using a '\'. But like in regular C code to use an incremental
assignment looks just better / is more clear.

> +textofs-y	:= 0x00408000
> +
> +# The byte offset of the kernel image in RAM from the start of RAM.
> +TEXT_OFFSET := $(textofs-y)

If you are going to have different TEXT_OFFSET's then I suggest to move
this to KConfig as an "hex "Text offset" config option.
You can set default values dependign on BSP etc.

Also defiing stuff here just to export it for use in boot/
has always looked like a strange concept - but many archs do so today.
You do not export TEXT_OFFSET but I guess this is a bug?

> +
> +export	TEXT_OFFSET GZFLAGS
This variable is never used.


> +
> +core-y				+= arch/unicore32/kernel/ arch/unicore32/mm/
> +core-$(CONFIG_UNICORE_FPU_F64)	+= arch/unicore32/uc-f64/
> +
> +drivers-$(CONFIG_ARCH_PUV3)	+= drivers/staging/puv3/
> +
> +libs-y				+= arch/unicore32/lib/
> +# include libc.a in libs-y for string functions, like memcpy and so on.
> +libs-y				+= $(shell $(CC) $(KBUILD_CFLAGS) -print-file-name=libc.a)
> +libs-y				+= $(shell $(CC) $(KBUILD_CFLAGS) -print-file-name=libgcc.a)
> +

The other three archs that uses libgcc use:

    $(shell $(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)

So when I read the above I am confused why it looks different than the others.
For libc I guess you do nto have that option and what you do is fine there.

> +
> +CLEAN_FILES += $(ASM_GENERIC_HEADERS)
> +
> +# We use MRPROPER_FILES and CLEAN_FILES now

Stale comment


> +  echo  '                  Install using (your) ~/bin/$(INSTALLKERNEL) or'
> +  echo  '                  (distribution) /sbin/$(INSTALLKERNEL) or'
> +  echo  '                  install to $$(INSTALL_PATH) and run lilo'

I do not think the three lines above is correct for unicore32.
Looks like they are left from a copy from x86.

	Sam
