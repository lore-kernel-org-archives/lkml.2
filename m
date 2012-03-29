Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab2C2IOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 04:14:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:14036 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab2C2IOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 04:14:25 -0400
Subject: Re: K7/Athlon Optimization Causes Build Fail on Kernel 3.3 i686
From: Matt Fleming <matt.fleming@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Trevor Turner <turn3r.tr3v0r@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20120329074802.GA31955@liondog.tnic>
References: <CANYHJ6jjuO7yV_kbPsnJ6X+KXrsz2PRPPXHN4Rkr-vgoSG-E4A@mail.gmail.com>
	 <20120328111957.GA6765@x1.osrc.amd.com>
	 <CANYHJ6j6cxz47TGk8kdU58eau17Fi1K=fH2icmd=v19VjNggKw@mail.gmail.com>
	 <20120328171059.GA7919@x1.osrc.amd.com> <4F7346BB.9020907@xenotime.net>
	 <20120328172759.GC6765@x1.osrc.amd.com>
	 <20120329074802.GA31955@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Thu, 29 Mar 2012 09:14:15 +0100
Message-ID: <1333008855.4289.3.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14)
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-29 at 09:48 +0200, Borislav Petkov wrote:
> On Wed, Mar 28, 2012 at 07:27:59PM +0200, Borislav Petkov wrote:
> > On Wed, Mar 28, 2012 at 10:13:31AM -0700, Randy Dunlap wrote:
> > > > in your config. K7 and EFI are from different epochs anyway and cannot
> > > > obviously be enabled both on the same system with the current Kconfig
> > > > for EFI.
> > 
> > > but the Kconfig files shouldn't allow such a failing .config to be
> > > created, or the Makefiles are inadequate, or <mumble something>....
> > 
> > Yeah, something like the following:
> > 
> > config MK7
> > 	bool "Athlon/Duron/K7"
> > 	depends on X86_32 && !EFI_STUB
> > 
> > or the other way around:
> > 
> > config EFI_STUB
> >        bool "EFI stub support"
> >        depends on EFI && !MK7
> 
> Trevor,
> 
> can you apply the following patch and retest please? You shouldn't
> be able to select EFI_STUB and K7 optimizations at the same time in
> Kconfig.
> 
> Thanks.
> 
> --
> From 24e9ee38516a770a275dde217c250cf8b78521d5 Mon Sep 17 00:00:00 2001
> From: Borislav Petkov <bp@alien8.de>
> Date: Thu, 29 Mar 2012 09:39:51 +0200
> Subject: [PATCH] AMD, K7: Fix compilation error when EFI_STUG is enabled
> 
> Trevor Turner reported that building the 3.3 kernel on his K7 box fails.
> Reproducing the issue locally got us also the exact build error:
> 
> arch/x86/boot/compressed/eboot.o: In function `efi_main':
> eboot.c:(.text+0x1530): undefined reference to `_mmx_memcpy'
> eboot.c:(.text+0x17d0): undefined reference to `_mmx_memcpy'
> make[2]: *** [arch/x86/boot/compressed/vmlinux] Error 1
> make[1]: *** [arch/x86/boot/compressed/vmlinux] Error 2
> make[1]: *** Waiting for unfinished jobs....
> 
> due to the fact that K7 has special MMX memcpy routines which EFI_STUB
> uses through memcpy but is not linked against them thus the build
> failure.
> 
> Instead of making this work, we decided to make EFI_STUB and K7 mutually
> exclusive since they're from different epochs anyway. The patch below
> fixes that.
> 
> Reported-by: Trevor Turner <turn3r.tr3v0r@gmail.com>
> Cc: Matt Fleming <matt.fleming@intel.com>
> Signed-off-by: Borislav Petkov <bp@alien8.de>
> ---
>  arch/x86/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Hmm... I think what might make more sense is to make EFI (not EFI_STUB)
depend on !MK7, since I doubt people actually need both MK7 and any EFI
firmware support.

