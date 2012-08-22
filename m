Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab2HVKeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 06:34:10 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:33957 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab2HVKeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 06:34:08 -0400
Date: Wed, 22 Aug 2012 06:33:40 -0400 (EDT)
From: Tomas Racek <tracek@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>,
        Borislav Petkov <borislav.petkov@amd.com>,
        kvm-devel <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        qemu-devel@nongnu.org, linux-kernel@vger.kernel.org,
        Anthony Liguori <anthony@codemonkey.ws>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>,
        the arch/x86 maintainers <x86@kernel.org>
Message-ID: <1406258973.2560632.1345631620655.JavaMail.root@redhat.com>
In-Reply-To: <5034AE84.90708@redhat.com>
Subject: Re: [PATCH] x86, alternative: fix p6 nops on non-modular kernels
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.34.27.4]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC20 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> On 08/22/2012 12:54 PM, Avi Kivity wrote:
> > On 08/21/2012 12:28 PM, Tomas Racek wrote:
> >> 
> >> http://fi.muni.cz/~xracek/debian2.img.bz2
> >> 
> >> Other things are the same.
> >> 
> >> The runtest.sh sets environment for xfstests and runs test 285
> >> which I wrote and and which should test if FS sends discard
> >> requests only on free sectors:
> >> 285:
> >> 1. Create loop device and FS on it.
> >> 2. Populate it with some garbage.
> >> 3. Get free sectors from FS.
> >> 4. Run fstrim and look for discard requests via blk tracer.
> >> 5. Compare free sectors to discard requests.
> >> 
> >> The test itself can have some issues but I'm pretty sure it
> >> shouldn't crash the system. ;-)
> > 
> > Does the following patch help?
> > 
> 
> It's obvious that it should.  You're running a non-modular kernel,
> and those nops are discarded (probably a leftover from the days
> patching was a boot-only activity), so the kernel patched garbage
> over its own code.
> 

Works fine. Thank you!

Tom


> -------8<----cut-here-----8<-----------------------------------
> 
> From: Avi Kivity <avi@redhat.com>
> Date: Wed, 22 Aug 2012 12:58:18 +0300
> Subject: [PATCH] x86, alternative: fix p6 nops on non-modular kernels
> 
> Probably a leftover from the early days of self-patching, p6nops are
> marked __initconst_or_module, which causes them to be discarded in a
> non-modular kernel.  If something later triggers patching, it will
> overwrite kernel code with garbage.
> 
> Reported-by: Tomas Racek <tracek@redhat.com>
> Signed-off-by: Avi Kivity <avi@redhat.com>
> 
> diff --git a/arch/x86/kernel/alternative.c
> b/arch/x86/kernel/alternative.c
> index afb7ff7..ced4534 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -165,7 +165,7 @@ static int __init setup_noreplace_paravirt(char
> *str)
>  #endif
>  
>  #ifdef P6_NOP1
> -static const unsigned char  __initconst_or_module p6nops[] =
> +static const unsigned char p6nops[] =
>  {
>  	P6_NOP1,
>  	P6_NOP2,
> 
> 
> --
> error compiling committee.c: too many arguments to function
> 
