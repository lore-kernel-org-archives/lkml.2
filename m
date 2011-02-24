Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab1BXRIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 12:08:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755364Ab1BXRIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 12:08:40 -0500
Message-ID: <4D669089.6080007@redhat.com>
Date: Thu, 24 Feb 2011 12:08:25 -0500
From: Satoru Moriya <smoriya@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: linux-mm@kvack.org, akpm@linux-foundation.org, npiggin@kernel.dk,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, cl@linux.com,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 3/3][RESEND] Provide control over unmapped pages (v4)
References: <20110201165329.12377.13683.stgit@localhost6.localdomain6> <20110201165533.12377.11775.stgit@localhost6.localdomain6>
In-Reply-To: <20110201165533.12377.11775.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2011 11:55 AM, Balbir Singh wrote:
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 7b56473..2ac8549 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1660,6 +1660,9 @@ zonelist_scan:
>  			unsigned long mark;
>  			int ret;
>  
> +			if (should_reclaim_unmapped_pages(zone))
> +				wakeup_kswapd(zone, order, classzone_idx);
> +
>  			mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
>  			if (zone_watermark_ok(zone, order, mark,
>  				    classzone_idx, alloc_flags))

<snip>

> +int sysctl_max_unmapped_ratio_sysctl_handler(ctl_table *table, int write,
> +	void __user *buffer, size_t *length, loff_t *ppos)
> +{
> +	struct zone *zone;
> +	int rc;
> +
> +	rc = proc_dointvec_minmax(table, write, buffer, length, ppos);
> +	if (rc)
> +		return rc;
> +
> +	for_each_zone(zone)
> +		zone->max_unmapped_pages = (zone->present_pages *
> +				sysctl_max_unmapped_ratio) / 100;
> +	return 0;
> +}
> +#endif
> +

<snip>

> +
> +bool should_reclaim_unmapped_pages(struct zone *zone)
> +{
> +	if (unlikely(unmapped_page_control) &&
> +		(zone_unmapped_file_pages(zone) > zone->max_unmapped_pages))
> +		return true;
> +	return false;
> +}
> +#endif

Why don't you limit the amount of unmapped pages for the whole system?
Current implementation, which limit unmapped pages per zone, may cause unnecessary
reclaiming. Because if memory access is not balanced among zones(or nodes),
the kernel may reclaim unmapped pages even though other zones/nodes have enough
spaces for them.

Anyway, I'm interested in this patchset. Because my customers in enterprise area
want this kind of feature for a long time to avoid direct reclaim completely 
in a certain situation.

Regards,
Satoru
