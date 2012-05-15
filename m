Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398Ab2EOIxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 04:53:36 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51715 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758195Ab2EOIxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 04:53:34 -0400
Message-ID: <4FB21988.40503@openvz.org>
Date: Tue, 15 May 2012 12:53:28 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm/memcg: apply add/del_page to lruvec
References: <alpine.LSU.2.00.1205132152530.6148@eggly.anvils> <alpine.LSU.2.00.1205132201210.6148@eggly.anvils> <4FB0E985.9000107@openvz.org> <alpine.LSU.2.00.1205141252060.1693@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1205141252060.1693@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Mon, 14 May 2012, Konstantin Khlebnikov wrote:
>> Hugh Dickins wrote:
>>> Take lruvec further: pass it instead of zone to add_page_to_lru_list()
>>> and del_page_from_lru_list(); and pagevec_lru_move_fn() pass lruvec
>>> down to its target functions.
>>>
>>> This cleanup eliminates a swathe of cruft in memcontrol.c,
>>> including mem_cgroup_lru_add_list(), mem_cgroup_lru_del_list() and
>>> mem_cgroup_lru_move_lists() - which never actually touched the lists.
>>>
>>> In their place, mem_cgroup_page_lruvec() to decide the lruvec,
>>> previously a side-effect of add, and mem_cgroup_update_lru_size()
>>> to maintain the lru_size stats.
>>>
>>> Whilst these are simplifications in their own right, the goal is to
>>> bring the evaluation of lruvec next to the spin_locking of the lrus,
>>> in preparation for a future patch.
>>>
>>> Signed-off-by: Hugh Dickins<hughd@google.com>
>>> ---
>>> The horror, the horror: I have three lines of 81 columns:
>>> I do think they look better this way than split up.
>>
>> This too huge and hard to review. =(
>
> Hah, we have very different preferences: whereas I found your
> split into twelve a hindrance to review rather than a help.
>
>> I have the similar thing splitted into several patches.
>
> I had been hoping to get this stage, where I think we're still in
> agreement (except perhaps on the ordering of function arguments!),
> into 3.5 as a basis for later discussion.

Yeah, my version differs mostly in function's names and ordering of arguments.
I use 'long' for last argument in mem_cgroup_update_lru_size(),
and call it once in isolate_lru_pages(), rather than for each isolated page.
You have single mem_cgroup_page_lruvec() variant, and this is biggest difference
between our versions. So, Ok, nothing important at this stage.

Acked-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

>
> But I won't have time to split it into bite-sized pieces for
> linux-next now before 3.4 goes out, so it sounds like we'll have
> to drop it this time around.  Oh well.
>
> Thanks (you and Kame and Michal) for the very quick review of
> the other, even more trivial, patches.
>
>>
>> Also I want to replace page_cgroup->mem_cgroup pointer with
>> page_cgroup->lruvec
>> and rework "surreptitious switching any uncharged page to root"
>> In my set I have mem_cgroup_page_lruvec() without side-effects and
>> mem_cgroup_page_lruvec_putback() with can switch page's lruvec, but it not
>> always moves pages to root: in
>> putback_inactive_pages()/move_active_pages_to_lru()
>> we have better candidate for lruvec switching.
>
> But those sound like later developments on top of this to me.
>
> Hugh

