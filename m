Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab1IEMt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 08:49:59 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:36368 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab1IEMtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 08:49:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCHv2] ISP:BUILD:FIX: Move media_entity_init() and
Date: Mon, 5 Sep 2011 14:49:50 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.3-gentoo; KDE/4.7.0; x86_64; ; )
Cc: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "Ravi, Deepthy" <deepthy.ravi@ti.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
References: <1313761725-6614-1-git-send-email-deepthy.ravi@ti.com> <201109041101.05028.laurent.pinchart@ideasonboard.com> <4E637DEC.5080507@infradead.org>
In-Reply-To: <4E637DEC.5080507@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109051449.50744.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Sunday 04 September 2011 15:32:28 Mauro Carvalho Chehab wrote:
> Em 04-09-2011 06:01, Laurent Pinchart escreveu:
> > On Sunday 04 September 2011 00:21:38 Mauro Carvalho Chehab wrote:
> >> Em 24-08-2011 10:25, Laurent Pinchart escreveu:
> >>> On Wednesday 24 August 2011 14:19:01 Hiremath, Vaibhav wrote:
> >>>> On Wednesday, August 24, 2011 5:00 PM Laurent Pinchart wrote:
> >>>>> On Wednesday 24 August 2011 13:21:27 Ravi, Deepthy wrote:
> >>>>>> On Wed, Aug 24, 2011 at 4:47 PM, Laurent Pinchart wrote:
> >>>>>>> On Friday 19 August 2011 15:48:45 Deepthy Ravi wrote:
> >>>>>>>> From: Vaibhav Hiremath <hvaibhav@ti.com>
> >>>>>>>> 
> >>>>>>>> Fix the build break caused when CONFIG_MEDIA_CONTROLLER
> >>>>>>>> option is disabled and if any sensor driver has to be used
> >>>>>>>> between MC and non MC framework compatible devices.
> >>>>>>>> 
> >>>>>>>> For example,if tvp514x video decoder driver migrated to
> >>>>>>>> MC framework is being built without CONFIG_MEDIA_CONTROLLER
> >>>>>>>> option enabled, the following error messages will result.
> >>>>>>>> drivers/built-in.o: In function `tvp514x_remove':
> >>>>>>>> drivers/media/video/tvp514x.c:1285: undefined reference to
> >>>>>>>> `media_entity_cleanup'
> >>>>>>>> drivers/built-in.o: In function `tvp514x_probe':
> >>>>>>>> drivers/media/video/tvp514x.c:1237: undefined reference to
> >>>>>>>> `media_entity_init'
> >>>>>>> 
> >>>>>>> If the tvp514x is migrated to the MC framework, its Kconfig option
> >>>>>>> should depend on MEDIA_CONTROLLER.
> >>>>>> 
> >>>>>> The same TVP514x driver is being used for both MC and non MC
> >>>>>> compatible devices, for example OMAP3 and AM35x. So if it is made
> >>>>>> dependent on MEDIA CONTROLLER, we cannot enable the driver for MC
> >>>>>> independent devices.
> >>>>> 
> >>>>> Then you should use conditional compilation in the tvp514x driver
> >>>>> itself. Or
> >>>> 
> >>>> No. I am not in favor of conditional compilation in driver code.
> >>> 
> >>> Actually, thinking some more about this, you should make the tvp514x
> >>> driver depend on CONFIG_MEDIA_CONTROLLER unconditionally. This doesn't
> >>> mean that the driver will become unusable by applications that are not
> >>> MC-aware. Hosts/bridges don't have to export subdev nodes, they can
> >>> just call subdev pad-level operations internally and let applications
> >>> control the whole device through a single V4L2 video node.
> >>> 
> >>>>> better, port the AM35x driver to the MC API.
> >>>> 
> >>>> Why should we use MC if I have very simple device (like AM35x) which
> >>>> only supports single path? I can very well use simple V4L2 sub-dev
> >>>> based approach (master - slave), isn't it?
> >>> 
> >>> The AM35x driver should use the in-kernel MC and V4L2 subdev APIs, but
> >>> it doesn't have to expose them to userspace.
> >> 
> >> I don't agree. If AM35x doesn't expose the MC API to userspace,
> >> CONFIG_MEDIA_CONTROLLER should not be required at all.
> >> 
> >> Also, according with the Linux best practices, when  #if tests for
> >> config symbols are required, developers should put it into the header
> >> files, and not inside the code, as it helps to improve code
> >> readability. From
> >> 
> >> Documentation/SubmittingPatches:
> >> 	2) #ifdefs are ugly
> >> 	
> >> 	Code cluttered with ifdefs is difficult to read and maintain.  Don't do
> >> 	it.  Instead, put your ifdefs in a header, and conditionally define
> >> 	'static inline' functions, or macros, which are used in the code.
> >> 	Let the compiler optimize away the "no-op" case.
> >> 
> >> So, this patch is perfectly fine on my eyes.
> > 
> > I'm sorry, but I don't agree.
> > 
> > Regarding the V4L2 subdev pad-level API, the goal is to convert all host
> > and subdev drivers to it, so that's definitely the way to go. This does
> > *not* mean that subdevs must expose a subdev device node. That's
> > entirely optional. What I'm talking about is switching from
> > video::*_mbus_fmt operations to pad::*_fmt operations. The pad-level
> > format operations are very similar to video-level format operations, and
> > more generic. Drivers shouldn't implement both.
> 
> I agree that implementing two ways for doing the same thing is a bad idea,
> but especially since your idea is to convert all subdevs to it, this type
> of conversion should not require enabling CONFIG_MEDIA_CONTROLLER, as this
> feature is used to enable the MC userspace API.
> 
> > Regarding the MC API, drivers are not required to register a media_device
> > instance. I have no issue with that. However, drivers should initialized
> > the subdev's embedded media_entity, as that's required by subdev
> > pad-level operations to get the number of pads for a subdev.
> 
> There are two solutions:
> 
> 1) add some "fallback" method at the core to use the video::*_mbus_fmt way,
> when MC is disabled;
> 
> 2) split the config options into two: one configurable by the user to
> enable the userspace MC API, and another, used internally that would
> select the MC internal API when drivers need it.
>
> As your plan is to convert all drivers to the new way, (2) doesn't make
> much sense in long term, as, at the end, all drivers will be selecting it.

