Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab2DPT6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 15:58:06 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:34819 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab2DPT6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 15:58:04 -0400
Date: Mon, 16 Apr 2012 15:52:58 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] xen-blkfront: set pages are FOREIGN_FRAME when
 sharing them
Message-ID: <20120416195258.GA14982@phenom.dumpdata.com>
References: <1334075119-25102-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334075119-25102-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090209.4F8C79C6.00A9,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 05:25:19PM +0100, Stefano Stabellini wrote:
> Set pages as FOREIGN_FRAME whenever blkfront shares them with another
> domain. Then when blkfront un-share them, also removes the
> FOREIGN_FRAME_BIT from the p2m.
> 
> We do it so that when the source and the destination domain are the same
> (blkfront connected to blkback in the same domain) we can more easily

Hm, however you mention qdisk which does not use blkback?

> recognize which ones are the source pfns and which ones are the
> destination pfns (both are going to be pointing to the same mfns).

OK, so what happens if we do not do this?
> 
> Without this patch enstablishing a connection between blkfront and QEMU
> qdisk in the same domain causes QEMU to hang and never return.

What is the reason behind it..?

Just to make sure I got it right:

The scenario is where a PV guest launches and inside it, it runs
QEMU exporting its disk (xvda, or some sda if iSCSI or FCoE) to some
other domain. In other words - a stubdomain, right? That would
imply that we have xen-blkfront, xen-blkback [or not?], and QEMU
using gntdev on the same page at some point.

So if we have a request from the other guest to read, it would be:
 - QEMU allocates some pages.
 - QEMU qdisk getting kicked.
 - QEMU using gntdev to IOCTL_GNTDEV_MAP_GRANT_REF the appropiate
   page
 - gntdev ends up calling gnttab_map_refs. The gnttab_map_refs then
   uses the m2p_add_override, which calls set_phys_to_machine(pfn, FOREIGN_FRAME(mfn)).
 - QEMU passes the mentioned page to the kernel using the libaio.
 - libaio does its syscall to sys_aio? which then maps the 'struct page'
   in the kernel space. The PFN has FOREIGN_FRAME set.
 - kernel aio code passes the 'struct page' to xen-blkfront.
 - xen-blkfront now (with your patch) makes sure to re-stamp FOREIGN_FRAME on the
   PFN.
   
 - once xen-blkfront is done, it returns to libaio. libaio calls
   QEMU and it calls gntdev to unmap. The grant dev does it, and calls
   m2p_remove_override on the PFN [the one that had the FOREIGN_FRAME bit set].
   
Hm, I think I lost myself here.  Is the case here that QEMU does not
do the IOCTL_GNTDEV_MAP_GRANT_REF so in reality the PFN that is provided
to xen-blkfront does not have FOREIGN_FRAME stamped?


> 
> 
> Changes in v3:
> - only set_phys_to_machine if xen_pv_domain.
> 
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  drivers/block/xen-blkfront.c |   33 ++++++++++++++++++++++++++++-----
>  1 files changed, 28 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 2f22874..cabfbbb 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -262,7 +262,7 @@ static int blkif_ioctl(struct block_device *bdev, fmode_t mode,
>  static int blkif_queue_request(struct request *req)
>  {
>  	struct blkfront_info *info = req->rq_disk->private_data;
> -	unsigned long buffer_mfn;
> +	unsigned long buffer_mfn, buffer_pfn;
>  	struct blkif_request *ring_req;
>  	unsigned long id;
>  	unsigned int fsect, lsect;
> @@ -321,7 +321,8 @@ static int blkif_queue_request(struct request *req)
>  		       BLKIF_MAX_SEGMENTS_PER_REQUEST);
>  
>  		for_each_sg(info->sg, sg, ring_req->u.rw.nr_segments, i) {
> -			buffer_mfn = pfn_to_mfn(page_to_pfn(sg_page(sg)));
> +			buffer_pfn = page_to_pfn(sg_page(sg));
> +			buffer_mfn = pfn_to_mfn(buffer_pfn);
>  			fsect = sg->offset >> 9;
>  			lsect = fsect + (sg->length >> 9) - 1;
>  			/* install a grant reference. */
> @@ -340,6 +341,17 @@ static int blkif_queue_request(struct request *req)
>  						.gref       = ref,
>  						.first_sect = fsect,
>  						.last_sect  = lsect };
> +			/* 
> +			 * Set the page as foreign, considering that we are giving
> +			 * it to a foreign domain.
> +			 * This is important in case the destination domain is
> +			 * ourselves, so that we can more easily recognize the
> +			 * source pfn from destination pfn, both mapping to the same
> +			 * mfn.
> +			 */
> +			if (xen_pv_domain())

Should this also do the auto_translate bit check? Or do we not care
about that since the set_phys_to_machine does it for us?

> +				set_phys_to_machine(buffer_pfn,
> +						FOREIGN_FRAME(buffer_mfn));
>  		}
>  	}
>  
> @@ -715,8 +727,12 @@ static void blkif_completion(struct blk_shadow *s)
>  	int i;
>  	/* Do not let BLKIF_OP_DISCARD as nr_segment is in the same place
>  	 * flag. */
> -	for (i = 0; i < s->req.u.rw.nr_segments; i++)
> +	for (i = 0; i < s->req.u.rw.nr_segments; i++) {
>  		gnttab_end_foreign_access(s->req.u.rw.seg[i].gref, 0, 0UL);
> +		if (xen_pv_domain())
> +			set_phys_to_machine(s->frame[i],
> +					get_phys_to_machine(s->frame[i]) & ~FOREIGN_FRAME_BIT);
> +	}
>  }
>  
>  static irqreturn_t blkif_interrupt(int irq, void *dev_id)
> @@ -1051,13 +1067,20 @@ static int blkif_recover(struct blkfront_info *info)
>  		memcpy(&info->shadow[req->u.rw.id], &copy[i], sizeof(copy[i]));
>  
>  		if (req->operation != BLKIF_OP_DISCARD) {
> +			unsigned long buffer_pfn;
> +			unsigned long buffer_mfn;
>  		/* Rewrite any grant references invalidated by susp/resume. */
> -			for (j = 0; j < req->u.rw.nr_segments; j++)
> +			for (j = 0; j < req->u.rw.nr_segments; j++) {
> +				buffer_pfn = info->shadow[req->u.rw.id].frame[j];
> +				buffer_mfn = pfn_to_mfn(buffer_pfn);
>  				gnttab_grant_foreign_access_ref(
>  					req->u.rw.seg[j].gref,
>  					info->xbdev->otherend_id,
> -					pfn_to_mfn(info->shadow[req->u.rw.id].frame[j]),
> +					buffer_mfn,
>  					rq_data_dir(info->shadow[req->u.rw.id].request));
> +				if (xen_pv_domain())
> +					set_phys_to_machine(buffer_pfn, FOREIGN_FRAME(buffer_mfn));
> +			}
>  		}
>  		info->shadow[req->u.rw.id].req = *req;
>  
> -- 
> 1.7.2.5
