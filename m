Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab2LMFeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 00:34:44 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:40063 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab2LMFen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 00:34:43 -0500
Message-ID: <1355376877.1567.2.camel@kernel.cn.ibm.com>
Subject: Re: [patch 1/8] mm: memcg: only evict file pages when we have plenty
From: Simon Jeons <simon.jeons@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Wed, 12 Dec 2012 23:34:37 -0600
In-Reply-To: <1355348620-9382-2-git-send-email-hannes@cmpxchg.org>
References: <1355348620-9382-1-git-send-email-hannes@cmpxchg.org>
	 <1355348620-9382-2-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-12 at 16:43 -0500, Johannes Weiner wrote:
> dc0422c "mm: vmscan: only evict file pages when we have plenty" makes

Can't find dc0422c.

> a point of not going for anonymous memory while there is still enough
> inactive cache around.
> 
> The check was added only for global reclaim, but it is just as useful
> for memory cgroup reclaim.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/vmscan.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 157bb11..3874dcb 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1671,6 +1671,16 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
>  		denominator = 1;
>  		goto out;
>  	}
> +	/*
> +	 * There is enough inactive page cache, do not reclaim
> +	 * anything from the anonymous working set right now.
> +	 */
> +	if (!inactive_file_is_low(lruvec)) {
> +		fraction[0] = 0;
> +		fraction[1] = 1;
> +		denominator = 1;
> +		goto out;
> +	}
>  
>  	anon  = get_lru_size(lruvec, LRU_ACTIVE_ANON) +
>  		get_lru_size(lruvec, LRU_INACTIVE_ANON);
> @@ -1688,15 +1698,6 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
>  			fraction[1] = 0;
>  			denominator = 1;
>  			goto out;
> -		} else if (!inactive_file_is_low_global(zone)) {
> -			/*
> -			 * There is enough inactive page cache, do not
> -			 * reclaim anything from the working set right now.
> -			 */
> -			fraction[0] = 0;
> -			fraction[1] = 1;
> -			denominator = 1;
> -			goto out;
>  		}
>  	}
>  


