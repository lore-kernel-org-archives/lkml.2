Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751061Ab1HIXCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 19:02:08 -0400
Received: from banach.math.auburn.edu ([131.204.45.3]:36105 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab1HIXCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 19:02:06 -0400
Date: Tue, 9 Aug 2011 18:05:49 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Hans de Goede <hdegoede@redhat.com>
cc: Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <greg@kroah.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, libusb-devel@lists.sourceforge.net,
        Alexander Graf <agraf@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
        hector@marcansoft.com, Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, pbonzini@redhat.com,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Oliver Neukum <oliver@neukum.org>, Felipe Balbi <balbi@ti.com>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Adam Baker <linux@baker-net.org.uk>
Subject: Re: USB mini-summit at LinuxCon Vancouver
In-Reply-To: <4E41912F.50901@redhat.com>
Message-ID: <alpine.LNX.2.00.1108091640300.23684@banach.math.auburn.edu>
References: <Pine.LNX.4.44L0.1108091016380.1949-100000@iolanthe.rowland.org> <4E41912F.50901@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 9 Aug 2011, Hans de Goede wrote:

> Hi,
> 
> On 08/09/2011 04:19 PM, Alan Stern wrote:
> > On Tue, 9 Aug 2011, Hans de Goede wrote:
> > 
> > > I would really like to see the dual mode camera and TV tuner discussion
> > > separated. They are 2 different issues AFAIK.
> > > 
> > > 1) Dual mode cameras:
> > > 
> > > In the case of the dual mode camera we have 1 single device (both at
> > > the hardware level and at the logical block level), which can do 2 things,
> > > but not at the same time. It can stream live video data from a sensor,
> > > or it can retrieve earlier taken pictures from some picture memory.
> > > 
> > > Unfortunately even though these 2 functions live in a single logical
> > > block,
> > > historically we've developed 2 drivers for them. This leads to fighting
> > > over device ownership (surprise surprise), and to me the solution is
> > > very clear, 1 logical block == 1 driver.
> > 
> > According to Theodore, we have developed 5 drivers for them because the
> > stillcam modes in different devices use four different vendor-specific
> > drivers.
> 
> Yes, but so the the webcam modes of the different devices, so for
> the 5 (not sure if that is the right number) dual-cam mode chipsets
> we support there will be 5 drivers, each supporting both the
> webcam and the access to pictures stored in memory of the chipset
> they support. So 5 chipsets -> 5 drivers each supporting 1 chipset,
> and both functions of the single logical device that chipset
> represents.
> 
> >  Does it really make sense to combine 5 drivers into one?
> 
> Right, that is not the plan. The plan is to simply stop having 2 drivers
> for 1 logical (and physical) block. So we go from 10 drivers, 5 stillcam
> + 5 webcam, to just 5 drivers. We will also likely be able to share
> code between the code for the 2 functionalities for things like generic
> set / get register functions, initialization, etc.

Probably this is a good time for some inventory to be done.

 sure of the exact number of drivers. The jeilinj driver does not count 
here. It is a standard mass storage device as a still camera, and if it is 
going to be hooked up as a webcam then it has to have some buttons pushed 
just so, prior to hookup -- after which it comes up with a different USB 
Product number as a proprietary webcam device, supported by the jeilinj 
driver. Thus, this is not one of the droids we are looking for.

Specifically, the currently affected drivers are sq905, sq905c, mr97310a, 
and sn9c2028. 

Fuji Finepix seems to produce both still cameras (PTP protocol) and 
webcams. If there are currently any dual-mode cameras, it is not obvious. 
Perhaps any of these which can be dual mode are like the jeilinj cameras 
and come up under different Product numbers in the different modes, which 
is not a problem. 

There do seem to exist stv06xx dual-mode cameras:

stv0680/stv0680.c:      { "STM:USB Dual-mode camera",   0x0553, 0x0202, 1 
},

is found in camlibs/stv0680, for example, along with a whole bunch of 
other cameras with the same Vendor:Product number. It seems, too, that the 
same Vendor:Product number is listed in gspca/stv0680.c

So I guess we found another affected driver.


The intersection seems to be void between the lists of the spca50x cameras 
and webcams, though one can not be certain about the future. I do know of 
another dualmode camera, powered by the JL2005A chip. I wrote a kernel 
module for it some months ago. Said module has not been sent upward 
because of mysterious issues with one of the three cameras used for 
testing it.

We also find among the gspca driver files this

* GSPCA sub driver for W996[78]CF JPEG USB Dual Mode Camera Chip.
 *
 * Copyright (C) 2009 Hans de Goede <hdegoede@redhat.com>

but I am not sure about which cameras are using this.

Theodore Kilgore
