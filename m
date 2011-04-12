Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574Ab1DLVLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 17:11:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932155Ab1DLVLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 17:11:17 -0400
Date: Tue, 12 Apr 2011 14:10:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
        behlendorf1@llnl.gov, oleg@redhat.com
Subject: Re: [PATCH] remove abs64()
Message-Id: <20110412141040.a5706346.akpm@linux-foundation.org>
In-Reply-To: <20110412140726.3f4f2a7b.rdunlap@xenotime.net>
References: <20110412210045.GA19901@p183>
	<20110412140726.3f4f2a7b.rdunlap@xenotime.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011 14:07:26 -0700
Randy Dunlap <rdunlap@xenotime.net> wrote:

> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> > @@ -143,28 +143,27 @@ extern int _cond_resched(void);
> >  
> >  #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
> >  
> > -/*
> > - * abs() handles unsigned and signed longs, ints, shorts and chars.  For all
> > - * input types abs() returns a signed long.
> > - * abs() should not be used for 64-bit types (s64, u64, long long) - use abs64()
> > - * for those.
> > - */
> > -#define abs(x) ({						\
> > -		long ret;					\
> > -		if (sizeof(x) == sizeof(long)) {		\
> > -			long __x = (x);				\
> > -			ret = (__x < 0) ? -__x : __x;		\
> > -		} else {					\
> > -			int __x = (x);				\
> > -			ret = (__x < 0) ? -__x : __x;		\
> > -		}						\
> > -		ret;						\
> > -	})
> > -
> > -#define abs64(x) ({				\
> > -		s64 __x = (x);			\
> > -		(__x < 0) ? -__x : __x;		\
> > -	})
> > +#define abs(x)								\
> > +({									\
> > +	typeof(x) _x = (x);						\
> > +									\
> > +	__builtin_choose_expr(						\
> > +		__builtin_types_compatible_p(typeof(_x), signed char),	\
> > +		(unsigned char)({ _x < 0 ? -_x : _x; }),		\
> > +	__builtin_choose_expr(						\
> > +		__builtin_types_compatible_p(typeof(_x), short),	\
> > +		(unsigned short)({ _x < 0 ? -_x : _x; }),		\
> > +	__builtin_choose_expr(						\
> > +		__builtin_types_compatible_p(typeof(_x), int),		\
> > +		(unsigned int)({ _x < 0 ? -_x : _x; }),			\
> > +	__builtin_choose_expr(						\
> > +		__builtin_types_compatible_p(typeof(_x), long),		\
> > +		(unsigned long)({ _x < 0 ? -_x : _x; }),		\
> > +	__builtin_choose_expr(						\
> > +		__builtin_types_compatible_p(typeof(_x), long long),	\
> > +		(unsigned long long)({ _x < 0 ? -_x : _x; }),		\
> > +	_x)))));							\
> > +})
> 
> that is better?

I think so.

It's a bit concerning that it changes the return type of abs().
