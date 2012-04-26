Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab2DZAHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 20:07:39 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37495 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453Ab2DZAHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 20:07:38 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F98914C.2060505@jp.fujitsu.com>
Date: Thu, 26 Apr 2012 09:05:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Nick Piggin <npiggin@gmail.com>, Minchan Kim <minchan@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC] propagate gfp_t to page table alloc functions
References: <1335171318-4838-1-git-send-email-minchan@kernel.org> <4F963742.2030607@jp.fujitsu.com> <4F963B8E.9030105@kernel.org> <CAPa8GCA8q=S9sYx-0rDmecPxYkFs=gATGL-Dz0OYXDkwEECJkg@mail.gmail.com> <4F965413.9010305@kernel.org> <CAPa8GCCwfCFO6yxwUP5Qp9O1HGUqEU2BZrrf50w8TL9FH9vbrA@mail.gmail.com> <20120424143015.99fd8d4a.akpm@linux-foundation.org> <4F973BF2.4080406@jp.fujitsu.com> <CAHGf_=r09BCxXeuE8dSti4_SrT5yahrQCwJh=NrrA3rsUhhu_w@mail.gmail.com> <4F973FB8.6050103@jp.fujitsu.com> <20120424172554.c9c330dd.akpm@linux-foundation.org>
In-Reply-To: <20120424172554.c9c330dd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/25 9:25), Andrew Morton wrote:

> On Wed, 25 Apr 2012 09:05:12 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
>> (2012/04/25 8:55), KOSAKI Motohiro wrote:
>>
>>> On Tue, Apr 24, 2012 at 7:49 PM, KAMEZAWA Hiroyuki
>>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>>> (2012/04/25 6:30), Andrew Morton wrote:
>>>>
>>>>> On Tue, 24 Apr 2012 17:48:29 +1000
>>>>> Nick Piggin <npiggin@gmail.com> wrote:
>>>>>
>>>>>>> Hmm, there are several places to use GFP_NOIO and GFP_NOFS even, GFP_ATOMIC.
>>>>>>> I believe it's not trivial now.
>>>>>>
>>>>>> They're all buggy then. Unfortunately not through any real fault of their own.
>>>>>
>>>>> There are gruesome problems in block/blk-throttle.c (thread "mempool,
>>>>> percpu, blkcg: fix percpu stat allocation and remove stats_lock").  It
>>>>> wants to do an alloc_percpu()->vmalloc() from the IO submission path,
>>>>> under GFP_NOIO.
>>>>>
>>>>> Changing vmalloc() to take a gfp_t does make lots of sense, although I
>>>>> worry a bit about making vmalloc() easier to use!
>>>>>
>>>>> I do wonder whether the whole scheme of explicitly passing a gfp_t was
>>>>> a mistake and that the allocation context should be part of the task
>>>>> context.  ie: pass the allocation mode via *current.
>>>>
>>>> yes...that's very interesting.
>>>
>>> I think GFP_ATOMIC is used non task context too. ;-)
>>
>> Hmm, in interrupt context or some ? Can't we detect it ?
> 
> There are lots of practical details and I haven't begun to think it
> through, mainly because it Isn't Going To Happen!
> 
> For example how do we handle spin_lock()?  Does spin_lock() now do
> 
> gfp_t spin_lock_2(spinlock_t *lock)
> {
> 	gfp_t old_gfp = set_current_gfp(GFP_ATOMIC);
> 	spin_lock(lock);
> 	return old_gfp;
> }
> 
> void spin_unlock_2(spinlock_t *lock, gfp_t old_gfp)
> {
> 	spin_unlock(lock);
> 	set_current_gfp(old_gfp);
> }
> 
> Well that's bad.  Currently we require programmers to keep track of
> what context they're running in.  So they think about what they're
> doing.  If we made it this easy, we'd see a big proliferation of
> GFP_ATOMIC allocations, which is bad.
> 
> Requiring the spin_lock() caller to run set_current_gfp() would have
> the same effect.
> 
> 
> 
> Or do we instead do this:
> 
> -	some_function(foo, bar, GFP_NOIO);
> +	old_gfp = set_current_gfp(GFP_NOIO);
> +	some_function(foo, bar);
> +	set_current_gfp(old_gfp);
> 
> So the rule is "if the code was using an explicit GFP_foo then convert
> it to use set_current_gfp().  If the code was receiving a gfp_t
> variable from the caller then delete that arg".
> 
> Or something like that.  It's all too hopelessly impractical to bother
> discussing - 20 years too late!
> 
> 
> otoh, maybe a constrained version of this could be used to address the
> vmalloc() problem alone.
> 


Yes, I think it will be good start.

> 
> otoh2, I didn't *want* blk-throttle.c to use GFP_NOIO for vmalloc(). 
> GFP_NOIO is weak, unreliable and lame.  blk-throttle should find a way
> of using GFP_KERNEL!


I agree.
Thanks,
-Kame

