Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291Ab2AMVpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 16:45:34 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57102 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759269Ab2AMVpb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 16:45:31 -0500
MIME-Version: 1.0
In-Reply-To: <20120113163423.GG17060@tiehlicka.suse.cz>
References: <1326207772-16762-1-git-send-email-hannes@cmpxchg.org>
	<1326207772-16762-3-git-send-email-hannes@cmpxchg.org>
	<20120113120406.GC17060@tiehlicka.suse.cz>
	<20120113155001.GB1653@cmpxchg.org>
	<20120113163423.GG17060@tiehlicka.suse.cz>
Date: Fri, 13 Jan 2012 13:45:30 -0800
Message-ID: <CALWz4iyj4SMMyYhbuZ3HUq-jvcZUCGarceYY7vxm4b7X=yvCMg@mail.gmail.com>
Subject: Re: [patch 2/2] mm: memcg: hierarchical soft limit reclaim
From: Ying Han <yinghan@google.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 8:34 AM, Michal Hocko <mhocko@suse.cz> wrote:
> On Fri 13-01-12 16:50:01, Johannes Weiner wrote:
>> On Fri, Jan 13, 2012 at 01:04:06PM +0100, Michal Hocko wrote:
>> > On Tue 10-01-12 16:02:52, Johannes Weiner wrote:
> [...]
>> > > +bool mem_cgroup_over_softlimit(struct mem_cgroup *root,
>> > > +                        struct mem_cgroup *memcg)
>> > > +{
>> > > + if (mem_cgroup_disabled())
>> > > +         return false;
>> > > +
>> > > + if (!root)
>> > > +         root = root_mem_cgroup;
>> > > +
>> > > + for (; memcg; memcg = parent_mem_cgroup(memcg)) {
>> > > +         /* root_mem_cgroup does not have a soft limit */
>> > > +         if (memcg == root_mem_cgroup)
>> > > +                 break;
>> > > +         if (res_counter_soft_limit_excess(&memcg->res))
>> > > +                 return true;
>> > > +         if (memcg == root)
>> > > +                 break;
>> > > + }
>> > > + return false;
>> > > +}
>> >
>> > Well, this might be little bit tricky. We do not check whether memcg and
>> > root are in a hierarchy (in terms of use_hierarchy) relation.
>> >
>> > If we are under global reclaim then we iterate over all memcgs and so
>> > there is no guarantee that there is a hierarchical relation between the
>> > given memcg and its parent. While, on the other hand, if we are doing
>> > memcg reclaim then we have this guarantee.
>> >
>> > Why should we punish a group (subtree) which is perfectly under its soft
>> > limit just because some other subtree contributes to the common parent's
>> > usage and makes it over its limit?
>> > Should we check memcg->use_hierarchy here?
>>
>> We do, actually.  parent_mem_cgroup() checks the res_counter parent,
>> which is only set when ->use_hierarchy is also set.
>
> Of course I am blind.. We do not setup res_counter parent for
> !use_hierarchy case. Sorry for noise...
> Now it makes much better sense. I was wondering how !use_hierarchy could
> ever work, this should be a signal that I am overlooking something
> terribly.
>
> [...]
>> > > @@ -2121,8 +2121,16 @@ static void shrink_zone(int priority, struct zone *zone,
>> > >                   .mem_cgroup = memcg,
>> > >                   .zone = zone,
>> > >           };
>> > > +         int epriority = priority;
>> > > +         /*
>> > > +          * Put more pressure on hierarchies that exceed their
>> > > +          * soft limit, to push them back harder than their
>> > > +          * well-behaving siblings.
>> > > +          */
>> > > +         if (mem_cgroup_over_softlimit(root, memcg))
>> > > +                 epriority = 0;
>> >
>> > This sounds too aggressive to me. Shouldn't we just double the pressure
>> > or something like that?
>>
>> That's the historical value.  When I tried priority - 1, it was not
>> aggressive enough.
>
> Probably because we want to reclaim too much. Maybe we should do
> reduce nr_to_reclaim (ugly) or reclaim only overlimit groups until certain
> priority level as Ying suggested in her patchset.

I plan to post that change on top of this, and this patch set does the
basic stuff to allow us doing further improvement.

I still like the design to skip over_soft_limit cgroups until certain
priority. One way to set up the soft limit for each cgroup is to base
on its actual working set size, and we prefer to punish A first with
lots of page cache ( cold file pages above soft limit) than reclaiming
anon pages from B ( below soft limit ). Unless we can not get enough
pages reclaimed from A, we will start reclaiming from B.

This might not be the ideal solution, but should be a good start. Thoughts?

--Ying

> --
> Michal Hocko
> SUSE Labs
> SUSE LINUX s.r.o.
> Lihovarska 1060/12
> 190 00 Praha 9
> Czech Republic
