Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab1GLP7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 11:59:41 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:31892 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753654Ab1GLP7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 11:59:40 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Cqqicz4VM1lSBx0Y8ne7KHCvYdZhnvjCsG0qIVBbgfIN4HO
 4wTxGbUoJp1uEWQBfIl_zoOtXKkTkd9PQOuelYYVDKIYBrOYRhQdb.x71lhi
 E0Uji2T9aP56rZjTmybrOFpUJB5pluCBPZt62o09LtX_MiVFN9pYvi3uexvQ
 cGlBK20wuUBTn_bsZEvFVFuA5hGcORU1v_ylYqBo.YJ9tBBdmxDWa2VvbFSB
 EzEclu8pyjXtvb4_KknB.cruQuc6ijw7fKix5p9DxS8eWqzuSUcP1MqpaIHM
 q4s6OaOvoM9A6jvVAUZDNlR1vCrEAfUJ0QV_g7H6Mf2X0xK.J
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 12 Jul 2011 10:59:36 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [slubllv7 06/17] slub: Add cmpxchg_double_slab()
In-Reply-To: <1310414100.2860.6.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1107121057550.2931@router.home>
References: <20110601172543.437240675@linux.com>  <20110601172615.286693377@linux.com> <1310414100.2860.6.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011, Eric Dumazet wrote:

> > @@ -338,6 +342,37 @@ static inline int oo_objects(struct kmem
> >  	return x.x & OO_MASK;
> >  }
> >
> > +static inline bool cmpxchg_double_slab(struct kmem_cache *s, struct page *page,
> > +		void *freelist_old, unsigned long counters_old,
> > +		void *freelist_new, unsigned long counters_new,
> > +		const char *n)
> > +{
> > +#ifdef CONFIG_CMPXCHG_DOUBLE
> > +	if (s->flags & __CMPXCHG_DOUBLE) {
> > +		if (cmpxchg_double(&page->freelist,
> > +			freelist_old, counters_old,
> > +			freelist_new, counters_new))
> > +		return 1;
> > +	} else
> > +#endif
> > +	{
> > +		if (page->freelist == freelist_old && page->counters == counters_old) {
> > +			page->freelist = freelist_new;
> > +			page->counters = counters_new;
> > +			return 1;
> > +		}
> > +	}
>
> This works only on 64bit arches, where page->counters get all following
> fields combined : inuse, objects, frozen, _count
>
> On 32bit arch, I am afraid you have to disable the cmpxchg_double()
> thing ?

We do not need to have _count included. This is just there because the
field is in the way on 64 bit and we can only do 2x 64 bit cmpxchges.  On
32 bi we can drop _count from "counters".



