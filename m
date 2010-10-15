Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab0JOEtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 00:49:12 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:58920 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab0JOEtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 00:49:10 -0400
X-Originating-Ip: 216.16.235.2
Date: Fri, 15 Oct 2010 00:47:56 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Richard Weinberger <richard@nod.at>,
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
Message-ID: <20101015044756.GA16666@foursquare.net>
References: <20100929012945.GA3324@foursquare.net> <4CA2CCC3.8010307@fusionio.com> <20100929063452.GA13290@foursquare.net> <4CAA02D0.7040901@gmail.com> <20101004195152.GA31583@foursquare.net> <4CAAE077.9010500@gmail.com> <20101005203137.GA594@foursquare.net> <4CAD7D98.7080808@fusionio.com> <20101007202339.GA8338@foursquare.net> <4CB70234.3030308@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB70234.3030308@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 03:14:28PM +0200, Tejun Heo wrote:
> Hello,
> 
> Can you please try this one then?  It seems to work here but I can't
> reproduce the original problem reliably so I'm not really sure.
> 
> Thanks.
> 
> diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
> index 1bcd208..9734994 100644
> --- a/arch/um/drivers/ubd_kern.c
> +++ b/arch/um/drivers/ubd_kern.c
> @@ -163,6 +163,7 @@ struct ubd {
>  	struct scatterlist sg[MAX_SG];
>  	struct request *request;
>  	int start_sg, end_sg;
> +	sector_t rq_pos;
>  };
> 
>  #define DEFAULT_COW { \
> @@ -187,6 +188,7 @@ struct ubd {
>  	.request =		NULL, \
>  	.start_sg =		0, \
>  	.end_sg =		0, \
> +	.rq_pos =		0, \
>  }
> 
>  /* Protected by ubd_lock */
> @@ -1228,7 +1230,6 @@ static void do_ubd_request(struct request_queue *q)
>  {
>  	struct io_thread_req *io_req;
>  	struct request *req;
> -	sector_t sector;
>  	int n;
> 
>  	while(1){
> @@ -1239,12 +1240,12 @@ static void do_ubd_request(struct request_queue *q)
>  				return;
> 
>  			dev->request = req;
> +			dev->rq_pos = blk_rq_pos(req);
>  			dev->start_sg = 0;
>  			dev->end_sg = blk_rq_map_sg(q, req, dev->sg);
>  		}
> 
>  		req = dev->request;
> -		sector = blk_rq_pos(req);
>  		while(dev->start_sg < dev->end_sg){
>  			struct scatterlist *sg = &dev->sg[dev->start_sg];
> 
> @@ -1256,10 +1257,9 @@ static void do_ubd_request(struct request_queue *q)
>  				return;
>  			}
>  			prepare_request(req, io_req,
> -					(unsigned long long)sector << 9,
> +					(unsigned long long)dev->rq_pos << 9,
>  					sg->offset, sg->length, sg_page(sg));
> 
> -			sector += sg->length >> 9;
>  			n = os_write_file(thread_fd, &io_req,
>  					  sizeof(struct io_thread_req *));
>  			if(n != sizeof(struct io_thread_req *)){
> @@ -1272,6 +1272,7 @@ static void do_ubd_request(struct request_queue *q)
>  				return;
>  			}
> 
> +			dev->rq_pos += sg->length >> 9;
>  			dev->start_sg++;
>  		}
>  		dev->end_sg = 0;



I tested this patch, on 2.6.35.5, as heavily as I could today, and
was unable to reproduce the filesystem corruption.

Seems to be fixed. :-)

Thanks!
- Chris

