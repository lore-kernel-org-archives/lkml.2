Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505Ab2D0CXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 22:23:54 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56402 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758110Ab2D0CXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 22:23:53 -0400
X-AuditID: 9c930179-b7bfaae000006f69-16-4f9a03368853
Message-ID: <4F9A0360.3030900@kernel.org>
Date: Fri, 27 Apr 2012 11:24:32 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: David Rientjes <rientjes@google.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Nick Piggin <npiggin@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC] propagate gfp_t to page table alloc functions
References: <1335171318-4838-1-git-send-email-minchan@kernel.org> <4F963742.2030607@jp.fujitsu.com> <4F963B8E.9030105@kernel.org> <CAPa8GCA8q=S9sYx-0rDmecPxYkFs=gATGL-Dz0OYXDkwEECJkg@mail.gmail.com> <4F965413.9010305@kernel.org> <CAPa8GCCwfCFO6yxwUP5Qp9O1HGUqEU2BZrrf50w8TL9FH9vbrA@mail.gmail.com> <20120424143015.99fd8d4a.akpm@linux-foundation.org> <4F973BF2.4080406@jp.fujitsu.com> <CAHGf_=r09BCxXeuE8dSti4_SrT5yahrQCwJh=NrrA3rsUhhu_w@mail.gmail.com> <4F973FB8.6050103@jp.fujitsu.com> <20120424172554.c9c330dd.akpm@linux-foundation.org> <4F98914C.2060505@jp.fujitsu.com> <alpine.DEB.2.00.1204251715420.19452@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1204251715420.19452@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 09:20 AM, David Rientjes wrote:

> On Thu, 26 Apr 2012, KAMEZAWA Hiroyuki wrote:
> 
>>> Or do we instead do this:
>>>
>>> -	some_function(foo, bar, GFP_NOIO);
>>> +	old_gfp = set_current_gfp(GFP_NOIO);
>>> +	some_function(foo, bar);
>>> +	set_current_gfp(old_gfp);
>>>
>>> So the rule is "if the code was using an explicit GFP_foo then convert
>>> it to use set_current_gfp().  If the code was receiving a gfp_t
>>> variable from the caller then delete that arg".
>>>
>>> Or something like that.  It's all too hopelessly impractical to bother
>>> discussing - 20 years too late!
>>>
>>>
>>> otoh, maybe a constrained version of this could be used to address the
>>> vmalloc() problem alone.
>>>
>>
>> Yes, I think it will be good start.
>>
> 
> Maybe a per-thread_info variant of gfp_allowed_mask?  So Andrew's 
> set_current_gfp() becomes set_current_gfp_allowed() that does
> 
> 	void set_current_gfp_allowed(gfp_t gfp_mask)
> 	{
> 		current->gfp_allowed = gfp_mask & gfp_allowed_mask;
> 	}
> 
> and then the page allocator does
> 
> 	gfp_mask &= current->gfp_allowed;
> 
> rather than how it currently does
> 
> 	gfp_mask &= gfp_allowed_mask;
> 
> and then the caller of set_current_gfp_allowed() cleans up with 
> set_current_gfp_allowed(__GFP_BITS_MASK).


Caller should restore old gfp_mask instead of __GFP_BITS_MASK in case of
nesting.And how do we care of atomic context?

I was about to add warning in __vmalloc internal if caller uses GFP_NOIO, GFP_NOFS, GFP_ATOMIC
with Nick's comment and let them make to fix it. But it seems Andrew doesn't agree.

Andrew, please tell me your opinion for fixing this problem.

-- 
Kind regards,
Minchan Kim
