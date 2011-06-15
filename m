Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab1FOWse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 18:48:34 -0400
Received: from smtp-out.google.com ([216.239.44.51]:50408 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab1FOWsb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 18:48:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=G7mKS5PPJzM+hhFKt13AN9R2e5fBxU9La85UvLXK9jcnL7yheeahgvIjQJOf8FW2l+
         7/4EeZ1DNZG8bU0d69Jg==
MIME-Version: 1.0
In-Reply-To: <20110609150026.GD3994@tiehlicka.suse.cz>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
	<1306909519-7286-5-git-send-email-hannes@cmpxchg.org>
	<BANLkTim5TSWpBfeF2dugGZwQmNC-Cf+GCNctraq8FtziJxsd2g@mail.gmail.com>
	<BANLkTimuRks4+h=Kjt2Lzc-s-XsAHCH9vg@mail.gmail.com>
	<20110609150026.GD3994@tiehlicka.suse.cz>
Date: Wed, 15 Jun 2011 15:48:25 -0700
Message-ID: <BANLkTimbEnEHuxBDzKrEjPY7Y5F_aSoOdXkmjaOY+3xLBLzLdA@mail.gmail.com>
Subject: Re: [patch 4/8] memcg: rework soft limit reclaim
From: Ying Han <yinghan@google.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
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

On Thu, Jun 9, 2011 at 8:00 AM, Michal Hocko <mhocko@suse.cz> wrote:
> On Thu 02-06-11 22:25:29, Ying Han wrote:
>> On Thu, Jun 2, 2011 at 2:55 PM, Ying Han <yinghan@google.com> wrote:
>> > On Tue, May 31, 2011 at 11:25 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
>> >> Currently, soft limit reclaim is entered from kswapd, where it selects
> [...]
>> >> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> >> index c7d4b44..0163840 100644
>> >> --- a/mm/vmscan.c
>> >> +++ b/mm/vmscan.c
>> >> @@ -1988,9 +1988,13 @@ static void shrink_zone(int priority, struct zone *zone,
>> >>                unsigned long reclaimed = sc->nr_reclaimed;
>> >>                unsigned long scanned = sc->nr_scanned;
>> >>                unsigned long nr_reclaimed;
>> >> +               int epriority = priority;
>> >> +
>> >> +               if (mem_cgroup_soft_limit_exceeded(root, mem))
>> >> +                       epriority -= 1;
>> >
>> > Here we grant the ability to shrink from all the memcgs, but only
>> > higher the priority for those exceed the soft_limit. That is a design
>> > change
>> > for the "soft_limit" which giving a hint to which memcgs to reclaim
>> > from first under global memory pressure.
>>
>>
>> Basically, we shouldn't reclaim from a memcg under its soft_limit
>> unless we have trouble reclaim pages from others.
>
> Agreed.
>
>> Something like the following makes better sense:
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index bdc2fd3..b82ba8c 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -1989,6 +1989,8 @@ restart:
>>         throttle_vm_writeout(sc->gfp_mask);
>>  }
>>
>> +#define MEMCG_SOFTLIMIT_RECLAIM_PRIORITY       2
>> +
>>  static void shrink_zone(int priority, struct zone *zone,
>>                                 struct scan_control *sc)
>>  {
>> @@ -2001,13 +2003,13 @@ static void shrink_zone(int priority, struct zone *zone,
>>                 unsigned long reclaimed = sc->nr_reclaimed;
>>                 unsigned long scanned = sc->nr_scanned;
>>                 unsigned long nr_reclaimed;
>> -               int epriority = priority;
>>
>> -               if (mem_cgroup_soft_limit_exceeded(root, mem))
>> -                       epriority -= 1;
>> +               if (!mem_cgroup_soft_limit_exceeded(root, mem) &&
>> +                               priority > MEMCG_SOFTLIMIT_RECLAIM_PRIORITY)
>> +                       continue;
>
> yes, this makes sense but I am not sure about the right(tm) value of the
> MEMCG_SOFTLIMIT_RECLAIM_PRIORITY. 2 sounds too low. You would do quite a
> lot of loops
> (DEFAULT_PRIORITY-MEMCG_SOFTLIMIT_RECLAIM_PRIORITY) * zones * memcg_count
> without any progress (assuming that all of them are under soft limit
> which doesn't sound like a totally artificial configuration) until you
> allow reclaiming from groups that are under soft limit. Then, when you
> finally get to reclaiming, you scan rather aggressively.

Fair enough, something smarter is definitely needed :)

>
> Maybe something like 3/4 of DEFAULT_PRIORITY? You would get 3 times
> over all (unbalanced) zones and all cgroups that are above the limit
> (scanning max{1/4096+1/2048+1/1024, 3*SWAP_CLUSTER_MAX} of the LRUs for
> each cgroup) which could be enough to collect the low hanging fruit.

Hmm, that sounds more reasonable than the initial proposal.

For the same worst case where all the memcgs are blow their soft
limit, we need to scan 3 times of total memcgs before actually doing
anything. For that condition, I can not think of anything solve the
problem totally unless we have separate list of memcg (like what do
currently) per-zone.

--Ying

> --
> Michal Hocko
> SUSE Labs
> SUSE LINUX s.r.o.
> Lihovarska 1060/12
> 190 00 Praha 9
> Czech Republic
>
