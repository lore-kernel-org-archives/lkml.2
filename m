Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643Ab2ECRF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 13:05:26 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45332 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab2ECRFY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 13:05:24 -0400
Date: Thu, 03 May 2012 13:04:16 -0400 (EDT)
Message-Id: <20120503.130416.839732919427673590.davem@davemloft.net>
To: hannes@cmpxchg.org
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] mm: nobootmem: Correct alloc_bootmem semantics.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120503152841.GA19918@cmpxchg.org>
References: <CAE9FiQWYPPXA0YmgBP6SkKiEaLJJnzxMqPn2_VwOKoYSKGwULQ@mail.gmail.com>
	<20120425.190034.632638679653622318.davem@davemloft.net>
	<20120503152841.GA19918@cmpxchg.org>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 03 May 2012 10:04:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>
Date: Thu, 3 May 2012 17:28:41 +0200

> On Wed, Apr 25, 2012 at 07:00:34PM -0400, David Miller wrote:
>> From: Yinghai Lu <yinghai@kernel.org>
>> Date: Wed, 25 Apr 2012 15:46:42 -0700
>> 
>> > On Wed, Apr 25, 2012 at 1:10 PM, David Miller <davem@davemloft.net> wrote:
>> >> @@ -298,13 +298,19 @@ void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
>> >>        if (WARN_ON_ONCE(slab_is_available()))
>> >>                return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
>> >>
>> >> +again:
>> >>        ptr = __alloc_memory_core_early(pgdat->node_id, size, align,
>> >>                                         goal, -1ULL);
>> >>        if (ptr)
>> >>                return ptr;
>> > 
>> > If you want to be consistent to bootmem version.
>> > 
>> > again label should be here instead.
>> 
>> It is merely an artifact of implementation that the bootmem version
>> doesn't try to respect the given node if the goal cannot be satisfied,
>> and in fact I would classify that as a bug that needs to be fixed.
>> 
>> Therefore, I believe the bootmem case is what needs to be adjusted
>> instead.
> 
> Now it does: node+goal, goal, node, anywhere
> 
> whereas the memblock version of __alloc_bootmem_node_nopanic() also
> still does: node+goal, goal, anywhere
> 
> Your description suggests that the node should be higher prioritized
> than the goal, which I understand as: node+goal, node, anywhere.
> 
> Which do we actually want?

I think the goal is what needs to be prioritized.  An explicit goal usually
has a requirement, like "I need physical memory in the low 32-bits" and if
they specified an explicit node they really mean "and give me it on NUMA
node X if you can."  Hence the sequence:

	node+goal, goal, node, any

the only other reasonable option would be:

	node+goal, node, goal, any

but I think that doesn't match what people want when an explicit goal
is specified.  Do you?
