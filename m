Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab2GSXR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 19:17:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61021 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab2GSXR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 19:17:27 -0400
Date: Thu, 19 Jul 2012 16:17:23 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>
Subject: Re: [PATCH 15/90] staging: comedi: adv_pci1723: move
 comedi_pci_enable() into the attach
Message-ID: <20120719231723.GA23010@kroah.com>
References: <201207181830.48668.hartleys@visionengravers.com>
 <5007D568.2050401@mev.co.uk>
 <ADE657CA350FB648AAC2C43247A983F00206AA916472@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F00206AA916472@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 12:12:02PM -0500, H Hartley Sweeten wrote:
> On Thursday, July 19, 2012 2:38 AM, Ian Abbott wrote:
> > On 2012-07-19 02:30, H Hartley Sweeten wrote:
> >> Use pci_is_enabled() in the "find pci device" function to determine if
> >> the found pci device is not in use and move the comedi_pci_enable() call
> >> into the attach.
> >>
> >> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> >> Cc: Ian Abbott <abbotti@mev.co.uk>
> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> ---
> >>   drivers/staging/comedi/drivers/adv_pci1723.c | 10 +++++-----
> >>   1 file changed, 5 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
> >> index f561a2a..e971fa6 100644
> >> --- a/drivers/staging/comedi/drivers/adv_pci1723.c
> >> +++ b/drivers/staging/comedi/drivers/adv_pci1723.c
> >> @@ -302,11 +302,7 @@ static struct pci_dev *pci1723_find_pci_dev(struct comedi_device *dev,
> >>   		}
> >>   		if (pcidev->vendor != PCI_VENDOR_ID_ADVANTECH)
> >>   			continue;
> >> -		/*
> >> -		 * Look for device that isn't in use.
> >> -		 * Enable PCI device and request regions.
> >> -		 */
> >> -		if (comedi_pci_enable(pcidev, "adv_pci1723"))
> >> +		if (pci_is_enabled(pcidev))
> >>   			continue;
> >>   		return pcidev;
> >>   	}
> >
> > Just because the device is enabled doesn't mean that it is in use, so 
> > this change could skip over a perfectly good unused device.
> 
> Are you sure? According to Documentation/PCI/pci.txt, the first thing
> a driver "should" do when taking ownership of a PCI device is enable
> the device. The last thing it "should" do when being unloaded is
> disable the device.
> 
> It would seem that checking pci_is_enabled() would let us know that
> the pci_dev in question is being used.
> 
> > If you want to move the comedi_pci_enable() call, this is a change in 
> > behaviour for this particular driver, but is consistent with most of the 
> > other Comedi PCI drivers (and the bus/slot options can be used to select 
> > a particular device).  This is probably a good thing, but you should 
> > take out the pci_is_enabled test.
> 
> I was curious about this.
> 
> In the original driver, doing an 'attach' with bus/slot both = 0 would result
> in the pci bus being walked to find the first device that could be enabled
> (i.e. a "free" device) and using that device. This allows doing the 'attach'
> with more than one card installed and being able to attach to each one
> by simply:
> 
> comedi_config /dev/comedi0 adv_pci1723
> comedi_config /dev/comedi1 adv_pci1723
> etc.
> 
> The "normal" operation for the comedi pci drivers appears to require
> the bus/slot information when multiple devices are used. Or implement
> the 'attach_pci' callback in the comedi_driver and allow the core to
> simply pass the pci_dev directly to the driver.
> 
> What would you prefer?
> 
> I was planning on making a comedi_find_pci_dev() function that the
> drivers could call with a "match" callback. This would allow a common
> function for most of the boilerplate code and just require the drivers
> to check the the match against the boardinfo dev/id, etc. as required.
> Something like:
> 
> struct pci_dev *comedi_find_pci_dev(struct comedi_device *dev,
> 	struct comedi_devconfig *it,
> 	const void *(*match)(struct comedi_device *,
> 				struct pci_dev *))
> {
> 	struct pci_dev *pcidev = NULL;
> 	int bus = it->options[0];
> 	int slot = it->options[1];
> 
> 	for_each_pci_dev(pcidev) {
> 		/* pci_is_enabled() test? */
> 		if ((bus && bus != pcidev->bus->number) ||
> 		    (slot && slot != PCI_SLOT(pcidev->devfn)))
> 			continue;
> 		dev->board_ptr = match(dev, pcidev);
> 		if (dev->board_ptr) {
> 			comedi_set_hw_dev(dev, &pcidev->dev);
> 			return pcidev;
> 		}
> 	}
> 	return NULL;
> }
> 
> The "match" function for a driver would then just be something like:
> 
> const void *match_pci(struct comedi_device *dev, struct pci_dev *pcidev)
> {
> 	const struct boardinfo *board;
> 	int i;
> 
> 	for (i = 0; i < ARRAY_SIZE(boardinfo); i++) {
> 		board = &boardinfo[i];
> 		if (pcidev->vendor != board->ven_id ||
> 		    pcidev->device != board->dev_id)
> 			continue;
> 		return board;
> 	}
> 	return NULL;
> }
> 
> This would require adding a dummy boardinfo to some of the drivers but
> I think it's cleaner.
> 
> Comments?

Ick.  What ever happened to converting these drivers to use the PCI api
correctly and not to search the PCI space for the device, but have the
PCI core call them if the device is found?

It looks like most of these drivers have already been converted to that
style, so these checks for "do we find a device" can all be removed
entirely now, right?  There's no way the functions would be called if
the device wasn't found in the first place.

Or am I missing something here?

thanks,

greg k-h
