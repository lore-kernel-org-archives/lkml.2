Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933628Ab1ERTGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:06:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:27682 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933500Ab1ERTGa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:06:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,232,1304319600"; 
   d="scan'208";a="4158745"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 18 May 2011 12:04:14 -0700
Subject: RE: [PATCH 7/9] x86/lib/memcpy_64.S: Optimize memcpy by enhanced
 REP MOVSB/STOSB
Thread-Topic: [PATCH 7/9] x86/lib/memcpy_64.S: Optimize memcpy by enhanced
 REP MOVSB/STOSB
Thread-Index: AcwVJdbDtM87wlhwRPWah0RMLhhwuwAZFr4Q
Message-ID: <493994B35A117E4F832F97C4719C4C04011505C846@orsmsx505.amr.corp.intel.com>
References: <1305671358-14478-1-git-send-email-fenghua.yu@intel.com>
 <1305671358-14478-8-git-send-email-fenghua.yu@intel.com>
 <20110518063544.GC2945@elte.hu>
In-Reply-To: <20110518063544.GC2945@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Ingo Molnar [mailto:mingo@elte.hu]
> Sent: Tuesday, May 17, 2011 11:36 PM
> To: Yu, Fenghua
> Cc: Thomas Gleixner; H Peter Anvin; Mallick, Asit K; Linus Torvalds;
> Avi Kivity; Arjan van de Ven; Andrew Morton; Andi Kleen; linux-kernel
> Subject: Re: [PATCH 7/9] x86/lib/memcpy_64.S: Optimize memcpy by
> enhanced REP MOVSB/STOSB
> 
> 
> * Fenghua Yu <fenghua.yu@intel.com> wrote:
> 
> > From: Fenghua Yu <fenghua.yu@intel.com>
> >
> > Support memcpy() with enhanced rep movsb. On processors supporting
> enhanced
> > rep movsb, the alternative memcpy() function using enhanced rep movsb
> > overrides the original function and the fast string function.
> >
> > Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> > ---
> >  arch/x86/lib/memcpy_64.S |   45 ++++++++++++++++++++++++++++++++----
> ---------
> >  1 files changed, 32 insertions(+), 13 deletions(-)
> 
> >  ENDPROC(__memcpy)
> >
> >  	/*
> > -	 * Some CPUs run faster using the string copy instructions.
> > -	 * It is also a lot simpler. Use this when possible:
> > -	 */
> > -
> > -	.section .altinstructions, "a"
> > -	.align 8
> > -	.quad memcpy
> > -	.quad .Lmemcpy_c
> > -	.word X86_FEATURE_REP_GOOD
> > -
> > -	/*
> > +	 * Some CPUs are adding enhanced REP MOVSB/STOSB feature
> > +	 * If the feature is supported, memcpy_c_e() is the first choice.
> > +	 * If enhanced rep movsb copy is not available, use fast string
> copy
> > +	 * memcpy_c() when possible. This is faster and code is simpler
> than
> > +	 * original memcpy().
> 
> Please use more obvious names than cryptic and meaningless _c and _c_e
> postfixes. We do not repeat these many times.
> 
> Also, did you know about the 'perf bench mem memcpy' tool prototype we
> have in
> the kernel tree? It is intended to check and evaluate exactly the
> patches you
> are offering here. The code lives in:
> 
>   tools/perf/bench/mem-memcpy-arch.h
>   tools/perf/bench/mem-memcpy.c
>   tools/perf/bench/mem-memcpy-x86-64-asm-def.h
>   tools/perf/bench/mem-memcpy-x86-64-asm.S
> 
> Please look into testing (fixing if needed), using and extending it:
> 
>  - We want to measure the alternatives variants as well, not just the
> generic one
> 
>  - We want to measure memmove, memclear, etc. operations as well, not
> just
>    memcpy
> 
>  - We want cache-cold and cache-hot numbers as well, going along
> multiple sizes
> 
> This tool can also useful when developing these changes: they can be
> tested in
> user-space and can be iterated very quickly, without having to build
> and
> booting the kernel.
> 
> We can commit any enhancements/fixes you do to perf bench alongside
> your memcpy
> patches. All in one, such measurements will make it much easier for us
> to apply
> the patches.
> 
> Thanks,
> 
> 	Ingo

I'll work on the bench tool and will let you know when it's ready.

Thanks.

-Fenghua
