Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab2CJJqP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 04:46:15 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44410 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab2CJJqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 04:46:12 -0500
Message-ID: <4F5B22DE.4020402@openvz.org>
Date: Sat, 10 Mar 2012 13:46:06 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <jweiner@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7 v2] mm: rework __isolate_lru_page() file/anon filter
References: <20120229091547.29236.28230.stgit@zurg> <20120303091327.17599.80336.stgit@zurg> <alpine.LSU.2.00.1203061904570.18675@eggly.anvils> <20120308143034.f3521b1e.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LSU.2.00.1203081758490.18195@eggly.anvils> <4F59AE3C.5040200@openvz.org> <alpine.LSU.2.00.1203091559260.23317@eggly.anvils> <4F5AFAF0.6060608@openvz.org>
In-Reply-To: <4F5AFAF0.6060608@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Khlebnikov wrote:
> Hugh Dickins wrote:
>> On Fri, 9 Mar 2012, Konstantin Khlebnikov wrote:
>>>
>>> Actually __isolate_lru_page() even little bit bigger
>>
>> I was coming to realize that it must be your page_lru()ing:
>> although it's dressed up in one line, there's several branches there.
>
> Yes, but I think we can optimize page_lru(): we can prepare ready-to-use
> page lru index in lower bits of page->flags, if we swap page flags and split
> LRU_UNEVICTABLE into FILE/ANON parts.
>
>>
>> I think you'll find you have a clear winner at last, if you just pass
>> lru on down as third arg to __isolate_lru_page(), where file used to
>> be passed, instead of re-evaluating it inside.
>>
>> shrink callers already have the lru, and compaction works it out
>> immediately afterwards.
>
> No, for non-lumpy isolation we don't need this check at all,
> because all pages already picked from right lru list.
>
> I'll send separate patch for this (on top v5 patchset), after meditation =)

Heh, looks like we don't need these checks at all:
without RECLAIM_MODE_LUMPYRECLAIM we isolate only pages from right lru,
with RECLAIM_MODE_LUMPYRECLAIM we isolate pages from all evictable lru.
Thus we should check only PageUnevictable() on lumpy reclaim.

>
>>
>> Though we do need to be careful: the lumpy case would then have to
>> pass page_lru(cursor_page).  Oh, actually no (though it would deserve
>> a comment): since the lumpy case selects LRU_ALL_EVICTABLE, it's
>> irrelevant what it passes for lru, so might as well stick with
>> the one passed down.  Though you may decide I'm being too tricky
>> there, and prefer to calculate page_lru(cursor_page) anyway, it
>> not being the hottest path.
>>
>> Whether you'd still want page_lru(page) __always_inline, I don't know.
>>
>> Hugh
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email:<a href=mailto:"dont@kvack.org">  email@kvack.org</a>

