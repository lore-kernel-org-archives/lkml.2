Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab0HaXhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 19:37:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39952 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab0HaXho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 19:37:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 2/3] mm: page allocator: Calculate a better estimate of NR_FREE_PAGES when memory is low and kswapd is awake
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1283276257-1793-3-git-send-email-mel@csn.ul.ie>
References: <1283276257-1793-1-git-send-email-mel@csn.ul.ie> <1283276257-1793-3-git-send-email-mel@csn.ul.ie>
Message-Id: <20100901083425.971F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  1 Sep 2010 08:37:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#ifdef CONFIG_SMP
> +/* Called when a more accurate view of NR_FREE_PAGES is needed */
> +unsigned long zone_nr_free_pages(struct zone *zone)
> +{
> +	unsigned long nr_free_pages = zone_page_state(zone, NR_FREE_PAGES);
> +
> +	/*
> +	 * While kswapd is awake, it is considered the zone is under some
> +	 * memory pressure. Under pressure, there is a risk that
> +	 * per-cpu-counter-drift will allow the min watermark to be breached
> +	 * potentially causing a live-lock. While kswapd is awake and
> +	 * free pages are low, get a better estimate for free pages
> +	 */
> +	if (nr_free_pages < zone->percpu_drift_mark &&
> +			!waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
> +		int cpu;
> +
> +		for_each_online_cpu(cpu) {
> +			struct per_cpu_pageset *pset;
> +
> +			pset = per_cpu_ptr(zone->pageset, cpu);
> +			nr_free_pages += pset->vm_stat_diff[NR_FREE_PAGES];

If my understanding is correct, we have no lock when reading pset->vm_stat_diff.
It mean nr_free_pages can reach negative value at very rarely race. boundary
check is necessary?




