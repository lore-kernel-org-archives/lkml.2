Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab1ERGgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 02:36:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60829 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375Ab1ERGgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 02:36:00 -0400
Date: Wed, 18 May 2011 08:35:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/9] x86/lib/memcpy_64.S: Optimize memcpy by enhanced REP
 MOVSB/STOSB
Message-ID: <20110518063544.GC2945@elte.hu>
References: <1305671358-14478-1-git-send-email-fenghua.yu@intel.com>
 <1305671358-14478-8-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305671358-14478-8-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Fenghua Yu <fenghua.yu@intel.com> wrote:

> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Support memcpy() with enhanced rep movsb. On processors supporting enhanced 
> rep movsb, the alternative memcpy() function using enhanced rep movsb 
> overrides the original function and the fast string function.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/lib/memcpy_64.S |   45 ++++++++++++++++++++++++++++++++-------------
>  1 files changed, 32 insertions(+), 13 deletions(-)

>  ENDPROC(__memcpy)
>  
>  	/*
> -	 * Some CPUs run faster using the string copy instructions.
> -	 * It is also a lot simpler. Use this when possible:
> -	 */
> -
> -	.section .altinstructions, "a"
> -	.align 8
> -	.quad memcpy
> -	.quad .Lmemcpy_c
> -	.word X86_FEATURE_REP_GOOD
> -
> -	/*
> +	 * Some CPUs are adding enhanced REP MOVSB/STOSB feature
> +	 * If the feature is supported, memcpy_c_e() is the first choice.
> +	 * If enhanced rep movsb copy is not available, use fast string copy
> +	 * memcpy_c() when possible. This is faster and code is simpler than
> +	 * original memcpy().

Please use more obvious names than cryptic and meaningless _c and _c_e 
postfixes. We do not repeat these many times.

Also, did you know about the 'perf bench mem memcpy' tool prototype we have in 
the kernel tree? It is intended to check and evaluate exactly the patches you 
are offering here. The code lives in:

  tools/perf/bench/mem-memcpy-arch.h
  tools/perf/bench/mem-memcpy.c
  tools/perf/bench/mem-memcpy-x86-64-asm-def.h
  tools/perf/bench/mem-memcpy-x86-64-asm.S

Please look into testing (fixing if needed), using and extending it:

 - We want to measure the alternatives variants as well, not just the generic one

 - We want to measure memmove, memclear, etc. operations as well, not just 
   memcpy

 - We want cache-cold and cache-hot numbers as well, going along multiple sizes

This tool can also useful when developing these changes: they can be tested in 
user-space and can be iterated very quickly, without having to build and 
booting the kernel.

We can commit any enhancements/fixes you do to perf bench alongside your memcpy 
patches. All in one, such measurements will make it much easier for us to apply 
the patches.

Thanks,

	Ingo
