Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab1DBNHO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 09:07:14 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:40096 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754930Ab1DBNHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 09:07:13 -0400
Date: Sat, 2 Apr 2011 06:06:52 -0700
From: Johannes Weiner <hannes@cmpxchg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Maksym Planeta <mcsim.planeta@gmail.com>, mingo@redhat.com,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] page: get_order() optimization
Message-ID: <20110402130652.GA2344@cmpxchg.org>
References: <1301685493-2567-1-git-send-email-mcsim.planeta@gmail.com>
 <4D9628C8.3040309@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9628C8.3040309@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 12:34:32PM -0700, H. Peter Anvin wrote:
> On 04/01/2011 12:18 PM, Maksym Planeta wrote:
> > Loop was repalaced with __builtin_clz(). This still allows to precompute
> > constants, but on some architectures it uses special instruction to
> > calculate order.
> > 
> > Signed-off-by: Maksym Planeta <mcsim.planeta@gmail.com>
> > ---
> >  include/asm-generic/getorder.h |    8 +++-----
> >  1 files changed, 3 insertions(+), 5 deletions(-)
> > 
> > diff --git a/include/asm-generic/getorder.h b/include/asm-generic/getorder.h
> > index 67e7245..fe8020c 100644
> > --- a/include/asm-generic/getorder.h
> > +++ b/include/asm-generic/getorder.h
> > @@ -11,11 +11,9 @@ static inline __attribute_const__ int get_order(unsigned long size)
> >  	int order;
> >  
> >  	size = (size - 1) >> (PAGE_SHIFT - 1);
> > -	order = -1;
> > -	do {
> > -		size >>= 1;
> > -		order++;
> > -	} while (size);
> > +	order = (__builtin_clzl(size) ^ (BITS_PER_LONG - 1));
> > +	if (size == 0)
> > +		order = 0;
> >  	return order;
> >  }
> >  
> 
> You need to guard this with __GNUC__ >= 4; there are still laggards
> using gcc 3.  Furthermore, on some platforms __builtin_clz*() does a
> libgcc call which may be undesirable.
> 
> For the generic case, one can do something like this instead of a loop:

It looks odd to me to count from the left and then subtract to get the
offset of the msb from the right.  Can't we just use fls() here, which
is already made available in both generic and arch-optimized versions?

	pages = size - 1 >> PAGE_SHIFT;
	if (pages)
		return __fls(pages) + 1;
	return 0;
