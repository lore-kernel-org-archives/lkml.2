Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab1HODBo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 23:01:44 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21797 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab1HODBn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 23:01:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=qhog99IP9AZkd+aAjPuGNDlTYrp12bxlyvckx7/n/lWRnzNSUW0tNw4733k9V5GmE
	Z7Bk0uJ+MNuvz538arj/g==
MIME-Version: 1.0
In-Reply-To: <20110812191718.GE29086@cmpxchg.org>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
	<1306909519-7286-9-git-send-email-hannes@cmpxchg.org>
	<CALWz4izVoN2s6J9t1TVj+1pMmHVxfiWYvq=uqeTL4C5-YsBwOw@mail.gmail.com>
	<20110812083458.GB6916@cmpxchg.org>
	<CALWz4iz=30A7hUkEmo5_K3q1KiM8tBWvh_ghhbEFm0ZksfzQ=g@mail.gmail.com>
	<20110812191718.GE29086@cmpxchg.org>
Date: Sun, 14 Aug 2011 20:01:36 -0700
Message-ID: <CALWz4iz=dE9BGme7+-Fwdz2-gt2GfymzYcXrg0ZcSD7PAbARfg@mail.gmail.com>
Subject: Re: [patch 8/8] mm: make per-memcg lru lists exclusive
From: Ying Han <yinghan@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 12:17 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Fri, Aug 12, 2011 at 10:08:18AM -0700, Ying Han wrote:
>> On Fri, Aug 12, 2011 at 1:34 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
>> > And in reality, we only care about properly memcg-unaccounting the
>> > old lru state before we change pc->mem_cgroup, so this becomes
>> >
>> >        if (!PageLRU(page))
>> >                 return;
>> >        spin_lock_irqsave(&zone->lru_lock, flags);
>> >         if (!PageCgroupUsed(pc))
>> >                mem_cgroup_lru_del(page);
>> >         spin_unlock_irqrestore(&zone->lru_lock, flags);
>> >
>> > I don't see why we should care if the page stays physically linked
>> > to the list.
>>
>> Can you clarify that?
>
> Well, I don't see anything wrong with leaving it on the LRU.  We just
> need to unaccount the page from pc->mem_cgroup's lru stats before the
> page is charged, pc->mem_cgroup overwritten, and the account lost.
>
>> > The handling after committing the charge becomes this:
>> >
>> > -       if (likely(!PageLRU(page)))
>> > -               return;
>> >        spin_lock_irqsave(&zone->lru_lock, flags);
>> >         lru = page_lru(page);
>> >        if (PageLRU(page) && !PageCgroupAcctLRU(pc)) {
>> >                del_page_from_lru_list(zone, page, lru);
>> >                add_page_to_lru_list(zone, page, lru);
>> >        }
>> >
>> > If the page is not on the LRU, someone else will put it there and link
>> > it up properly.  If it is on the LRU and already memcg-accounted then
>> > it must be on the right lruvec as setting pc->mem_cgroup and PCG_USED
>> > is properly ordered.  Otherwise, it has to be physically moved to the
>> > correct lruvec and memcg-accounted for.
>>
>> While working on the zone->lru_lock patch, i have been questioning myself on
>> the PageLRU and PageCgroupAcctLRU bit. Here is my question:
>>
>> It looks to me that PageLRU indicates the page is linked to per-zone lru
>> list, and PageCgroupAcctLRU indicates the page is charged to a memcg and
>> also linked to memcg's private lru list. All of these work nicely when we
>> have both global and private (per-memcg) lru list, but i can not put them
>> together after this patch.
>>
>> Now page is linked to private lru always either memcg or root. While linked
>> to either lru list, the page could be uncharged (like swapcache). No matter
>> what, i am thinking whether or not we can get rid of the AcctLRU bit from pc
>> and use LRU bit only here.
>
> As I said above: if after the commit the page is on the LRU (PageLRU
> set), pc->mem_cgroup's lru stats may or may not include the page, and
> the page may or may not be on the right lruvec.
>
> If someone had the page isolated (reclaim?) while we charge it and put
> it back, the page may either be charged or uncharged at the time of
> putback.

Thank you and this is a good example.

So PageLRU bit is consistent w/ whether or not the page is linked  to
a lru list (root or memcg), and AcctLRU indicates more on the memcg
charge/uncharge.

Here I am trying to summarize the possibilities of different flags of
a page linked to a lru list ( based on the implementation after this
patch series). please help to correct :

root lru:
1. PageLRU, Used, AcctLRU: page charged to root and linked to root lru
list. ( ext: page allocated under root cgroup )

2. PageLRU, !Used, !AcctLRU: page not charged and linked to root lru
list. ( ext: page uncharged before free, or like readahead swapcache)

3. PageLRU, Used, !AcctLRU: page del from root lru before uncharge, or
charged before add to root lru

4. PageLRU, !Used, AcctLRU: page uncharged before del from root lru
(ext: swapcache)

non-root lru:

1. PageLRU, Used, AcctLRU: page charged to memcg and linked to memcg lru list

2. PageLRU, !Used, !AcctLRU: not sure if this is possible

3. PageLRU, Used, !AcctLRU: page del from memcg lru before uncharge,
or charged before add to memcg lru

4. PageLRU, !Used, AcctLRU: page uncharged before del from memcg lru
(ext: swapcache)


>
>        unused: PageLRU is set, but page possibly on the wrong lruvec
>        (root_mem_cgroup's per default, see mem_cgroup_lru_add_list)
>        and not properly accounted for.  We can detect this case by
>        seeing AcctLRU cleared.

This fits the case 2 above.

>
>        used: PageLRU is set, page on the right lruvec and properly
>        accounted.  We can detect this case by seeing that
>        mem_cgroup_lru_add_list() set AcctLRU.

This fits the case 1 above.


Thanks

--Ying
