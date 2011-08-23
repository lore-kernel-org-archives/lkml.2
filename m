Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab1HWG5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 02:57:07 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:49019 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab1HWG5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 02:57:06 -0400
Message-ID: <4E534F33.5070609@openvz.org>
Date: Tue, 23 Aug 2011 10:56:51 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110702 Iceape/2.0.14
MIME-Version: 1.0
To: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] vmscan: use atomic-long for shrinker batching
References: <20110822101721.19462.63082.stgit@zurg> <20110822101727.19462.55289.stgit@zurg>
In-Reply-To: <20110822101727.19462.55289.stgit@zurg>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Khlebnikov wrote:
>   		delta = (4 * nr_pages_scanned) / shrinker->seeks;
> @@ -329,12 +327,11 @@ unsigned long shrink_slab(struct shrink_control *shrink,
>   		 * manner that handles concurrent updates. If we exhausted the
>   		 * scan, there is no need to do an update.
>   		 */
> -		do {
> -			nr = shrinker->nr;
> -			new_nr = total_scan + nr;
> -			if (total_scan<= 0)
> -				break;
> -		} while (cmpxchg(&shrinker->nr, nr, new_nr) != nr);
> +		if (total_scan>  0)
> +			new_nr = atomic_long_add_return(total_scan,
> +					&shrinker->nr_in_batch);
> +		else
> +			new_nr = atomic_long_read(&shrinker->nr_in_batch);
>
>   		trace_mm_shrink_slab_end(shrinker, shrink_ret, nr, new_nr);

BTW, new_nr required only for tracing, maybe this will be better/faster,
because atomic accuracy there isn't required at all.

	if (total_scan > 0)
		atomic_long_add(total_scan, &shrinker->nr_in_batch);

	new_nr = atomic_long_read(&shrinker->nr_in_batch);
	trace_mm_shrink_slab_end(shrinker, shrink_ret, nr, new_nr);
