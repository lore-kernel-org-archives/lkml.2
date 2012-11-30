Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab2K3EH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 23:07:57 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38480 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab2K3EH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 23:07:56 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50B830F8.2010908@jp.fujitsu.com>
Date: Fri, 30 Nov 2012 13:07:20 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Tejun Heo <htejun@gmail.com>, Glauber Costa <glommer@parallels.com>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [patch v2 3/6] memcg: rework mem_cgroup_iter to use cgroup iterators
References: <1353955671-14385-1-git-send-email-mhocko@suse.cz> <1353955671-14385-4-git-send-email-mhocko@suse.cz>
In-Reply-To: <1353955671-14385-4-git-send-email-mhocko@suse.cz>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/27 3:47), Michal Hocko wrote:
> mem_cgroup_iter curently relies on css->id when walking down a group
> hierarchy tree. This is really awkward because the tree walk depends on
> the groups creation ordering. The only guarantee is that a parent node
> is visited before its children.
> Example
>   1) mkdir -p a a/d a/b/c
>   2) mkdir -a a/b/c a/d
> Will create the same trees but the tree walks will be different:
>   1) a, d, b, c
>   2) a, b, c, d
> 
> 574bd9f7 (cgroup: implement generic child / descendant walk macros) has
> introduced generic cgroup tree walkers which provide either pre-order
> or post-order tree walk. This patch converts css->id based iteration
> to pre-order tree walk to keep the semantic with the original iterator
> where parent is always visited before its subtree.
> 
> cgroup_for_each_descendant_pre suggests using post_create and
> pre_destroy for proper synchronization with groups addidition resp.
> removal. This implementation doesn't use those because a new memory
> cgroup is fully initialized in mem_cgroup_create and css reference
> counting enforces that the group is alive for both the last seen cgroup
> and the found one resp. it signals that the group is dead and it should
> be skipped.
> 
> If the reclaim cookie is used we need to store the last visited group
> into the iterator so we have to be careful that it doesn't disappear in
> the mean time. Elevated reference count on the css keeps it alive even
> though the group have been removed (parked waiting for the last dput so
> that it can be freed).
> 
> V2
> - use css_{get,put} for iter->last_visited rather than
>    mem_cgroup_{get,put} because it is stronger wrt. cgroup life cycle
> - cgroup_next_descendant_pre expects NULL pos for the first iterartion
>    otherwise it might loop endlessly for intermediate node without any
>    children.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


