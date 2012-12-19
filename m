Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab2LSUPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 15:15:51 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:35382 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2LSUPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 15:15:44 -0500
Date: Wed, 19 Dec 2012 15:14:48 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Olaf Hering <olaf@aepfle.de>, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen/blkback: prevent repeated backend_changed invocations
Message-ID: <20121219201448.GH15037@phenom.dumpdata.com>
References: <1355259026-16946-1-git-send-email-olaf@aepfle.de>
 <50C9FC0302000078000B0344@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C9FC0302000078000B0344@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 03:02:11PM +0000, Jan Beulich wrote:
> >>> On 11.12.12 at 21:50, Olaf Hering <olaf@aepfle.de> wrote:
> > backend_changed might be called multiple times, which will leak
> > be->mode. Make sure it will be called only once. Remove some unneeded
> > checks. Also the be->mode string was leaked, release the memory on
> > device shutdown.
> 
> So I decided to make an attempt myself, retaining the current
> behavior of allowing multiple calls, yet not having to sprinkle
> around multiple kfree()-s for be->mode. Slightly re-structuring
> the function made this pretty strait forward.

<nods> Would it be possible to post a patch?

> 
> Jan
> 
> > Signed-off-by: Olaf Hering <olaf@aepfle.de>
> > ---
> > 
> > incorporate all comments from Jan.
> > fold the oneline change to xen_blkbk_remove into this change
> > now its compile tested.
> > 
> >  drivers/block/xen-blkback/xenbus.c | 69 ++++++++++++++++++--------------------
> >  1 file changed, 33 insertions(+), 36 deletions(-)
> > 
> > diff --git a/drivers/block/xen-blkback/xenbus.c 
> > b/drivers/block/xen-blkback/xenbus.c
> > index f58434c..5ca77c3 100644
> > --- a/drivers/block/xen-blkback/xenbus.c
> > +++ b/drivers/block/xen-blkback/xenbus.c
> > @@ -28,6 +28,7 @@ struct backend_info {
> >  	unsigned		major;
> >  	unsigned		minor;
> >  	char			*mode;
> > +	unsigned		alive;
> >  };
> >  
> >  static struct kmem_cache *xen_blkif_cachep;
> > @@ -366,6 +367,7 @@ static int xen_blkbk_remove(struct xenbus_device *dev)
> >  		be->blkif = NULL;
> >  	}
> >  
> > +	kfree(be->mode);
> >  	kfree(be);
> >  	dev_set_drvdata(&dev->dev, NULL);
> >  	return 0;
> > @@ -501,10 +503,14 @@ static void backend_changed(struct xenbus_watch *watch,
> >  		= container_of(watch, struct backend_info, backend_watch);
> >  	struct xenbus_device *dev = be->dev;
> >  	int cdrom = 0;
> > -	char *device_type;
> > +	char *device_type, *p;
> > +	long handle;
> >  
> >  	DPRINTK("");
> >  
> > +	if (be->alive)
> > +		return;
> > +
> >  	err = xenbus_scanf(XBT_NIL, dev->nodename, "physical-device", "%x:%x",
> >  			   &major, &minor);
> >  	if (XENBUS_EXIST_ERR(err)) {
> > @@ -520,12 +526,7 @@ static void backend_changed(struct xenbus_watch *watch,
> >  		return;
> >  	}
> >  
> > -	if ((be->major || be->minor) &&
> > -	    ((be->major != major) || (be->minor != minor))) {
> > -		pr_warn(DRV_PFX "changing physical device (from %x:%x to %x:%x) not 
> > supported.\n",
> > -			be->major, be->minor, major, minor);
> > -		return;
> > -	}
> > +	be->alive = 1;
> >  
> >  	be->mode = xenbus_read(XBT_NIL, dev->nodename, "mode", NULL);
> >  	if (IS_ERR(be->mode)) {
> > @@ -541,39 +542,35 @@ static void backend_changed(struct xenbus_watch *watch,
> >  		kfree(device_type);
> >  	}
> >  
> > -	if (be->major == 0 && be->minor == 0) {
> > -		/* Front end dir is a number, which is used as the handle. */
> > -
> > -		char *p = strrchr(dev->otherend, '/') + 1;
> > -		long handle;
> > -		err = strict_strtoul(p, 0, &handle);
> > -		if (err)
> > -			return;
> > -
> > -		be->major = major;
> > -		be->minor = minor;
> > +	/* Front end dir is a number, which is used as the handle. */
> > +	p = strrchr(dev->otherend, '/') + 1;
> > +	err = strict_strtoul(p, 0, &handle);
> > +	if (err)
> > +		return;
> >  
> > -		err = xen_vbd_create(be->blkif, handle, major, minor,
> > -				 (NULL == strchr(be->mode, 'w')), cdrom);
> > -		if (err) {
> > -			be->major = 0;
> > -			be->minor = 0;
> > -			xenbus_dev_fatal(dev, err, "creating vbd structure");
> > -			return;
> > -		}
> > +	be->major = major;
> > +	be->minor = minor;
> >  
> > -		err = xenvbd_sysfs_addif(dev);
> > -		if (err) {
> > -			xen_vbd_free(&be->blkif->vbd);
> > -			be->major = 0;
> > -			be->minor = 0;
> > -			xenbus_dev_fatal(dev, err, "creating sysfs entries");
> > -			return;
> > -		}
> > +	err = xen_vbd_create(be->blkif, handle, major, minor,
> > +			 (NULL == strchr(be->mode, 'w')), cdrom);
> > +	if (err) {
> > +		be->major = 0;
> > +		be->minor = 0;
> > +		xenbus_dev_fatal(dev, err, "creating vbd structure");
> > +		return;
> > +	}
> >  
> > -		/* We're potentially connected now */
> > -		xen_update_blkif_status(be->blkif);
> > +	err = xenvbd_sysfs_addif(dev);
> > +	if (err) {
> > +		xen_vbd_free(&be->blkif->vbd);
> > +		be->major = 0;
> > +		be->minor = 0;
> > +		xenbus_dev_fatal(dev, err, "creating sysfs entries");
> > +		return;
> >  	}
> > +
> > +	/* We're potentially connected now */
> > +	xen_update_blkif_status(be->blkif);
> >  }
> >  
> >  
> > -- 
> > 1.8.0.1
> 
> 
