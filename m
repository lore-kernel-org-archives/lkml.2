Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab2DDQDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 12:03:46 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:48534 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620Ab2DDQDp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 12:03:45 -0400
MIME-Version: 1.0
Message-ID: <d858d87f-6e07-4303-a9b3-e41ff93c8080@default>
Date: Wed, 4 Apr 2012 09:03:22 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: RE: [PATCH] staging: zsmalloc: fix memory leak
References: <<1333376036-9841-1-git-send-email-sjenning@linux.vnet.ibm.com>>
In-Reply-To: <<1333376036-9841-1-git-send-email-sjenning@linux.vnet.ibm.com>>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4F7C70D2.00B4,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Sent: Monday, April 02, 2012 8:14 AM
> To: Greg Kroah-Hartman
> Cc: Nitin Gupta; Dan Magenheimer; Konrad Rzeszutek Wilk; Robert Jennings; Seth Jennings;
> devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org; linux-mm@kvack.org
> Subject: [PATCH] staging: zsmalloc: fix memory leak
> 
> From: Nitin Gupta <ngupta@vflare.org>
> 
> This patch fixes a memory leak in zsmalloc where the first
> subpage of each zspage is leaked when the zspage is freed.
> 
> Based on 3.4-rc1.
> 
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

This is a rather severe memory leak and will affect most
benchmarking anyone does to evaluate zcache in 3.4 (e.g. as
to whether zcache is suitable for promotion), so t'would be nice
to get this patch in for -rc2.  (Note it fixes a "regression"
since it affects zcache only in 3.4+ because the fix is to
the new zsmalloc allocator... so no change to stable trees.)

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>

> ---
>  drivers/staging/zsmalloc/zsmalloc-main.c |   30 ++++++++++++++++++------------
>  1 files changed, 18 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
> index 09caa4f..917461c 100644
> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
> @@ -267,33 +267,39 @@ static unsigned long obj_idx_to_offset(struct page *page,
>  	return off + obj_idx * class_size;
>  }
> 
> +static void reset_page(struct page *page)
> +{
> +	clear_bit(PG_private, &page->flags);
> +	clear_bit(PG_private_2, &page->flags);
> +	set_page_private(page, 0);
> +	page->mapping = NULL;
> +	page->freelist = NULL;
> +	reset_page_mapcount(page);
> +}
> +
>  static void free_zspage(struct page *first_page)
>  {
> -	struct page *nextp, *tmp;
> +	struct page *nextp, *tmp, *head_extra;
> 
>  	BUG_ON(!is_first_page(first_page));
>  	BUG_ON(first_page->inuse);
> 
> -	nextp = (struct page *)page_private(first_page);
> +	head_extra = (struct page *)page_private(first_page);
> 
> -	clear_bit(PG_private, &first_page->flags);
> -	clear_bit(PG_private_2, &first_page->flags);
> -	set_page_private(first_page, 0);
> -	first_page->mapping = NULL;
> -	first_page->freelist = NULL;
> -	reset_page_mapcount(first_page);
> +	reset_page(first_page);
>  	__free_page(first_page);
> 
>  	/* zspage with only 1 system page */
> -	if (!nextp)
> +	if (!head_extra)
>  		return;
> 
> -	list_for_each_entry_safe(nextp, tmp, &nextp->lru, lru) {
> +	list_for_each_entry_safe(nextp, tmp, &head_extra->lru, lru) {
>  		list_del(&nextp->lru);
> -		clear_bit(PG_private_2, &nextp->flags);
> -		nextp->index = 0;
> +		reset_page(nextp);
>  		__free_page(nextp);
>  	}
> +	reset_page(head_extra);
> +	__free_page(head_extra);
>  }
> 
>  /* Initialize a newly allocated zspage */
> --
> 1.7.5.4
