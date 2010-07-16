Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965647Ab0GPNw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 09:52:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965477Ab0GPNw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 09:52:27 -0400
Date: Fri, 16 Jul 2010 09:52:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CFQ: delay getting cfq group at the very point we really
 need it
Message-ID: <20100716135211.GB15382@redhat.com>
References: <4C3E6B78.6070808@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3E6B78.6070808@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 09:59:20AM +0800, Gui Jianfeng wrote:
> Delay searching or allocating a cfq group at the very point that
> we really need it. This change would save some cycles every time
> we're getting a cfq queue.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/cfq-iosched.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index eb4086f..9b0cf13 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -2820,10 +2820,8 @@ cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync,
>  {
>  	struct cfq_queue *cfqq, *new_cfqq = NULL;
>  	struct cfq_io_context *cic;
> -	struct cfq_group *cfqg;
>  
>  retry:
> -	cfqg = cfq_get_cfqg(cfqd, 1);
>  	cic = cfq_cic_lookup(cfqd, ioc);
>  	/* cic always exists here */
>  	cfqq = cic_to_cfqq(cic, is_sync);
> @@ -2852,6 +2850,9 @@ retry:
>  		}
>  
>  		if (cfqq) {
> +			struct cfq_group *cfqg;
> +
> +			cfqg = cfq_get_cfqg(cfqd, 1);
>  			cfq_init_cfqq(cfqd, cfqq, current->pid, is_sync);

Gui, I noticed that once we have setup a cfqq and cfqg, for subequent
requests we should not come into this function at all because in 
cfq_set_request(), cic will have pointer to cfqq.

So I am not sure in what call path there is substantial saving but anyway,
it should not harm moving cfq_get_cfqg() call down and call it after
cfqq has been allocated.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek
