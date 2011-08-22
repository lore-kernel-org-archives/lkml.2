Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab1HVVaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 17:30:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753744Ab1HVVaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 17:30:16 -0400
Date: Mon, 22 Aug 2011 14:30:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] vmscan: fix initial shrinker size handling
Message-Id: <20110822143006.60f4b560.akpm@linux-foundation.org>
In-Reply-To: <20110822101721.19462.63082.stgit@zurg>
References: <20110822101721.19462.63082.stgit@zurg>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Aug 2011 14:17:21 +0300
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> Shrinker function can returns -1, it means it cannot do anything without a risk of deadlock.
> For example prune_super() do this if it cannot grab superblock refrence, even if nr_to_scan=0.
> Currenly we interpret this like ULONG_MAX size shrinker, evaluate total_scan according this,
> and next time this shrinker can get really big pressure. Let's skip such shrinkers instead.

Yes, that looks like a significant oversight.

> Also make total_scan signed, otherwise check (total_scan < 0) below never works.

Hopefully a smaller oversight.

> ---
>  mm/vmscan.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 29b3612..f174561 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -248,14 +248,18 @@ unsigned long shrink_slab(struct shrink_control *shrink,
>  
>  	list_for_each_entry(shrinker, &shrinker_list, list) {
>  		unsigned long long delta;
> -		unsigned long total_scan;
> -		unsigned long max_pass;
> +		long total_scan;
> +		long max_pass;
>  		int shrink_ret = 0;
>  		long nr;
>  		long new_nr;
>  		long batch_size = shrinker->batch ? shrinker->batch
>  						  : SHRINK_BATCH;
>  
> +		max_pass = do_shrinker_shrink(shrinker, shrink, 0);
> +		if (max_pass <= 0)
> +			continue;
> +
>  		/*
>  		 * copy the current shrinker scan count into a local variable
>  		 * and zero it so that other concurrent shrinker invocations
> @@ -266,7 +270,6 @@ unsigned long shrink_slab(struct shrink_control *shrink,
>  		} while (cmpxchg(&shrinker->nr, nr, 0) != nr);
>  
>  		total_scan = nr;
> -		max_pass = do_shrinker_shrink(shrinker, shrink, 0);
>  		delta = (4 * nr_pages_scanned) / shrinker->seeks;
>  		delta *= max_pass;
>  		do_div(delta, lru_pages + 1);

Why was the shrinker call moved to before the alteration of shrinker->nr?
