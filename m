Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab3AIJTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 04:19:46 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:38036 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438Ab3AIJTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 04:19:43 -0500
Date: Wed, 9 Jan 2013 01:19:39 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, swarren@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-tegra@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH v2 2/4] input: keyboard: tegra: use devm_* for resource
 allocation
Message-ID: <20130109091939.GA4369@core.coreip.homeip.net>
References: <1357371910-3164-1-git-send-email-ldewangan@nvidia.com>
 <1357371910-3164-3-git-send-email-ldewangan@nvidia.com>
 <20130105080658.GA1315@core.coreip.homeip.net>
 <20130106192739.GA11566@avionic-0098.adnet.avionic-design.de>
 <20130106195748.GA28212@core.coreip.homeip.net>
 <20130109070745.GA12782@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130109070745.GA12782@avionic-0098.adnet.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 08:07:45AM +0100, Thierry Reding wrote:
> On Sun, Jan 06, 2013 at 11:57:48AM -0800, Dmitry Torokhov wrote:
> > On Sun, Jan 06, 2013 at 08:27:39PM +0100, Thierry Reding wrote:
> > > On Sat, Jan 05, 2013 at 12:06:58AM -0800, Dmitry Torokhov wrote:
> > > > On Sat, Jan 05, 2013 at 01:15:08PM +0530, Laxman Dewangan wrote:
> > > [...]
> > > > > @@ -735,25 +738,16 @@ static int tegra_kbc_probe(struct platform_device *pdev)
> > > > >  	spin_lock_init(&kbc->lock);
> > > > >  	setup_timer(&kbc->timer, tegra_kbc_keypress_timer, (unsigned long)kbc);
> > > > >  
> > > > > -	res = request_mem_region(res->start, resource_size(res), pdev->name);
> > > > > -	if (!res) {
> > > > > -		dev_err(&pdev->dev, "failed to request I/O memory\n");
> > > > > -		err = -EBUSY;
> > > > > -		goto err_free_mem;
> > > > > -	}
> > > > > -
> > > > > -	kbc->mmio = ioremap(res->start, resource_size(res));
> > > > > +	kbc->mmio = devm_request_and_ioremap(&pdev->dev, res);
> > > > >  	if (!kbc->mmio) {
> > > > > -		dev_err(&pdev->dev, "failed to remap I/O memory\n");
> > > > > -		err = -ENXIO;
> > > > > -		goto err_free_mem_region;
> > > > > +		dev_err(&pdev->dev, "Cannot request memregion/iomap address\n");
> > > > > +		return -EADDRNOTAVAIL;
> > > > 
> > > > Erm, no, -EBUSY please.
> > > 
> > > EADDRNOTAVAIL is the canonical error for devm_request_and_ioremap()
> > > failure. The kerneldoc comment in lib/devres.c even gives a short
> > > example that uses this error code.
> > 
> > I am sorry, but I do not consider a function that was added a little
> > over a year ago as a canon. If you look at the uses of EADDRNOTAVAIL it
> > is used predominantly in networking code to indicate that attempted
> > _network_ address is not available.
> 
> EBUSY might be misleading, though. devm_request_and_ioremap() can fail
> in both the request_mem_region() and ioremap() calls. Furthermore it'd
> be good to settle on a consistent error-code instead of doing it
> differently depending on subsystem and/or driver. Currently the various
> error codes used are:
> 
> 	EBUSY, EADDRNOTAVAIL, ENXIO, ENOMEM, ENODEV, ENOENT, EINVAL,
> 	EIO, EFAULT, EADDRINUSE
> 
> Also if we can settle on one error code we should follow up with a patch
> to make it consistent across the tree and also update that kerneldoc
> comment. I volunteer to do that if nobody else steps up. I'm also Cc'ing
> Wolfram (the original author), maybe he has some thoughts on this.
> 

If you going to change all drivers make devm_request_and_ioremap()
return ERR_PTR()-encoded errors and then we can differentiate what
part of it failed.

Thanks.

-- 
Dmitry
