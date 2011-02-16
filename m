Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab1BPDBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 22:01:47 -0500
Received: from smtp-out.google.com ([74.125.121.67]:22600 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218Ab1BPDBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 22:01:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type:content-id;
        b=qoynwvEpAmoWMePir9NKe14IJ8RHXcXZ+3dWzVP9T/Tnc3d5BM1x86y/QcuW+k/M7T
         tyuD+llfM/QkjIzTl56w==
Date: Tue, 15 Feb 2011 19:01:34 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan.kim@gmail.com>
cc: Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] - Improve drain pages performance on large systems
In-Reply-To: <AANLkTim+rjN8GMwOV5MLeVjXaevHmCciAc5DwQXgiO62@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1102151858580.19953@chino.kir.corp.google.com>
References: <20110215223840.GA27420@sgi.com> <AANLkTim+rjN8GMwOV5MLeVjXaevHmCciAc5DwQXgiO62@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531368966-1485521709-1297825218=:19953"
Content-ID: <alpine.DEB.2.00.1102151900250.19953@chino.kir.corp.google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531368966-1485521709-1297825218=:19953
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.00.1102151900251.19953@chino.kir.corp.google.com>

On Wed, 16 Feb 2011, Minchan Kim wrote:

> > Index: linux/mm/page_alloc.c
> > ===================================================================
> > --- linux.orig/mm/page_alloc.c  2011-02-15 16:28:36.165921713 -0600
> > +++ linux/mm/page_alloc.c       2011-02-15 16:29:43.085502487 -0600
> > @@ -592,10 +592,24 @@ static void free_pcppages_bulk(struct zo
> >        int batch_free = 0;
> >        int to_free = count;
> >
> > +       /*
> > +        * Quick scan of zones. If all are empty, there is nothing to do.
> > +        */
> > +       for (migratetype = 0; migratetype < MIGRATE_PCPTYPES; migratetype++) {
> > +               struct list_head *list;
> > +
> > +               list = &pcp->lists[migratetype];
> > +               if (!list_empty(list))
> > +                       break;
> > +       }
> > +       if (migratetype == MIGRATE_PCPTYPES)
> > +               return;
> > +
> >        spin_lock(&zone->lock);
> >        zone->all_unreclaimable = 0;
> >        zone->pages_scanned = 0;
> >
> > +       migratetype = 0;
> >        while (to_free) {
> >                struct page *page;
> >                struct list_head *list;
> 
> It does make sense to me.
> Although new code looks to be rather costly in small box, anyway we
> use the same logic  in while loop so cache would be hot. so cost would
> be little.
> 

I was going to mention the implications for small machines as well, this 
doesn't look good for callers that know free_pcppages_bulk() will do 
something.

> But how about this? This one never affect fast-critical path.
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ff7e158..2dfb61a 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1095,8 +1095,10 @@ static void drain_pages(unsigned int cpu)
>                 pset = per_cpu_ptr(zone->pageset, cpu);
> 
>                 pcp = &pset->pcp;
> -               free_pcppages_bulk(zone, pcp->count, pcp);
> -               pcp->count = 0;
> +               if (pcp->count > 0) {
> +                       free_pcppages_bulk(zone, pcp->count, pcp);
> +                       pcp->count = 0;
> +               }
>                 local_irq_restore(flags);
>         }
>  }

Right, this is 2ff754fa upstream.  I'm wondering if Jack still sees the 
same problem since 2.6.38-rc3.
--531368966-1485521709-1297825218=:19953--
