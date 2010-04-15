Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab0DODb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 23:31:57 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38506 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231Ab0DODbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 23:31:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: 32GB SSD on USB1.1 P3/700 == ___HELL___ (2.6.34-rc3)
Cc: kosaki.motohiro@jp.fujitsu.com, Andreas Mohr <andi@lisas.de>,
       Jens Axboe <axboe@kernel.dk>, Minchan Kim <minchan.kim@gmail.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <20100407070842.GA18215@localhost>
References: <20100407070050.GA10527@localhost> <20100407070842.GA18215@localhost>
Message-Id: <20100415122928.D168.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 15 Apr 2010 12:31:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Many applications (this one and below) are stuck in
> > wait_on_page_writeback(). I guess this is why "heavy write to
> > irrelevant partition stalls the whole system".  They are stuck on page
> > allocation. Your 512MB system memory is a bit tight, so reclaim
> > pressure is a bit high, which triggers the wait-on-writeback logic.
> 
> I wonder if this hacking patch may help.
> 
> When creating 300MB dirty file with dd, it is creating continuous
> region of hard-to-reclaim pages in the LRU list. priority can easily
> go low when irrelevant applications' direct reclaim run into these
> regions..

Sorry I'm confused not. can you please tell us more detail explanation?
Why did lumpy reclaim cause OOM? lumpy reclaim might cause
direct reclaim slow down. but IIUC it's not cause OOM because OOM is
only occur when priority-0 reclaim failure. IO get stcking also prevent
priority reach to 0.



> 
> Thanks,
> Fengguang
> ---
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index e0e5f15..f7179cf 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1149,7 +1149,7 @@ static unsigned long shrink_inactive_list(unsigned long max_scan,
>  	 */
>  	if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
>  		lumpy_reclaim = 1;
> -	else if (sc->order && priority < DEF_PRIORITY - 2)
> +	else if (sc->order && priority < DEF_PRIORITY / 2)
>  		lumpy_reclaim = 1;
>  
>  	pagevec_init(&pvec, 1);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



