Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab1FIDwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 23:52:15 -0400
Received: from smtp-out.google.com ([74.125.121.67]:32533 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab1FIDwM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 23:52:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hUDwvNujTV3T+bdpvzltjilZQtMxZ+m6cBa39npm6yKrmyPxFDSDYqhlZr0BjVlaio
         7h48qc0QjouDuxbNAmlw==
MIME-Version: 1.0
In-Reply-To: <20110608153211.GB27827@cmpxchg.org>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
	<BANLkTikgqSsg5+49295h7kdZ=sQpZLs4kw@mail.gmail.com>
	<BANLkTi=sYtLGk2_VQLejEU2rQ0JBgg_ZmQ@mail.gmail.com>
	<20110602075028.GB20630@cmpxchg.org>
	<BANLkTi=AZG4LKUdeODB0uP=_CVBRnGs_Nw@mail.gmail.com>
	<20110602175142.GH28684@cmpxchg.org>
	<BANLkTi=9083abfiKdZ5_oXyA+dZqaXJfZg@mail.gmail.com>
	<20110608153211.GB27827@cmpxchg.org>
Date: Wed, 8 Jun 2011 20:52:03 -0700
Message-ID: <BANLkTincHpoay1JtpjG0RY9CCvfepRohTXUH6KKULYJ9jbdo+A@mail.gmail.com>
Subject: Re: [patch 0/8] mm: memcg naturalization -rc2
From: Ying Han <yinghan@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 8:32 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Tue, Jun 07, 2011 at 08:53:21PM -0700, Ying Han wrote:
>> On Thu, Jun 2, 2011 at 10:51 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
>> >
>> > On Thu, Jun 02, 2011 at 08:51:39AM -0700, Ying Han wrote:
>> > > However on this patchset, we changed that design and doing
>> > > hierarchy_walk of the memcg tree. Can we clarify more on why we made
>> > > the design change? I can see the current design provides a efficient
>> > > way to pick the one memcg over-their-soft-limit under shrink_zone().
>> >
>> > The question is whether we even want it to work that way.  I outlined
>> > that in the changelog of the soft limit rework patch.
>> >
>> > As I see it, the soft limit should not exist solely to punish a memcg,
>> > but to prioritize memcgs in case hierarchical pressure exists.  I am
>> > arguing that the focus should be on relieving the pressure, rather
>> > than beating the living crap out of the single-biggest offender.  Keep
>> > in mind the scenarios where the biggest offender has a lot of dirty,
>> > hard-to-reclaim pages while there are other, unsoftlimited groups that
>> > have large amounts of easily reclaimable cache of questionable future
>> > value.  I believe only going for soft-limit excessors is too extreme,
>> > only for the single-biggest one outright nuts.
>> >
>> > The second point I made last time already is that there is no
>> > hierarchy support with that current scheme.  If you have a group with
>> > two subgroups, it makes sense to soft limit one subgroup against the
>> > other when the parent hits its limit.  This is not possible otherwise.
>> >
>> > The third point was that the amount of code to actually support the
>> > questionable behaviour of picking the biggest offender is gigantic
>> > compared to naturally hooking soft limit reclaim into regular reclaim.
>>
>> Ok, thank you for detailed clarification. After reading through the
>> patchset more closely, I do agree that it makes
>> better integration of memcg reclaim to the other part of vm reclaim
>> code. So I don't have objection at this point to
>> proceed w/ this direction. However, three of my concerns still remains:
>>
>> 1.  Whether or not we introduced extra overhead for each shrink_zone()
>> under global memory pressure. We used to have quick
>> access of memcgs to reclaim from who has pages charged on the zone.
>> Now we need to do hierarchy_walk for all memcgs on the system. This
>> requires more testing and more data results would be helpful
>
> That's a nice description for "we went ahead and reclaimed pages from
> a zone without any regard for memory control groups" ;-)
>
> But OTOH I agree with you of course, we may well have to visit a
> number of memcgs before finding any that have memory allocated from
> the zone we are trying to reclaim from.
>
>> 2. The way we treat the per-memcg soft_limit is changed in this patch.
>> The same comment I made on the following patch where we shouldn't
>> change the definition of user API (soft_limit_in_bytes in this case).
>> So I attached the patch to fix that where we should only go to the
>> ones under their soft_limit above certain reclaim priority. Please
>> consider.
>
> Here is your proposal from the other mail:
>
> : Basically, we shouldn't reclaim from a memcg under its soft_limit
> : unless we have trouble reclaim pages from others. Something like the
> : following makes better sense:
> :
> : diff --git a/mm/vmscan.c b/mm/vmscan.c
> : index bdc2fd3..b82ba8c 100644
> : --- a/mm/vmscan.c
> : +++ b/mm/vmscan.c
> : @@ -1989,6 +1989,8 @@ restart:
> :         throttle_vm_writeout(sc->gfp_mask);
> :  }
> :
> : +#define MEMCG_SOFTLIMIT_RECLAIM_PRIORITY       2
> : +
> :  static void shrink_zone(int priority, struct zone *zone,
> :                                 struct scan_control *sc)
> :  {
> : @@ -2001,13 +2003,13 @@ static void shrink_zone(int priority, struct zone *zone,
> :                 unsigned long reclaimed = sc->nr_reclaimed;
> :                 unsigned long scanned = sc->nr_scanned;
> :                 unsigned long nr_reclaimed;
> : -               int epriority = priority;
> :
> : -               if (mem_cgroup_soft_limit_exceeded(root, mem))
> : -                       epriority -= 1;
> : +               if (!mem_cgroup_soft_limit_exceeded(root, mem) &&
> : +                               priority > MEMCG_SOFTLIMIT_RECLAIM_PRIORITY)
> : +                       continue;
>
> I am not sure if you are serious or playing devil's advocate here,
> because it exacerbates the problem you are concerned about in 1. by
> orders of magnitude.

No, the two are different issues. The first one is a performance
concern of detailed implementation, while the second one is a design
concern. On the second, I would like us to not changing kernel API
spec (soft_limit) in this case :)

> Starting priority is 12.  If you have no groups over soft limit, you
> iterate the whole hierarchy 10 times before you even begin to think of
> reclaiming something.

I agree that the patch I posted might make the performance issue even
bigger, which we need to look into next. But I just want to demo my
understanding of reclaim based on soft_limit.

>
> I guess it would make much more sense to evaluate if reclaiming from
> memcgs while there are others exceeding their soft limit is even a
> problem.  Otherwise this discussion is pretty pointless.

AFAIK it is a problem since it changes the spec of kernel API
memory.soft_limit_in_bytes. That value is set per-memcg which all the
pages allocated above that are best effort and targeted to reclaim
prior to others.

>
>> 3. Please break this patchset into different patchsets. One way to
>> break it could be:
>
> Yes, that makes a ton of sense.  Kame suggested the same thing, there
> are too much goals in this series.
>
>> a) code which is less relevant to this effort and should be merged
>> first early regardless
>> b) code added in vm reclaim supporting the following changes
>> c) rework soft limit reclaim
>
> I dropped that for now..

Ok, we can make the soft_limit reclaim into a seperate patch including
cleaning up the current implementation. I can probably pick that up
after we agreed how to do global reclaim based on soft_limit (last
comment)

>
>> d) make per-memcg lru lists exclusive
>
> ..and focus on this one instead.

>
>> I should have the patch posted soon which breaks the zone->lru lock
>> for memcg reclaim. That patch should come after everything listed
>> above.
>
> Yeah, the lru lock fits perfectly into struct lruvec.
>
I posted that patch today and please take a look when you get chance.
That patch relies on the
d), so i will wait till the previous patches merged.

--Ying
