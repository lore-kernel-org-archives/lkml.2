Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab2C2HsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 03:48:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36549 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab2C2HsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 03:48:08 -0400
Date: Thu, 29 Mar 2012 09:48:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Trevor Turner <turn3r.tr3v0r@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: K7/Athlon Optimization Causes Build Fail on Kernel 3.3 i686
Message-ID: <20120329074802.GA31955@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Trevor Turner <turn3r.tr3v0r@gmail.com>,
	Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
	Matt Fleming <matt.fleming@intel.com>
References: <CANYHJ6jjuO7yV_kbPsnJ6X+KXrsz2PRPPXHN4Rkr-vgoSG-E4A@mail.gmail.com>
 <20120328111957.GA6765@x1.osrc.amd.com>
 <CANYHJ6j6cxz47TGk8kdU58eau17Fi1K=fH2icmd=v19VjNggKw@mail.gmail.com>
 <20120328171059.GA7919@x1.osrc.amd.com>
 <4F7346BB.9020907@xenotime.net>
 <20120328172759.GC6765@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120328172759.GC6765@x1.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 07:27:59PM +0200, Borislav Petkov wrote:
> On Wed, Mar 28, 2012 at 10:13:31AM -0700, Randy Dunlap wrote:
> > > in your config. K7 and EFI are from different epochs anyway and cannot
> > > obviously be enabled both on the same system with the current Kconfig
> > > for EFI.
> 
> > but the Kconfig files shouldn't allow such a failing .config to be
> > created, or the Makefiles are inadequate, or <mumble something>....
> 
> Yeah, something like the following:
> 
> config MK7
> 	bool "Athlon/Duron/K7"
> 	depends on X86_32 && !EFI_STUB
> 
> or the other way around:
> 
> config EFI_STUB
>        bool "EFI stub support"
>        depends on EFI && !MK7

Trevor,

can you apply the following patch and retest please? You shouldn't
be able to select EFI_STUB and K7 optimizations at the same time in
Kconfig.

Thanks.

--
>From 24e9ee38516a770a275dde217c250cf8b78521d5 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <bp@alien8.de>
Date: Thu, 29 Mar 2012 09:39:51 +0200
Subject: [PATCH] AMD, K7: Fix compilation error when EFI_STUG is enabled

Trevor Turner reported that building the 3.3 kernel on his K7 box fails.
Reproducing the issue locally got us also the exact build error:

arch/x86/boot/compressed/eboot.o: In function `efi_main':
eboot.c:(.text+0x1530): undefined reference to `_mmx_memcpy'
eboot.c:(.text+0x17d0): undefined reference to `_mmx_memcpy'
make[2]: *** [arch/x86/boot/compressed/vmlinux] Error 1
make[1]: *** [arch/x86/boot/compressed/vmlinux] Error 2
make[1]: *** Waiting for unfinished jobs....

due to the fact that K7 has special MMX memcpy routines which EFI_STUB
uses through memcpy but is not linked against them thus the build
failure.

Instead of making this work, we decided to make EFI_STUB and K7 mutually
exclusive since they're from different epochs anyway. The patch below
fixes that.

Reported-by: Trevor Turner <turn3r.tr3v0r@gmail.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5bed94e189fa..80b116281661 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1516,7 +1516,7 @@ config EFI
 
 config EFI_STUB
        bool "EFI stub support"
-       depends on EFI
+       depends on EFI && !MK7
        ---help---
           This kernel feature allows a bzImage to be loaded directly
 	  by EFI firmware without the use of a bootloader.
-- 
1.7.5.3.401.gfb674

-- 
Regards/Gruss,
    Boris.
