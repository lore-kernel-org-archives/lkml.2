Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab0K3Sce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 13:32:34 -0500
Received: from kroah.org ([198.145.64.141]:34367 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab0K3Scd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 13:32:33 -0500
Date: Tue, 30 Nov 2010 10:32:25 -0800
From: Greg KH <greg@kroah.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH/RFC] core: add a function to safely try to get device
 driver owner
Message-ID: <20101130183225.GA27680@kroah.com>
References: <Pine.LNX.4.64.1011292043000.27962@axis700.grange>
 <Pine.LNX.4.64.1011301803540.18790@axis700.grange>
 <20101130171509.GA18794@kroah.com>
 <201011301855.56228.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011301855.56228.laurent.pinchart@ideasonboard.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 06:55:54PM +0100, Laurent Pinchart wrote:
> Hi Greg,
> 
> On Tuesday 30 November 2010 18:15:09 Greg KH wrote:
> > On Tue, Nov 30, 2010 at 06:09:46PM +0100, Guennadi Liakhovetski wrote:
> > > On Tue, 30 Nov 2010, Greg KH wrote:
> > > > On Tue, Nov 30, 2010 at 12:11:42AM +0100, Guennadi Liakhovetski wrote:
> > > > > On Mon, 29 Nov 2010, Greg KH wrote:
> > > > > > On Mon, Nov 29, 2010 at 11:10:50PM +0100, Guennadi Liakhovetski 
> wrote:
> > > > > > > On Mon, 29 Nov 2010, Greg KH wrote:
> 
> [snip]
> 
> > > > > > > > Wait, what?  The device is already bound to a driver, right, so
> > > > > > > > why would you care about "locking" the module into memory? 
> > > > > > > > What could this possibly be used for?
> > > > > > > 
> > > > > > > To protect against rmmod -> driver_unregister -> dev->driver =
> > > > > > > NULL?
> > > > > > 
> > > > > > But again, why would some other driver ever care about what some
> > > > > > random dev->driver would be?
> > > > > 
> > > > > It's not a random one, call it a "companion device."
> > > > 
> > > > Ok, but again go back to Jon's original proposal to just call the
> > > > functions in that driver from yours, causing the implicit module
> > > > ordering issue to be automatically resolved.
> > > 
> > > Greg, in this specific case - yes, I could do this. But (1) there is no
> > > need for that - both drivers implement and use the v4l2-subdev API and
> > > thus stay generic. In the host driver this adds the convenience, that it
> > > doesn't have to call to the CSI2 driver explicitly at all - it just calls
> > > the v4l2-subdev function like "call .s_mbus_fmt for all subdev drivers"
> > > and the function is called for the sensor and the CSI2 driver. (2) what
> > > about the other location I pointed out earlier in the v4l2 core? There
> > > drivers are absolutely generic. I also suspect these are not the only
> > > cases, where this helper would come in handy. I added the media list to
> > > CC for any more opinions on this matter.
> > 
> > I agree, it probably would not solve all of the different issues that
> > people might have for this type of thing, and this isn't the first time
> > I've heard it be requested either.
> > 
> > But, this patch is just trying to increment a module owner of a device
> > that is bound to a driver, which is the wrong level to be thinking of
> > it.
> > 
> > If you request a module to be loaded, what would possibly cause it to be
> > unbound that you need to have this "safely" in place?  Why would the
> > module be unloaded?  And if it was unloaded, doesn't that imply that
> > someone else wanted it unloaded so keeping that from happening would be
> > a bit rude, right?
> 
> It depends on your definition of rude. I would consider the kernel even more 
> rude if it accepted my unload request and then crashed.

I totally agree, and that is a bug that should be fixed, but shouldn't
have anything to do with this proposed interface (i.e. locking the
module in place is not the proper fix.)

> I've recently run into a problem similar to Guennadi's with the OMAP3 ISP 
> driver. The driver instantiates several V4L2 I2C sub-devices for the camera 
> sensors and the lens and flash controllers. The sub-device drivers get 
> platform data when they're probed, and receive callbacks to the board code to 
> turn power on/off and configure clocks (it's a bit more complex than just 
> that, but you get the idea). The board code callbacks then call to the OMAP3 
> ISP driver to configure clocks, because the sensor clock is provided by the 
> OMAP3 ISP.
> 
> Now, when the user opens the sensor's subdev device node (/dev/v4l-subdev*), 
> the subdev open function will turn the sensor clock on. To do that it will 
> call the OMAP3 ISP driver through board code. If the OMAP3 ISP driver is 
> unloaded at that point things will go pretty bad.

Then the interface to call that driver should be properly reference
counted, right?  That has nothing to do with the driver core locking
modules into place.

> The way we deal with this is to try_module_get() on the OMAP3 ISP driver in 
> the subdev open() handlers. I'm of course opened to alternatives.

Do it like the rest of the kernel does it, lock the module in place with
the module pointer it passed to you before calling open in that module.
Nothing new here at all.

thanks,

greg k-h
