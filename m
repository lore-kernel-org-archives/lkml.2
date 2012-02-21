Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab2BUVfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 16:35:31 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45627 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab2BUVfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 16:35:30 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.205.132.138 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Message-ID: <4F440E1D.7050004@openvz.org>
Date: Wed, 22 Feb 2012 01:35:25 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20120201 Iceape/2.0.14
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/10] mm/memcg: move lru_lock into lruvec
References: <alpine.LSU.2.00.1202201518560.23274@eggly.anvils> <alpine.LSU.2.00.1202201537040.23274@eggly.anvils> <4F434300.3080001@openvz.org> <alpine.LSU.2.00.1202211205280.1858@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1202211205280.1858@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Tue, 21 Feb 2012, Konstantin Khlebnikov wrote:
>>
>> On lumpy/compaction isolate you do:
>>
>> if (!PageLRU(page))
>> 	continue
>>
>> __isolate_lru_page()
>>
>> page_relock_rcu_vec()
>> 	rcu_read_lock()
>> 	rcu_dereference()...
>> 	spin_lock()...
>> 	rcu_read_unlock()
>>
>> You protect page_relock_rcu_vec with switching pointers back to root.
>>
>> I do:
>>
>> catch_page_lru()
>> 	rcu_read_lock()
>> 	if (!PageLRU(page))
>> 		return false
>> 	rcu_dereference()...
>> 	spin_lock()...
>> 	rcu_read_unlock()
>> 	if (PageLRU())
>> 		return true
>> if true
>> 	__isolate_lru_page()
>>
>> I protect my catch_page_lruvec() with PageLRU() under single rcu-interval
>> with locking.
>> Thus my code is better, because it not requires switching pointers back to
>> root memcg.
>
> That sounds much better, yes - if it does work reliably.
>
> I'll have to come back to think about your locking later too;
> or maybe that's exactly where I need to look, when investigating
> the mm_inline.h:41 BUG.

pages_count[] updates looks correct.
This really may be bug in locking, and this VM_BUG_ON catch it before list-debug.

>
> But at first sight, I have to say I'm very suspicious: I've never found
> PageLRU a good enough test for whether we need such a lock, because of
> races with those pages on percpu lruvec about to be put on the lru.
>
> But maybe once I look closer, I'll find that's handled by your changes
> away from lruvec; though I'd have thought the same issue exists,
> independent of whether the pending pages are in vector or list.

Are you talking about my per-cpu page-lists for lru-adding?
This is just an unnecessary patch, I don't know why I include it into v2 set.
It does not protect anything.

>
> Hugh
>
>>
>> Meanwhile after seeing your patches, I realized that this rcu-protection is
>> required only for lock-by-pfn in lumpy/compaction isolation.
>> Thus my locking should be simplified and optimized.

