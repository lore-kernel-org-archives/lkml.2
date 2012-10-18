Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab2JRAan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 20:30:43 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36016 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab2JRAal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 20:30:41 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <507F4D86.106@jp.fujitsu.com>
Date: Thu, 18 Oct 2012 09:29:58 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [RFC] memcg/cgroup: do not fail fail on pre_destroy callbacks
References: <1350480648-10905-1-git-send-email-mhocko@suse.cz>
In-Reply-To: <1350480648-10905-1-git-send-email-mhocko@suse.cz>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/10/17 22:30), Michal Hocko wrote:
> Hi,
> memcg is the only controller which might fail in its pre_destroy
> callback which makes the cgroup core more complicated for no good
> reason. This is an attempt to change this unfortunate state.
> 
> I am sending this a RFC because I would like to hear back whether the
> approach is correct. I thought that the changes would be more invasive
> but it seems that the current code was mostly prepared for this and it
> needs just some small tweaks (so I might be missing something important
> here).
> 
> The first two patches are just clean ups. They could be merged even
> without the rest.
> 
> The real change, although the code is not changed that much, is the 3rd
> patch. It changes the way how we handle mem_cgroup_move_parent failures.
> We have to realize that all those failures are *temporal*. Because we
> are either racing with the page removal or the page is temporarily off
> the LRU because of migration resp. global reclaim. As a result we do
> not fail mem_cgroup_force_empty_list if the page cannot be moved to the
> parent and rather retry until the LRU is empty.
> 
> The 4th patch is for cgroup core. I have moved cgroup_call_pre_destroy
> inside the cgroup_lock which is not very nice because the callbacks
> can take some time. Maybe we can move this call at the very end of the
> function?
> All I need for memcg is that cgroup_call_pre_destroy has been called and
> that no new cgroups can be attached to the group. The cgroup_lock is
> necessary for the later condition but if we move after CGRP_REMOVED flag
> is set then we are safe as well.
> 
> The last two patches are trivial follow ups for the cgroups core change
> because now we know that nobody will interfere with us so we can drop
> those empty && no child condition.
> 
> Comments, thoughts?
> 
> Michal Hocko (6):
>        memcg: split mem_cgroup_force_empty into reclaiming and reparenting parts
>        memcg: root_cgroup cannot reach mem_cgroup_move_parent
>        memcg: Simplify mem_cgroup_force_empty_list error handling
>        cgroups: forbid pre_destroy callback to fail
>        memcg: make mem_cgroup_reparent_charges non failing
>        hugetlb: do not fail in hugetlb_cgroup_pre_destroy
> 
> Cumulative diffstat:
>   kernel/cgroup.c     |   30 ++++---------
>   mm/hugetlb_cgroup.c |   11 ++---
>   mm/memcontrol.c     |  124 +++++++++++++++++++++++++++------------------------
>   3 files changed, 78 insertions(+), 87 deletions(-)

Thank you very much ! The whole patch seems good to me and I like this approach.

Thanks,
-Kame




