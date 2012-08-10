Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab2HJLM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 07:12:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53860 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab2HJLM0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 07:12:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Martin <dave.martin@linaro.org>
Subject: Re: [PATCH 04/10] ARM: pass -marm to gcc by default
Date: Fri, 10 Aug 2012 11:12:20 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org
References: <1344461278-28245-1-git-send-email-arnd@arndb.de> <alpine.LFD.2.02.1208091721460.5231@xanadu.home> <20120810095911.GA2157@linaro.org>
In-Reply-To: <20120810095911.GA2157@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201208101112.20416.arnd@arndb.de>
X-Provags-ID: V02:K0:u+HQTzQVHKiRcNq4nDuf3WGxTxodfTMw44PpGiDJg78
 b0rcK28glk0I3slK5+CrLxhWWit8N0fb0ofYaLgrRm7/cUvEq7
 fJijcTa3hUWAtqqrKYVADNUWl+FbLeY+ARnFCPPwYyn40cs4Su
 orDVtP8zTHBKom3BiFv5NFozQbse+BoLsTOPKn0myEYrLNXe6i
 yOg1VtsA+BoRi5Reg5U07ClmBpCe0sMyCKR834GVe22MSsJ+wa
 qjKz4XAUkl59GpfoaoCe+xhvpUcZX7Oj1O6n01ssRRclsYlaFc
 yEynM3weoRGAMXRdlr2mkq953adFytJafhhHX9/WXD+rqzM9or
 xOjTFH3cCZ9aY6kM2plw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 August 2012, Dave Martin wrote:
> On Thu, Aug 09, 2012 at 05:22:30PM -0400, Nicolas Pitre wrote:
> > On Thu, 9 Aug 2012, Russell King - ARM Linux wrote:
> > 
> > > On Thu, Aug 09, 2012 at 05:12:58PM -0400, Nicolas Pitre wrote:
> > > > CFLAGS_THUMB2 should probably be renamed to something more appropriate 
> > > > in this case, e.g. CFLAGS_MODE.
> > > 
> > > CFLAGS_ISA would be more relevant to it, because it's selecting the
> > > instruction set.
> > 
> > Agreed.  This particular TLA escaped my mind somehow.
> 
> Seems fair enough.  It doesn't quite match the official architectural
> terminology, but it clear enough what it means, and less cumbersome than
> the alternatives.
> 
> Best not to use MODE though.  That word is way too overloaded.

Ok. I already noticed that we already set -marm in KBUILD_CFLAGS but
not in the AFLAGS. This new version should cover all the issues
and make it more obvious what's actually going on.

	Arnd

8<----
>From 34763772164d1442509f27d7f8a09326ff4b7878 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 30 Apr 2012 12:40:00 +0000
Subject: [PATCH] ARM: pass -marm to gcc by default for both C and assembler

The Linaro cross toolchain and probably others nowadays default to
building in THUMB2 mode. When building a kernel for a CPU that does
not support THUMB2, the compiler complains about incorrect flags.
We can work around this by setting -marm for all non-T2 builds.

Without this patch, building assabet_defconfig results in:

usr/initramfs_data.S:1:0: warning: target CPU does not support THUMB instructions [enabled by default]
arch/arm/nwfpe/entry.S:1:0: warning: target CPU does not support THUMB instructions [enabled by default]
firmware/cis/PCMLM28.cis.gen.S:1:0: warning: target CPU does not support THUMB instructions [enabled by default]
(and many more)

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Dave Martin <dave.martin@linaro.org>

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 30eae87..ca0dabc 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -21,8 +21,6 @@ endif
 OBJCOPYFLAGS	:=-O binary -R .comment -S
 GZFLAGS		:=-9
 #KBUILD_CFLAGS	+=-pipe
-# Explicitly specifiy 32-bit ARM ISA since toolchain default can be -mthumb:
-KBUILD_CFLAGS	+=$(call cc-option,-marm,)
 
 # Never generate .eh_frame
 KBUILD_CFLAGS	+= $(call cc-option,-fno-dwarf2-cfi-asm)
@@ -105,17 +103,20 @@ endif
 ifeq ($(CONFIG_THUMB2_KERNEL),y)
 AFLAGS_AUTOIT	:=$(call as-option,-Wa$(comma)-mimplicit-it=always,-Wa$(comma)-mauto-it)
 AFLAGS_NOWARN	:=$(call as-option,-Wa$(comma)-mno-warn-deprecated,-Wa$(comma)-W)
-CFLAGS_THUMB2	:=-mthumb $(AFLAGS_AUTOIT) $(AFLAGS_NOWARN)
-AFLAGS_THUMB2	:=$(CFLAGS_THUMB2) -Wa$(comma)-mthumb
+CFLAGS_ISA	:=-mthumb $(AFLAGS_AUTOIT) $(AFLAGS_NOWARN)
+AFLAGS_ISA	:=$(CFLAGS_ISA) -Wa$(comma)-mthumb
 # Work around buggy relocation from gas if requested:
 ifeq ($(CONFIG_THUMB2_AVOID_R_ARM_THM_JUMP11),y)
 CFLAGS_MODULE	+=-fno-optimize-sibling-calls
 endif
+else
+CFLAGS_ISA	:=$(call cc-option,-marm,)
+AFLAGS_ISA	:=$(CFLAGS_ISA)
 endif
 
 # Need -Uarm for gcc < 3.x
-KBUILD_CFLAGS	+=$(CFLAGS_ABI) $(CFLAGS_THUMB2) $(arch-y) $(tune-y) $(call cc-option,-mshort-load-bytes,$(call cc-option,-malignment-traps,)) -msoft-float -Uarm
-KBUILD_AFLAGS	+=$(CFLAGS_ABI) $(AFLAGS_THUMB2) $(arch-y) $(tune-y) -include asm/unified.h -msoft-float
+KBUILD_CFLAGS	+=$(CFLAGS_ABI) $(CFLAGS_ISA) $(arch-y) $(tune-y) $(call cc-option,-mshort-load-bytes,$(call cc-option,-malignment-traps,)) -msoft-float -Uarm
+KBUILD_AFLAGS	+=$(CFLAGS_ABI) $(AFLAGS_ISA) $(arch-y) $(tune-y) -include asm/unified.h -msoft-float
 
 CHECKFLAGS	+= -D__arm__
 
