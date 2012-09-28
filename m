Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab2I1IrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:47:17 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:59579 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235Ab2I1IrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:47:14 -0400
Message-ID: <50656459.70309@ti.com>
Date: Fri, 28 Sep 2012 11:48:25 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120917 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: CMA broken in next-20120926
References: <20120927112911.GA25959@avionic-0098.mockup.avionic-design.de> <20120927151159.4427fc8f.akpm@linux-foundation.org> <20120928054330.GA27594@bbox> <20120928083722.GM3429@suse.de>
In-Reply-To: <20120928083722.GM3429@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/28/2012 11:37 AM, Mel Gorman wrote:
>> I hope this patch fixes the bug. If this patch fixes the problem
>> but has some problem about description or someone has better idea,
>> feel free to modify and resend to akpm, Please.
>>
> 
> A full revert is overkill. Can the following patch be tested as a
> potential replacement please?
> 
> ---8<---
> mm: compaction: Iron out isolate_freepages_block() and isolate_freepages_range() -fix1
> 
> CMA is reported to be broken in next-20120926. Minchan Kim pointed out
> that this was due to nr_scanned != total_isolated in the case of CMA
> because PageBuddy pages are one scan but many isolations in CMA. This
> patch should address the problem.
> 
> This patch is a fix for
> mm-compaction-acquire-the-zone-lock-as-late-as-possible-fix-2.patch
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

linux-next + this patch alone also works for me.

Tested-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

> ---
>  mm/compaction.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 8250b69..d6e260a 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -282,6 +282,7 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
>  {
>  	int nr_scanned = 0, total_isolated = 0;
>  	struct page *cursor, *valid_page = NULL;
> +	unsigned long nr_strict_required = end_pfn - blockpfn;
>  	unsigned long flags;
>  	bool locked = false;
>  
> @@ -343,10 +344,10 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
>  
>  	/*
>  	 * If strict isolation is requested by CMA then check that all the
> -	 * pages scanned were isolated. If there were any failures, 0 is
> +	 * pages requested were isolated. If there were any failures, 0 is
>  	 * returned and CMA will fail.
>  	 */
> -	if (strict && nr_scanned != total_isolated)
> +	if (strict && nr_strict_required != total_isolated)
>  		total_isolated = 0;
>  
>  	if (locked)
> 


-- 
Péter
