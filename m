Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab1DZGiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 02:38:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33156 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab1DZGiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 02:38:19 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [PATCH 1/2] virtio_balloon: disable oom killer when fill balloon
Cc: kosaki.motohiro@jp.fujitsu.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110426052916.GA11933@darkstar>
References: <20110426052916.GA11933@darkstar>
Message-Id: <20110426154037.F38B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 26 Apr 2011 15:38:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When memory pressure is high, virtio ballooning will probably cause oom killing.
> Even if alloc_page with GFP_NORETRY itself does not directly trigger oom it
> will make memory becoming low then memory alloc of other processes will trigger
> oom killing. It is not desired behaviour.
> 
> Here disable oom killer in fill_balloon to address this issue.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> ---
>  drivers/virtio/virtio_balloon.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- linux-2.6.orig/drivers/virtio/virtio_balloon.c	2010-10-13 10:14:38.000000000 +0800
> +++ linux-2.6/drivers/virtio/virtio_balloon.c	2011-04-26 11:38:43.979785141 +0800
> @@ -25,6 +25,7 @@
>  #include <linux/freezer.h>
>  #include <linux/delay.h>
>  #include <linux/slab.h>
> +#include <linux/oom.h>
>  
>  struct virtio_balloon
>  {
> @@ -102,6 +103,7 @@ static void fill_balloon(struct virtio_b
>  	/* We can only do one array worth at a time. */
>  	num = min(num, ARRAY_SIZE(vb->pfns));
>  
> +	oom_killer_disable();

I think this patch need proper comment at least. My first impression
is, "Hm, __GFP_NORETRY should prevent oom, why is this necessary?".
So, this actually prevent _another_ thread call out_of_memory().
Also, Here doesn't have any exclusion against hibernation (ie another
oom_killer_disable() callsite). It should be described why lock is 
unnecessary.

Thanks.


>  	for (vb->num_pfns = 0; vb->num_pfns < num; vb->num_pfns++) {
>  		struct page *page = alloc_page(GFP_HIGHUSER | __GFP_NORETRY |
>  					__GFP_NOMEMALLOC | __GFP_NOWARN);
> @@ -119,6 +121,7 @@ static void fill_balloon(struct virtio_b
>  		vb->num_pages++;
>  		list_add(&page->lru, &vb->pages);
>  	}
> +	oom_killer_enable();
>  
>  	/* Didn't get any?  Oh well. */
>  	if (vb->num_pfns == 0)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



