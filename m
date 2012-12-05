Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab2LEKVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 05:21:33 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:52945 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab2LEKVc convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Wed, 5 Dec 2012 05:21:32 -0500
Message-Id: <50BF2E3802000078000AE162@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Wed, 05 Dec 2012 10:21:28 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Olaf Hering" <olaf@aepfle.de>, <konrad.wilk@oracle.com>
Cc: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/blkback: prevent leak of mode during multiple
 backend_changed calls
References: <1354701697-5815-1-git-send-email-olaf@aepfle.de>
In-Reply-To: <1354701697-5815-1-git-send-email-olaf@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 05.12.12 at 11:01, Olaf Hering <olaf@aepfle.de> wrote:
> backend_changed might be called multiple times, which will leak
> be->mode. free the previous value before storing the current mode value.

As said before - this is one possible route to take. But did you
consider at all the alternative of preventing the function from
getting called more than once for a given device? As also said
before, I think that would have other bad effects, and hence
should be preferred (and would likely also result in a smaller
patch).

And _if_ this here is the route to go, I'd clearly see this and your
earlier patch to be folded into just one (dealing with both leaks
in one go).

Jan

> Signed-off-by: Olaf Hering <olaf@aepfle.de>
> ---
> 
> !! Not compile tested !!
> 
>  drivers/block/xen-blkback/xenbus.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/block/xen-blkback/xenbus.c 
> b/drivers/block/xen-blkback/xenbus.c
> index a6585a4..8650b19 100644
> --- a/drivers/block/xen-blkback/xenbus.c
> +++ b/drivers/block/xen-blkback/xenbus.c
> @@ -502,7 +502,7 @@ static void backend_changed(struct xenbus_watch *watch,
>  		= container_of(watch, struct backend_info, backend_watch);
>  	struct xenbus_device *dev = be->dev;
>  	int cdrom = 0;
> -	char *device_type;
> +	char *mode, *device_type;
>  
>  	DPRINTK("");
>  
> @@ -528,13 +528,15 @@ static void backend_changed(struct xenbus_watch *watch,
>  		return;
>  	}
>  
> -	be->mode = xenbus_read(XBT_NIL, dev->nodename, "mode", NULL);
> -	if (IS_ERR(be->mode)) {
> -		err = PTR_ERR(be->mode);
> +	mode = xenbus_read(XBT_NIL, dev->nodename, "mode", NULL);
> +	kfree(be->mode);
> +	if (IS_ERR(mode)) {
> +		err = PTR_ERR(mode);
>  		be->mode = NULL;
>  		xenbus_dev_fatal(dev, err, "reading mode");
>  		return;
>  	}
> +	be->mode = mode;
>  
>  	device_type = xenbus_read(XBT_NIL, dev->otherend, "device-type", NULL);
>  	if (!IS_ERR(device_type)) {
> @@ -555,7 +557,7 @@ static void backend_changed(struct xenbus_watch *watch,
>  		be->minor = minor;
>  
>  		err = xen_vbd_create(be->blkif, handle, major, minor,
> -				 (NULL == strchr(be->mode, 'w')), cdrom);
> +				 (NULL == strchr(mode, 'w')), cdrom);
>  		if (err) {
>  			be->major = 0;
>  			be->minor = 0;
> -- 
> 1.8.0.1



