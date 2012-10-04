Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab2JDMki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 08:40:38 -0400
Received: from mail.x86-64.org ([217.9.48.20]:38645 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756200Ab2JDMkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 08:40:37 -0400
Date: Thu, 4 Oct 2012 14:40:25 +0200
From: Borislav Petkov <bp@amd64.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: tty_init_dev: 24 callbacks suppressed
Message-ID: <20121004124025.GC21028@aftab.osrc.amd.com>
References: <20121004092055.GA21028@aftab.osrc.amd.com>
 <20121004112347.GA245@x4>
 <20121004115157.GA245@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121004115157.GA245@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 01:51:57PM +0200, Markus Trippelsdorf wrote:
> diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
> index e11ccb4..d8de255 100644
> --- a/include/linux/ratelimit.h
> +++ b/include/linux/ratelimit.h
> @@ -46,20 +46,17 @@ extern int ___ratelimit(struct ratelimit_state *rs, const char *func);
>  #define WARN_ON_RATELIMIT(condition, state)			\
>  		WARN_ON((condition) && __ratelimit(state))
>  
> -#define __WARN_RATELIMIT(condition, state, format...)		\
> -({								\
> -	int rtn = 0;						\
> -	if (unlikely(__ratelimit(state)))			\
> -		rtn = WARN(condition, format);			\
> -	rtn;							\
> -})
> -
> -#define WARN_RATELIMIT(condition, format...)			\
> +#define WARN_RATELIMIT(condition, fmt, ...)			\
>  ({								\
>  	static DEFINE_RATELIMIT_STATE(_rs,			\
>  				      DEFAULT_RATELIMIT_INTERVAL,	\
>  				      DEFAULT_RATELIMIT_BURST);	\
> -	__WARN_RATELIMIT(condition, &_rs, format);		\
> +	int rtn = !!(condition);				\
> +								\
> +	if (unlikely(rtn && __ratelimit(&_rs)))		\
> +		WARN(rtn, fmt, ##__VA_ARGS__);			\
> +								\
> +	rtn;							\
>  })

Aha, I see it. We need to look at the condition before the __ratelimit,
otherwise we WARN unnecessarily, good catch.

>  #else
> @@ -67,15 +64,9 @@ extern int ___ratelimit(struct ratelimit_state *rs, const char *func);
>  #define WARN_ON_RATELIMIT(condition, state)			\
>  	WARN_ON(condition)
>  
> -#define __WARN_RATELIMIT(condition, state, format...)		\
> -({								\
> -	int rtn = WARN(condition, format);			\
> -	rtn;							\
> -})
> -
> -#define WARN_RATELIMIT(condition, format...)			\
> +#define WARN_RATELIMIT(condition, fmt, ...)			\

... except this change is unrelated and unneeded - there's enough room
in 80 cols to leave it as "format" instead of shortening it.

Other than that:

Acked-and-tested-by: Borislav Petkov <borislav.petkov@amd.com>

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
