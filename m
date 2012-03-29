Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007Ab2C2KsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 06:48:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37079 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758153Ab2C2KsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 06:48:18 -0400
Date: Thu, 29 Mar 2012 12:48:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Trevor Turner <turn3r.tr3v0r@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: K7/Athlon Optimization Causes Build Fail on Kernel 3.3 i686
Message-ID: <20120329104822.GA17233@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Matt Fleming <matt.fleming@intel.com>,
	Trevor Turner <turn3r.tr3v0r@gmail.com>,
	Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>
References: <CANYHJ6jjuO7yV_kbPsnJ6X+KXrsz2PRPPXHN4Rkr-vgoSG-E4A@mail.gmail.com>
 <20120328111957.GA6765@x1.osrc.amd.com>
 <CANYHJ6j6cxz47TGk8kdU58eau17Fi1K=fH2icmd=v19VjNggKw@mail.gmail.com>
 <20120328171059.GA7919@x1.osrc.amd.com>
 <4F7346BB.9020907@xenotime.net>
 <20120328172759.GC6765@x1.osrc.amd.com>
 <20120329074802.GA31955@liondog.tnic>
 <1333008855.4289.3.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1333008855.4289.3.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 09:14:15AM +0100, Matt Fleming wrote:
> Hmm... I think what might make more sense is to make EFI (not EFI_STUB)
> depend on !MK7, since I doubt people actually need both MK7 and any EFI
> firmware support.

... and EFI_STUB depends on EFI, yeah, true story.

Here's an updated patch, Trevor pls try this one instead, thanks.

--
>From b3419ea2f2d38e758022bab17855eb9df8ee43c0 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <bp@alien8.de>
Date: Thu, 29 Mar 2012 09:39:51 +0200
Subject: [PATCH] AMD, K7: Fix compilation error when EFI is enabled

Trevor Turner reported that building the 3.3 kernel on his K7 box fails.
Reproducing the issue locally got us also the exact build error:

arch/x86/boot/compressed/eboot.o: In function `efi_main':
eboot.c:(.text+0x1530): undefined reference to `_mmx_memcpy'
eboot.c:(.text+0x17d0): undefined reference to `_mmx_memcpy'
make[2]: *** [arch/x86/boot/compressed/vmlinux] Error 1
make[1]: *** [arch/x86/boot/compressed/vmlinux] Error 2
make[1]: *** Waiting for unfinished jobs....

due to the fact that K7 has special MMX memcpy routines which EFI uses
through memcpy but is not linked against them thus the build failure.

Instead of making this work, we decided to make EFI and K7 mutually
exclusive since they're from different epochs anyway. The patch below
fixes that.

Reported-by: Trevor Turner <turn3r.tr3v0r@gmail.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5bed94e189fa..95d2b7c9b74a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1502,7 +1502,7 @@ config ARCH_RANDOM
 
 config EFI
 	bool "EFI runtime service support"
-	depends on ACPI
+	depends on ACPI && !MK7
 	---help---
 	  This enables the kernel to use EFI runtime services that are
 	  available (such as the EFI variable services).
-- 
1.7.9


-- 
Regards/Gruss,
Boris.
