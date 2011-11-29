Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab1K2XEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 18:04:13 -0500
Received: from imr4.ericy.com ([198.24.6.9]:37972 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab1K2XEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 18:04:10 -0500
Subject: Re: MFD: core assumes that all children are platform devices
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: =?ISO-8859-1?Q?Jean-Fran=E7ois?= Dagenais 
	<jeff.dagenais@gmail.com>
CC: =?ISO-8859-1?Q?Jean-Fran=E7ois?= Dagenais 
	<dagenaisj@sonatest.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>
In-Reply-To: <F9D1750C-7D71-46D1-BE90-6D44CA26CB4F@gmail.com>
References: <2F9D884C-6B95-4F81-8445-8056676B28D8@sonatest.com>
	 <20111129185746.GA23986@ericsson.com>
	 <F9D1750C-7D71-46D1-BE90-6D44CA26CB4F@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Tue, 29 Nov 2011 15:02:49 -0800
Message-ID: <1322607769.23607.18.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-29 at 16:40 -0500, Jean-François Dagenais wrote:
> 
> Sent from my iPod
> 
> On 2011-11-29, at 1:57 PM, Guenter Roeck <guenter.roeck@ericsson.com> wrote:
> 
> > On Mon, Nov 28, 2011 at 11:23:00AM -0500, Jean-François Dagenais wrote:
> >> Hi,
> >> 
> >> I have a pci driver that registers with UIO for it's operations. As a consequence, the pci device
> >> instance has a child device of class uio.
> >> 
> >> My driver also declares a ds1wm instance that has it's register interface at an offset in BAR0
> >> of the pci device, as an MFD cell.
> >> 
> >> When I call mfd_remove_devices, MFD proceeds to enumerate ALL the parent device's chilren
> >> and assumes that they are MFD cells, and thus platform_device, which is not true in my case.
> >> (...uio is a child of the parent pci device)
> >> 
> >> I had (luckily or unluckily) not seen signs of this broken assumption on certain setups I have
> >> used, but in my current setup, this page-faults every time now.
> >> 
> >> This is a major thing and I have not found the assumption documented anywhere.
> >> 
> >> I could first declare a new child device on my pci device and then declare it as the parent to
> >> the mfd cells...
> >> 
> > I had the same problem, with a Multi-function USB device. Took me a while to figure out that
> > mfd_remove_devices() removed the USB child devices when I used the USB device as MFD parent device.
> > 
> > My solution was to do what you suggested - my MFD probe function now creates a platform device
> > to be used as MFD parent device. Works nicely, it doesn't require much additional code,
> > and I think it is cleaner than other possible solutions (at least the ones I came up with).
> > We'll see how it flies with the MFD and USB maintainers once I submit the patch ;).
> > 
> >> Or, is there a way for the mfd-core, as it's doing the "for each child device", to recognize
> >> non-MFD-cell children and skip them?
> >> 
> > Looking at your proposed patch, I personally prefer my solution.
> I'd like to see your patch... You mean to say that you changed your driver, or the mfd core? If it's your driver's probe function, then the problem still exists out there and imposing an extra device alloc simply as a container is in my opinion both a hassle and a waste of resource. At the very least, this task should be done by the mfd core. It still seems pointless though, when you can filter out which children are the ones to remove, like what my patch does.

I did not touch the mfd core; I am in general not in favor of changing
core code if I can avoid it.

You can clone my driver from git://github.com/groeck/diolan.git. The mfd
core code is in diolan-u2c-core.c. Not in shape for submission, and the
SPI part is completely untested, but the MFD code should be ok.

> > Of course it would be nice
> > if it was documented that MFD parent devices MUST be dedicated (platform) devices and must not
> > have any non-MFD child devices. This would be a simple documentation patch and avoid making
> > assumptions on MFD child device removal.
> Well the patch uses already present assumptions, it just checks
> for them.
> 
The assumption I referred to was your assumption or expectation that
mfd_remove_devices() only removes a subset of child devices, not all of
them.

> What's good is that my patch doesn't prevent you from using a container platform device either.
> 
> We'll see what Samuel thinks...

Agreed. Either way, I think I'll stick with my approach - if nothing
else for backward compatibility. I would not want to have a driver which
depends on changed semantics of a kernel API function call.

Thanks,
Guenter


