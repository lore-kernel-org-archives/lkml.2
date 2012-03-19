Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710Ab2CSC0m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 22:26:42 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:39239 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757666Ab2CSC0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 22:26:01 -0400
Message-ID: <4F6698C1.3070105@snapgear.com>
Date: Mon, 19 Mar 2012 12:24:01 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: <paul.gortmaker@windriver.com>, <hpa@zytor.com>,
        <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <arnd@arndb.de>,
        <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 13/35] Disintegrate asm/system.h for M68K [ver #2]
References: <4F608A15.9030609@snapgear.com> <20120312233602.13888.27659.stgit@warthog.procyon.org.uk> <20120312233816.13888.142.stgit@warthog.procyon.org.uk> <17434.1331905343@redhat.com>
In-Reply-To: <17434.1331905343@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 16/03/12 23:42, David Howells wrote:
> How about if I insert the attached patch prior?

Yep, that fixes it. Builds on its own, and with the asm/system.h
disintegration patch applied (and rejects fixed) as well.

Regards
Greg



> ---
> From: David Howells<dhowells@redhat.com>
>
> m68k: Fix xchg/cmpxchg to fail to link if given an inappropriate pointer
>
> Fix the m68k versions of xchg() and cmpxchg() to fail to link if given an
> inappropriately sized pointer rather than BUG()'ing at runtime.
>
> Signed-off-by: David Howells<dhowells@redhat.com>
> ---
>
>   arch/m68k/include/asm/system.h |   20 ++++++++++++++++----
>   1 files changed, 16 insertions(+), 4 deletions(-)
>
>
> diff --git a/arch/m68k/include/asm/system.h b/arch/m68k/include/asm/system.h
> index 47b01f4..a10c4d1 100644
> --- a/arch/m68k/include/asm/system.h
> +++ b/arch/m68k/include/asm/system.h
> @@ -68,6 +68,8 @@ asmlinkage void resume(void);
>   struct __xchg_dummy { unsigned long a[100]; };
>   #define __xg(x) ((volatile struct __xchg_dummy *)(x))
>
> +extern unsigned long __invalid_xchg_size(unsigned long, volatile void *, int);
> +
>   #ifndef CONFIG_RMW_INSNS
>   static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int size)
>   {
> @@ -92,7 +94,8 @@ static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int siz
>   		x = tmp;
>   		break;
>   	default:
> -		BUG();
> +		tmp = __invalid_xchg_size(x, ptr, size);
> +		break;
>   	}
>
>   	local_irq_restore(flags);
> @@ -102,7 +105,7 @@ static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int siz
>   static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int size)
>   {
>   	switch (size) {
> -	    case 1:
> +	case 1:
>   		__asm__ __volatile__
>   			("moveb %2,%0\n\t"
>   			 "1:\n\t"
> @@ -110,7 +113,7 @@ static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int siz
>   			 "jne 1b"
>   			 : "=&d" (x) : "d" (x), "m" (*__xg(ptr)) : "memory");
>   		break;
> -	    case 2:
> +	case 2:
>   		__asm__ __volatile__
>   			("movew %2,%0\n\t"
>   			 "1:\n\t"
> @@ -118,7 +121,7 @@ static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int siz
>   			 "jne 1b"
>   			 : "=&d" (x) : "d" (x), "m" (*__xg(ptr)) : "memory");
>   		break;
> -	    case 4:
> +	case 4:
>   		__asm__ __volatile__
>   			("movel %2,%0\n\t"
>   			 "1:\n\t"
> @@ -126,6 +129,9 @@ static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int siz
>   			 "jne 1b"
>   			 : "=&d" (x) : "d" (x), "m" (*__xg(ptr)) : "memory");
>   		break;
> +	default:
> +		x = __invalid_xchg_size(x, ptr, size);
> +		break;
>   	}
>   	return x;
>   }
> @@ -135,6 +141,9 @@ static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int siz
>
>   #define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
>
> +extern unsigned long __invalid_cmpxchg_size(volatile void *,
> +					    unsigned long, unsigned long, int);
> +
>   /*
>    * Atomic compare and exchange.  Compare OLD with MEM, if identical,
>    * store NEW in MEM.  Return the initial value in MEM.  Success is
> @@ -162,6 +171,9 @@ static inline unsigned long __cmpxchg(volatile void *p, unsigned long old,
>   				      : "=d" (old), "=m" (*(int *)p)
>   				      : "d" (new), "0" (old), "m" (*(int *)p));
>   		break;
> +	default:
> +		old = __invalid_cmpxchg_size(p, old, new, size);
> +		break;
>   	}
>   	return old;
>   }
>
>
>


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
