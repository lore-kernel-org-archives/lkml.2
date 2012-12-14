Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab2LNMHL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 07:07:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39012 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab2LNMHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 07:07:10 -0500
Date: Fri, 14 Dec 2012 13:07:07 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Ying Han <yinghan@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <htejun@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Li Zefan <lizefan@huawei.com>
Subject: Re: [patch v2 3/6] memcg: rework mem_cgroup_iter to use cgroup
 iterators
Message-ID: <20121214120707.GG6898@dhcp22.suse.cz>
References: <1353955671-14385-1-git-send-email-mhocko@suse.cz>
 <1353955671-14385-4-git-send-email-mhocko@suse.cz>
 <CALWz4ixPmvguxQO8s9mqH+OLEXC5LDfzEVFx_qqe2hBaRcsXiA@mail.gmail.com>
 <20121211155432.GC1612@dhcp22.suse.cz>
 <CALWz4izL7fEuQhEvKa7mUqi0sa25mcFP-xnTnL3vU3Z17k7VHg@mail.gmail.com>
 <20121212090652.GB32081@dhcp22.suse.cz>
 <20121212192441.GD10374@dhcp22.suse.cz>
 <CALWz4iygkxRUJX2bEhHp6nyEwyVA8w8WxNcQqzmXuMeH8kMuYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALWz4iygkxRUJX2bEhHp6nyEwyVA8w8WxNcQqzmXuMeH8kMuYA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 13-12-12 17:14:13, Ying Han wrote:
[...]
> I haven't tried this patch set yet. Before I am doing that, I am
> curious whether changing the target reclaim to be consistent with
> global reclaim something worthy to consider based my last reply:
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 53dcde9..3f158c5 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1911,20 +1911,6 @@ static void shrink_zone(struct zone *zone,
> struct scan_control *sc)
> 
>                 shrink_lruvec(lruvec, sc);
> 
> -               /*
> -                * Limit reclaim has historically picked one memcg and
> -                * scanned it with decreasing priority levels until
> -                * nr_to_reclaim had been reclaimed.  This priority
> -                * cycle is thus over after a single memcg.
> -                *
> -                * Direct reclaim and kswapd, on the other hand, have
> -                * to scan all memory cgroups to fulfill the overall
> -                * scan target for the zone.
> -                */
> -               if (!global_reclaim(sc)) {
> -                       mem_cgroup_iter_break(root, memcg);
> -                       break;
> -               }
>                 memcg = mem_cgroup_iter(root, memcg, &reclaim);

This wouldn't work because you would over-reclaim proportionally to the
number of groups in the hierarchy.

>         } while (memcg);
>  }
> 
> --Ying

-- 
Michal Hocko
SUSE Labs
