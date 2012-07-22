Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab2GVCH4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 22:07:56 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51675 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973Ab2GVCHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 22:07:48 -0400
X-Sasl-enc: Z2I8PM5gn1QI/GAYbeOqDLfqYAV6a+uWNt6rJQyU6dLm 1342922867
Date: Sat, 21 Jul 2012 19:07:46 -0700
From: Greg KH <greg@kroah.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the staging tree with the
 target-merge tree
Message-ID: <20120722020746.GB31926@kroah.com>
References: <20120719145301.b8992aa986b47d7c44651710@canb.auug.org.au>
 <20120719235523.GA13623@kroah.com>
 <1342806778.25472.1.camel@haakon2.linux-iscsi.org>
 <20120720180358.GA9134@kroah.com>
 <20120720184228.GA19243@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120720184228.GA19243@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 09:42:28PM +0300, Michael S. Tsirkin wrote:
> On Fri, Jul 20, 2012 at 11:03:58AM -0700, Greg KH wrote:
> > On Fri, Jul 20, 2012 at 10:52:58AM -0700, Nicholas A. Bellinger wrote:
> > > Hi Greg,
> > > 
> > > On Thu, 2012-07-19 at 16:55 -0700, Greg KH wrote:
> > > > On Thu, Jul 19, 2012 at 02:53:01PM +1000, Stephen Rothwell wrote:
> > > > > Hi Greg,
> > > > > 
> > > > > Today's linux-next merge of the staging tree got a conflict in
> > > > > drivers/staging/Kconfig between commit d0146d396bfa ("tcm_vhost: Initial
> > > > > merge for vhost level target fabric driver") from the target-merge tree
> > > > > and commit 15a4bc17b7f4 ("Staging: add CSR Wifi "os helper" module") from
> > > > > the staging tree.
> > > > > 
> > > > > Just context changes.  I fixed it up (see below) and can carry the fix as
> > > > > necessary.
> > > > > -- 
> > > > > Cheers,
> > > > > Stephen Rothwell                    sfr@canb.auug.org.au
> > > > > 
> > > > > diff --cc drivers/staging/Kconfig
> > > > > index 67ec9fe,e3402d5..0000000
> > > > > --- a/drivers/staging/Kconfig
> > > > > +++ b/drivers/staging/Kconfig
> > > > > @@@ -132,6 -132,8 +132,10 @@@ source "drivers/staging/ipack/Kconfig
> > > > >   
> > > > >   source "drivers/staging/gdm72xx/Kconfig"
> > > > >   
> > > > > + source "drivers/staging/csr/Kconfig"
> > > > > + 
> > > > > + source "drivers/staging/omap-thermal/Kconfig"
> > > > > + 
> > > > >  +source "drivers/vhost/Kconfig.tcm"
> > > > 
> > > > Why is someone putting a non drivers/staging/ Kconfig file here in
> > > > drivers/staging/Kconfig?  That's not ok at all.
> > > > 
> > > > Target people, please just depend on CONFIG_STAGING if you want to do
> > > > that, but don't mess with files in the drivers/staging/ directory for no
> > > > good reason at all.
> > > > 
> > > 
> > > This was a request from MST (CC'ed) in order to have TCM_VHOST show up
> > > under the staging configuration options..
> > 
> > If you really want it to show up there, then send me a patch adding the
> > code to drivers/staging/.  Otherwise it really makes no sense.
> > 
> > > If that's really not what should be done, I'm happy to drop this part
> > > and just use CONFIG_STAGING again.
> > 
> > Why are you wanting to depend on CONFIG_STAGING in the first place?
> > What is wrong with the code that it can't be merged "properly" now?
> > Don't use CONFIG_STAGING as a "crutch" unless you really need it.
> > 
> > thanks,
> > 
> > greg k-h
> 
> It's very similar to how it was with nouveau: we are not sure
> we can commit to the userspace ABI yet.

Then you are in trouble :)

> Most importantly, it still seems not 100% clear whether this driver will
> have major userspace using it. And if not, it would be very hard to
> support a driver when recent userspace does not use it in the end.
> 
> At the moment arguments on upstream mailing list seem to be
> a bit circular: there's no module in upstream kernel so
> userspace does not want to accept the patches.
> 
> If we put enabling this driver in staging, then it works out in one of
> two ways
> - userspace starts using it then this effectively freezes the ABI and
>   we move it out of staging next release
> - no userspace uses it and we drop it completely or rework ABI
> 
> On the other hand, it is marginally better to not want code in staging
> for two reasons:
> - there are dependencies between this code and other code in
>   drivers/vhost which are easier for me to handle if it's all
>   in one place

If there are going to be lots of dependancies, then I don't want it in
drivers/staging/ as it doesn't belong there, it belongs cleaned up and
in the "real" place.

> - a bit easier to track history if we do not move code

git preserves this, don't worry about that at all.

So, if this code really does depend on core vhost changes that are going
to be happening over time, I would not recommend it being in
drivers/staging/ as you are right, you are going to have a hard time
syncing with me.

But don't think that by somehow marking the driver with CONFIG_STAGING
that you get a free pass on the "we are going to break the userspace
api", that's not ok.  Be careful about this.  Yes, it's tough, and it's
a "chicken and egg" problem like you mention above, I know.

sorry,

greg k-h
