Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab0CaTms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 15:42:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756585Ab0CaTmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 15:42:46 -0400
Date: Wed, 31 Mar 2010 12:42:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: miaox@cn.fujitsu.com
Cc: Nick Piggin <npiggin@suse.de>, David Rientjes <rientjes@google.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH] [PATCH -mmotm] cpuset,mm: use seqlock to protect
 task->mempolicy and mems_allowed (v2) (was: Re: [PATCH V2 4/4] cpuset,mm:
 update task's mems_allowed lazily)
Message-Id: <20100331124201.8cb20a11.akpm@linux-foundation.org>
In-Reply-To: <4BAB6646.7040302@cn.fujitsu.com>
References: <4B94CD2D.8070401@cn.fujitsu.com>
	<alpine.DEB.2.00.1003081330370.18502@chino.kir.corp.google.com>
	<4B95F802.9020308@cn.fujitsu.com>
	<20100311081548.GJ5812@laptop>
	<4B98C6DE.3060602@cn.fujitsu.com>
	<20100311110317.GL5812@laptop>
	<4BAB6646.7040302@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010 21:33:58 +0800
Miao Xie <miaox@cn.fujitsu.com> wrote:

> on 2010-3-11 19:03, Nick Piggin wrote:
> >> Ok, I try to make a new patch by using seqlock.
> > 
> > Well... I do think seqlocks would be a bit simpler because they don't
> > require this checking and synchronizing of this patch.
> Hi, Nick Piggin
> 
> I have made a new patch which uses seqlock to protect mems_allowed and mempolicy.
> please review it.

That's an awfully big patch for a pretty small bug?

> Subject: [PATCH] [PATCH -mmotm] cpuset,mm: use seqlock to protect task->mempolicy and mems_allowed (v2)
> 
> Before applying this patch, cpuset updates task->mems_allowed by setting all
> new bits in the nodemask first, and clearing all old unallowed bits later.
> But in the way, the allocator can see an empty nodemask, though it is infrequent.
> 
> The problem is following:
> The size of nodemask_t is greater than the size of long integer, so loading
> and storing of nodemask_t are not atomic operations. If task->mems_allowed
> don't intersect with new_mask, such as the first word of the mask is empty
> and only the first word of new_mask is not empty. When the allocator
> loads a word of the mask before
> 
> 	current->mems_allowed |= new_mask;
> 
> and then loads another word of the mask after
> 
> 	current->mems_allowed = new_mask;
> 
> the allocator gets an empty nodemask.

Probably we could fix this via careful ordering of the updates,
barriers and perhaps some avoicance action at the reader side.

> Besides that, if the size of nodemask_t is less than the size of long integer,
> there is another problem. when the kernel allocater invokes the following function,
> 
> 	struct zoneref *next_zones_zonelist(struct zoneref *z,
> 						enum zone_type highest_zoneidx,
> 						nodemask_t *nodes,
> 						struct zone **zone)
> 	{
> 		/*
> 		 * Find the next suitable zone to use for the allocation.
> 		 * Only filter based on nodemask if it's set
> 		 */
> 		if (likely(nodes == NULL))
> 			......
>  	       else
> 			while (zonelist_zone_idx(z) > highest_zoneidx ||
> 					(z->zone && !zref_in_nodemask(z, nodes)))
> 				z++;
> 
> 		*zone = zonelist_zone(z);
> 		return z;
> 	}
> 
> if we change nodemask between two calls of zref_in_nodemask(), such as
> 	Task1						Task2
> 	zref_in_nodemask(z = node0's z, nodes = 1-2)
> 	zref_in_nodemask return 0
> 							nodes = 0
> 	zref_in_nodemask(z = node1's z, nodes = 0)
> 	zref_in_nodemask return 0
> z will overflow.

And maybe we can fix this by taking a copy into a local.

> when the kernel allocater accesses task->mempolicy, there is the same problem.

And maybe we can fix those in a similar way.

But it's all too much, and we'll just break it again in the future.  So
yup, I guess locking is needed.

