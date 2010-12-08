Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab0LHR6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 12:58:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:36299 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754912Ab0LHR6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 12:58:16 -0500
Message-ID: <4CFFC6F2.5040304@kernel.org>
Date: Wed, 08 Dec 2010 18:57:06 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>, akpm@linux-foundation.org,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] x86: Replace uses of current_cpu_data with this_cpu ops
References: <20101206171618.302060721@linux.com>  <20101206171638.595205962@linux.com> <4CFE41F8.7040400@kernel.org>  <4CFE4294.30001@kernel.org>  <alpine.DEB.2.00.1012070846050.25976@router.home>  <4CFE4BE0.9040203@kernel.org>  <alpine.DEB.2.00.1012070906290.26552@router.home>  <4CFE4E05.7070902@kernel.org>  <alpine.DEB.2.00.1012071020040.26552@router.home>  <4CFF8520.4020704@kernel.org> <1291815501.2883.34.camel@edumazet-laptop>  <alpine.DEB.2.00.1012080929590.23407@router.home> <1291828646.2883.65.camel@edumazet-laptop> <4CFFBE67.8070809@kernel.org> <alpine.DEB.2.00.1012081132280.23407@router.home>
In-Reply-To: <alpine.DEB.2.00.1012081132280.23407@router.home>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Dec 2010 17:57:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

On 12/08/2010 06:33 PM, Christoph Lameter wrote:
> Beginnings of a patch to avoid bitops. If you think this is the right way
> then I will complete it for all uses of cpu_has.
> 
> ---
>  arch/x86/include/asm/cpufeature.h |   15 +++++++++++++++
>  arch/x86/kernel/apic/apic.c       |    2 +-
>  2 files changed, 16 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/arch/x86/include/asm/cpufeature.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/cpufeature.h	2010-12-08 09:39:31.000000000 -0600
> +++ linux-2.6/arch/x86/include/asm/cpufeature.h	2010-12-08 09:40:02.000000000 -0600
> @@ -221,6 +221,21 @@ extern const char * const x86_power_flag
>  	  ? 1 :								\
>  	 test_cpu_cap(c, bit))
> 
> +#define this_cpu_has(bit)							\
> +	(__builtin_constant_p(bit) &&					\
> +	 ( (((bit)>>5)==0 && (1UL<<((bit)&31) & REQUIRED_MASK0)) ||	\
> +	   (((bit)>>5)==1 && (1UL<<((bit)&31) & REQUIRED_MASK1)) ||	\
> +	   (((bit)>>5)==2 && (1UL<<((bit)&31) & REQUIRED_MASK2)) ||	\
> +	   (((bit)>>5)==3 && (1UL<<((bit)&31) & REQUIRED_MASK3)) ||	\
> +	   (((bit)>>5)==4 && (1UL<<((bit)&31) & REQUIRED_MASK4)) ||	\
> +	   (((bit)>>5)==5 && (1UL<<((bit)&31) & REQUIRED_MASK5)) ||	\
> +	   (((bit)>>5)==6 && (1UL<<((bit)&31) & REQUIRED_MASK6)) ||	\
> +	   (((bit)>>5)==7 && (1UL<<((bit)&31) & REQUIRED_MASK7)) ||	\
> +	   (((bit)>>5)==8 && (1UL<<((bit)&31) & REQUIRED_MASK8)) ||	\
> +	   (((bit)>>5)==9 && (1UL<<((bit)&31) & REQUIRED_MASK9)) )	\
> +	  ? 1 :								\

It would be nice to factor out the above so that it's not repated for
cpu_has() and this_cpu_has().

> +	 (this_cpu_read(cpu_info.x86_capabilty) & (1 << bit)))

bit can go beyond unsigned, so 1 << bit doesn't work.  Why not just
start with a simple wrapper?  ie. sth like

#define this_cpu_has(bit)	cpu_has(__this_cpu_ptr(&cpu_info), bit)

We can later optimize in a separate patch along the line of...

#define this_cpu_has(bit) ({						\
	__builtin_constant_p(bit) ?					\
		(cpu_required_bit_test(bit) ||				\
		 this_cpu_read(cpu_info.x86_capability + ((bit) >> 5)) & \
		 (1 << ((bit) & 31))) :					\
		cpu_has(__this_cpu_ptr(&cpu_info), bit);		\
})

Thanks.

-- 
tejun
