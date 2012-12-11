Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab2LKPyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 10:54:39 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46421 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab2LKPyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 10:54:38 -0500
Date: Tue, 11 Dec 2012 16:54:32 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Ying Han <yinghan@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <htejun@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Li Zefan <lizefan@huawei.com>
Subject: Re: [patch v2 3/6] memcg: rework mem_cgroup_iter to use cgroup
 iterators
Message-ID: <20121211155432.GC1612@dhcp22.suse.cz>
References: <1353955671-14385-1-git-send-email-mhocko@suse.cz>
 <1353955671-14385-4-git-send-email-mhocko@suse.cz>
 <CALWz4ixPmvguxQO8s9mqH+OLEXC5LDfzEVFx_qqe2hBaRcsXiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALWz4ixPmvguxQO8s9mqH+OLEXC5LDfzEVFx_qqe2hBaRcsXiA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 09-12-12 11:39:50, Ying Han wrote:
> On Mon, Nov 26, 2012 at 10:47 AM, Michal Hocko <mhocko@suse.cz> wrote:
[...]
> >                 if (reclaim) {
> > -                       iter->position = id;
> > +                       struct mem_cgroup *curr = memcg;
> > +
> > +                       if (last_visited)
> > +                               css_put(&last_visited->css);
			    ^^^^^^^^^^^
			    here
> > +
> > +                       if (css && !memcg)
> > +                               curr = mem_cgroup_from_css(css);
> > +
> > +                       /* make sure that the cached memcg is not removed */
> > +                       if (curr)
> > +                               css_get(&curr->css);
> > +                       iter->last_visited = curr;
> 
> Here we take extra refcnt for last_visited, and assume it is under
> target reclaim which then calls mem_cgroup_iter_break() and we leaked
> a refcnt of the target memcg css.

I think you are not right here. The extra reference is kept for
iter->last_visited and it will be dropped the next time somebody sees
the same zone-priority iter. See above.

Or have I missed your question?

[...]
-- 
Michal Hocko
SUSE Labs
