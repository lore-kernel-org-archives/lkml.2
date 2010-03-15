Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936828Ab0COVLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 17:11:40 -0400
Received: from relay2.sgi.com ([192.48.179.30]:38905 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932738Ab0COVLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 17:11:38 -0400
Date: Mon, 15 Mar 2010 16:11:36 -0500
From: Robin Holt <holt@sgi.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Robin Holt <holt@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Subject: Re: [Patch] x86,pat Update the page flags for memtype atomically
 instead of using memtype_lock.
Message-ID: <20100315211136.GD4920@sgi.com>
References: <20100311161700.GC5685@sgi.com>
 <1268439313.2793.148.camel@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268439313.2793.148.camel@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  static inline void set_page_memtype(struct page *pg, unsigned long memtype)
> >  {
> > +	unsigned long memtype_flags = _PGMT_DEFAULT;
> > +	unsigned long old_flags;
> > +	unsigned long new_flags;
> > +
> >  	switch (memtype) {
> >  	case _PAGE_CACHE_WC:
> > -		ClearPageUncached(pg);
> > -		SetPageWC(pg);
> > +		memtype_flags = _PGMT_WC;
> >  		break;
> >  	case _PAGE_CACHE_UC_MINUS:
> > -		SetPageUncached(pg);
> > -		ClearPageWC(pg);
> > +		memtype_flags = _PGMT_UC_MINUS;
> >  		break;
> >  	case _PAGE_CACHE_WB:
> > -		SetPageUncached(pg);
> > -		SetPageWC(pg);
> > -		break;
> > -	default:
> > -	case -1:
> > -		ClearPageUncached(pg);
> > -		ClearPageWC(pg);
> > +		memtype_flags = _PGMT_WB;
> 
> For WB case it should be _PGMT_WB and for the case of "-1" this should
> be _PGMT_DEFAULT, as in the case of free page we mark it _PGMT_DEFAULT
> and when there is an explicit request to mark it WB, then we mark it
> _PGMT_WB
> 
> Other than that it looks good to me.

This is easier to look at if you ignore the diff and just look at the
fixed up code:

static inline void set_page_memtype(struct page *pg, unsigned long memtype)
{
	unsigned long memtype_flags = _PGMT_DEFAULT;
	unsigned long old_flags;
	unsigned long new_flags;

	switch (memtype) {
	case _PAGE_CACHE_WC:
		memtype_flags = _PGMT_WC;
		break;
	case _PAGE_CACHE_UC_MINUS:
		memtype_flags = _PGMT_UC_MINUS;
		break;
	case _PAGE_CACHE_WB:
		memtype_flags = _PGMT_WB;
		break;
	}

	do {
		old_flags = pg->flags;
		new_flags = (old_flags & _PGMT_CLEAR_MASK) | memtype_flags;
	} while (cmpxchg(&pg->flags, old_flags, new_flags) != old_flags);
}


The memtype_flags start out cleared and only deviate when _WC, _UC_MINUS,
or _WB is specified.

Did I miss anything there?

Thanks,
Robin
