Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab2LKWnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:43:39 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:46234 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab2LKWnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:43:37 -0500
MIME-Version: 1.0
In-Reply-To: <20121211161559.GF1612@dhcp22.suse.cz>
References: <1353955671-14385-1-git-send-email-mhocko@suse.cz>
	<1353955671-14385-4-git-send-email-mhocko@suse.cz>
	<CALWz4iwNvRd7AgEiSzd7Gr-7P5oh0uESS5A7rLZ7dZWeTjOzpQ@mail.gmail.com>
	<20121211155025.GB1612@dhcp22.suse.cz>
	<20121211161559.GF1612@dhcp22.suse.cz>
Date: Tue, 11 Dec 2012 14:43:37 -0800
Message-ID: <CALWz4iwhCLUrFomjmWiDf3_C7P1sTFeRhKMB4fHw5RFamoZ8pw@mail.gmail.com>
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

On Tue, Dec 11, 2012 at 8:15 AM, Michal Hocko <mhocko@suse.cz> wrote:
> On Tue 11-12-12 16:50:25, Michal Hocko wrote:
>> On Sun 09-12-12 08:59:54, Ying Han wrote:
>> > On Mon, Nov 26, 2012 at 10:47 AM, Michal Hocko <mhocko@suse.cz> wrote:
>> [...]
>> > > +               /*
>> > > +                * Even if we found a group we have to make sure it is alive.
>> > > +                * css && !memcg means that the groups should be skipped and
>> > > +                * we should continue the tree walk.
>> > > +                * last_visited css is safe to use because it is protected by
>> > > +                * css_get and the tree walk is rcu safe.
>> > > +                */
>> > > +               if (css == &root->css || (css && css_tryget(css)))
>> > > +                       memcg = mem_cgroup_from_css(css);
>> > >
>> > >                 if (reclaim) {
>> > > -                       iter->position = id;
>> > > +                       struct mem_cgroup *curr = memcg;
>> > > +
>> > > +                       if (last_visited)
>> > > +                               css_put(&last_visited->css);
>> > > +
>> > > +                       if (css && !memcg)
>> > > +                               curr = mem_cgroup_from_css(css);
>> >
>> > In this case, the css_tryget() failed which implies the css is on the
>> > way to be removed. (refcnt ==0) If so, why it is safe to call
>> > css_get() directly on it below? It seems not preventing the css to be
>> > removed by doing so.
>>
>> Well, I do not remember exactly but I guess the code is meant to say
>> that we need to store a half-dead memcg because the loop has to be
>> retried. As we are under RCU hood it is just half dead.
>> Now that you brought this up I think this is not safe as well because
>> another thread could have seen the cached value while we tried to retry
>> and his RCU is not protecting the group anymore.
>
> Hmm, thinking about it some more, it _is_ be safe in the end.
>
> We are safe because we are under RCU. And even if somebody else looked
> at the half-dead memcg from iter->last_visited it cannot disappear
> because the current one will retry without dropping RCU so the grace
> period couldn't have been finished.
>
>                 CPU0                                    CPU1
> rcu_read_lock()                                         rcu_read_lock()
> while(!memcg) {                                         while(!memcg)
> [...]
> spin_lock(&iter->iter_lock)
> [...]
> if (css == &root->css ||
>                 (css && css_tryget(css)))
>         memcg = mem_cgroup_from_css(css)
> [...]
> if (css && !memcg)
>         curr = mem_cgroup_from_css(css)
> if (curr)
>         css_get(curr);
> spin_unlock(&iter->iter_lock)
>                                                         spin_lock(&iter->iter_lock)
>                                                         /* sees the half dead memcg but its cgroup is still valid */
>                                                         [...]
>                                                         spin_unlock(&iter->iter_lock)
> /* we do retry */
> }
> rcu_read_unlock()
>
> so the css_get will just helps to prevent from further code obfuscation.
>
> Makes sense? The code gets much simplified later in the series,
> fortunately.

My understanding on this is that we should never call css_get()
without calling css_tryget() and it succeed. Whether or not it is
*safe* to do so, that seems conflicts with the assumption of the
cgroup_rmdir().

I would rather make the change to do the retry after css_tryget()
failed. The patch I have on my local tree:

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f2eeee6..e2af02d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -991,6 +991,7 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
        while (!memcg) {
                struct mem_cgroup_reclaim_iter *uninitialized_var(iter);
                struct cgroup_subsys_state *css = NULL;
+               struct cgroup *prev_cgroup, *next_cgroup;

                if (reclaim) {
                        int nid = zone_to_nid(reclaim->zone);
@@ -1018,10 +1019,9 @@ struct mem_cgroup *mem_cgroup_iter(struct
mem_cgroup *root,
                if (!last_visited) {
                        css = &root->css;
                } else {
-                       struct cgroup *prev_cgroup, *next_cgroup;
-
                        prev_cgroup = (last_visited == root) ? NULL
                                : last_visited->css.cgroup;
+skip_node:
                        next_cgroup = cgroup_next_descendant_pre(
                                        prev_cgroup,
                                        root->css.cgroup);
@@ -1038,15 +1038,17 @@ struct mem_cgroup *mem_cgroup_iter(struct
mem_cgroup *root,
                if (css == &root->css || (css && css_tryget(css)))
                        memcg = container_of(css, struct mem_cgroup, css);

+               if (css && !memcg) {
+                       prev_cgroup = next_cgroup;
+                       goto skip_node;
+               }
+
                if (reclaim) {
                        struct mem_cgroup *curr = memcg;

                        if (last_visited)
                                css_put(&last_visited->css);

-                       if (css && !memcg)
-                               curr = container_of(css, struct
mem_cgroup, css);
-
                        /* make sure that the cached memcg is not removed */
                        if (curr)
                                css_get(&curr->css);
@@ -1057,8 +1059,6 @@ struct mem_cgroup *mem_cgroup_iter(struct
mem_cgroup *root,
                        else if (!prev && memcg)
                                reclaim->generation = iter->generation;
                        spin_unlock(&iter->iter_lock);


--Ying

> --
> Michal Hocko
> SUSE Labs
