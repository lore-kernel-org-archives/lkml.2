Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab2HXPEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 11:04:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481Ab2HXPEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 11:04:32 -0400
Message-ID: <503797F0.1050805@redhat.com>
Date: Fri, 24 Aug 2012 11:04:16 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: [RFC] mm: support MIGRATE_DISCARD
References: <1345782330-23234-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1345782330-23234-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2012 12:25 AM, Minchan Kim wrote:
> This patch introudes MIGRATE_DISCARD mode in migration.
> It drops *unmapped clean cache pages* instead of migration so that

Am I confused, or does the code not match the changelog?

It looks like it is still trying to discard mapped page cache pages:

> +	file = page_is_file_cache(page);
> +	ttu_flags = TTU_IGNORE_ACCESS;
> +retry:
> +	if (!(mode & MIGRATE_DISCARD) || !file || PageDirty(page))
> +		ttu_flags |= (TTU_MIGRATION | TTU_IGNORE_MLOCK);
> +	else
> +		discard_mode = true;
> +
>   	/* Establish migration ptes or remove ptes */
> -	try_to_unmap(page, TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
> +	rc = try_to_unmap(page, ttu_flags);
>
>   skip_unmap:
> -	if (!page_mapped(page))
> -		rc = move_to_new_page(newpage, page, remap_swapcache, mode);
> +	if (rc == SWAP_SUCCESS) {
> +		if (!discard_mode)
> +			rc = move_to_new_page(newpage, page,
> +					remap_swapcache, mode);
> +		else {
> +
> +			rc = discard_page(page);
> +			goto uncharge;
> +		}



-- 
All rights reversed
