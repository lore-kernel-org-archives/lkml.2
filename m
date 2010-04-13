Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab0DMIRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 04:17:18 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:32990 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab0DMIRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 04:17:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] mm: add context argument to shrinker callback
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
In-Reply-To: <1271118255-21070-2-git-send-email-david@fromorbit.com>
References: <1271118255-21070-1-git-send-email-david@fromorbit.com> <1271118255-21070-2-git-send-email-david@fromorbit.com>
Message-Id: <20100413170653.D10A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 13 Apr 2010 17:17:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index e70f21b..7d48942 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -982,11 +982,11 @@ static inline void sync_mm_rss(struct task_struct *task, struct mm_struct *mm)
>  /*
>   * A callback you can register to apply pressure to ageable caches.
>   *
> - * 'shrink' is passed a count 'nr_to_scan' and a 'gfpmask'.  It should
> - * look through the least-recently-used 'nr_to_scan' entries and
> - * attempt to free them up.  It should return the number of objects
> - * which remain in the cache.  If it returns -1, it means it cannot do
> - * any scanning at this time (eg. there is a risk of deadlock).
> + * 'shrink' is passed a context 'ctx', a count 'nr_to_scan' and a 'gfpmask'.
> + * It should look through the least-recently-used 'nr_to_scan' entries and
> + * attempt to free them up.  It should return the number of objects which
> + * remain in the cache.  If it returns -1, it means it cannot do any scanning
> + * at this time (eg. there is a risk of deadlock).
>   *
>   * The 'gfpmask' refers to the allocation we are currently trying to
>   * fulfil.
> @@ -995,7 +995,8 @@ static inline void sync_mm_rss(struct task_struct *task, struct mm_struct *mm)
>   * querying the cache size, so a fastpath for that case is appropriate.
>   */
>  struct shrinker {
> -	int (*shrink)(int nr_to_scan, gfp_t gfp_mask);
> +	int (*shrink)(void *ctx, int nr_to_scan, gfp_t gfp_mask);
> +	void *ctx;	/* user callback context */
>  	int seeks;	/* seeks to recreate an obj */
>  
>  	/* These are for internal use */
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 5321ac4..40f27d2 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -215,8 +215,9 @@ unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
>  	list_for_each_entry(shrinker, &shrinker_list, list) {
>  		unsigned long long delta;
>  		unsigned long total_scan;
> -		unsigned long max_pass = (*shrinker->shrink)(0, gfp_mask);
> +		unsigned long max_pass;
>  
> +		max_pass = (*shrinker->shrink)(shrinker->ctx, 0, gfp_mask);
>  		delta = (4 * scanned) / shrinker->seeks;
>  		delta *= max_pass;
>  		do_div(delta, lru_pages + 1);
> @@ -244,8 +245,10 @@ unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
>  			int shrink_ret;
>  			int nr_before;
>  
> -			nr_before = (*shrinker->shrink)(0, gfp_mask);
> -			shrink_ret = (*shrinker->shrink)(this_scan, gfp_mask);
> +			nr_before = (*shrinker->shrink)(shrinker->ctx,
> +							0, gfp_mask);
> +			shrink_ret = (*shrinker->shrink)(shrinker->ctx,
> +							this_scan, gfp_mask);
>  			if (shrink_ret == -1)
>  				break;
>  			if (shrink_ret < nr_before)

Looks good about this mm part.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


off-topic: shrink_slab() was introduced for page/[id]-cache scan balancing
at first. now it still have hardcorded shrinker->nr calculation for slab
although now lots another subsystem using it. shrinker->seeks seems no
intuitive knob. probably we should try generalization it in future. but
it is another story. I think this patch provide good first step.

                delta = (4 * scanned) / shrinker->seeks;
                delta *= max_pass;
                do_div(delta, lru_pages + 1);
                shrinker->nr += delta;


Thanks.



