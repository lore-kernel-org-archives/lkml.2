Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab2FHHMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 03:12:48 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:46047 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab2FHHMq convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 8 Jun 2012 03:12:46 -0400
Message-Id: <4FD1C20A0200007800088AC4@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 08 Jun 2012 08:12:42 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/2] xen/blkfront: Add BUG_ON to deal
 with misbehaving backends.
References: <1337982603-15692-1-git-send-email-konrad.wilk@oracle.com>
 <1337982603-15692-3-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.00.1205281111460.26786@kaball-desktop>
 <4FC4A10F0200007800086842@nat28.tlf.novell.com>
 <20120531181712.GA19700@phenom.dumpdata.com>
 <alpine.DEB.2.00.1206011111590.26786@kaball-desktop>
 <20120607215942.GA13592@phenom.dumpdata.com>
In-Reply-To: <20120607215942.GA13592@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 07.06.12 at 23:59, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -141,14 +141,33 @@ static int get_id_from_freelist(struct blkfront_info 
> *info)
>  	return free;
>  }
>  
> -static void add_id_to_freelist(struct blkfront_info *info,
> +static int add_id_to_freelist(struct blkfront_info *info,
>  			       unsigned long id)
>  {
> +	if (info->shadow[id].req.u.rw.id != id)
> +		return -EINVAL;
> +	if (info->shadow[id].request == NULL)
> +		return -EINVAL;
>  	info->shadow[id].req.u.rw.id  = info->shadow_free;
>  	info->shadow[id].request = NULL;
>  	info->shadow_free = id;
> +	return 0;
>  }
>  
> +static const char *op_name(int op)
> +{
> +	static const char *names[] = {

Could/should really be "static const char *const names[]".

> +		[BLKIF_OP_READ] = "read",
> +		[BLKIF_OP_WRITE] = "write",
> +		[BLKIF_OP_WRITE_BARRIER] = "barrier",
> +		[BLKIF_OP_FLUSH_DISKCACHE] = "flush",
> +		[BLKIF_OP_RESERVED_1] = "reserved",
> +		[BLKIF_OP_DISCARD] = "discard" };
> +
> +	if (op < 0 || op >= ARRAY_SIZE(names))
> +		return "unknown";
> +	return names[op];
> +}
>  static int xlbd_reserve_minors(unsigned int minor, unsigned int nr)
>  {
>  	unsigned int end = minor + nr;
> @@ -744,20 +763,31 @@ static irqreturn_t blkif_interrupt(int irq, void 
> *dev_id)
>  
>  		bret = RING_GET_RESPONSE(&info->ring, i);
>  		id   = bret->id;
> +		/*
> +		 * The backend has messed up and given us an id that we would
> +		 * never have given to it (we stamp it up to BLK_RING_SIZE -
> +		 * look in get_id_from_freelist.
> +		 */
> +		if (id >= BLK_RING_SIZE)
> +			/* We can't safely get the 'struct request' as
> +			 * the id is busted. So limp along. */
> +			goto err_out;

Getting out of the loop here isn't really what I'd call "limp along" -
it'd likely get the communication to a halt (if there are more
responses ready). I'd rather see this print something, and then
continue the loop. Or alternatively, if we really want to stop
communication in such a case, initiate tear down of the device.

> +
>  		req  = info->shadow[id].request;
>  
>  		if (bret->operation != BLKIF_OP_DISCARD)
>  			blkif_completion(&info->shadow[id]);
>  
> -		add_id_to_freelist(info, id);
> +		if (add_id_to_freelist(info, id))
> +			goto err_out;

Same here, obviously.

>  
>  		error = (bret->status == BLKIF_RSP_OKAY) ? 0 : -EIO;
>  		switch (bret->operation) {
>  		case BLKIF_OP_DISCARD:
>  			if (unlikely(bret->status == BLKIF_RSP_EOPNOTSUPP)) {
>  				struct request_queue *rq = info->rq;
> -				printk(KERN_WARNING "blkfront: %s: discard op failed\n",
> -					   info->gd->disk_name);
> +				printk(KERN_WARNING "blkfront: %s: %s op failed\n",
> +					   info->gd->disk_name, op_name(bret->operation));
>  				error = -EOPNOTSUPP;
>  				info->feature_discard = 0;
>  				info->feature_secdiscard = 0;
> @@ -769,18 +799,14 @@ static irqreturn_t blkif_interrupt(int irq, void 
> *dev_id)
>  		case BLKIF_OP_FLUSH_DISKCACHE:
>  		case BLKIF_OP_WRITE_BARRIER:
>  			if (unlikely(bret->status == BLKIF_RSP_EOPNOTSUPP)) {
> -				printk(KERN_WARNING "blkfront: %s: write %s op failed\n",
> -				       info->flush_op == BLKIF_OP_WRITE_BARRIER ?
> -				       "barrier" :  "flush disk cache",
> -				       info->gd->disk_name);
> +				printk(KERN_WARNING "blkfront: %s: %s op failed\n",
> +				       info->gd->disk_name, op_name(bret->operation));
>  				error = -EOPNOTSUPP;
>  			}
>  			if (unlikely(bret->status == BLKIF_RSP_ERROR &&
>  				     info->shadow[id].req.u.rw.nr_segments == 0)) {
> -				printk(KERN_WARNING "blkfront: %s: empty write %s op failed\n",
> -				       info->flush_op == BLKIF_OP_WRITE_BARRIER ?
> -				       "barrier" :  "flush disk cache",
> -				       info->gd->disk_name);
> +				printk(KERN_WARNING "blkfront: %s: empty %s op failed\n",
> +				       info->gd->disk_name, op_name(bret->operation));
>  				error = -EOPNOTSUPP;
>  			}
>  			if (unlikely(error)) {
> @@ -813,12 +839,18 @@ static irqreturn_t blkif_interrupt(int irq, void 
> *dev_id)
>  			goto again;
>  	} else
>  		info->ring.sring->rsp_event = i + 1;
> -
>  	kick_pending_request_queues(info);
>  
>  	spin_unlock_irqrestore(&blkif_io_lock, flags);
>  
>  	return IRQ_HANDLED;
> +err_out:
> +	WARN(1, "%s: response to %s has incorrect id\n",
> +	     info->gd->disk_name, op_name(bret->operation));
> +
> +	spin_unlock_irqrestore(&info->io_lock, flags);
> +
> +	return IRQ_HANDLED;
>  }
>  
>  
> diff --git a/include/xen/interface/io/blkif.h 
> b/include/xen/interface/io/blkif.h
> index ee338bf..bc75c75 100644
> --- a/include/xen/interface/io/blkif.h
> +++ b/include/xen/interface/io/blkif.h
> @@ -59,6 +59,12 @@ typedef uint64_t blkif_sector_t;
>  #define BLKIF_OP_FLUSH_DISKCACHE   3
>  
>  /*
> + * Used in SLES sources for device specific command packet
> + * contained within the request. Reserved for that purpose.
> + */
> +#define BLKIF_OP_RESERVED_1        4

If you really want to give this a numeric tag, wouldn't it be better
to make this _4? But maybe you could leave out the definition here
altogether, and leave the corresponding names[] slot set to NULL?

Jan

> +
> +/*
>   * Recognised only if "feature-discard" is present in backend xenbus info.
>   * The "feature-discard" node contains a boolean indicating whether trim
>   * (ATA) or unmap (SCSI) - conviently called discard requests are likely
> -- 
> 1.7.7.6


