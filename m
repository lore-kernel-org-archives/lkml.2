Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760313Ab2CNJs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 05:48:26 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:29177 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758742Ab2CNJsY convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 14 Mar 2012 05:48:24 -0400
Message-Id: <4F60777502000078000783B6@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 14 Mar 2012 09:48:21 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <axboe@kernel.dk>, <xen-devel@lists.xensource.com>,
        "Li Dongyang" <lidongyang@suse.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/blkback: Squash the discard support for 'file'
 and 'phy' type.
References: <1331679128-27646-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1331679128-27646-1-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 13.03.12 at 23:52, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> The only reason for the distinction was for the special case of
> 'file' (which is assumed to be loopback device), was to reach inside
> the loopback device, find the underlaying file, and call fallocate on it.
> Fortunately "xen-blkback: convert hole punching to discard request on
> loop devices" removes that use-case and we now based the discard
> support based on blk_queue_discard(q) and extract all appropriate
> parameters from the 'struct request_queue'.
> 
> CC: Li Dongyang <lidongyang@novell.com>
> CC: Jan Beulich <JBeulich@suse.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Jan Beulich <jbeulich@suse.com>

(with a few minor remarks below)

> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -419,21 +419,17 @@ static int dispatch_discard_io(struct xen_blkif *blkif,
>  	int err = 0;
>  	int status = BLKIF_RSP_OKAY;
>  	struct block_device *bdev = blkif->vbd.bdev;
> -
> +	unsigned long secure = 0;

Mind keeping the blank line and dropping the pointless initializer (which
future gcc is likely going to be warning about)?

>  	blkif->st_ds_req++;
>  
>  	xen_blkif_get(blkif);
> -	if (blkif->blk_backend_type == BLKIF_BACKEND_PHY ||
> -	    blkif->blk_backend_type == BLKIF_BACKEND_FILE) {
> -		unsigned long secure = (blkif->vbd.discard_secure &&
> -			(req->u.discard.flag & BLKIF_DISCARD_SECURE)) ?
> -			BLKDEV_DISCARD_SECURE : 0;
> -		err = blkdev_issue_discard(bdev,
> -				req->u.discard.sector_number,
> -				req->u.discard.nr_sectors,
> -				GFP_KERNEL, secure);
> -	} else
> -		err = -EOPNOTSUPP;
> +	secure = (blkif->vbd.discard_secure &&
> +		 (req->u.discard.flag & BLKIF_DISCARD_SECURE)) ?
> +		 BLKDEV_DISCARD_SECURE : 0;
> +
> +	err = blkdev_issue_discard(bdev, req->u.discard.sector_number,
> +				   req->u.discard.nr_sectors,
> +				   GFP_KERNEL, secure);
>  
>  	if (err == -EOPNOTSUPP) {
>  		pr_debug(DRV_PFX "discard op failed, not supported\n");
> --- a/drivers/block/xen-blkback/xenbus.c
> +++ b/drivers/block/xen-blkback/xenbus.c
> @@ -393,52 +393,37 @@ int xen_blkbk_discard(struct xenbus_transaction xbt, 
> struct backend_info *be)
>  	char *type;
>  	int err;
>  	int state = 0;
> +	struct block_device *bdev = be->blkif->vbd.bdev;
> +	struct request_queue *q = bdev_get_queue(bdev);
>  
> -	type = xenbus_read(XBT_NIL, dev->nodename, "type", NULL);
> -	if (!IS_ERR(type)) {
> -		if (strncmp(type, "file", 4) == 0) {
> -			state = 1;
> -			blkif->blk_backend_type = BLKIF_BACKEND_FILE;
> +	if (blk_queue_discard(q)) {
> +		err = xenbus_printf(xbt, dev->nodename,
> +			"discard-granularity", "%u",
> +			q->limits.discard_granularity);
> +		if (err) {
> +			xenbus_dev_fatal(dev, err,
> +				"writing discard-granularity");
> +			goto kfree;

Unrelated to the patch here, but failure to write any sort of extension
data shouldn't be considered fatal - the backend can well work without
these, and it should be left to the frontend to decide whether it wants
to live without the unavailable extensions.

Jan

> +		}
> +		err = xenbus_printf(xbt, dev->nodename,
> +			"discard-alignment", "%u",
> +			q->limits.discard_alignment);
> +		if (err) {
> +			xenbus_dev_fatal(dev, err,
> +				"writing discard-alignment");
> +			goto kfree;
>  		}
> -		if (strncmp(type, "phy", 3) == 0) {
> -			struct block_device *bdev = be->blkif->vbd.bdev;
> -			struct request_queue *q = bdev_get_queue(bdev);
> -			if (blk_queue_discard(q)) {
> -				err = xenbus_printf(xbt, dev->nodename,
> -					"discard-granularity", "%u",
> -					q->limits.discard_granularity);
> -				if (err) {
> -					xenbus_dev_fatal(dev, err,
> -						"writing discard-granularity");
> -					goto kfree;
> -				}
> -				err = xenbus_printf(xbt, dev->nodename,
> -					"discard-alignment", "%u",
> -					q->limits.discard_alignment);
> -				if (err) {
> -					xenbus_dev_fatal(dev, err,
> -						"writing discard-alignment");
> -					goto kfree;
> -				}
> -				state = 1;
> -				blkif->blk_backend_type = BLKIF_BACKEND_PHY;
> -			}
> -			/* Optional. */
> -			err = xenbus_printf(xbt, dev->nodename,
> -				"discard-secure", "%d",
> -				blkif->vbd.discard_secure);
> -			if (err) {
> -				xenbus_dev_fatal(dev, err,
> +		state = 1;
> +		/* Optional. */
> +		err = xenbus_printf(xbt, dev->nodename,
> +				    "discard-secure", "%d",
> +				    blkif->vbd.discard_secure);
> +		if (err) {
> +			xenbus_dev_fatal(dev, err,
>  					"writting discard-secure");
> -				goto kfree;
> -			}
> +			goto kfree;
>  		}
> -	} else {
> -		err = PTR_ERR(type);
> -		xenbus_dev_fatal(dev, err, "reading type");
> -		goto out;
>  	}
> -
>  	err = xenbus_printf(xbt, dev->nodename, "feature-discard",
>  			    "%d", state);
>  	if (err)


