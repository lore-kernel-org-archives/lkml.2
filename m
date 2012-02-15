Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab2BOUYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:24:37 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:51384 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754996Ab2BOUYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:24:36 -0500
Date: Wed, 15 Feb 2012 15:24:27 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Christoph Lameter <cl@linux.com>
Cc: Xi Wang <xi.wang@gmail.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Juhl <jj@chaosbits.net>, Jens Axboe <axboe@kernel.dk>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>
Subject: Re: Uninline kcalloc
Message-ID: <20120215202427.GA7035@elliptictech.com>
References: <20120214072017.GF26353@mwanda>
 <alpine.DEB.2.00.1202140858080.20013@router.home>
 <8F83835C-366C-46AC-A50A-3F680B7D2D83@gmail.com>
 <alpine.DEB.2.00.1202141032410.22250@router.home>
 <ADCFB33D-7284-4D3F-8280-545AF82EC744@gmail.com>
 <alpine.DEB.2.00.1202141329360.24883@router.home>
 <alpine.DEB.2.00.1202141336060.24883@router.home>
 <20120214205032.GA631@elliptictech.com>
 <alpine.DEB.2.00.1202141513210.29019@router.home>
 <20120215201757.GA6934@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120215201757.GA6934@elliptictech.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-02-15 15:17 -0500, Nick Bowler wrote:
> On 2012-02-14 15:24 -0600, Christoph Lameter wrote:
> > On Tue, 14 Feb 2012, Nick Bowler wrote:
> > 
> > > On 2012-02-14 13:37 -0600, Christoph Lameter wrote:
> > > > This patch still preserves kcalloc. But note that if kcalloc returns NULL
> > > > then multiple conditions may have caused it. One is that the array is
> > > > simply too large. The other may be that such an allocation is not possible
> > > > due to fragmentation.
> > > [...]
> > > > +static inline long calculate_array_size(size_t n, size_t size)
> > > > +{
> > > > +	if (size != 0 && n > ULONG_MAX / size)
> > > > +
> > > > +		return 0;
> > >
> > > This isn't right.  The above tests whether or not the result of the
> > > multiplication will not be representable in an 'unsigned long'...
> > 
> > Yes and so does the current kcalloc.
> 
> Well, the current kcalloc doesn't assign the result to a signed long.
> However, it does assign the result to a size_t, which makes one wonder
> why it's not testing against SIZE_MAX.

Of course, right after I send this I realize that we do not appear to
define SIZE_MAX in the kernel.  So s/SIZE_MAX/((size_t)-1)/g.

> If size_t has the same range as unsigned long on all architectures,
> then this confusion doesn't matter, but is that actually the case?
> 
> > > > +	return n * size;
> > >
> > > but then the result is assigned to a (signed) long, which may overflow
> > > if it's greater than LONG_MAX.
> > 
> > That can happen?
> 
> Yes, because LONG_MAX (the maximum value of your return type) is
> strictly less than ULONG_MAX (what you test against).  It's not hard to
> pick input numbers that multiply to something between LONG_MAX and
> ULONG_MAX, which will cause your function to return a negative value
> (standard C leaves the result of such a conversion implementation-
> defined, but I'll assume for now that it works this way for everything
> that compiles Linux).
> 
> Admittedly, your kcalloc change then assigns this negative value to a
> size_t, which will result in the correct positive value assuming
> SIZE_MAX == ULONG_MAX, but that's gratuitously roundabout.
> 
> [...]
> > > [...]
> > > >  void *kcalloc(size_t n, size_t size, gfp_t flags)
> > > >  {
> > > > -	if (size != 0 && n > ULONG_MAX / size)
> > > > -		return NULL;
> > > > -	return __kmalloc(n * size, flags | __GFP_ZERO);
> > > > +	size_t s = calculate_array_size(n, size);
> > > > +
> > > > +	if (s)
> > > > +		return kzalloc(s, flags);
> > > > +
> > > > +	return NULL;
> > > >  }
> > >
> > > This hunk changes the behaviour of kcalloc if either of the two size parameters
> > > is 0.
> > 
> > You want ZERO_PTR returns?
> >
> > NULL is one permissible return value of calloc() if size == 0. So we are
> > now deviating from user space conventions.
> 
> Sort of.  While standard C leaves it implementation-defined whether
> successful zero-sized allocations are possible, all sane implementations
> let them succeed.  Hence, portable C apps need to handle 0 as a special
> case, because there are insane implementations out there.  There's no
> reason for the kernel to be one of them.
> 
> Regardless, this was still a (presumably unintentional) change from
> the previous behaviour.
> 
> Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

