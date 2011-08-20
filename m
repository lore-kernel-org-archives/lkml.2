Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab1HTQAl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 12:00:41 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:20613 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752928Ab1HTQAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 12:00:40 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: BuCxHf4VM1meh32UxW0syAFw1.TiB4c9K8AiEKDXVgyB9v4
 3Z9dh4gNHjpYE2yLRYPHdZ8CepbVBwZ8rURjkgp81eKoe.M7lsk1WkI1apNj
 6PAFCl_wPvyMDevQZdkYwXbiQtfq6Roq9eiRAR9I3A4uLtnJEMXff.RM3gfz
 RKtpdLAh1lQKzAzMtOHeSUWOGV7RoE3fM5de_AQpauWCYJlrJIQz6yaHasjW
 0MeLGVvf38sZdohpR9vdwQ_K6TMOB.uH1BSpuVcf4KQfWAtzCg.qbFzxof4w
 XFwyN1zStOPMXziY7WHXyOUtmSKDNMFVwbEHSzDzqP98QHWWbtSeKUhbJZHi
 QyrWnk2Yshs.8Qs2ystpP6IK4_fHt_OK38BxOkltknzlOXA--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Sat, 20 Aug 2011 11:00:37 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [slub p4 6/7] slub: per cpu cache for partial pages
In-Reply-To: <alpine.DEB.2.00.1108201339580.3008@localhost6.localdomain6>
Message-ID: <alpine.DEB.2.00.1108201059060.5267@router.home>
References: <20110809211221.831975979@linux.com> <20110809211302.222722588@linux.com> <alpine.DEB.2.00.1108201339580.3008@localhost6.localdomain6>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Aug 2011, Pekka Enberg wrote:

> > @@ -2919,7 +3071,34 @@ static int kmem_cache_open(struct kmem_c
> >  	 * The larger the object size is, the more pages we want on the
> > partial
> >  	 * list to avoid pounding the page allocator excessively.
> >  	 */
> > -	set_min_partial(s, ilog2(s->size));
> > +	set_min_partial(s, ilog2(s->size) / 2);
>
> Why do we want to make minimum size smaller?

Because we are getting additional partial pages cached for each processor.

> > +	 */
> > +	if (s->size >= PAGE_SIZE)
> > +		s->cpu_partial = 2;
> > +	else if (s->size >= 1024)
> > +		s->cpu_partial = 6;
> > +	else if (s->size >= 256)
> > +		s->cpu_partial = 13;
> > +	else
> > +		s->cpu_partial = 30;
>
> How did you come up with these limits?

These are the per cpu queue limits of SLAB.

> > +		struct {		/* slub per cpu partial pages */
> > +			struct page *next;	/* Next partial slab */
> > +#ifdef CONFIG_64BIT
> > +			int pages;	/* Nr of partial slabs left */
> > +			int pobjects;	/* Approximate # of objects */
> > +#else
> > +			short int pages;
> > +			short int pobjects;
> > +#endif
> > +		};
> > +	};
>
> Why are the sizes different on 32-bit and 64-bit? Does this change 'struct
> page' size?

int == long /2 under 64 bit
int == long on 32 bit.

without the ifdef the page struct could get bigger for 32 bit.

