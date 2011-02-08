Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab1BHX6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 18:58:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755828Ab1BHX6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 18:58:03 -0500
Date: Tue, 8 Feb 2011 15:57:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, npiggin@kernel.dk, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
        cl@linux.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 3/3][RESEND] Provide control over unmapped pages (v4)
Message-Id: <20110208155756.e149c3b6.akpm@linux-foundation.org>
In-Reply-To: <20110201165533.12377.11775.stgit@localhost6.localdomain6>
References: <20110201165329.12377.13683.stgit@localhost6.localdomain6>
	<20110201165533.12377.11775.stgit@localhost6.localdomain6>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Feb 2011 22:25:45 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Changelog v4
> 1. Add max_unmapped_ratio and use that as the upper limit
> to check when to shrink the unmapped page cache (Christoph
> Lameter)
> 
> Changelog v2
> 1. Use a config option to enable the code (Andrew Morton)
> 2. Explain the magic tunables in the code or at-least attempt
>    to explain them (General comment)
> 3. Hint uses of the boot parameter with unlikely (Andrew Morton)
> 4. Use better names (balanced is not a good naming convention)
> 
> Provide control using zone_reclaim() and a boot parameter. The
> code reuses functionality from zone_reclaim() to isolate unmapped
> pages and reclaim them as a priority, ahead of other mapped pages.
> A new sysctl for max_unmapped_ratio is provided and set to 16,
> indicating 16% of the total zone pages are unmapped, we start
> shrinking unmapped page cache.

We'll need some documentation for sysctl_max_unmapped_ratio, please. 
In Documentation/sysctl/vm.txt, I suppose.

It will be interesting to find out what this ratio refers to.  it
apears to be a percentage.  We've had problem in the past where 1% was
way too much and we had to change the kernel to provide much
finer-grained control.

>
> ...
>
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -306,7 +306,10 @@ struct zone {
>  	/*
>  	 * zone reclaim becomes active if more unmapped pages exist.
>  	 */
> +#if defined(CONFIG_UNMAPPED_PAGE_CONTROL) || defined(CONFIG_NUMA)
>  	unsigned long		min_unmapped_pages;
> +	unsigned long		max_unmapped_pages;
> +#endif

This change breaks the connection between min_unmapped_pages and its
documentation, and fails to document max_unmapped_pages.

Also, afacit if CONFIG_NUMA=y and CONFIG_UNMAPPED_PAGE_CONTROL=n,
max_unmapped_pages will be present in the kernel image and will appear
in /proc but it won't actually do anything.  Seems screwed up and
misleading.

>
> ...
>
> +#if defined(CONFIG_UNMAPPED_PAGECACHE_CONTROL)
> +/*
> + * Routine to reclaim unmapped pages, inspired from the code under
> + * CONFIG_NUMA that does unmapped page and slab page control by keeping
> + * min_unmapped_pages in the zone. We currently reclaim just unmapped
> + * pages, slab control will come in soon, at which point this routine
> + * should be called reclaim cached pages
> + */
> +unsigned long reclaim_unmapped_pages(int priority, struct zone *zone,
> +						struct scan_control *sc)
> +{
> +	if (unlikely(unmapped_page_control) &&
> +		(zone_unmapped_file_pages(zone) > zone->min_unmapped_pages)) {
> +		struct scan_control nsc;
> +		unsigned long nr_pages;
> +
> +		nsc = *sc;
> +
> +		nsc.swappiness = 0;
> +		nsc.may_writepage = 0;
> +		nsc.may_unmap = 0;
> +		nsc.nr_reclaimed = 0;
> +
> +		nr_pages = zone_unmapped_file_pages(zone) -
> +				zone->min_unmapped_pages;
> +		/*
> +		 * We don't want to be too aggressive with our
> +		 * reclaim, it is our best effort to control
> +		 * unmapped pages
> +		 */
> +		nr_pages >>= 3;
> +
> +		zone_reclaim_pages(zone, &nsc, nr_pages);
> +		return nsc.nr_reclaimed;
> +	}
> +	return 0;
> +}

This returns an undocumented ulong which is never used by callers.


