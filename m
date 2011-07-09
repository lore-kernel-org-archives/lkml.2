Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab1GIX3t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 19:29:49 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:10086 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab1GIX3p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 19:29:45 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Julia Lawall <julia@diku.dk>, Hank Janssen <hjanssen@microsoft.com>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] drivers/staging/hv/blkvsc_drv.c: eliminate NULL pointer
 dereference
Thread-Topic: [PATCH] drivers/staging/hv/blkvsc_drv.c: eliminate NULL
 pointer dereference
Thread-Index: AQHMPm2x/QklnUfIME68w5HFNjPP7JTkoeVQ
Date: Sat, 9 Jul 2011 23:29:43 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0480817866A@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1310239406-9592-1-git-send-email-julia@diku.dk>
In-Reply-To: <1310239406-9592-1-git-send-email-julia@diku.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.35]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Julia Lawall [mailto:julia@diku.dk]
> Sent: Saturday, July 09, 2011 3:23 PM
> To: Hank Janssen
> Cc: kernel-janitors@vger.kernel.org; Haiyang Zhang; Greg Kroah-Hartman; KY
> Srinivasan; Abhishek Kane (Mindtree Consulting PVT LTD);
> devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] drivers/staging/hv/blkvsc_drv.c: eliminate NULL pointer
> dereference
> 
> From: Julia Lawall <julia@diku.dk>
> 
> In this code, blkvsc_req is allocated in the cache blkdev->request_pool,
> but freed in the first case to the cache blkvsc_req->dev->request_pool.
> blkvsc_req->dev is subsequently initialized to blkdev, making these the
> same at the second call to kmem_cache_free.  But at the point of the first
> call, blkvsc_req->dev is NULL.  The second call is changed too, for
> uniformity.
> 
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression x,e,e1,e2,e3;
> @@
> 
> x = \(kmem_cache_alloc\|kmem_cache_zalloc\)(e1,e2)
> ... when != x = e
> (
> kmem_cache_free(e1,x);
> |
> ?-kmem_cache_free(e3,x);
> +kmem_cache_free(e1,x);
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/staging/hv/blkvsc_drv.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff -u -p a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
> --- a/drivers/staging/hv/blkvsc_drv.c
> +++ b/drivers/staging/hv/blkvsc_drv.c
> @@ -325,7 +325,7 @@ static int blkvsc_do_operation(struct bl
> 
>  	page_buf = alloc_page(GFP_KERNEL);
>  	if (!page_buf) {
> -		kmem_cache_free(blkvsc_req->dev->request_pool,
> blkvsc_req);
> +		kmem_cache_free(blkdev->request_pool, blkvsc_req);
>  		return -ENOMEM;
>  	}
> 
> @@ -422,7 +422,7 @@ cleanup:
> 
>  	__free_page(page_buf);
> 
> -	kmem_cache_free(blkvsc_req->dev->request_pool, blkvsc_req);
> +	kmem_cache_free(blkdev->request_pool, blkvsc_req);
> 
>  	return ret;
>  }
> 
Thank you for catching this. As you know, this driver is going away. Some weeks ago,
I had submitted patches to handle the IDE devices (the ones currently handled by this 
driver) with the stor driver. Greg, I am in the process of re-spinning all the patches I had
sent in June, based on your comments last week. If you are going to be applying this patch,
please let me know, I can locally apply this and correctly re-base my patches. 

Regards,

K. Y
