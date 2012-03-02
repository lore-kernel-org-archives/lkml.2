Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab2CBIM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 03:12:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43493 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab2CBIMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 03:12:25 -0500
Date: Fri, 2 Mar 2012 09:12:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alex Shi <alex.shi@intel.com>
Cc: tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86@kernel.org, asit.k.mallick@intel.com
Subject: Re: change last level cache alignment on x86?
Message-ID: <20120302081208.GA24504@elte.hu>
References: <1330590816.21053.1336.camel@debian>
 <1330673425.21053.1503.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330673425.21053.1503.camel@debian>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alex Shi <alex.shi@intel.com> wrote:

> On Thu, 2012-03-01 at 16:33 +0800, Alex,Shi wrote:
> > Currently last level defined in kernel is still 128 bytes, but actually
> > I checked intel's core2, NHM, SNB, atom, serial platforms, all of them
> > are using 64 bytes. 
> > I did not get detailed info on AMD platforms. Guess someone like to give
> > the info here. So, Is if it possible to do the similar following changes
> > to use 64 byte cache alignment in kernel?
> > 
> > ===
> > diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
> > index 3c57033..f342a5a 100644
> > --- a/arch/x86/Kconfig.cpu
> > +++ b/arch/x86/Kconfig.cpu
> > @@ -303,7 +303,7 @@ config X86_GENERIC
> >  config X86_INTERNODE_CACHE_SHIFT
> >  	int
> >  	default "12" if X86_VSMP
> > -	default "7" if NUMA
> > +	default "7" if NUMA && (MPENTIUM4)
> >  	default X86_L1_CACHE_SHIFT
> >  
> >  config X86_CMPXCHG
> 
> In arch/x86/include/asm/cache.h, the INTERNODE_CACHE_SHIFT macro will
> transfer to '__cacheline_aligned_in_smp' finally. 
> 
> #ifdef CONFIG_X86_VSMP
> #ifdef CONFIG_SMP
> #define __cacheline_aligned_in_smp                                      \
>         __attribute__((__aligned__(INTERNODE_CACHE_BYTES)))             \
>         __page_aligned_data
> #endif
> #endif

Note the #ifdef CONFIG_X86_VSMP - so the 128 bytes does not 
actually transform into __cacheline_aligned_in_smp.

> look at the following contents in Kconfig.cpu, I wondering if 
> it is possible to remove 'default "7" if NUMA' line. Then a 
> thin and fit cache alignment will be potential helpful on 
> performance. Anyone like to give some comments?

>  config X86_INTERNODE_CACHE_SHIFT
>         int
>         default "12" if X86_VSMP
> -       default "7" if NUMA
>         default X86_L1_CACHE_SHIFT

Yes, removing that line would be fine I think - I think it was 
copied from the old L1 alignment of 128 bytes (which was a P4 
artifact when that CPU was the dominant platform - that's not 
been the case for a long time already).

Could you please also do a before/after build of an x86 
defconfig with NUMA enabled and see what the alignments in the 
before/after System.map are?

Thanks,

	Ingo
