Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab0K2WK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:10:57 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:52105 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab0K2WK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:10:56 -0500
Date: Mon, 29 Nov 2010 23:10:50 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Greg KH <greg@kroah.com>
cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] core: add a function to safely try to get device
 driver owner
In-Reply-To: <20101129214128.GA9691@kroah.com>
Message-ID: <Pine.LNX.4.64.1011292300300.27962@axis700.grange>
References: <Pine.LNX.4.64.1011292043000.27962@axis700.grange>
 <20101129131737.3dd6eb03@bike.lwn.net> <Pine.LNX.4.64.1011292147540.27962@axis700.grange>
 <20101129214128.GA9691@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:84lWORYiNNkBuvy1XgUcg+z8u6sobVNgzSFcD/STRzC
 ogSm1o66w3sX8+48BrZwyDxpmw/0eQ8rpa/kYnYQ5UyMUNsHNw
 5ZiLiCB9jIelXHYbOAtqOYNnJKpemEAKXe6V9NBopSE3Zyp+lh
 QkekT1yT2W2sW55nswypKxdTnHJKgVQ4Qwl/vASclusXf23Ek5
 QFrqlzCiYHPL517N+zIiiaCKrks00qxWj2mXipSOxM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010, Greg KH wrote:

> On Mon, Nov 29, 2010 at 09:54:10PM +0100, Guennadi Liakhovetski wrote:
> > Hi Jon
> > 
> > On Mon, 29 Nov 2010, Jonathan Corbet wrote:
> > 
> > > On Mon, 29 Nov 2010 20:43:28 +0100 (CET)
> > > Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > > 
> > > > When two drivers interoperate without an explicit dependency, it is often
> > > > required to prevent one of them from being unloaded safely by dereferencing
> > > > dev->driver->owner. This patch provides a generic function to do this in a
> > > > race-free way.
> > > 
> > > I must ask: why not, instead, make the dependency explicit?  In
> > > particular, this looks like an application for the proposed media
> > > controller code, which is meant to model the connections between otherwise
> > > independent devices.  The fact that your example comes from V4L2 (which is
> > > the current domain of the media controller) also argues that way.
> > 
> > Sorry, don't see a good way to do this. This function is for a general 
> > dependency, where you don't have that driver, we are checking for register 
> > with us, so, the only way to get to it is via dev->driver->owner.
> 
> Wait, what?  The device is already bound to a driver, right, so why
> would you care about "locking" the module into memory?  What could this
> possibly be used for?

To protect against rmmod -> driver_unregister -> dev->driver = NULL?

> > And I also don't want to move registering the device into the
> > dependant driver and then wait (with a timeout) for a driver to probe
> > with it... I just want to verify, whether a driver has attached to
> > that device and whether I can lock it down.
> 
> Who cares if a driver is attached to any device?  And again, why would
> you want to "lock it down"?

In my case I have two platform devices: CEU and CSI2. In some cases (with 
parallel sensors) CEU operates on its own. With serial (CSI-2) camera 
sensors we need the CSI2 driver. So, I want to 
try_module_get(csi2_dev->driver->owner) the CSI2 driver from my CEU 
driver. This call can Oops if not done safely. Am I missing something? Is 
there an easier way to achieve the same?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
