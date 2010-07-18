Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab0GRIoh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 04:44:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49728 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab0GRIof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 04:44:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Xc+bSOYYxMuWSmYvrUoHNTK8sdCsSddJpJYKBPcm1l3VqKrYX+80+x74x5xN8o8WDL
         GnkYk7yDuSkN+f0ogGSXg7g1fhn2af1Y2Q7q8zEkr4HLXDJLIOuvqDER7FW19r5PWdJB
         +lrQCYuQNKWZsaR6jSOb5Ct651zynSaC9EjTQ=
Subject: Re: [PATCH 2/8] Basic zcache functionality
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1279283870-18549-3-git-send-email-ngupta@vflare.org>
References: <1279283870-18549-1-git-send-email-ngupta@vflare.org>
	 <1279283870-18549-3-git-send-email-ngupta@vflare.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 18 Jul 2010 10:44:31 +0200
Message-ID: <1279442671.2476.34.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 16 juillet 2010 à 18:07 +0530, Nitin Gupta a écrit :

> This particular patch implemets basic functionality only:
> +static u64 zcache_get_stat(struct zcache_pool *zpool,
> +		enum zcache_pool_stats_index idx)
> +{
> +	int cpu;
> +	s64 val = 0;
> +
> +	for_each_possible_cpu(cpu) {
> +		unsigned int start;
> +		struct zcache_pool_stats_cpu *stats;
> +
> +		stats = per_cpu_ptr(zpool->stats, cpu);
> +		do {
> +			start = u64_stats_fetch_begin(&stats->syncp);
> +			val += stats->count[idx];
> +		} while (u64_stats_fetch_retry(&stats->syncp, start));
> +	}
> +
> +	BUG_ON(val < 0);
> +	return val;
> +}

Sorry this is wrong.

Inside the fetch/retry block you should not do the addition to val, only
a read of value to a temporary variable, since this might be done
several times.

You want something like :

static u64 zcache_get_stat(struct zcache_pool *zpool,
			   enum zcache_pool_stats_index idx)
{
	int cpu;
	s64 temp, val = 0;

	for_each_possible_cpu(cpu) {
		unsigned int start;
		struct zcache_pool_stats_cpu *stats;

		stats = per_cpu_ptr(zpool->stats, cpu);
		do {
			start = u64_stats_fetch_begin(&stats->syncp);
			temp = stats->count[idx];
		} while (u64_stats_fetch_retry(&stats->syncp, start));
		val += temp;
	}

...
}