But (1) makes even less sense :-) The issue here is that MC-enabled drivers 
will use pad-level subdev operations, so those operations need to be 
implemented in subdev drivers used by MC-enabled hosts/bridges. I don't like 
the idea of having two sets of similar operations in subdevs, as that will 
result in duplicate code. We should thus implement only pad-level subdev 
operations for MC-aware subdevs (a wrapper method can be implemented in the 
code to convert video operations to subdev operations transparently for non 
MC-aware hosts/bridges). This requires media_entity_init() and 
media_entity_cleanup() being available to those subdev drivers regardless of 
whether the host/bridge exposes the MC API to userspace.

I don't mind splitting the config option. An alternative would be to compile 
media_entity_init() and media_entity_cleanup() based on CONFIG_MEDIA_SUPPORT 
instead of CONFIG_MEDIA_CONTROLLER, but that looks a bit hackish to me.

> Also, I don't like the idea of increasing drivers complexity for the
> existing drivers that work properly without MC. All those core conversions
> that were done in the last two years caused already too much instability
> to them.
> 
> We should really avoid touching on them again for something that won't be
> adding any new feature nor fixing any known bug.

We don't have to convert them all in one go right now, we can implement pad-
level operations support selectively when a subdev driver becomes used by an 
MC-enabled host/bridge driver.

> > This will result in no modification to the userspace.

-- 
Regards,

Laurent Pinchart
