Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424553Ab2LFRC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 12:02:59 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:50062 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab2LFRC6 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Thu, 6 Dec 2012 12:02:58 -0500
Message-Id: <50C0DDCA02000078000AEBA9@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Thu, 06 Dec 2012 17:02:50 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Olaf Hering" <olaf@aepfle.de>
Cc: <xen-devel@lists.xen.org>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/blkback: prevent leak of mode during multiple
 backend_changed calls
References: <1354701697-5815-1-git-send-email-olaf@aepfle.de>
 <50BF2E3802000078000AE162@nat28.tlf.novell.com>
 <20121206162304.GA3989@aepfle.de>
In-Reply-To: <20121206162304.GA3989@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.12.12 at 17:23, Olaf Hering <olaf@aepfle.de> wrote:
> On Wed, Dec 05, Jan Beulich wrote:
> 
>> >>> On 05.12.12 at 11:01, Olaf Hering <olaf@aepfle.de> wrote:
>> > backend_changed might be called multiple times, which will leak
>> > be->mode. free the previous value before storing the current mode value.
>> 
>> As said before - this is one possible route to take. But did you
>> consider at all the alternative of preventing the function from
>> getting called more than once for a given device? As also said
>> before, I think that would have other bad effects, and hence
>> should be preferred (and would likely also result in a smaller
>> patch).
> 
> Maybe it could be done like this, adding a flag to the backend device
> and exit early if its called twice.

Maybe, but it looks odd to me. But then again I had hoped Konrad
would have an opinion here...

Also I don't see why you need to free be->mode now on all error
paths - afaict it would still get freed when "be" gets freed (with
your earlier patch).

Jan

> --- a/drivers/block/xen-blkback/xenbus.c
> +++ b/drivers/block/xen-blkback/xenbus.c
> @@ -28,6 +28,7 @@ struct backend_info {
>  	unsigned		major;
>  	unsigned		minor;
>  	char			*mode;
> +	unsigned		alive;
>  };
>  
>  static struct kmem_cache *xen_blkif_cachep;
> @@ -506,6 +507,9 @@ static void backend_changed(struct xenbus_watch *watch,
>  
>  	DPRINTK("");
>  
> +	if (be->alive)
> +		return;
> +
>  	err = xenbus_scanf(XBT_NIL, dev->nodename, "physical-device", "%x:%x",
>  			   &major, &minor);
>  	if (XENBUS_EXIST_ERR(err)) {
> @@ -548,8 +552,11 @@ static void backend_changed(struct xenbus_watch *watch,
>  		char *p = strrchr(dev->otherend, '/') + 1;
>  		long handle;
>  		err = strict_strtoul(p, 0, &handle);
> -		if (err)
> +		if (err) {
> +			kfree(be->mode);
> +			be->mode = NULL;
>  			return;
> +		}
>  
>  		be->major = major;
>  		be->minor = minor;
> @@ -560,6 +567,8 @@ static void backend_changed(struct xenbus_watch *watch,
>  			be->major = 0;
>  			be->minor = 0;
>  			xenbus_dev_fatal(dev, err, "creating vbd structure");
> +			kfree(be->mode);
> +			be->mode = NULL;
>  			return;
>  		}
>  
> @@ -569,10 +578,13 @@ static void backend_changed(struct xenbus_watch 
> *watch,
>  			be->major = 0;
>  			be->minor = 0;
>  			xenbus_dev_fatal(dev, err, "creating sysfs entries");
> +			kfree(be->mode);
> +			be->mode = NULL;
>  			return;
>  		}
>  
>  		/* We're potentially connected now */
> +		be->alive = 1;
>  		xen_update_blkif_status(be->blkif);
>  	}
>  }
> -- 
> 1.8.0.1



