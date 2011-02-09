Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab1BIPzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 10:55:04 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:49903 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab1BIPzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 10:55:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FbuVzC01ZbiaDzvZH5mHB32OmPkYRRSJGWMYvmB8zhU6ErvgwFRqsLL1RSOUAcEQ7A
         09XayCV23S56IOvliMYDz9B27Rz7QeowI7Rie7jpHFdXH3XZ2u8HMMKUQFKlgeb6ecQR
         kT5pJ7m26mcZKqudX8oo/5KTXvPEWixavYnZ4=
Message-ID: <4D52B8D1.6080706@gmail.com>
Date: Wed, 09 Feb 2011 07:54:57 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110204 Thunderbird/3.1.8
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] vmscan: fix zone shrinking exit when scan work is done
References: <20110209154606.GJ27110@cmpxchg.org>
In-Reply-To: <20110209154606.GJ27110@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2011 07:46 AM, Johannes Weiner wrote:
> Hi,
>
> I think this should fix the problem of processes getting stuck in
> reclaim that has been reported several times.  Kent actually
> single-stepped through this code and noted that it was never exiting
> shrink_zone(), which really narrowed it down a lot, considering the
> tons of nested loops from the allocator down to the list shrinking.
>
> 	Hannes

I was able to trigger this in just a few minutes stress testing bcache, 
and now it's been going for half an hour working beautifully. Thanks!

>
> ---
> From: Johannes Weiner<hannes@cmpxchg.org>
> Subject: vmscan: fix zone shrinking exit when scan work is done
>
> '3e7d344 mm: vmscan: reclaim order-0 and use compaction instead of
> lumpy reclaim' introduced an indefinite loop in shrink_zone().
>
> It meant to break out of this loop when no pages had been reclaimed
> and not a single page was even scanned.  The way it would detect the
> latter is by taking a snapshot of sc->nr_scanned at the beginning of
> the function and comparing it against the new sc->nr_scanned after the
> scan loop.  But it would re-iterate without updating that snapshot,
> looping forever if sc->nr_scanned changed at least once since
> shrink_zone() was invoked.
>
> This is not the sole condition that would exit that loop, but it
> requires other processes to change the zone state, as the reclaimer
> that is stuck obviously can not anymore.
>
> This is only happening for higher-order allocations, where reclaim is
> run back to back with compaction.
>
> Reported-by: Michal Hocko<mhocko@suse.cz>
> Reported-by: Kent Overstreet<kent.overstreet@gmail.com>
> Signed-off-by: Johannes Weiner<hannes@cmpxchg.org>

Tested-by: Kent Overstreet<kent.overstreet@gmail.com>

> ---
>   mm/vmscan.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 148c6e6..17497d0 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1882,12 +1882,12 @@ static void shrink_zone(int priority, struct zone *zone,
>   	unsigned long nr[NR_LRU_LISTS];
>   	unsigned long nr_to_scan;
>   	enum lru_list l;
> -	unsigned long nr_reclaimed;
> +	unsigned long nr_reclaimed, nr_scanned;
>   	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
> -	unsigned long nr_scanned = sc->nr_scanned;
>
>   restart:
>   	nr_reclaimed = 0;
> +	nr_scanned = sc->nr_scanned;
>   	get_scan_count(zone, sc, nr, priority);
>
>   	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||

