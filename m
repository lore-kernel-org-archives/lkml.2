Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab2LKQQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 11:16:08 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:55982 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab2LKQQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 11:16:06 -0500
Date: Tue, 11 Dec 2012 17:15:59 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Ying Han <yinghan@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <htejun@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Li Zefan <lizefan@huawei.com>
Subject: Re: [patch v2 3/6] memcg: rework mem_cgroup_iter to use cgroup
 iterators
Message-ID: <20121211161559.GF1612@dhcp22.suse.cz>
References: <1353955671-14385-1-git-send-email-mhocko@suse.cz>
 <1353955671-14385-4-git-send-email-mhocko@suse.cz>
 <CALWz4iwNvRd7AgEiSzd7Gr-7P5oh0uESS5A7rLZ7dZWeTjOzpQ@mail.gmail.com>
 <20121211155025.GB1612@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121211155025.GB1612@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 11-12-12 16:50:25, Michal Hocko wrote:
> On Sun 09-12-12 08:59:54, Ying Han wrote:
> > On Mon, Nov 26, 2012 at 10:47 AM, Michal Hocko <mhocko@suse.cz> wrote:
> [...]
> > > +               /*
> > > +                * Even if we found a group we have to make sure it is alive.
> > > +                * css && !memcg means that the groups should be skipped and
> > > +                * we should continue the tree walk.
> > > +                * last_visited css is safe to use because it is protected by
> > > +                * css_get and the tree walk is rcu safe.
> > > +                */
> > > +               if (css == &root->css || (css && css_tryget(css)))
> > > +                       memcg = mem_cgroup_from_css(css);
> > >
> > >                 if (reclaim) {
> > > -                       iter->position = id;
> > > +                       struct mem_cgroup *curr = memcg;
> > > +
> > > +                       if (last_visited)
> > > +                               css_put(&last_visited->css);
> > > +
> > > +                       if (css && !memcg)
> > > +                               curr = mem_cgroup_from_css(css);
> > 
> > In this case, the css_tryget() failed which implies the css is on the
> > way to be removed. (refcnt ==0) If so, why it is safe to call
> > css_get() directly on it below? It seems not preventing the css to be
> > removed by doing so.
> 
> Well, I do not remember exactly but I guess the code is meant to say
> that we need to store a half-dead memcg because the loop has to be
> retried. As we are under RCU hood it is just half dead.
> Now that you brought this up I think this is not safe as well because
> another thread could have seen the cached value while we tried to retry
> and his RCU is not protecting the group anymore.

Hmm, thinking about it some more, it _is_ be safe in the end.

We are safe because we are under RCU. And even if somebody else looked
at the half-dead memcg from iter->last_visited it cannot disappear
because the current one will retry without dropping RCU so the grace
period couldn't have been finished.

		CPU0					CPU1
rcu_read_lock()						rcu_read_lock()
while(!memcg) {						while(!memcg)
[...]
spin_lock(&iter->iter_lock)
[...]
if (css == &root->css ||
		(css && css_tryget(css)))
	memcg = mem_cgroup_from_css(css)
[...]
if (css && !memcg)
	curr = mem_cgroup_from_css(css)
if (curr)
	css_get(curr);
spin_unlock(&iter->iter_lock)
							spin_lock(&iter->iter_lock)
							/* sees the half dead memcg but its cgroup is still valid */ 
							[...]
							spin_unlock(&iter->iter_lock)
/* we do retry */
}
rcu_read_unlock()

so the css_get will just helps to prevent from further code obfuscation.

Makes sense? The code gets much simplified later in the series,
fortunately.
-- 
Michal Hocko
SUSE Labs
