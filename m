Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423074Ab2LGRM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 12:12:29 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:58117 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422888Ab2LGRM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 12:12:28 -0500
MIME-Version: 1.0
In-Reply-To: <20121207085839.GB31938@dhcp22.suse.cz>
References: <1353955671-14385-1-git-send-email-mhocko@suse.cz>
	<1353955671-14385-4-git-send-email-mhocko@suse.cz>
	<CALWz4ixQR0vHp+mGJdi2q77dMHaG8BZmb+iKfMmT=T0V8X8rAg@mail.gmail.com>
	<CALWz4iwrJtG-YUkA8ZpQC=JDMs3_ZRqwjrg+OEEO+_HA_KM9UA@mail.gmail.com>
	<20121207085839.GB31938@dhcp22.suse.cz>
Date: Fri, 7 Dec 2012 09:12:25 -0800
Message-ID: <CALWz4iwP5vzqE8O0uyCuBnOwbJX_07CB=CsGpP3yzrtQDkr2Qw@mail.gmail.com>
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

On Fri, Dec 7, 2012 at 12:58 AM, Michal Hocko <mhocko@suse.cz> wrote:
> On Thu 06-12-12 19:43:52, Ying Han wrote:
> [...]
>> Forgot to mention, I was testing 3.7-rc6 with the two cgroup changes :
>
> Could you give a try to -mm tree as well. There are some changes for
> memcgs removal in that tree which are not in Linus's tree.

I will give a try, which patchset you have in mind so i can double check?

I didn't find the place where the css pins the memcg, which either
something i missed or not in place in my tree. I twisted the patch a
bit to make it closer to your v2 version, but instead keep the
mem_cgroup_put() as well as using css_tryget(). Again, my test is
happy with it:

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f2eeee6..acec05a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1004,6 +1004,7 @@ struct mem_cgroup *mem_cgroup_iter(struct
mem_cgroup *root,
                        if (prev && reclaim->generation != iter->generation) {
                                if (last_visited) {
                                        css_put(&last_visited->css);
+                                       mem_cgroup_put(last_visited);
                                        iter->last_visited = NULL;
                                }
                                spin_unlock(&iter->iter_lock);
@@ -1041,15 +1042,22 @@ struct mem_cgroup *mem_cgroup_iter(struct
mem_cgroup *root,
                if (reclaim) {
                        struct mem_cgroup *curr = memcg;

-                       if (last_visited)
+                       if (last_visited) {
                                css_put(&last_visited->css);
+                               mem_cgroup_put(last_visited);
+                       }

                        if (css && !memcg)
                                curr = container_of(css, struct
mem_cgroup, css);

                        /* make sure that the cached memcg is not removed */
-                       if (curr)
-                               css_get(&curr->css);
+                       if (curr) {
+                               mem_cgroup_get(curr);
+                               if (!css_tryget(&curr->css)) {
+                                       mem_cgroup_put(curr);
+                                       curr = NULL;
+                               }
+                       }
                        iter->last_visited = curr;

                        if (!css)


--Ying

> --
> Michal Hocko
> SUSE Labs
