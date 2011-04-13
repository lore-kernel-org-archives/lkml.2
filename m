Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab1DMUVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 16:21:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757474Ab1DMUVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 16:21:35 -0400
Date: Wed, 13 Apr 2011 22:20:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
        behlendorf1@llnl.gov
Subject: Re: [PATCH] remove abs64()
Message-ID: <20110413202031.GA19113@redhat.com>
References: <20110412210045.GA19901@p183> <20110413142703.GA1511@redhat.com> <20110413114808.12783565.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110413114808.12783565.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13, Andrew Morton wrote:
>
> On Wed, 13 Apr 2011 16:27:03 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > On 04/13, Alexey Dobriyan wrote:
> > >
> > > +#define abs(x)								\
> > > +({									\
> > > +	typeof(x) _x = (x);						\
> > > +									\
> > > +	__builtin_choose_expr(						\
> > > +		__builtin_types_compatible_p(typeof(_x), signed char),	\
> > > +		(unsigned char)({ _x < 0 ? -_x : _x; }),		\
> > > +	__builtin_choose_expr(						\
> > > +		__builtin_types_compatible_p(typeof(_x), short),	\
> > > +		(unsigned short)({ _x < 0 ? -_x : _x; }),		\
> > > +	__builtin_choose_expr(						\
> > > +		__builtin_types_compatible_p(typeof(_x), int),		\
> > > +		(unsigned int)({ _x < 0 ? -_x : _x; }),			\
> > > +	__builtin_choose_expr(						\
> > > +		__builtin_types_compatible_p(typeof(_x), long),		\
> > > +		(unsigned long)({ _x < 0 ? -_x : _x; }),		\
> > > +	__builtin_choose_expr(						\
> > > +		__builtin_types_compatible_p(typeof(_x), long long),	\
> > > +		(unsigned long long)({ _x < 0 ? -_x : _x; }),		\
> > > +	_x)))));							\
> > > +})
> >
> > Personally I agree.
> >
> > But, we have some stupid users which do something like abs(u32_value)
> > and expecting that abs() should treat this value as "signed".
> >
>
> um, yes, I'd forgotten that one.  That's a show-stopper.

May be we can demand to fix them?

I agree with Alexey, it is a bit ugly to have abs() and abs64(), and abs()
itself doesn't look very nice.

What if we simply add

	BUILD_BUG_ON( (typeof(_x)-1) > 0 );

into abs()?

After that it would be trivial to find the offenders and fix them,

	- abs(unsigned_int)
	+ abs((int) unsigned_int)

Oleg.

