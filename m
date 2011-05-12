Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab1ELPdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 11:33:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755688Ab1ELPds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 11:33:48 -0400
Message-ID: <4DCBFDB9.10209@redhat.com>
Date: Thu, 12 May 2011 11:33:13 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [rfc patch 2/6] vmscan: make distinction between memcg reclaim
 and LRU list selection
References: <1305212038-15445-1-git-send-email-hannes@cmpxchg.org> <1305212038-15445-3-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1305212038-15445-3-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2011 10:53 AM, Johannes Weiner wrote:
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
> Signed-off-by: Johannes Weiner<hannes@cmpxchg.org>
> ---
>   mm/vmscan.c |   96 ++++++++++++++++++++++++++++++++++------------------------
>   1 files changed, 56 insertions(+), 40 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f6b435c..ceeb2a5 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -104,8 +104,12 @@ struct scan_control {
>   	 */
>   	reclaim_mode_t reclaim_mode;
>
> -	/* Which cgroup do we reclaim from */
> -	struct mem_cgroup *mem_cgroup;
> +	/*
> +	 * The memory cgroup we reclaim on behalf of, and the one we
> +	 * are currently reclaiming from.
> +	 */
> +	struct mem_cgroup *memcg;
> +	struct mem_cgroup *current_memcg;

I can't say I'm fond of these names.  I had to read the
rest of the patch to figure out that the old mem_cgroup
got renamed to current_memcg.

Would it be better to call them my_memcg and reclaim_memcg?

Maybe somebody else has better suggestions...

Other than the naming, no objection.

