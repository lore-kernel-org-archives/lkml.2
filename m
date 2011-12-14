Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab1LNS6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:58:08 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:50290 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757888Ab1LNS6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:58:04 -0500
Date: Wed, 14 Dec 2011 13:56:41 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: xen-devel@lists.xensource.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen-blkfront: Use kcalloc instead of kzalloc to allocate
 array
Message-ID: <20111214185641.GD24598@phenom.dumpdata.com>
References: <1322600880.1534.293.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322600880.1534.293.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090202.4EE8F19F.00DA,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 10:08:00PM +0100, Thomas Meyer wrote:
> The advantage of kcalloc is, that will prevent integer overflows which could
> result from the multiplication of number of elements and size and it is also
> a bit nicer to read.
> 
> The semantic patch that makes this change is available
> in https://lkml.org/lkml/2011/11/25/107
> 

Thomas,

I put the xen-blkfront part of the patch in my tree and dropped the cciss_scsi one.

> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
> 
> diff -u -p a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
> --- a/drivers/block/cciss_scsi.c 2011-11-28 19:36:47.343430551 +0100
> +++ b/drivers/block/cciss_scsi.c 2011-11-28 19:49:24.922716381 +0100
> @@ -534,10 +534,10 @@ adjust_cciss_scsi_table(ctlr_info_t *h,
>  	int nadded, nremoved;
>  	struct Scsi_Host *sh = NULL;
>  
> -	added = kzalloc(sizeof(*added) * CCISS_MAX_SCSI_DEVS_PER_HBA,
> -			GFP_KERNEL);
> -	removed = kzalloc(sizeof(*removed) * CCISS_MAX_SCSI_DEVS_PER_HBA,
> +	added = kcalloc(CCISS_MAX_SCSI_DEVS_PER_HBA, sizeof(*added),
>  			GFP_KERNEL);
> +	removed = kcalloc(CCISS_MAX_SCSI_DEVS_PER_HBA, sizeof(*removed),
> +			  GFP_KERNEL);
>  
>  	if (!added || !removed) {
>  		dev_warn(&h->pdev->dev,
> @@ -1191,8 +1191,8 @@ cciss_update_non_disk_devices(ctlr_info_
>  
>  	ld_buff = kzalloc(reportlunsize, GFP_KERNEL);
>  	inq_buff = kmalloc(OBDR_TAPE_INQ_SIZE, GFP_KERNEL);
> -	currentsd = kzalloc(sizeof(*currentsd) *
> -			(CCISS_MAX_SCSI_DEVS_PER_HBA+1), GFP_KERNEL);
> +	currentsd = kcalloc(CCISS_MAX_SCSI_DEVS_PER_HBA + 1,
> +			    sizeof(*currentsd), GFP_KERNEL);
>  	if (ld_buff == NULL || inq_buff == NULL || currentsd == NULL) {
>  		printk(KERN_ERR "cciss: out of memory\n");
>  		goto out;
> diff -u -p a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> --- a/drivers/block/xen-blkfront.c 2011-11-13 11:07:22.680095573 +0100
> +++ b/drivers/block/xen-blkfront.c 2011-11-28 19:49:29.109460410 +0100
> @@ -156,7 +156,7 @@ static int xlbd_reserve_minors(unsigned
>  	if (end > nr_minors) {
>  		unsigned long *bitmap, *old;
>  
> -		bitmap = kzalloc(BITS_TO_LONGS(end) * sizeof(*bitmap),
> +		bitmap = kcalloc(BITS_TO_LONGS(end), sizeof(*bitmap),
>  				 GFP_KERNEL);
>  		if (bitmap == NULL)
>  			return -ENOMEM;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
