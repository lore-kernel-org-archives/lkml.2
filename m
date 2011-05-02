Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028Ab1EBO5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 10:57:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757909Ab1EBO5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 10:57:42 -0400
Message-ID: <4DBEC65B.4010201@redhat.com>
Date: Mon, 02 May 2011 10:57:31 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 2/2] Filter unevictable page out in deactivate_page
References: <cover.1304261567.git.minchan.kim@gmail.com> <dc54a5771cf1f580a91d16816100d4a2bcf2cdf5.1304261567.git.minchan.kim@gmail.com>
In-Reply-To: <dc54a5771cf1f580a91d16816100d4a2bcf2cdf5.1304261567.git.minchan.kim@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2011 11:03 AM, Minchan Kim wrote:
> It's pointless that deactive_page's pagevec operation about
> unevictable page as it's nop.
> This patch removes unnecessary overhead which might be a bit problem
> in case that there are many unevictable page in system(ex, mprotect workload)
>
> Signed-off-by: Minchan Kim<minchan.kim@gmail.com>
> ---
>   mm/swap.c |    9 +++++++++
>   1 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/mm/swap.c b/mm/swap.c
> index 2e9656d..b707694 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -511,6 +511,15 @@ static void drain_cpu_pagevecs(int cpu)
>    */
>   void deactivate_page(struct page *page)
>   {
> +
> +	/*
> +	 * In workload which system has many unevictable page(ex, mprotect),
> +	 * unevictalge page deactivation for accelerating reclaim

Typo.

> +	 * is pointless.
> +	 */
> +	if (PageUnevictable(page))
> +		return;
> +
>   	if (likely(get_page_unless_zero(page))) {
>   		struct pagevec *pvec =&get_cpu_var(lru_deactivate_pvecs);
>


-- 
All rights reversed
