Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259Ab0HJEdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 00:33:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838Ab0HJEdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 00:33:09 -0400
Date: Mon, 9 Aug 2010 21:34:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Minchan Kim <minchan.kim@gmail.com>,
        Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/10] Use percpu stats
Message-Id: <20100809213431.d7699d46.akpm@linux-foundation.org>
In-Reply-To: <1281374816-904-4-git-send-email-ngupta@vflare.org>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>
	<1281374816-904-4-git-send-email-ngupta@vflare.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  9 Aug 2010 22:56:49 +0530 Nitin Gupta <ngupta@vflare.org> wrote:

> +/*
> + * Individual percpu values can go negative but the sum across all CPUs
> + * must always be positive (we store various counts). So, return sum as
> + * unsigned value.
> + */
> +static u64 zram_get_stat(struct zram *zram, enum zram_stats_index idx)
>  {
> -	u64 val;
> -
> -	spin_lock(&zram->stat64_lock);
> -	val = *v;
> -	spin_unlock(&zram->stat64_lock);
> +	int cpu;
> +	s64 val = 0;
> +
> +	for_each_possible_cpu(cpu) {
> +		s64 temp;
> +		unsigned int start;
> +		struct zram_stats_cpu *stats;
> +
> +		stats = per_cpu_ptr(zram->stats, cpu);
> +		do {
> +			start = u64_stats_fetch_begin(&stats->syncp);
> +			temp = stats->count[idx];
> +		} while (u64_stats_fetch_retry(&stats->syncp, start));
> +		val += temp;
> +	}
>  
> +	WARN_ON(val < 0);
>  	return val;
>  }

That reimplements include/linux/percpu_counter.h, poorly.

Please see the June discussion "[PATCH v2 1/2] tmpfs: Quick token
library to allow scalable retrieval of tokens from token jar" for some
discussion.

