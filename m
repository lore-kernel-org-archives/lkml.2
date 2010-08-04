Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab0HDQPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 12:15:35 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:27031 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752313Ab0HDQPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 12:15:34 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: .8R7gH0VM1mwe1eOZmHH125LdmtHxmRGyACzGAI2xM2MVWf
 b.LN2DwlIjtpa2i2Ol0mbtTlg2WQX8kne60TlJRLYGDFb.wGkIPNJAM2fz8S
 oCmLaWCvmxarTFgarRRv6V06ch_OXdPORZ_zC5fP7fEfhqb0IqXcx85C9pC.
 c.j3wURyCj86sZFLNcjDEfZ8RYWKa.IQNJYLHbEe0FzYB99bLTNAzjFHfP5m
 e
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 4 Aug 2010 11:15:29 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: [S+Q3 03/23] slub: Use a constant for a unspecified node.
In-Reply-To: <alpine.DEB.2.00.1008032029380.23490@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1008040946200.11084@router.home>
References: <20100804024514.139976032@linux.com> <20100804024525.562559967@linux.com> <alpine.DEB.2.00.1008032029380.23490@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Aug 2010, David Rientjes wrote:

> >  static struct page *get_partial(struct kmem_cache *s, gfp_t flags, int node)
> >  {
> >  	struct page *page;
> > -	int searchnode = (node == -1) ? numa_node_id() : node;
> > +	int searchnode = (node == NUMA_NO_NODE) ? numa_node_id() : node;
> >
> >  	page = get_partial_node(get_node(s, searchnode));
> >  	if (page || (flags & __GFP_THISNODE) || node != -1)
>
> This has a merge conflict with 2.6.35 since it has this:
>
> 	page = get_partial_node(get_node(s, searchnode));
> 	if (page || (flags & __GFP_THISNODE))
> 		return page;
>
> 	return get_any_partial(s, flags);
>
> so what happened to the dropped check for returning get_any_partial() when
> node != -1?  I added the check for benchmarking.

Strange no merge conflict here. Are you sure you use upstream?

GFP_THISNODE does not matter too much. If page == NULL then we failed
to allocate a page on a specific node and have to either give up (and then
extend the slab) or take a page from another node.

We always have give up to go to the page allocator if GFP_THIS_NODE was
set. The modification to additionally also go to the page allocator if
a node was just set even without GFP_THISNODE. So checking for
GFP_THISNODE does not make sense anymore.




