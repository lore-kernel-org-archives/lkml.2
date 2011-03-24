Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab1CXRlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:41:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60164 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab1CXRlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:41:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kNXhbPNct9ED8upImoj5meOR2W9VUHgQGddxs6ru3PyJINYrQoonLEVQJu7/LMZu3w
         IT564ihrzAIkwYJcrBI9+IecqgMD1hitq/raLNBKnIDx+YU767A4UbV7pnxMsInfxFqj
         3uzwNl37sk8iYNX8ClY1eVJxnkqER/wDvZQT4=
Date: Thu, 24 Mar 2011 19:41:03 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Michael Rodriguez <dkingston02@gmail.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/itimer.c use ternary operators where appropriate
 and fix all style issues.
Message-ID: <20110324174103.GA5187@p183.telecom.by>
References: <1300987563-27697-1-git-send-email-dkingston02@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300987563-27697-1-git-send-email-dkingston02@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 01:26:03PM -0400, Michael Rodriguez wrote:
> @@ -33,12 +32,8 @@ static struct timeval itimer_get_remtime(struct hrtimer *timer)
>  	 * hrtimer_get_remtime() call but before this condition
>  	 * then we return 0 - which is correct.
>  	 */
> -	if (hrtimer_active(timer)) {
> -		if (rem.tv64 <= 0)
> -			rem.tv64 = NSEC_PER_USEC;
> -	} else
> -		rem.tv64 = 0;
> -
> +	rem.tv64 = ((hrtimer_active(timer) && rem.tv64 <= 0) ?
> +			NSEC_PER_USEC : 0);

NAK, not equivalent code.

>  	return ktime_to_timeval(rem);
>  }
>  
> @@ -57,17 +52,12 @@ static void get_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
>  		cputime_t t;
>  
>  		thread_group_cputimer(tsk, &cputime);
> -		if (clock_id == CPUCLOCK_PROF)
> -			t = cputime_add(cputime.utime, cputime.stime);
> -		else
> -			/* CPUCLOCK_VIRT */
> -			t = cputime.utime;
> -
> -		if (cputime_le(cval, t))
> -			/* about to fire */
> -			cval = cputime_one_jiffy;
> -		else
> -			cval = cputime_sub(cval, t);
> +
> +		t = (clock_id == CPUCLOCK_PROF) ? cputime_add(cputime.utime,
> +			cputime.stime) : cputime.utime;
> +
> +		cval = (cputime_le(cval, t) ? cputime_one_jiffy :
> +			cputime_sub(cval, t));

This code is not more readable than original one.
