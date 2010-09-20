Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab0ITPN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 11:13:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49629 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427Ab0ITPN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 11:13:26 -0400
Date: Mon, 20 Sep 2010 08:10:29 -0700
From: Greg KH <gregkh@suse.de>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Dan Carpenter <error27@gmail.com>, Vasiliy Kulikov <segooon@gmail.com>,
        kernel-janitors@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>,
        Benny Halevy <bhalevy@panasas.com>, Tejun Heo <tj@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, osd-dev@open-osd.org,
        linux-scsi@vger.kernel.org, cornelia.huck@de.ibm.com,
        linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 10/14] scsi: osd: fix device_register() error handling
Message-ID: <20100920151029.GA25386@suse.de>
References: <1284900907-24621-1-git-send-email-segooon@gmail.com>
 <20100919142653.GF6236@bicker>
 <1284983897.2973.11.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284983897.2973.11.camel@mulgrave.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 06:58:17AM -0500, James Bottomley wrote:
> On Sun, 2010-09-19 at 16:26 +0200, Dan Carpenter wrote:
> > On Sun, Sep 19, 2010 at 04:55:07PM +0400, Vasiliy Kulikov wrote:
> > > If device_register() fails then call put_device().
> > > See comment to device_register.
> > > 
> > > Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> > > ---
> > >  compile tested.
> > > 
> > >  drivers/scsi/osd/osd_uld.c |    4 +++-
> > >  1 files changed, 3 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
> > > index cefb2c0..3e0edc2 100644
> > > --- a/drivers/scsi/osd/osd_uld.c
> > > +++ b/drivers/scsi/osd/osd_uld.c
> > > @@ -474,7 +474,7 @@ static int osd_probe(struct device *dev)
> > >  	error = device_register(&oud->class_dev);
> > >  	if (error) {
> > >  		OSD_ERR("device_register failed => %d\n", error);
> > > -		goto err_put_cdev;
> > > +		goto err_put_device;
> > >  	}
> > >  
> > >  	get_device(&oud->class_dev);
> > > @@ -482,6 +482,8 @@ static int osd_probe(struct device *dev)
> > >  	OSD_INFO("osd_probe %s\n", disk->disk_name);
> > >  	return 0;
> > >  
> > 
> > Hm...  So if device_register() fails then we should always call
> > device_put()?  It seems like a lot of existing code does that but I
> > hadn't realized until now that that is how it works.
> 
> Heh, it wasn't a bug when most of the code was written.  It became a bug
> when dev_set_name() was added because now the storage allocated for the
> name has to be freed with a put.  Previous to this, the advice was just
> to free the device if device_register() failed.
> 
> > Why can't the device_put() just be added inside the device_register() so
> > the unwinding works automatically?
> 
> Since Greg and Kay didn't actually alter any of the device_register()
> failure paths, this does sound to be the better course of action ... of
> course, every device_register() introduced after the dev_set_name()
> change may call put_device() on the cleanup path ... someone needs to
> check.

Yes, this patch series should not be needed at all.  If there's a
problem with the driver core here, it should be fixed, not forcing the
issue to all of the individual callers.

Vasiliy, can you please do that instead?

thanks,

greg k-h
