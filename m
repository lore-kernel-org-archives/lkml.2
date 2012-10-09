Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab2JIR1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:27:38 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50721 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484Ab2JIR1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:27:35 -0400
Date: Tue, 9 Oct 2012 18:27:31 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] ARM: pass -marm to gcc by default for both C and
 assembler
Message-ID: <20121009172731.GC2122@linaro.org>
References: <1349796183-30648-1-git-send-email-arnd@arndb.de>
 <1349796183-30648-7-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349796183-30648-7-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 05:23:00PM +0200, Arnd Bergmann wrote:
> The Linaro cross toolchain and probably others nowadays default to
> building in THUMB2 mode. When building a kernel for a CPU that does
> not support THUMB2, the compiler complains about incorrect flags.
> We can work around this by setting -marm for all non-T2 builds.
> 
> Without this patch, building assabet_defconfig results in:
> 
> usr/initramfs_data.S:1:0: warning: target CPU does not support THUMB instructions [enabled by default]
> arch/arm/nwfpe/entry.S:1:0: warning: target CPU does not support THUMB instructions [enabled by default]
> firmware/cis/PCMLM28.cis.gen.S:1:0: warning: target CPU does not support THUMB instructions [enabled by default]
> (and many more)
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Nicolas Pitre <nico@linaro.org>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Dave Martin <dave.martin@linaro.org>

This looks like a sensible fix, but it could be worth amending the
commit message to explain what was fixed, since it took me a moment or
two to puzzle out why the code this patch removes was broken.  Maybe
something like:

-marm was passed unconditionally for C files previously, but nothing was
passed to the gcc frontend when processing .S files, resulting in a
warning.  The assembler never defaults to ARM unless -Wa,-mthumb is
supplied explicitly, so the files were still assembled correctly.

This patch makes sure that -marm is passed for .S files too, and also
avoids the redundant gcc -marm -mthumb in Thumb kernels.


Preferably with that (or equivalent):

Acked-by: Dave Martin <dave.martin@linaro.org>

> ---
>  arch/arm/Makefile |   13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/Makefile b/arch/arm/Makefile
> index f023e3a..5f914fc 100644
> --- a/arch/arm/Makefile
> +++ b/arch/arm/Makefile
> @@ -21,8 +21,6 @@ endif
>  OBJCOPYFLAGS	:=-O binary -R .comment -S
>  GZFLAGS		:=-9
>  #KBUILD_CFLAGS	+=-pipe
> -# Explicitly specifiy 32-bit ARM ISA since toolchain default can be -mthumb:
> -KBUILD_CFLAGS	+=$(call cc-option,-marm,)
>  
>  # Never generate .eh_frame
>  KBUILD_CFLAGS	+= $(call cc-option,-fno-dwarf2-cfi-asm)
> @@ -105,17 +103,20 @@ endif
>  ifeq ($(CONFIG_THUMB2_KERNEL),y)
>  AFLAGS_AUTOIT	:=$(call as-option,-Wa$(comma)-mimplicit-it=always,-Wa$(comma)-mauto-it)
>  AFLAGS_NOWARN	:=$(call as-option,-Wa$(comma)-mno-warn-deprecated,-Wa$(comma)-W)
> -CFLAGS_THUMB2	:=-mthumb $(AFLAGS_AUTOIT) $(AFLAGS_NOWARN)
> -AFLAGS_THUMB2	:=$(CFLAGS_THUMB2) -Wa$(comma)-mthumb
> +CFLAGS_ISA	:=-mthumb $(AFLAGS_AUTOIT) $(AFLAGS_NOWARN)
> +AFLAGS_ISA	:=$(CFLAGS_ISA) -Wa$(comma)-mthumb
>  # Work around buggy relocation from gas if requested:
>  ifeq ($(CONFIG_THUMB2_AVOID_R_ARM_THM_JUMP11),y)
>  CFLAGS_MODULE	+=-fno-optimize-sibling-calls
>  endif
> +else
> +CFLAGS_ISA	:=$(call cc-option,-marm,)
> +AFLAGS_ISA	:=$(CFLAGS_ISA)
>  endif
>  
>  # Need -Uarm for gcc < 3.x
> -KBUILD_CFLAGS	+=$(CFLAGS_ABI) $(CFLAGS_THUMB2) $(arch-y) $(tune-y) $(call cc-option,-mshort-load-bytes,$(call cc-option,-malignment-traps,)) -msoft-float -Uarm
> -KBUILD_AFLAGS	+=$(CFLAGS_ABI) $(AFLAGS_THUMB2) $(arch-y) $(tune-y) -include asm/unified.h -msoft-float
> +KBUILD_CFLAGS	+=$(CFLAGS_ABI) $(CFLAGS_ISA) $(arch-y) $(tune-y) $(call cc-option,-mshort-load-bytes,$(call cc-option,-malignment-traps,)) -msoft-float -Uarm
> +KBUILD_AFLAGS	+=$(CFLAGS_ABI) $(AFLAGS_ISA) $(arch-y) $(tune-y) -include asm/unified.h -msoft-float
>  
>  CHECKFLAGS	+= -D__arm__
>  
> -- 
> 1.7.10
> 
