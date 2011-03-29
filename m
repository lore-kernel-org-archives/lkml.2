Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab1C2TnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 15:43:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:43092 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab1C2TnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 15:43:04 -0400
Date: Tue, 29 Mar 2011 21:42:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <johnstul@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] fix msecs_to_jiffies() to not return values greater than
 MAX_JIFFY_OFFSET
In-Reply-To: <2120287.WTetKHanc4@donald.sf-tec.de>
Message-ID: <alpine.LFD.2.00.1103292103070.2774@localhost6.localdomain6>
References: <2120287.WTetKHanc4@donald.sf-tec.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Mar 2011, Rolf Eike Beer wrote:

> The documentation of msecs_to_jiffies() says:
> 
>  * - negative values mean 'infinite timeout' (MAX_JIFFY_OFFSET)
>  *
>  * - 'too large' values [that would result in larger than
>  *   MAX_JIFFY_OFFSET values] mean 'infinite timeout' too.
> 
> But when you pass in e.g. MAX_JIFFY_OFFSET + 1000 for HZ = 1000 it will not
> return MAX_JIFFY_OFFSET, but the bigger value. This makes sure that the value

That's only true for 32 bit.

> returned from this function can never be bigger than MAX_JIFFY_OFFSET. Also
> use DIV_ROUND_UP() in one place where that is open coded.

>  unsigned long msecs_to_jiffies(const unsigned int m)
>  {
> +	unsigned long r;
>  	/*
>  	 * Negative value, means infinite timeout:
>  	 */
> @@ -445,7 +446,7 @@ unsigned long msecs_to_jiffies(const unsigned int m)
>  	 * round multiple of HZ, divide with the factor between them,
>  	 * but round upwards:
>  	 */
> -	return (m + (MSEC_PER_SEC / HZ) - 1) / (MSEC_PER_SEC / HZ);
> +	r = DIV_ROUND_UP(m, MSEC_PER_SEC / HZ);
>  #elif HZ > MSEC_PER_SEC && !(HZ % MSEC_PER_SEC)
>  	/*
>  	 * HZ is larger than 1000, and HZ is a nice round multiple of
> @@ -457,7 +458,7 @@ unsigned long msecs_to_jiffies(const unsigned int m)
>  	if (m > jiffies_to_msecs(MAX_JIFFY_OFFSET))
>  		return MAX_JIFFY_OFFSET;
>  
> -	return m * (HZ / MSEC_PER_SEC);
> +	r = m * (HZ / MSEC_PER_SEC);

For this case the jiffies_to_msec() check should be sufficient.

>  #else
>  	/*
>  	 * Generic case - multiply, round and divide. But first
> @@ -467,9 +468,10 @@ unsigned long msecs_to_jiffies(const unsigned int m)
>  	if (HZ > MSEC_PER_SEC && m > jiffies_to_msecs(MAX_JIFFY_OFFSET))
>  		return MAX_JIFFY_OFFSET;

Hmm, this check is silly. MUL32 is chosen, so that we cannot overflow.

> -	return (MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32)
> +	r = (MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32)
  		>> MSEC_TO_HZ_SHR32;

>  #endif
> +	return min_t(unsigned long, r, MAX_JIFFY_OFFSET);
>  }
>  EXPORT_SYMBOL(msecs_to_jiffies);

I start to wonder whether we really need these three variants or
whether we just could go with that MUL/SHIFT based implementation and
a final check for MAX_JIFFY_OFFSET. That would boil down to:

unsigned long msecs_to_jiffies(const unsigned int m)
{
	u64 res = (MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32) >> MSEC_TO_HZ_SHR32;

	return min_t(unsigned long, (unsigned long)res, MAX_JIFFY_OFFSET);
}

That'd avoid the whole division and msecs_to_jiffies() is not really a
high precision function.

Thanks,

	tglx
