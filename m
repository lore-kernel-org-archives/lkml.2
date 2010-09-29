Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab0I2Bam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 21:30:42 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:36205 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab0I2Bam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 21:30:42 -0400
X-Originating-Ip: 216.16.235.2
Date: Tue, 28 Sep 2010 21:29:45 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Richard Weinberger <richard@nod.at>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jdike@addtoit.com" <jdike@addtoit.com>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        "user-mode-linux-user@lists.sourceforge.net" 
	<user-mode-linux-user@lists.sourceforge.net>,
        "janjaap@bos.nl" <janjaap@bos.nl>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "adobriyan@gmail.com" <adobriyan@gmail.com>,
        "syzop@vulnscan.org" <syzop@vulnscan.org>
Subject: Re: [PATCH 1/1] um: ubd: Fix data corruption
Message-ID: <20100929012945.GA3324@foursquare.net>
References: <1285710456-4435-1-git-send-email-richard@nod.at> <20100928150000.f007f43e.akpm@linux-foundation.org> <201009290013.11332.richard@nod.at> <20100928225202.GA30352@foursquare.net> <4CA275CE.6060401@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA275CE.6060401@fusionio.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 08:10:06AM +0900, Jens Axboe wrote:
> It looks like that if we need to restart the requeue, then
> we use the initial position and not the current index. Does
> this help?
> 
> diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
> index 1bcd208..81ee063 100644
> --- a/arch/um/drivers/ubd_kern.c
> +++ b/arch/um/drivers/ubd_kern.c
> @@ -162,7 +162,7 @@ struct ubd {
>  	spinlock_t lock;
>  	struct scatterlist sg[MAX_SG];
>  	struct request *request;
> -	int start_sg, end_sg;
> +	int start_sg, end_sg, rq_off;
>  };
>  
>  #define DEFAULT_COW { \
> @@ -187,6 +187,7 @@ struct ubd {
>  	.request =		NULL, \
>  	.start_sg =		0, \
>  	.end_sg =		0, \
> +	.rq_off =		0, \
>  }
>  
>  /* Protected by ubd_lock */
> @@ -1241,10 +1242,11 @@ static void do_ubd_request(struct request_queue *q)
>  			dev->request = req;
>  			dev->start_sg = 0;
>  			dev->end_sg = blk_rq_map_sg(q, req, dev->sg);
> +			dev->rq_off = 0;
>  		}
>  
>  		req = dev->request;
> -		sector = blk_rq_pos(req);
> +		sector = blk_rq_pos(req) + dev->rq_off;
>  		while(dev->start_sg < dev->end_sg){
>  			struct scatterlist *sg = &dev->sg[dev->start_sg];
>  
> @@ -1273,6 +1275,7 @@ static void do_ubd_request(struct request_queue *q)
>  			}
>  
>  			dev->start_sg++;
> +			dev->rq_off += sg->length >> 9;
>  		}
>  		dev->end_sg = 0;
>  		dev->request = NULL;
> 
> -- 

This patch does not fix the corruption issue for me.  I applied the patch
to 2.6.35.5, and reproduced the "deleted inode referenced" errors
in both a gentoo and ubuntu guest OS.  It does take longer to reproduce
though, with this patch.

- Chris

