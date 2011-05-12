Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923Ab1ELX5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 19:57:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56076 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758709Ab1ELX5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 19:57:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 13 May 2011 08:50:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [rfc patch 2/6] vmscan: make distinction between memcg reclaim
 and LRU list selection
Message-Id: <20110513085027.25b25a47.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1305212038-15445-3-git-send-email-hannes@cmpxchg.org>
References: <1305212038-15445-1-git-send-email-hannes@cmpxchg.org>
	<1305212038-15445-3-git-send-email-hannes@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011 16:53:54 +0200
Johannes Weiner <hannes@cmpxchg.org> wrote:

> The reclaim code has a single predicate for whether it currently
> reclaims on behalf of a memory cgroup, as well as whether it is
> reclaiming from the global LRU list or a memory cgroup LRU list.
> 
> Up to now, both cases always coincide, but subsequent patches will
> change things such that global reclaim will scan memory cgroup lists.
> 
> This patch adds a new predicate that tells global reclaim from memory
> cgroup reclaim, and then changes all callsites that are actually about
> global reclaim heuristics rather than strict LRU list selection.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>


Hmm, isn't it better to merge this to patches where the meaning of
new variable gets clearer ?

> ---
>  mm/vmscan.c |   96 ++++++++++++++++++++++++++++++++++------------------------
>  1 files changed, 56 insertions(+), 40 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f6b435c..ceeb2a5 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -104,8 +104,12 @@ struct scan_control {
>  	 */
>  	reclaim_mode_t reclaim_mode;
>  
> -	/* Which cgroup do we reclaim from */
> -	struct mem_cgroup *mem_cgroup;
> +	/*
> +	 * The memory cgroup we reclaim on behalf of, and the one we
> +	 * are currently reclaiming from.
> +	 */
> +	struct mem_cgroup *memcg;
> +	struct mem_cgroup *current_memcg;
>  

I wonder if you avoid renaming exisiting one, the patch will
be clearer...



>  	/*
>  	 * Nodemask of nodes allowed by the caller. If NULL, all nodes
> @@ -154,16 +158,24 @@ static LIST_HEAD(shrinker_list);
>  static DECLARE_RWSEM(shrinker_rwsem);
>  
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR
> -#define scanning_global_lru(sc)	(!(sc)->mem_cgroup)
> +static bool global_reclaim(struct scan_control *sc)
> +{
> +	return !sc->memcg;
> +}
> +static bool scanning_global_lru(struct scan_control *sc)
> +{
> +	return !sc->current_memcg;
> +}


Could you add comments ?

Thanks,
-Kame

