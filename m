Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab2LLV4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:56:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168Ab2LLV4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:56:02 -0500
Message-ID: <50C8FCE0.1060408@redhat.com>
Date: Wed, 12 Dec 2012 16:53:36 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/8] mm: memcg: only evict file pages when we have plenty
References: <1355348620-9382-1-git-send-email-hannes@cmpxchg.org> <1355348620-9382-2-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1355348620-9382-2-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 04:43 PM, Johannes Weiner wrote:
> dc0422c "mm: vmscan: only evict file pages when we have plenty" makes
> a point of not going for anonymous memory while there is still enough
> inactive cache around.
>
> The check was added only for global reclaim, but it is just as useful
> for memory cgroup reclaim.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>   mm/vmscan.c | 19 ++++++++++---------
>   1 file changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 157bb11..3874dcb 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1671,6 +1671,16 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
>   		denominator = 1;
>   		goto out;
>   	}
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
>   	anon  = get_lru_size(lruvec, LRU_ACTIVE_ANON) +
>   		get_lru_size(lruvec, LRU_INACTIVE_ANON);
> @@ -1688,15 +1698,6 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
>   			fraction[1] = 0;
>   			denominator = 1;
>   			goto out;
> -		} else if (!inactive_file_is_low_global(zone)) {
> -			/*
> -			 * There is enough inactive page cache, do not
> -			 * reclaim anything from the working set right now.
> -			 */
> -			fraction[0] = 0;
> -			fraction[1] = 1;
> -			denominator = 1;
> -			goto out;
>   		}
>   	}
>
>

I believe the if() block should be moved to AFTER
the check where we make sure we actually have enough
file pages.

