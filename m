Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab2LKWgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:36:12 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46892 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab2LKWgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:36:10 -0500
MIME-Version: 1.0
In-Reply-To: <20121211155432.GC1612@dhcp22.suse.cz>
References: <1353955671-14385-1-git-send-email-mhocko@suse.cz>
	<1353955671-14385-4-git-send-email-mhocko@suse.cz>
	<CALWz4ixPmvguxQO8s9mqH+OLEXC5LDfzEVFx_qqe2hBaRcsXiA@mail.gmail.com>
	<20121211155432.GC1612@dhcp22.suse.cz>
Date: Tue, 11 Dec 2012 14:36:10 -0800
Message-ID: <CALWz4izL7fEuQhEvKa7mUqi0sa25mcFP-xnTnL3vU3Z17k7VHg@mail.gmail.com>
Subject: Re: [patch v2 3/6] memcg: rework mem_cgroup_iter to use cgroup iterators
From: Ying Han <yinghan@google.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <htejun@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Li Zefan <lizefan@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 7:54 AM, Michal Hocko <mhocko@suse.cz> wrote:
> On Sun 09-12-12 11:39:50, Ying Han wrote:
>> On Mon, Nov 26, 2012 at 10:47 AM, Michal Hocko <mhocko@suse.cz> wrote:
> [...]
>> >                 if (reclaim) {
>> > -                       iter->position = id;
>> > +                       struct mem_cgroup *curr = memcg;
>> > +
>> > +                       if (last_visited)
>> > +                               css_put(&last_visited->css);
>                             ^^^^^^^^^^^
>                             here
>> > +
>> > +                       if (css && !memcg)
>> > +                               curr = mem_cgroup_from_css(css);
>> > +
>> > +                       /* make sure that the cached memcg is not removed */
>> > +                       if (curr)
>> > +                               css_get(&curr->css);
>> > +                       iter->last_visited = curr;
>>
>> Here we take extra refcnt for last_visited, and assume it is under
>> target reclaim which then calls mem_cgroup_iter_break() and we leaked
>> a refcnt of the target memcg css.
>
> I think you are not right here. The extra reference is kept for
> iter->last_visited and it will be dropped the next time somebody sees
> the same zone-priority iter. See above.
>
> Or have I missed your question?

Hmm, question remains.

My understanding of the mem_cgroup_iter() is that each call path
should close the loop itself, in the sense that no *leaked* css refcnt
after that loop finished. It is the case for all the caller today
where the loop terminates at memcg == NULL, where all the refcnt have
been dropped by then.

One exception is mem_cgroup_iter_break(), where the loop terminates
with *leaked* refcnt and that is what the iter_break() needs to clean
up. We can not rely on the next caller of the loop since it might
never happen.

It makes sense to drop the refcnt of last_visited, the same reason as
drop refcnt of prev. I don't see why it makes different.

--Ying


>
> [...]
> --
> Michal Hocko
> SUSE Labs
