Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab0ICOKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 10:10:13 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:45149 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756573Ab0ICOKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 10:10:07 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: oWs8keEVM1n5DIthkBV07mq8omYoDFwYuHXRp8dOWj8dyS2
 LHoFpfu0GYHQvm5GUWuX2lyOdovzuSysSGKrnpty9lngyzJyXywP6RVy7uaR
 n7EsPJOxTq5lFLGGobWWoVoqik5icZZzM93suvg.GwWCzZYL3CO48UnUcZI_
 xdMWCtmh1BjmGLh9_hWm8YhMX2CZCRFo4qUK3OLmjqzwGwMVjFPXQMFUs9mB
 zOU6M.TvjKRSBmNXt5ACG8pVF9gQ8
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 3 Sep 2010 09:10:03 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/10] hugetlb: hugepage migration core
In-Reply-To: <1283488658-23137-5-git-send-email-n-horiguchi@ah.jp.nec.com>
Message-ID: <alpine.DEB.2.00.1009030907080.5633@router.home>
References: <1283488658-23137-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1283488658-23137-5-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Sep 2010, Naoya Horiguchi wrote:

> diff --git v2.6.36-rc2/mm/vmscan.c v2.6.36-rc2/mm/vmscan.c
> index c391c32..69ce2a3 100644
> --- v2.6.36-rc2/mm/vmscan.c
> +++ v2.6.36-rc2/mm/vmscan.c
> @@ -40,6 +40,7 @@
>  #include <linux/memcontrol.h>
>  #include <linux/delayacct.h>
>  #include <linux/sysctl.h>
> +#include <linux/hugetlb.h>
>
>  #include <asm/tlbflush.h>
>  #include <asm/div64.h>
> @@ -508,6 +509,10 @@ void putback_lru_page(struct page *page)
>
>  	VM_BUG_ON(PageLRU(page));
>
> +	if (PageHuge(page)) {
> +		put_page(page);
> +		return;
> +	}
>  redo:
>  	ClearPageUnevictable(page);
>
> @@ -1112,7 +1117,9 @@ int isolate_lru_page(struct page *page)
>  {
>  	int ret = -EBUSY;
>
> -	if (PageLRU(page)) {
> +	if (PageHuge(page) && get_page_unless_zero(compound_head(page)))
> +		ret = 0;
> +	else if (PageLRU(page)) {
>  		struct zone *zone = page_zone(page);
>
>  		spin_lock_irq(&zone->lru_lock);
>

Huge pages are not on the LRU right? So why use the lru functions for
them and then not use the lru? Its a bit stranger. The caller must aware
of the different handling of huge pages since there is no toying around
with the lru. So just have the caller do a put or get page instead.

