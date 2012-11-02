Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761008Ab2KBRFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:05:52 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:44673 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758840Ab2KBRFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:05:51 -0400
Date: Fri, 2 Nov 2012 13:05:46 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Roger Pau Monne <roger.pau@citrix.com>
Cc: xen-devel@lists.xen.org, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen-blk: persistent-grants fixes
Message-ID: <20121102170543.GA1853@konrad-lan.dumpdata.com>
References: <1351870984-22078-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351870984-22078-1-git-send-email-roger.pau@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 04:43:04PM +0100, Roger Pau Monne wrote:
> This patch contains fixes for persistent grants implementation v2:
> 
>  * handle == 0 is a valid handle, so initialize grants in blkback
>    setting the handle to BLKBACK_INVALID_HANDLE instead of 0. Reported
>    by Konrad Rzeszutek Wilk.
> 
>  * new_map is a boolean, use "true" or "false" instead of 1 and 0.
>    Reported by Konrad Rzeszutek Wilk.
> 
>  * blkfront announces the persistent-grants feature as
>    feature-persistent-grants, use feature-persistent instead which is
>    consistent with blkback and the public Xen headers.
> 
>  * Add a consistency check in blkfront to make sure we don't try to
>    access segments that have not been set.

Looks good.. but
> 
> Signed-off-by: Roger Pau Monne <roger.pau@citrix.com>
> Cc: <konrad.wilk@oracle.com>
> Cc: <linux-kernel@vger.kernel.org>
> ---
>  drivers/block/xen-blkback/blkback.c |   15 +++++++++------
>  drivers/block/xen-blkback/xenbus.c  |    2 +-
>  drivers/block/xen-blkfront.c        |    3 ++-
>  3 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> index 663d42d..a059616 100644
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -503,7 +503,7 @@ static int xen_blkbk_map(struct blkif_request *req,
>  			 * We are using persistent grants and
>  			 * the grant is already mapped
>  			 */
> -			new_map = 0;
> +			new_map = false;
>  		} else if (use_persistent_gnts &&
>  			   blkif->persistent_gnt_c <
>  			   max_mapped_grant_pages(blkif->blk_protocol)) {
> @@ -511,8 +511,8 @@ static int xen_blkbk_map(struct blkif_request *req,
>  			 * We are using persistent grants, the grant is
>  			 * not mapped but we have room for it
>  			 */
> -			new_map = 1;
> -			persistent_gnt = kzalloc(
> +			new_map = true;
> +			persistent_gnt = kmalloc(

Why do we want to use kmalloc instead of kzalloc?

>  				sizeof(struct persistent_gnt),
>  				GFP_KERNEL);
>  			if (!persistent_gnt)
> @@ -523,6 +523,7 @@ static int xen_blkbk_map(struct blkif_request *req,
>  				return -ENOMEM;
>  			}
>  			persistent_gnt->gnt = req->u.rw.seg[i].gref;
> +			persistent_gnt->handle = BLKBACK_INVALID_HANDLE;
>  
>  			pages_to_gnt[segs_to_map] =
>  				persistent_gnt->page;
> @@ -547,7 +548,7 @@ static int xen_blkbk_map(struct blkif_request *req,
>  				pr_alert(DRV_PFX " domain %u, device %#x is using maximum number of persistent grants\n",
>  					 blkif->domid, blkif->vbd.handle);
>  			}
> -			new_map = 1;
> +			new_map = true;
>  			pages[i] = blkbk->pending_page(pending_req, i);
>  			addr = vaddr(pending_req, i);
>  			pages_to_gnt[segs_to_map] =
> @@ -584,7 +585,8 @@ static int xen_blkbk_map(struct blkif_request *req,
>  	 */
>  	bitmap_zero(pending_req->unmap_seg, BLKIF_MAX_SEGMENTS_PER_REQUEST);
>  	for (i = 0, j = 0; i < nseg; i++) {
> -		if (!persistent_gnts[i] || !persistent_gnts[i]->handle) {
> +		if (!persistent_gnts[i] ||
> +		    persistent_gnts[i]->handle == BLKBACK_INVALID_HANDLE) {
>  			/* This is a newly mapped grant */
>  			BUG_ON(j >= segs_to_map);
>  			if (unlikely(map[j].status != 0)) {
> @@ -601,7 +603,8 @@ static int xen_blkbk_map(struct blkif_request *req,
>  			}
>  		}
>  		if (persistent_gnts[i]) {
> -			if (!persistent_gnts[i]->handle) {
> +			if (persistent_gnts[i]->handle ==
> +			    BLKBACK_INVALID_HANDLE) {
>  				/*
>  				 * If this is a new persistent grant
>  				 * save the handler
> diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
> index b225026..a03ecbb 100644
> --- a/drivers/block/xen-blkback/xenbus.c
> +++ b/drivers/block/xen-blkback/xenbus.c
> @@ -760,7 +760,7 @@ static int connect_ring(struct backend_info *be)
>  		return -1;
>  	}
>  	err = xenbus_gather(XBT_NIL, dev->otherend,
> -			    "feature-persistent-grants", "%u",
> +			    "feature-persistent", "%u",
>  			    &pers_grants, NULL);
>  	if (err)
>  		pers_grants = 0;
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 911d733..f1de806 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -852,6 +852,7 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
>  		rq_for_each_segment(bvec, s->request, iter) {
>  			BUG_ON((bvec->bv_offset + bvec->bv_len) > PAGE_SIZE);
>  			i = offset >> PAGE_SHIFT;
> +			BUG_ON(i >= s->req.u.rw.nr_segments);
>  			shared_data = kmap_atomic(
>  				pfn_to_page(s->grants_used[i]->pfn));
>  			bvec_data = bvec_kmap_irq(bvec, &flags);
> @@ -1069,7 +1070,7 @@ again:
>  		goto abort_transaction;
>  	}
>  	err = xenbus_printf(xbt, dev->nodename,
> -			    "feature-persistent-grants", "%u", 1);
> +			    "feature-persistent", "%u", 1);
>  	if (err)
>  		dev_warn(&dev->dev,
>  			 "writing persistent grants feature to xenbus");
> -- 
> 1.7.7.5 (Apple Git-26)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
