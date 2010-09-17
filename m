Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab0IQAEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 20:04:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798Ab0IQAEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 20:04:20 -0400
Date: Fri, 17 Sep 2010 02:00:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Brian Behlendorf <behlendorf1@llnl.gov>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ben Woodard <bwoodard@llnl.gov>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Mark Grondona <mgrondona@llnl.gov>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make div64_u64() precise on 32bit platforms
Message-ID: <20100917000016.GA23616@redhat.com>
References: <20100802160951.GA13385@redhat.com> <20100803152812.210439dc.akpm@linux-foundation.org> <201008090930.56671.behlendorf1@llnl.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008090930.56671.behlendorf1@llnl.gov>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09, Brian Behlendorf wrote:
>
> > On Mon, 2 Aug 2010 18:09:51 +0200
> >
> > Oleg Nesterov <oleg@redhat.com> wrote:
> > > We have a bugreport which blames div64_u64() on 32bit platforms.
> > >
> > > However, the code obviously doesn't even try to pretend it can do
> > > the 64bit division precisely. If there is something in the high
> > > word of divisor, div64_u64() just shifts both arguments and throws
> > > out the low bits.
> >
> > Well that was a bit lazy of us - I wonder how hard it is to fix.
> >
> > At present people will test their code on 64-bit only to find out later
> > that it doesn't work correctly on 32-bit.  Bad.  Perhaps we should
> > similarly break the 64-bit version :)
>
> Here's an even crazier idea, let's just fix the 32-bit version.  :)
>
> The attached patch fully implements div64_u64() such that it will return
> precisely the right quotient even when the divisor exceeds 32-bits.  The
> patch also adds a div64_s64() function to fully support signed 64-bit
> division.

Well, since nobody commented this patch...

Personally I agree, it makes sense to make it precise/correct. I think
you should add CC's and resend the patch. Although I do not know who
can ack it authoritatively (probably Andrew ;).

I have no idea how much the fixed version is slower, and afaics the
current callers do not really care about precision. But we can always
add the old code back as div64_64_sucks_on_32_bit_but_faster().

> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -162,6 +162,11 @@ extern int _cond_resched(void);
>  		(__x < 0) ? -__x : __x;		\
>  	})
>
> +#define abs64(x) ({				\
> +		s64 __x = (x);			\
> +		(__x < 0) ? -__x : __x;		\
> +	})
> +

Can't we just improve abs? Say,

	#define abs(x) ({				\
			typeof(x) __x = (x);		\
			(__x < 0) ? -__x : __x;		\
		})


>  u64 div64_u64(u64 dividend, u64 divisor)
>  {
> ...
> +	} else {
> +		n = __builtin_clzll(divisor);

This is a bit unusual. I mean, it is not that common to use gcc builtins
in the normal code. And, it seems, we can use __fls(divisor >> 32) or
just fls64() instead ?

Oleg.

