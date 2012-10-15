Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab2JOJLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 05:11:38 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53937 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab2JOJLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 05:11:37 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <507BD33C.4030209@jp.fujitsu.com>
Date: Mon, 15 Oct 2012 18:11:24 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] memcg: oom: fix totalpages calculation for swappiness==0
References: <20121010141142.GG23011@dhcp22.suse.cz>
In-Reply-To: <20121010141142.GG23011@dhcp22.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/10/10 23:11), Michal Hocko wrote:
> Hi,
> I am sending the patch below as an RFC because I am not entirely happy
> about myself and maybe somebody can come up with a different approach
> which would be less hackish.
> As a background, I have noticed that memcg OOM killer kills a wrong
> tasks while playing with memory.swappiness==0 in a small group (e.g.
> 50M). I have multiple anon mem eaters which fault in more than the hard
> limit. OOM killer kills the last executed task:
>
> # mem_eater spawns one process per parameter, mmaps the given size and
> # faults memory in in parallel (all of them are synced to start together)
> ./mem_eater anon:50M anon:20M anon:20M anon:20M
> 10571: anon_eater for 20971520B
> 10570: anon_eater for 52428800B
> 10573: anon_eater for 20971520B
> 10572: anon_eater for 20971520B
> 10573: done with status 9
> 10571: done with status 0
> 10572: done with status 9
> 10570: done with status 9
>
> [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
> [ 5706]     0  5706     4955      556      13        0             0 bash
> [10569]     0 10569     1015      134       6        0             0 mem_eater
> [10570]     0 10570    13815     4118      15        0             0 mem_eater
> [10571]     0 10571     6135     5140      16        0             0 mem_eater
> [10572]     0 10572     6135       22       7        0             0 mem_eater
> [10573]     0 10573     6135     3541      14        0             0 mem_eater
> Memory cgroup out of memory: Kill process 10573 (mem_eater) score 0 or sacrifice child
> Killed process 10573 (mem_eater) total-vm:24540kB, anon-rss:14028kB, file-rss:136kB
> [...]
> [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
> [ 5706]     0  5706     4955      556      13        0             0 bash
> [10569]     0 10569     1015      134       6        0             0 mem_eater
> [10570]     0 10570    13815    10267      27        0             0 mem_eater
> [10572]     0 10572     6135     2519      12        0             0 mem_eater
> Memory cgroup out of memory: Kill process 10572 (mem_eater) score 0 or sacrifice child
> Killed process 10572 (mem_eater) total-vm:24540kB, anon-rss:9940kB, file-rss:136kB
> [...]
> [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
> [ 5706]     0  5706     4955      556      13        0             0 bash
> [10569]     0 10569     1015      134       6        0             0 mem_eater
> [10570]     0 10570    13815    12773      31        0             0 mem_eater
> Memory cgroup out of memory: Kill process 10570 (mem_eater) score 2 or sacrifice child
> Killed process 10570 (mem_eater) total-vm:55260kB, anon-rss:50956kB, file-rss:136kB
>
> As you can see 50M (pid:10570) is killed as the last one while 20M ones
> are killed first. See the patch for more details about the problem.
> As I state in the changelog the very same issue is present in the global
> oom killer as well but it is much less probable as the amount of swap is
> usualy much smaller than the available RAM and I think it is not worth
> considering.
>
> ---
>  From 445c2ced957cd77cbfca44d0e3f5056fed252a34 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Wed, 10 Oct 2012 15:46:54 +0200
> Subject: [PATCH] memcg: oom: fix totalpages calculation for swappiness==0
>
> oom_badness takes totalpages argument which says how many pages are
> available and it uses it as a base for the score calculation. The value
> is calculated by mem_cgroup_get_limit which considers both limit and
> total_swap_pages (resp. memsw portion of it).
>
> This is usually correct but since fe35004f (mm: avoid swapping out
> with swappiness==0) we do not swap when swappiness is 0 which means
> that we cannot really use up all the totalpages pages. This in turn
> confuses oom score calculation if the memcg limit is much smaller
> than the available swap because the used memory (capped by the limit)
> is negligible comparing to totalpages so the resulting score is too
> small. A wrong process might be selected as result.
>
> The same issue exists for the global oom killer as well but it is not
> that problematic as the amount of the RAM is usually much bigger than
> the swap space.
>
> The problem can be worked around by checking swappiness==0 and not
> considering swap at all.
>
> Signed-off-by: Michal Hocko <mhocko@suse.cz>@jp.fujitsu.com>

Hm...where should we describe this behavior....
Documentation/cgroup/memory.txt "5.3 swappiness" ?

Anyway, the patch itself seems good.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


