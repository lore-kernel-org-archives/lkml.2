Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab2JESm2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 14:42:28 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:61232 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297Ab2JESm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 14:42:27 -0400
Date: Fri, 5 Oct 2012 14:42:24 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>,
        Dave Martin <dave.martin@linaro.org>
Subject: Re: [PATCH 16/16] ARM: pass -marm to gcc by default for both C and
 assembler
In-Reply-To: <1349448930-23976-17-git-send-email-arnd@arndb.de>
Message-ID: <alpine.LFD.2.02.1210051438460.16518@xanadu.home>
References: <1349448930-23976-1-git-send-email-arnd@arndb.de> <1349448930-23976-17-git-send-email-arnd@arndb.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2012, Arnd Bergmann wrote:

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
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Dave Martin <dave.martin@linaro.org>

I don't think you need "call cc-option" with -marm.  Those gcc versions 
that might not accept -marm have not been able to compile the kernel for 
a long long time now.  Otherwise...

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  arch/arm/Makefile |   13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/Makefile b/arch/arm/Makefile
> index a051dfb..4391427 100644
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
