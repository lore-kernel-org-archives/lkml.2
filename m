Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab1FBQOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 12:14:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58661 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab1FBQOO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 12:14:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lBS6d8LDX22VygQtkcisDyiB44zltKg5+FtplrUCaUg+RAOQYnIFEAxreQJ304Zmg1
         MweUt5sf69iaCPyJxGeRhFDa7qLk4hmNGqkRjWOiSEzizsm+pC5i+TEi3iRCFC7GMZEL
         bWCm41GiGO+NWAT198hXKh/qBaq8p4YdIy42I=
MIME-Version: 1.0
In-Reply-To: <20110602150123.GE28684@cmpxchg.org>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
	<1306909519-7286-3-git-send-email-hannes@cmpxchg.org>
	<BANLkTikKHq=NBAPOXJVDM7ZEc9CkW+HdmQ@mail.gmail.com>
	<20110602150123.GE28684@cmpxchg.org>
Date: Fri, 3 Jun 2011 01:14:12 +0900
Message-ID: <BANLkTinWGEJHf1MhzDS4JB0-V9iynoFoHA@mail.gmail.com>
Subject: Re: [patch 2/8] mm: memcg-aware global reclaim
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/3 Johannes Weiner <hannes@cmpxchg.org>:
> On Thu, Jun 02, 2011 at 10:59:01PM +0900, Hiroyuki Kamezawa wrote:
>> 2011/6/1 Johannes Weiner <hannes@cmpxchg.org>:

>> > @@ -1927,8 +1980,7 @@ static int mem_cgroup_do_charge(struct mem_cgroup *mem, gfp_t gfp_mask,
>> >        if (!(gfp_mask & __GFP_WAIT))
>> >                return CHARGE_WOULDBLOCK;
>> >
>> > -       ret = mem_cgroup_hierarchical_reclaim(mem_over_limit, NULL,
>> > -                                             gfp_mask, flags);
>> > +       ret = mem_cgroup_reclaim(mem_over_limit, gfp_mask, flags);
>> >        if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
>> >                return CHARGE_RETRY;
>> >        /*
>>
>> It seems this clean-up around hierarchy and softlimit can be in an
>> independent patch, no ?
>
> Hm, why do you think it's a cleanup?  The hierarchical target reclaim
> code is moved to vmscan.c and as a result the entry points for hard
> limit and soft limit reclaim differ.  This is why the original
> function, mem_cgroup_hierarchical_reclaim() has to be split into two
> parts.
>
If functionality is unchanged, I think it's clean up.
I agree to move hierarchy walk to vmscan.c. but it can be done as
a clean up patch for current code.
(Make current try_to_free_mem_cgroup_pages() to use this code.)
 and then, you can write a patch which only includes a core
logic/purpose of this patch
"use root cgroup's LRU for global and make global reclaim as full-scan
of memcgroup."

In short, I felt this patch is long....and maybe watchers of -mm are
not interested in rewritie of hierarchy walk but are intetested in the
chages in shrink_zone() itself very much.



>> > @@ -1943,6 +1976,31 @@ restart:
>> >        throttle_vm_writeout(sc->gfp_mask);
>> >  }
>> >
>> > +static void shrink_zone(int priority, struct zone *zone,
>> > +                       struct scan_control *sc)
>> > +{
>> > +       unsigned long nr_reclaimed_before = sc->nr_reclaimed;
>> > +       struct mem_cgroup *root = sc->target_mem_cgroup;
>> > +       struct mem_cgroup *first, *mem = NULL;
>> > +
>> > +       first = mem = mem_cgroup_hierarchy_walk(root, mem);
>>
>> Hmm, I think we should add some scheduling here, later.
>> (as select a group over softlimit or select a group which has
>>  easily reclaimable pages on this zone.)
>>
>> This name as hierarchy_walk() sounds like "full scan in round-robin, always".
>> Could you find better name ?
>
> Okay, I'll try.
>
>> > +       for (;;) {
>> > +               unsigned long nr_reclaimed;
>> > +
>> > +               sc->mem_cgroup = mem;
>> > +               do_shrink_zone(priority, zone, sc);
>> > +
>> > +               nr_reclaimed = sc->nr_reclaimed - nr_reclaimed_before;
>> > +               if (nr_reclaimed >= sc->nr_to_reclaim)
>> > +                       break;
>>
>> what this calculation means ?  Shouldn't we do this quit based on the
>> number of "scan"
>> rather than "reclaimed" ?
>
> It aborts the loop once sc->nr_to_reclaim pages have been reclaimed
> from that zone during that hierarchy walk, to prevent overreclaim.
>
> If you have unbalanced sizes of memcgs in the system, it is not
> desirable to have every reclaimer scan all memcgs, but let those quit
> early that have made some progress on the bigger memcgs.
>
Hmm, why not if (sc->nr_reclaimed >= sc->nr_to_reclaim) ?

I'm sorry if I miss something..


> It's essentially a forward progagation of the same check in
> do_shrink_zone().  It trades absolute fairness for average reclaim
> latency.
>
> Note that kswapd sets the reclaim target to infinity, so this
> optimization applies only to direct reclaimers.
>
>> > +               mem = mem_cgroup_hierarchy_walk(root, mem);
>> > +               if (mem == first)
>> > +                       break;
>>
>> Why we quit loop  ?
>
> get_scan_count() for traditional global reclaim returns the scan
> target for the zone.
>
> With this per-memcg reclaimer, get_scan_count() will return scan
> targets for the respective per-memcg zone subsizes.
>
> So once we have gone through all memcgs, we should have scanned the
> amount of pages that global reclaim would have deemed sensible for
> that zone at that priority level.
>
> As such, this is the exit condition based on scan count you referred
> to above.
>
That's what I want as a comment in codes.

Thanks,
-Kame
