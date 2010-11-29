Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab0K2WdD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:33:03 -0500
Received: from kroah.org ([198.145.64.141]:49259 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709Ab0K2Wcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:32:43 -0500
Date: Mon, 29 Nov 2010 14:32:09 -0800
From: Greg KH <greg@kroah.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] core: add a function to safely try to get device
 driver owner
Message-ID: <20101129223209.GB14663@kroah.com>
References: <Pine.LNX.4.64.1011292043000.27962@axis700.grange>
 <20101129131737.3dd6eb03@bike.lwn.net>
 <Pine.LNX.4.64.1011292147540.27962@axis700.grange>
 <20101129214128.GA9691@kroah.com>
 <Pine.LNX.4.64.1011292300300.27962@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1011292300300.27962@axis700.grange>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 11:10:50PM +0100, Guennadi Liakhovetski wrote:
> On Mon, 29 Nov 2010, Greg KH wrote:
> 
> > On Mon, Nov 29, 2010 at 09:54:10PM +0100, Guennadi Liakhovetski wrote:
> > > Hi Jon
> > > 
> > > On Mon, 29 Nov 2010, Jonathan Corbet wrote:
> > > 
> > > > On Mon, 29 Nov 2010 20:43:28 +0100 (CET)
> > > > Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > > > 
> > > > > When two drivers interoperate without an explicit dependency, it is often
> > > > > required to prevent one of them from being unloaded safely by dereferencing
> > > > > dev->driver->owner. This patch provides a generic function to do this in a
> > > > > race-free way.
> > > > 
> > > > I must ask: why not, instead, make the dependency explicit?  In
> > > > particular, this looks like an application for the proposed media
> > > > controller code, which is meant to model the connections between otherwise
> > > > independent devices.  The fact that your example comes from V4L2 (which is
> > > > the current domain of the media controller) also argues that way.
> > > 
> > > Sorry, don't see a good way to do this. This function is for a general 
> > > dependency, where you don't have that driver, we are checking for register 
> > > with us, so, the only way to get to it is via dev->driver->owner.
> > 
> > Wait, what?  The device is already bound to a driver, right, so why
> > would you care about "locking" the module into memory?  What could this
> > possibly be used for?
> 
> To protect against rmmod -> driver_unregister -> dev->driver = NULL?

But again, why would some other driver ever care about what some random
dev->driver would be?

> > > And I also don't want to move registering the device into the
> > > dependant driver and then wait (with a timeout) for a driver to probe
> > > with it... I just want to verify, whether a driver has attached to
> > > that device and whether I can lock it down.
> > 
> > Who cares if a driver is attached to any device?  And again, why would
> > you want to "lock it down"?
> 
> In my case I have two platform devices: CEU and CSI2. In some cases (with 
> parallel sensors) CEU operates on its own. With serial (CSI-2) camera 
> sensors we need the CSI2 driver. So, I want to 
> try_module_get(csi2_dev->driver->owner) the CSI2 driver from my CEU 
> driver. This call can Oops if not done safely. Am I missing something? Is 
> there an easier way to achieve the same?

Yes, from userspace load the module and then don't worry about it.

Don't ever think that poking around in a dev->driver field is safe at
all, it isn't.  I should just go hide the thing from the rest of the
kernel to keep this from happening, now that you mention it...

thanks,

greg k-h
