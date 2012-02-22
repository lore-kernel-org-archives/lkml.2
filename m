Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab2BVEFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 23:05:55 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52449 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab2BVEFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 23:05:54 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.205.120.141 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Message-ID: <4F44699D.3020309@openvz.org>
Date: Wed, 22 Feb 2012 08:05:49 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20120201 Iceape/2.0.14
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/10] mm/memcg: take care over pc->mem_cgroup
References: <alpine.LSU.2.00.1202201518560.23274@eggly.anvils> <alpine.LSU.2.00.1202201533260.23274@eggly.anvils> <20120221181321.637556cd.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LSU.2.00.1202211437140.2012@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1202211437140.2012@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Tue, 21 Feb 2012, KAMEZAWA Hiroyuki wrote:
>> On Mon, 20 Feb 2012 15:34:28 -0800 (PST)
>> Hugh Dickins<hughd@google.com>  wrote:
>> 	return NULL;
>>>
>>> +	lruvec = page_lock_lruvec(page);
>>>   	lock_page_cgroup(pc);
>>>
>>
>> Do we need to take lrulock+irq disable per page in this very very hot path ?
>
> I'm sure we don't want to: I hope you were pleased to find it goes away
> (from most cases) a couple of patches later.
>
> I had lruvec lock nested inside page_cgroup lock in the rollup I sent in
> December, whereas you went for page_cgroup lock nested inside lruvec lock
> in your lrucare patch.
>
> I couldn't find an imperative reason why they should be one way round or
> the other, so I tried hard to stick with your ordering, and it did work
> (in this 6/10).  But then I couldn't work out how to get rid of the
> overheads added in doing it this way round, so swapped them back.
>
>>
>> Hmm.... How about adding NR_ISOLATED counter into lruvec ?
>>
>> Then, we can delay freeing lruvec until all conunters goes down to zero.
>> as...
>>
>> 	bool we_can_free_lruvec = true;
>>
>> 	lock_lruvec(lruvec->lock);
>> 	for_each_lru_lruvec(lru)
>> 		if (!list_empty(&lruvec->lru[lru]))
>> 			we_can_free_lruvec = false;
>> 	if (lruvec->nr_isolated)
>> 		we_can_free_lruvec = false;
>> 	unlock_lruvec(lruvec)
>> 	if (we_can_free_lruvec)
>> 		kfree(lruvec);
>>
>> If compaction, lumpy reclaim free a page taken from LRU,
>> it knows what it does and can decrement lruvec->nr_isolated properly
>> (it seems zone's NR_ISOLATED is decremented at putback.)
>
> At the moment I'm thinking that what we end up with by 9/10 is
> better than adding such a refcount.  But I'm not entirely happy with
> mem_cgroup_reset_uncharged_to_root (it adds a further page_cgroup
> lookup just after I got rid of some others), and need yet to think
> about the race which Konstantin posits, so all options remain open.

This lruvec->nr_isolated seem reasonable, and its managegin not very costly.
In move_account() we anyway need to touch old_lruvec->lru_lock after recharge,
to stabilize PageLRU() before adding page to new_lruvec. (because that race)
In migration/compaction this handled automatically, because they always call putback_lru_page() at the end.
Main problem is shrink_page_list() for lumpy-reclaim, but seems like it never used if memory
compaction is enabled, so it can be slow and ineffective with tons of lru_list relocks.

>
> Hugh

