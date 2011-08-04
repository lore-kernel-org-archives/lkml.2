Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab1HDTtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 15:49:00 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:33725 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab1HDTsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 15:48:54 -0400
Date: Thu, 4 Aug 2011 15:48:38 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Joe Jin <joe.jin@oracle.com>
Cc: Daniel Stodden <daniel.stodden@citrix.com>,
        Jens Axboe <jaxboe@fusionio.com>, Annie Li <annie.li@oracle.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Kurt C Hackel <KURT.HACKEL@oracle.com>,
        Greg Marsden <greg.marsden@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 2/3] xen-blkback: repleace check
 kthread_should_stop() to remove_requested in xen_blkif_schedule() loop.
Message-ID: <20110804194838.GA12459@dumpdata.com>
References: <4E3A486D.7060506@oracle.com>
 <4E3A493C.2070103@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3A493C.2070103@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A02020A.4E3AF79F.0144,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 03:24:44PM +0800, Joe Jin wrote:
> 
> When backend state change to XenbusStateClosed, remove_requested will be set,
> so repleace check kthread_should_stop() to remove_requested in 
> xen_blkif_schedule() loop.
> 
> Signed-off-by: Joe Jin <joe.jin@oracle.com>
> Cc: Daniel Stodden <daniel.stodden@citrix.com>
> Cc: Jens Axboe <jaxboe@fusionio.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Annie Li <annie.li@oracle.com>
> Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>
> --
>  drivers/block/xen-blkback/blkback.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> index 2330a9a..3d64b52 100644
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -274,7 +274,7 @@ int xen_blkif_schedule(void *arg)
>  
>  	xen_blkif_get(blkif);
>  
> -	while (!kthread_should_stop()) {
> +	while (!blkif->remove_requested) {
>  		if (try_to_freeze())
>  			continue;
>  		if (unlikely(vbd->size != vbd_sz(vbd)))
> @@ -282,11 +282,11 @@ int xen_blkif_schedule(void *arg)
>  
>  		wait_event_interruptible(
>  			blkif->wq,
> -			blkif->waiting_reqs || kthread_should_stop());
> +			blkif->waiting_reqs || blkif->remove_requested);
>  		wait_event_interruptible(
>  			blkbk->pending_free_wq,
>  			!list_empty(&blkbk->pending_free) ||
> -			kthread_should_stop());
> +			blkif->remove_requested);
>  
>  		blkif->waiting_reqs = 0;
>  		smp_mb(); /* clear flag *before* checking for work */
> @@ -301,8 +301,8 @@ int xen_blkif_schedule(void *arg)
>  	if (log_stats)
>  		print_stats(blkif);
>  
> -	blkif->xenblkd = NULL;
>  	xen_blkif_put(blkif);
> +	xen_blkback_close(blkif);

<sigh> I can't believe I didn't catch this earlier, but this a
big NO NO. Each patch _MUST_ be compile on its own. If I commit
patch 1 and this patch, the compile (actually linker) process
stops b/c xen_blkback_close is not defined:

drivers/built-in.o: In function `xen_blkif_schedule':
/home/konrad/ssd/linux/drivers/block/xen-blkback/blkback.c:305: undefined reference to `xen_blkback_close'
make[2]: *** [.tmp_vmlinux1] Error 1

You can move the xen_blkback_close() to the third patch
instead of having it here.

I will be nice and do it for you.

>  
>  	return 0;
>  }
> @@ -476,7 +476,7 @@ __do_block_io_op(struct xen_blkif *blkif)
>  		if (RING_REQUEST_CONS_OVERFLOW(&blk_rings->common, rc))
>  			break;
>  
> -		if (kthread_should_stop()) {
> +		if (blkif->remove_requested) {
>  			more_to_do = 1;
>  			break;
>  		}
