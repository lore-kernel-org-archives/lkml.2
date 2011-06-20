Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab1FTAq7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 20:46:59 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44381 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab1FTAq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 20:46:58 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DFE987E.1070900@jp.fujitsu.com>
Date: Mon, 20 Jun 2011 09:46:54 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: david@fromorbit.com
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, xfs@oss.sgi.com
Subject: Re: [PATCH 02/12] vmscan: shrinker->nr updates race and go wrong
References: <1306998067-27659-1-git-send-email-david@fromorbit.com> <1306998067-27659-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1306998067-27659-3-git-send-email-david@fromorbit.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 48e3fbd..dce2767 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -251,17 +251,29 @@ unsigned long shrink_slab(struct shrink_control *shrink,
>  		unsigned long total_scan;
>  		unsigned long max_pass;
>  		int shrink_ret = 0;
> +		long nr;
> +		long new_nr;
>  
> +		/*
> +		 * copy the current shrinker scan count into a local variable
> +		 * and zero it so that other concurrent shrinker invocations
> +		 * don't also do this scanning work.
> +		 */
> +		do {
> +			nr = shrinker->nr;
> +		} while (cmpxchg(&shrinker->nr, nr, 0) != nr);
> +
> +		total_scan = nr;
>  		max_pass = do_shrinker_shrink(shrinker, shrink, 0);
>  		delta = (4 * nr_pages_scanned) / shrinker->seeks;
>  		delta *= max_pass;
>  		do_div(delta, lru_pages + 1);
> -		shrinker->nr += delta;
> -		if (shrinker->nr < 0) {
> +		total_scan += delta;
> +		if (total_scan < 0) {
>  			printk(KERN_ERR "shrink_slab: %pF negative objects to "
>  			       "delete nr=%ld\n",
> -			       shrinker->shrink, shrinker->nr);
> -			shrinker->nr = max_pass;
> +			       shrinker->shrink, total_scan);
> +			total_scan = max_pass;
>  		}
>  
>  		/*
> @@ -269,13 +281,11 @@ unsigned long shrink_slab(struct shrink_control *shrink,
>  		 * never try to free more than twice the estimate number of
>  		 * freeable entries.
>  		 */
> -		if (shrinker->nr > max_pass * 2)
> -			shrinker->nr = max_pass * 2;
> +		if (total_scan > max_pass * 2)
> +			total_scan = max_pass * 2;
>  
> -		total_scan = shrinker->nr;
> -		shrinker->nr = 0;
>  
> -		trace_mm_shrink_slab_start(shrinker, shrink, nr_pages_scanned,
> +		trace_mm_shrink_slab_start(shrinker, shrink, nr, nr_pages_scanned,
>  					lru_pages, max_pass, delta, total_scan);
>  
>  		while (total_scan >= SHRINK_BATCH) {
> @@ -295,8 +305,19 @@ unsigned long shrink_slab(struct shrink_control *shrink,
>  			cond_resched();
>  		}
>  
> -		shrinker->nr += total_scan;
> -		trace_mm_shrink_slab_end(shrinker, shrink_ret, total_scan);
> +		/*
> +		 * move the unused scan count back into the shrinker in a
> +		 * manner that handles concurrent updates. If we exhausted the
> +		 * scan, there is no need to do an update.
> +		 */
> +		do {
> +			nr = shrinker->nr;
> +			new_nr = total_scan + nr;
> +			if (total_scan <= 0)
> +				break;
> +		} while (cmpxchg(&shrinker->nr, nr, new_nr) != nr);
> +
> +		trace_mm_shrink_slab_end(shrinker, shrink_ret, nr, new_nr);
>  	}
>  	up_read(&shrinker_rwsem);
>  out:

Looks great fix. Please remove tracepoint change from this patch and send it
to -stable. iow, I expect I'll ack your next spin.

thanks.


