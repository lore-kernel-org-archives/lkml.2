Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab0I2Asg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 20:48:36 -0400
Received: from comms2.zx.nl ([194.187.76.142]:54779 "EHLO comms2.zx.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab0I2Asf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 20:48:35 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
Subject: Re: [PATCH 1/1] um: ubd: Fix data corruption
From: Janjaap Bos <janjaap@bos.nl>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Chris Frey <cdfrey@foursquare.net>, Richard Weinberger <richard@nod.at>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jdike@addtoit.com" <jdike@addtoit.com>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        "user-mode-linux-user@lists.sourceforge.net" 
	<user-mode-linux-user@lists.sourceforge.net>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "adobriyan@gmail.com" <adobriyan@gmail.com>,
        "syzop@vulnscan.org" <syzop@vulnscan.org>
In-reply-to: <4CA275CE.6060401@fusionio.com>
References: <1285710456-4435-1-git-send-email-richard@nod.at>
 <20100928150000.f007f43e.akpm@linux-foundation.org>
 <201009290013.11332.richard@nod.at> <20100928225202.GA30352@foursquare.net>
 <4CA275CE.6060401@fusionio.com>
Date: Wed, 29 Sep 2010 02:48:28 +0200
Message-id: <1285721308.9775.3.camel@voyager>
X-Mailer: Evolution 2.28.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-29 at 08:10 +0900, Jens Axboe wrote:

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

Yes, this works. I quickly tested it on current git version, and it does
not require the work-around. So far no corruption seen.

Thanks!
-Janjaap


