Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab1DSU5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:57:04 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:45953 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751804Ab1DSU5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:57:01 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 3Uwn4HEVM1ngrU6dWyiZ8cN2dj7nMdzVaXeyNtodYbeMzyB
 0q3rY6WXvMQ2KMKfNN4S0fgZZf08i1R8cp2ICaRmYSangX7JTWFOXBmezLvj
 cjE0jiRj17TTALesVwVrUxzW0CYGXhFOKOeZhlNoQ4paBE_k2i9tNqWdp3xN
 tty4HWYJdvlehd4YSJXH6nrraePKrfW.gXsDAm7dY9Wr8XtfdZ5vF7t5c3V7
 WXJYH03h5ITTZmezTzBfm8W111pCpTQih7WfMgFM2d3V0Eo77pLWtlnO8DeN
 EnE4VArxgkrhDKov1_2jX6qgu_tfbDcsMvY8Tzs8u0Nt9po9V
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 19 Apr 2011 15:56:46 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
In-Reply-To: <1303242580.11237.10.camel@mulgrave.site>
Message-ID: <alpine.DEB.2.00.1104191530040.23077@router.home>
References: <20110415135144.GE8828@tiehlicka.suse.cz>  <alpine.LSU.2.00.1104171952040.22679@sister.anvils>  <20110418100131.GD8925@tiehlicka.suse.cz>  <20110418135637.5baac204.akpm@linux-foundation.org>  <20110419111004.GE21689@tiehlicka.suse.cz> 
 <1303228009.3171.18.camel@mulgrave.site>  <BANLkTimYrD_Sby_u-fPSwn-RJJyEVavU5w@mail.gmail.com>  <1303233088.3171.26.camel@mulgrave.site>  <alpine.DEB.2.00.1104191213120.17888@router.home>  <1303235306.3171.33.camel@mulgrave.site> 
 <alpine.DEB.2.00.1104191254300.19358@router.home>  <1303237217.3171.39.camel@mulgrave.site>  <alpine.DEB.2.00.1104191325470.19358@router.home> <1303242580.11237.10.camel@mulgrave.site>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Apr 2011, James Bottomley wrote:

> > > I told you ... I forced an allocation into the first discontiguous
> > > region.  That will return 1 for page_to_nid().
> >
> > How? The kernel has no concept of a node 1 without CONFIG_NUMA and so you
> > cannot tell the page allocator to allocate from node 1.
>
> Yes, it does, as I explained in the email.

Looked through it and canot find it. How would that be possible to do
with core kernel calls since the page allocator calls do not allow you to
specify a node under !NUMA.

> Don't be silly: alpha, ia64, m32r, m68k, mips, parisc, tile and even x86
> all use the discontigmem memory model in some configurations.

I guess DISCONTIGMEM is typically used together with NUMA. Otherwise we
would have run into this before.

> > > Not really.  The rest of the kernel uses the proper macros.  in
> > > DISCONTIGMEM but !NUMA configs, the numa macros expand correctly.
> > > You've cut across that with all the CONFIG_NUMA checks in slub.
> >
> > What are "the proper macros"? AFAICT page_to_nid() is the proper way to
> > access the node of a page. If page_to_nid() returns 1 then you have a zone
> > that the kernel knows of as being in node 0 having a page on a different
> > node.
>
> Well it depends what you want.  If you only want the actual NUMA node,
> then pfn_to_nid() probably isn't what you want, because in a
> DISCONTIGMEM model, there may be multiple nids per actual numa node.

Right yes you got it. The notion of a node is different(!!!!!). What
matters to the core kernel is the notion of a NUMA node. If DISCONTIGMEM
runs with !NUMA then the way that "node" is used in DISCONTIGMEM is
different from the core code and refers only to the memory blocks managed
by DISCONTIGMEM. The node should be irrelevant to the core then.

> > We can likely force page_to_nid to ignore the node information that have
> > been erroneously placed there but this looks like something deeper is
> > wrong here. The node field in struct page is not only used for the Linux
> > support of a NUMA node but also for blocks of memory. Those should be
> > separate things.
>
> Look, it's not wrong, it's by design.  The assumption that non-numa
> systems don't use nodes is the wrong one.

Depends on how you define the notion of a node. The way the core kernel
uses the term "node" means that there will be only one node and that is
node 0 if CONFIG_NUMA is off. Thus page_to_nid() must return 0 for !NUMA.

All sort of things in the core code will break in weird ways if you do
allow page_to_nid to return 1 under !NUMA. Just look at the usage of
page_to_nid(). Tried to use huge pages yet? And how will your version
of reality deal with the following checks in the page allocator? F.e.

              VM_BUG_ON(page_to_nid(page) != zone_to_nid(zone));

Enabled CONFIG_DEBUG_VM yet?


> > Index: linux-2.6/include/linux/mm.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/mm.h	2011-04-19 13:20:20.092521248 -0500
> > +++ linux-2.6/include/linux/mm.h	2011-04-19 13:21:05.962521196 -0500
> > @@ -665,6 +665,7 @@ static inline int zone_to_nid(struct zon
> >  #endif
> >  }
> >
> > +#ifdef CONFIG_NUMA
> >  #ifdef NODE_NOT_IN_PAGE_FLAGS
> >  extern int page_to_nid(struct page *page);
> >  #else
> > @@ -673,6 +674,9 @@ static inline int page_to_nid(struct pag
> >  	return (page->flags >> NODES_PGSHIFT) & NODES_MASK;
> >  }
> >  #endif
> > +#else
> > +#define page_to_nid(x) 0
> > +#endif
>
> Don't be silly ... that breaks asm-generic/memory_model.h

Well yeah looks like in order to be clean in the !NUMA case we would then
need a page_to_discontig_node_id() there that is different from the
page_to_nid() used for the core.

