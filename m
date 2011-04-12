Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518Ab1DLVHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 17:07:30 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:57229 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932155Ab1DLVH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 17:07:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Ieu8sVmkLJwYnHx4LJ15eIHUru9ZVLjLEo8jpThtcabKGpIO+QDL5a4LtvHCiqprcfFswRwhdW/b73RUJ6554pa4/rk4bZPXs90IbqY4KrPskBEnMhIzG6LE2zYG0fpc;
Date: Tue, 12 Apr 2011 14:07:26 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        behlendorf1@llnl.gov, oleg@redhat.com
Subject: Re: [PATCH] remove abs64()
Message-Id: <20110412140726.3f4f2a7b.rdunlap@xenotime.net>
In-Reply-To: <20110412210045.GA19901@p183>
References: <20110412210045.GA19901@p183>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011 00:00:45 +0300 Alexey Dobriyan wrote:

> We don't need no stinking abs64() given some GCC extensions
> (especially __builtin_choose_expr()).
> 
> One abs() implementation is better than two abs() implementations.

questionable.

> New abs() doesn't expand type needlessly.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  drivers/gpu/drm/drm_irq.c |    4 ++--
>  include/linux/kernel.h    |   43 +++++++++++++++++++++----------------------
>  lib/div64.c               |    2 +-
>  3 files changed, 24 insertions(+), 25 deletions(-)


> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -143,28 +143,27 @@ extern int _cond_resched(void);
>  
>  #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
>  
> -/*
> - * abs() handles unsigned and signed longs, ints, shorts and chars.  For all
> - * input types abs() returns a signed long.
> - * abs() should not be used for 64-bit types (s64, u64, long long) - use abs64()
> - * for those.
> - */
> -#define abs(x) ({						\
> -		long ret;					\
> -		if (sizeof(x) == sizeof(long)) {		\
> -			long __x = (x);				\
> -			ret = (__x < 0) ? -__x : __x;		\
> -		} else {					\
> -			int __x = (x);				\
> -			ret = (__x < 0) ? -__x : __x;		\
> -		}						\
> -		ret;						\
> -	})
> -
> -#define abs64(x) ({				\
> -		s64 __x = (x);			\
> -		(__x < 0) ? -__x : __x;		\
> -	})
> +#define abs(x)								\
> +({									\
> +	typeof(x) _x = (x);						\
> +									\
> +	__builtin_choose_expr(						\
> +		__builtin_types_compatible_p(typeof(_x), signed char),	\
> +		(unsigned char)({ _x < 0 ? -_x : _x; }),		\
> +	__builtin_choose_expr(						\
> +		__builtin_types_compatible_p(typeof(_x), short),	\
> +		(unsigned short)({ _x < 0 ? -_x : _x; }),		\
> +	__builtin_choose_expr(						\
> +		__builtin_types_compatible_p(typeof(_x), int),		\
> +		(unsigned int)({ _x < 0 ? -_x : _x; }),			\
> +	__builtin_choose_expr(						\
> +		__builtin_types_compatible_p(typeof(_x), long),		\
> +		(unsigned long)({ _x < 0 ? -_x : _x; }),		\
> +	__builtin_choose_expr(						\
> +		__builtin_types_compatible_p(typeof(_x), long long),	\
> +		(unsigned long long)({ _x < 0 ? -_x : _x; }),		\
> +	_x)))));							\
> +})

that is better?

---
~Randy
