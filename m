Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424071Ab2LGTqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 14:46:47 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45798 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab2LGTqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 14:46:45 -0500
Date: Fri, 7 Dec 2012 14:46:35 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Olaf Hering <olaf@aepfle.de>, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen/blkback: prevent leak of mode during multiple
 backend_changed calls
Message-ID: <20121207194635.GA8782@phenom.dumpdata.com>
References: <1354701697-5815-1-git-send-email-olaf@aepfle.de>
 <50BF2E3802000078000AE162@nat28.tlf.novell.com>
 <20121206162304.GA3989@aepfle.de>
 <50C0DDCA02000078000AEBA9@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C0DDCA02000078000AEBA9@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 05:02:50PM +0000, Jan Beulich wrote:
> >>> On 06.12.12 at 17:23, Olaf Hering <olaf@aepfle.de> wrote:
> > On Wed, Dec 05, Jan Beulich wrote:
> > 
> >> >>> On 05.12.12 at 11:01, Olaf Hering <olaf@aepfle.de> wrote:
> >> > backend_changed might be called multiple times, which will leak
> >> > be->mode. free the previous value before storing the current mode value.
> >> 
> >> As said before - this is one possible route to take. But did you
> >> consider at all the alternative of preventing the function from
> >> getting called more than once for a given device? As also said
> >> before, I think that would have other bad effects, and hence
> >> should be preferred (and would likely also result in a smaller
> >> patch).
> > 
> > Maybe it could be done like this, adding a flag to the backend device
> > and exit early if its called twice.
> 
> Maybe, but it looks odd to me. But then again I had hoped Konrad
> would have an opinion here...

Sorry - was lurking around and hadn't paid any attention to this thread.
And it does not help that next week I am out :-)

> 
> Also I don't see why you need to free be->mode now on all error
> paths - afaict it would still get freed when "be" gets freed (with
> your earlier patch).
> 
> Jan
> 
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
> > @@ -506,6 +507,9 @@ static void backend_changed(struct xenbus_watch *watch,
> >  
> >  	DPRINTK("");
> >  
> > +	if (be->alive)
> > +		return;
> > +
> >  	err = xenbus_scanf(XBT_NIL, dev->nodename, "physical-device", "%x:%x",
> >  			   &major, &minor);
> >  	if (XENBUS_EXIST_ERR(err)) {
> > @@ -548,8 +552,11 @@ static void backend_changed(struct xenbus_watch *watch,
> >  		char *p = strrchr(dev->otherend, '/') + 1;
> >  		long handle;
> >  		err = strict_strtoul(p, 0, &handle);
> > -		if (err)
> > +		if (err) {
> > +			kfree(be->mode);
> > +			be->mode = NULL;
> >  			return;
> > +		}
> >  
> >  		be->major = major;
> >  		be->minor = minor;
> > @@ -560,6 +567,8 @@ static void backend_changed(struct xenbus_watch *watch,
> >  			be->major = 0;
> >  			be->minor = 0;
> >  			xenbus_dev_fatal(dev, err, "creating vbd structure");
> > +			kfree(be->mode);
> > +			be->mode = NULL;
> >  			return;
> >  		}
> >  
> > @@ -569,10 +578,13 @@ static void backend_changed(struct xenbus_watch 
> > *watch,
> >  			be->major = 0;
> >  			be->minor = 0;
> >  			xenbus_dev_fatal(dev, err, "creating sysfs entries");
> > +			kfree(be->mode);
> > +			be->mode = NULL;
> >  			return;
> >  		}
> >  
> >  		/* We're potentially connected now */
> > +		be->alive = 1;
> >  		xen_update_blkif_status(be->blkif);
> >  	}
> >  }
> > -- 
> > 1.8.0.1
> 
> 
> 
