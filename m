Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760763Ab2COIu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 04:50:57 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:23098 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759172Ab2COIuw convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Thu, 15 Mar 2012 04:50:52 -0400
Message-Id: <4F61BB780200007800078903@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 15 Mar 2012 08:50:48 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <axboe@kernel.dk>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] xen/blkback: Make optional features be really
 optional.
References: <1331748631-4022-1-git-send-email-konrad.wilk@oracle.com>
 <1331748631-4022-3-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1331748631-4022-3-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 14.03.12 at 19:10, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> They were using the xenbus_dev_fatal() function which would
> change the state of the connection immediately. Which is not
> what we want when we advertise optional features.
> 
> So make 'feature-discard','feature-barrier','feature-flush-cache'
> optional.
> 
> Suggested-by: Jan Beulich <JBeulich@suse.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/block/xen-blkback/xenbus.c |   25 ++++++++++---------------
>  1 files changed, 10 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/block/xen-blkback/xenbus.c 
> b/drivers/block/xen-blkback/xenbus.c
> index d417c13..d90a39c 100644
> --- a/drivers/block/xen-blkback/xenbus.c
> +++ b/drivers/block/xen-blkback/xenbus.c
> @@ -381,7 +381,7 @@ int xen_blkbk_flush_diskcache(struct xenbus_transaction 
> xbt,
>  	err = xenbus_printf(xbt, dev->nodename, "feature-flush-cache",
>  			    "%d", state);
>  	if (err)
> -		xenbus_dev_fatal(dev, err, "writing feature-flush-cache");
> +		dev_warn(&dev->dev, "writing feature-flush-cache (%d)", err);

I'm really not certain whether dev_warn() or xenbus_dev_error() is
better here. The latter would also make the error visible in xenstore,
but whether that's good, superfluous, or outright bad I'm unsure
about.

>  
>  	return err;
>  }
> @@ -400,16 +400,14 @@ int xen_blkbk_discard(struct xenbus_transaction xbt, 
> struct backend_info *be)
>  			"discard-granularity", "%u",
>  			q->limits.discard_granularity);
>  		if (err) {
> -			xenbus_dev_fatal(dev, err,
> -				"writing discard-granularity");
> +			dev_warn(&dev->dev, "writing discard-granularity (%d)", err);
>  			goto out;
>  		}
>  		err = xenbus_printf(xbt, dev->nodename,
>  			"discard-alignment", "%u",
>  			q->limits.discard_alignment);
>  		if (err) {
> -			xenbus_dev_fatal(dev, err,
> -				"writing discard-alignment");
> +			dev_warn(&dev->dev, "writing discard-alignment (%d)", err);
>  			goto out;
>  		}
>  		state = 1;
> @@ -418,15 +416,14 @@ int xen_blkbk_discard(struct xenbus_transaction xbt, 
> struct backend_info *be)
>  				    "discard-secure", "%d",
>  				    blkif->vbd.discard_secure);
>  		if (err) {
> -			xenbus_dev_fatal(dev, err,
> -					"writting discard-secure");
> +			dev_warn(dev-dev, "writing discard-secure (%d)", err);
>  			goto out;
>  		}
>  	}
>  	err = xenbus_printf(xbt, dev->nodename, "feature-discard",
>  			    "%d", state);
>  	if (err)
> -		xenbus_dev_fatal(dev, err, "writing feature-discard");
> +		dev_warn(&dev->dev, "writing feature-discard (%d)", err);
>  out:
>  	return err;
>  }
> @@ -439,7 +436,7 @@ int xen_blkbk_barrier(struct xenbus_transaction xbt,
>  	err = xenbus_printf(xbt, dev->nodename, "feature-barrier",
>  			    "%d", state);
>  	if (err)
> -		xenbus_dev_fatal(dev, err, "writing feature-barrier");
> +		dev_warn(&dev->dev, "writing feature-barrier (%d)", err);
>  
>  	return err;
>  }
> @@ -671,14 +668,12 @@ again:
>  		return;
>  	}
>  
> -	err = xen_blkbk_flush_diskcache(xbt, be, be->blkif->vbd.flush_support);
> -	if (err)
> -		goto abort;
> +	/* If we can't advertise it is OK. */
> +	(void)xen_blkbk_flush_diskcache(xbt, be, be->blkif->vbd.flush_support);
>  
> -	err = xen_blkbk_discard(xbt, be);
> +	(void)xen_blkbk_discard(xbt, be);
>  
> -	/* If we can't advertise it is OK. */
> -	err = xen_blkbk_barrier(xbt, be, be->blkif->vbd.flush_support);
> +	(void)xen_blkbk_barrier(xbt, be, be->blkif->vbd.flush_support);

The casts here are bogus in any case. Even more, the functions can
now easily be declared to return "void", as they don't have a caller
caring for their return value anymore (xen_blkbk_discard() should
even be "static").

Jan

>  
>  	err = xenbus_printf(xbt, dev->nodename, "sectors", "%llu",
>  			    (unsigned long long)vbd_sz(&be->blkif->vbd));


