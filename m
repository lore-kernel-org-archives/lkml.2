Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab0K3RJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:09:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56042 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab0K3RJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:09:50 -0500
Date: Tue, 30 Nov 2010 18:09:46 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Greg KH <greg@kroah.com>
cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH/RFC] core: add a function to safely try to get device
 driver owner
In-Reply-To: <20101130165614.GA18564@kroah.com>
Message-ID: <Pine.LNX.4.64.1011301803540.18790@axis700.grange>
References: <Pine.LNX.4.64.1011292043000.27962@axis700.grange>
 <20101129131737.3dd6eb03@bike.lwn.net> <Pine.LNX.4.64.1011292147540.27962@axis700.grange>
 <20101129214128.GA9691@kroah.com> <Pine.LNX.4.64.1011292300300.27962@axis700.grange>
 <20101129223209.GB14663@kroah.com> <Pine.LNX.4.64.1011300009500.27962@axis700.grange>
 <20101130165614.GA18564@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:+8kkP9q7Wdd7R5nsLP3Im3BgvvlgERCJv7OZkjqDzS4
 rzWJyqt3dPjXQZ1RFHD+JKEn7NP1CDjkIRMXC5wKUUGmyDogLX
 4IZimrznBANAMQ88LVX/B3jjNGbre6nd4eDs1ACcEsal/ZVMjw
 0NfhZEnDMqaINEtNickb7xqnSbp7W3ivJgbl14Im5THofR7hTC
 VtxiMqTNPF4BkVLCigg/+G9B10KbcehabLJunwXDuw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010, Greg KH wrote:

> On Tue, Nov 30, 2010 at 12:11:42AM +0100, Guennadi Liakhovetski wrote:
> > On Mon, 29 Nov 2010, Greg KH wrote:
> > 
> > > On Mon, Nov 29, 2010 at 11:10:50PM +0100, Guennadi Liakhovetski wrote:
> > > > On Mon, 29 Nov 2010, Greg KH wrote:
> > > > 
> > > > > On Mon, Nov 29, 2010 at 09:54:10PM +0100, Guennadi Liakhovetski wrote:
> > > > > > Hi Jon
> > > > > > 
> > > > > > On Mon, 29 Nov 2010, Jonathan Corbet wrote:
> > > > > > 
> > > > > > > On Mon, 29 Nov 2010 20:43:28 +0100 (CET)
> > > > > > > Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > > > > > > 
> > > > > > > > When two drivers interoperate without an explicit dependency, it is often
> > > > > > > > required to prevent one of them from being unloaded safely by dereferencing
> > > > > > > > dev->driver->owner. This patch provides a generic function to do this in a
> > > > > > > > race-free way.
> > > > > > > 
> > > > > > > I must ask: why not, instead, make the dependency explicit?  In
> > > > > > > particular, this looks like an application for the proposed media
> > > > > > > controller code, which is meant to model the connections between otherwise
> > > > > > > independent devices.  The fact that your example comes from V4L2 (which is
> > > > > > > the current domain of the media controller) also argues that way.
> > > > > > 
> > > > > > Sorry, don't see a good way to do this. This function is for a general 
> > > > > > dependency, where you don't have that driver, we are checking for register 
> > > > > > with us, so, the only way to get to it is via dev->driver->owner.
> > > > > 
> > > > > Wait, what?  The device is already bound to a driver, right, so why
> > > > > would you care about "locking" the module into memory?  What could this
> > > > > possibly be used for?
> > > > 
> > > > To protect against rmmod -> driver_unregister -> dev->driver = NULL?
> > > 
> > > But again, why would some other driver ever care about what some random
> > > dev->driver would be?
> > 
> > It's not a random one, call it a "companion device."
> 
> Ok, but again go back to Jon's original proposal to just call the
> functions in that driver from yours, causing the implicit module
> ordering issue to be automatically resolved.

Greg, in this specific case - yes, I could do this. But (1) there is no 
need for that - both drivers implement and use the v4l2-subdev API and 
thus stay generic. In the host driver this adds the convenience, that it 
doesn't have to call to the CSI2 driver explicitly at all - it just calls 
the v4l2-subdev function like "call .s_mbus_fmt for all subdev drivers" 
and the function is called for the sensor and the CSI2 driver. (2) what 
about the other location I pointed out earlier in the v4l2 core? There 
drivers are absolutely generic. I also suspect these are not the only 
cases, where this helper would come in handy. I added the media list to CC 
for any more opinions on this matter.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
