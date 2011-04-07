Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab1DGXCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 19:02:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141Ab1DGXCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 19:02:38 -0400
Date: Thu, 7 Apr 2011 16:01:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Julia Lawall <julia@diku.dk>
Cc: Alessandro Zummo <a.zummo@towertech.it>, kernel-janitors@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/rtc/rtc-mrst.c: Use release_mem_region after
 request_mem_region
Message-Id: <20110407160142.0a9d399c.akpm@linux-foundation.org>
In-Reply-To: <1300136425-3311-1-git-send-email-julia@diku.dk>
References: <1300136425-3311-1-git-send-email-julia@diku.dk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011 22:00:25 +0100
Julia Lawall <julia@diku.dk> wrote:

> The memory allocated using request_mem_region should be released using
> release_mem_region, not release_region.
> 
> The semantic patch that fixes part of this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression E1,E2,E3;
> @@
> 
> request_mem_region(E1,E2,E3)
> ...
> ?- release_region(E1,E2)
> + release_mem_region(E1,E2)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/rtc/rtc-mrst.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-mrst.c b/drivers/rtc/rtc-mrst.c
> index b86bc32..558dd7d 100644
> --- a/drivers/rtc/rtc-mrst.c
> +++ b/drivers/rtc/rtc-mrst.c
> @@ -379,7 +379,7 @@ cleanup1:
>  	mrst_rtc.dev = NULL;
>  	rtc_device_unregister(mrst_rtc.rtc);
>  cleanup0:
> -	release_region(iomem->start, iomem->end + 1 - iomem->start);
> +	release_mem_region(iomem->start, iomem->end + 1 - iomem->start);
>  	dev_err(dev, "rtc-mrst: unable to initialise\n");
>  	return retval;
>  }
> @@ -405,7 +405,7 @@ static void __exit rtc_mrst_do_remove(struct device *dev)
>  	mrst->rtc = NULL;
>  
>  	iomem = mrst->iomem;
> -	release_region(iomem->start, iomem->end + 1 - iomem->start);
> +	release_mem_region(iomem->start, iomem->end + 1 - iomem->start);
>  	mrst->iomem = NULL;
>  
>  	mrst->dev = NULL;

We may as well clean this up too.

--- a/drivers/rtc/rtc-mrst.c~drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix
+++ a/drivers/rtc/rtc-mrst.c
@@ -380,7 +380,7 @@ cleanup1:
 cleanup0:
 	dev_set_drvdata(dev, NULL);
 	mrst_rtc.dev = NULL;
-	release_mem_region(iomem->start, iomem->end + 1 - iomem->start);
+	release_mem_region(iomem->start, resource_size(iomem));
 	dev_err(dev, "rtc-mrst: unable to initialise\n");
 	return retval;
 }
@@ -406,7 +406,7 @@ static void __devexit rtc_mrst_do_remove
 	mrst->rtc = NULL;
 
 	iomem = mrst->iomem;
-	release_mem_region(iomem->start, iomem->end + 1 - iomem->start);
+	release_mem_region(iomem->start, resource_size(iomem));
 	mrst->iomem = NULL;
 
 	mrst->dev = NULL;
_

which makes one wonder why we don't have

void release_resource_mem(struct resource *r)
{
	release_mem_region(r->start, resource_size(r));
}
