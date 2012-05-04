Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab2EDJlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 05:41:15 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:47480 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676Ab2EDJlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 05:41:14 -0400
Date: Fri, 4 May 2012 11:41:05 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Miller <davem@davemloft.net>
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] mm: nobootmem: Correct alloc_bootmem semantics.
Message-ID: <20120504094105.GD31780@cmpxchg.org>
References: <CAE9FiQWYPPXA0YmgBP6SkKiEaLJJnzxMqPn2_VwOKoYSKGwULQ@mail.gmail.com>
 <20120425.190034.632638679653622318.davem@davemloft.net>
 <20120503152841.GA19918@cmpxchg.org>
 <20120503.130416.839732919427673590.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120503.130416.839732919427673590.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 01:04:16PM -0400, David Miller wrote:
> From: Johannes Weiner <hannes@cmpxchg.org>
> Date: Thu, 3 May 2012 17:28:41 +0200
> 
> > On Wed, Apr 25, 2012 at 07:00:34PM -0400, David Miller wrote:
> >> From: Yinghai Lu <yinghai@kernel.org>
> >> Date: Wed, 25 Apr 2012 15:46:42 -0700
> >> 
> >> > On Wed, Apr 25, 2012 at 1:10 PM, David Miller <davem@davemloft.net> wrote:
> >> >> @@ -298,13 +298,19 @@ void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
> >> >>        if (WARN_ON_ONCE(slab_is_available()))
> >> >>                return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
> >> >>
> >> >> +again:
> >> >>        ptr = __alloc_memory_core_early(pgdat->node_id, size, align,
> >> >>                                         goal, -1ULL);
> >> >>        if (ptr)
> >> >>                return ptr;
> >> > 
> >> > If you want to be consistent to bootmem version.
> >> > 
> >> > again label should be here instead.
> >> 
> >> It is merely an artifact of implementation that the bootmem version
> >> doesn't try to respect the given node if the goal cannot be satisfied,
> >> and in fact I would classify that as a bug that needs to be fixed.
> >> 
> >> Therefore, I believe the bootmem case is what needs to be adjusted
> >> instead.
> > 
> > Now it does: node+goal, goal, node, anywhere
> > 
> > whereas the memblock version of __alloc_bootmem_node_nopanic() also
> > still does: node+goal, goal, anywhere
> > 
> > Your description suggests that the node should be higher prioritized
> > than the goal, which I understand as: node+goal, node, anywhere.
> > 
> > Which do we actually want?
> 
> I think the goal is what needs to be prioritized.  An explicit goal usually
> has a requirement, like "I need physical memory in the low 32-bits" and if
> they specified an explicit node they really mean "and give me it on NUMA
> node X if you can."  Hence the sequence:
> 
> 	node+goal, goal, node, any
> 
> the only other reasonable option would be:
> 
> 	node+goal, node, goal, any
> 
> but I think that doesn't match what people want when an explicit goal
> is specified.  Do you?

Oh I think that's what limit is for.  The goal is usually to allocate
high address memory for users that can deal with it and keep lowmem
for users that can't.

For example, I can imagine sparsemem usemap allocation in the memory
hotplug case would prefer having the usemap on the same node as the
corresponding pgdat descriptor than allocating on any node above the
goal and possibly create circular dependencies.

But that is quite rare/unlikely anyway, and I guess in most other
cases it's better to go for preventing lowmem exhaustian than to
preserve node locality.

So I'm fine with this priority order, but it's a judgement call.

I'll send patches to make everything use the same policy.
