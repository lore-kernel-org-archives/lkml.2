Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557Ab2FZIST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 04:18:19 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:53011 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758541Ab2FZISO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 04:18:14 -0400
Date: Tue, 26 Jun 2012 10:17:54 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        davem@davemloft.net, shangw@linux.vnet.ibm.com, tj@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 046/181] mm: remove sparsemem allocation details from the
 bootmem allocator
Message-ID: <20120626081754.GY27816@cmpxchg.org>
References: <20120529220636.AAA66A0308@akpm.mtv.corp.google.com>
 <CAE9FiQVEq5j1zoKS31fgfG_3xZSyfqsjdDorDku-Sgj6BTShEg@mail.gmail.com>
 <CAE9FiQXR+3k4QmOJe59xom+JW5JZAP3znRXQwdyqV5LMEPCw2g@mail.gmail.com>
 <20120623091752.GK27816@cmpxchg.org>
 <CAE9FiQXYG0=XFAzZStExBTNqdnRPMSjASNydM45GC_G6qfuNkA@mail.gmail.com>
 <20120623220616.GS27816@cmpxchg.org>
 <CAE9FiQWoR_CJd8GD5i5jeFm=_ghUsdTwx8LbP8DnwgdEHo64uQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQWoR_CJd8GD5i5jeFm=_ghUsdTwx8LbP8DnwgdEHo64uQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 03:35:37PM -0700, Yinghai Lu wrote:
> On Sat, Jun 23, 2012 at 3:06 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> > On Sat, Jun 23, 2012 at 11:58:02AM -0700, Yinghai Lu wrote:
> >> +again:
> >> +     p = ___alloc_bootmem_node_nopanic(NODE_DATA(nid), size,
> >> +                                       SMP_CACHE_BYTES, goal, limit);
> >> +     if (!p && limit) {
> >> +             limit = 0;
> >> +             goto again;
> >> +     }
> >
> > I was aware that __alloc_bootmem_node_nopanic does a slightly
> > different fallback sequence, but as soon as you go outside the
> > section, you have a node-section-dependency either way.
> 
> you need to make sure, first try to get the in the same section, then same node.
> 
> >
> > Without this patch, it would retry without the node first, then
> > without the goal.  With your patch, you would try to limit the upper
> > end, but you may already go below the requested section.  What would
> > the limit gain?
> 
> goal: start of section
> limit: start of next section.
> 
> the layout should be
> start_of_range_same_node...start_of_range_same_section....end_of_range_same_section...end_of_range_of_same_node.
> 
> before your commit:
> 1. first try: start_of_range_same_section....end_of_range_same_section
> 2. second try: on same node.
> 
> with your commit:
> 1. first try: start_of_range_same_section....end_of_range_same_node.
> ===> it would get buffer out of same section.
> 2. second try: 0...0, aka 0... -1UL
> 
> with this patch:
> 1. first try: start_of_range_same_section....end_of_range_same_section
> 2. second try: 0...end_of_range_of_same_section.
> 3. third try: start_of_range_same_section...0, aka
> tart_of_range_same_section...-1UL;
> 4. third try: 0...0, aka 0...-1UL;

What I failed to take into account at first is that neither bootmem
implementation (necessarily) does a linear bottom-up search starting
from goal, so yes, we definitely need an upper limit for the first
attempt.

No use in reverting it, as the bootmem version was already broken
before, when the limit was removed in f5bf18f "bootmem/sparsemem:
remove limit constraint in alloc_bootmem_section".

I'm okay with exporting and using ___alloc_bootmem_node_nopanic() in
3.5.
