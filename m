Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab1CBNbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 08:31:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116Ab1CBNbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 08:31:40 -0500
Message-ID: <4D6E46B4.7030909@redhat.com>
Date: Wed, 02 Mar 2011 15:31:32 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        xiaoguangrong@cn.fujitsu.com
Subject: Re: [RFC PATCH 0/3] Weight-balanced binary tree + KVM growable memory
 slots using wbtree
References: <1298386481.5764.60.camel@x201>	 <20110222183822.22026.62832.stgit@s20.home>  <4D6507C9.1000906@redhat.com>	 <1298484395.18387.28.camel@x201> <1298489332.18387.56.camel@x201>	 <4D662DBF.2020706@redhat.com> <1298568944.6140.21.camel@x201>	 <4D6A1F55.7080804@redhat.com> <1298934271.4177.19.camel@x201>	 <4D6D0ADF.1050107@redhat.com> <1299003632.4177.66.camel@x201>
In-Reply-To: <1299003632.4177.66.camel@x201>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2011 08:20 PM, Alex Williamson wrote:
> >  >  It seems like we need a good mixed workload benchmark.  So far we've
> >  >  only tested worst case, with a pure emulated I/O test, and best case,
> >  >  with a pure memory test.  Ordering an array only helps the latter, and
> >  >  only barely beats the tree, so I suspect overall performance would be
> >  >  better with a tree.
> >
> >  But if we cache the missed-all-memslots result in the spte, we eliminate
> >  the worst case, and are left with just the best case.
>
> There's potentially a lot of entries between best case and worst case.

The mid case is where we have a lot of small slots which are 
continuously flushed.  That would be (ept=0 && new mappings continuously 
established) || (lots of small mappings && lots of host paging 
activity).  I don't know of any guests that continuously reestablish BAR 
mappings; and host paging activity doesn't apply to device assignment.  
What are we left with?

> >
> >  The problem here is that all workloads will cache all memslots very
> >  quickly into sptes and all lookups will be misses.  There are two cases
> >  where we have lookups that hit the memslots structure: ept=0, and host
> >  swap.  Neither are things we want to optimize too heavily.
>
> Which seems to suggest that:
>
>       A. making those misses fast = win
>       B. making those misses fast + caching misses = win++
>       C. we don't care if the sorted array is subtly faster for ept=0
>
> Sound right?  So is the question whether cached misses alone gets us 99%
> of the improvement since hits are already getting cached in sptes for
> cases we care about?

Yes, that's my feeling.  Caching those misses is a lot more important 
than speeding them up, since the cache will stay valid for long periods, 
and since the hit rate will be very high.

Cache+anything=O(1)
no-cache+tree=O(log(n))
no-cache+array=O(n)

-- 
error compiling committee.c: too many arguments to function

