Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab2GSXb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 19:31:29 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:24026 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab2GSXb0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 19:31:26 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-127.messagelabs.com!1342740685!4550513!2
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Ian Abbott <abbotti@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>
Date: Thu, 19 Jul 2012 18:31:23 -0500
Subject: RE: [PATCH 15/90] staging: comedi: adv_pci1723: move
 comedi_pci_enable() into the attach
Thread-Topic: [PATCH 15/90] staging: comedi: adv_pci1723: move
 comedi_pci_enable() into the attach
Thread-Index: Ac1mBKs9LGzQnqpiSamyjWys0EpmVQAACMVQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206AA9165BC@AUSP01VMBX24.collaborationhost.net>
References: <201207181830.48668.hartleys@visionengravers.com>
 <5007D568.2050401@mev.co.uk>
 <ADE657CA350FB648AAC2C43247A983F00206AA916472@AUSP01VMBX24.collaborationhost.net>
 <20120719231723.GA23010@kroah.com>
In-Reply-To: <20120719231723.GA23010@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 19, 2012 4:17 PM, gregkh wrote:
> On Thu, Jul 19, 2012 at 12:12:02PM -0500, H Hartley Sweeten wrote:
>> I was planning on making a comedi_find_pci_dev() function that the
>> drivers could call with a "match" callback. This would allow a common
>> function for most of the boilerplate code and just require the drivers
>> to check the the match against the boardinfo dev/id, etc. as required.
>> Something like:
>> 
>> struct pci_dev *comedi_find_pci_dev(struct comedi_device *dev,
>> 	struct comedi_devconfig *it,
>> 	const void *(*match)(struct comedi_device *,
>> 				struct pci_dev *))
>> {
>> 	struct pci_dev *pcidev = NULL;
>> 	int bus = it->options[0];
>> 	int slot = it->options[1];
>> 
>> 	for_each_pci_dev(pcidev) {
>> 		/* pci_is_enabled() test? */
>> 		if ((bus && bus != pcidev->bus->number) ||
>> 		    (slot && slot != PCI_SLOT(pcidev->devfn)))
>> 			continue;
>> 		dev->board_ptr = match(dev, pcidev);
>> 		if (dev->board_ptr) {
>> 			comedi_set_hw_dev(dev, &pcidev->dev);
>> 			return pcidev;
>> 		}
>> 	}
>> 	return NULL;
>> }
>> 
>> The "match" function for a driver would then just be something like:
>> 
>> const void *match_pci(struct comedi_device *dev, struct pci_dev *pcidev)
>> {
>> 	const struct boardinfo *board;
>> 	int i;
>> 
>> 	for (i = 0; i < ARRAY_SIZE(boardinfo); i++) {
>> 		board = &boardinfo[i];
>> 		if (pcidev->vendor != board->ven_id ||
>> 		    pcidev->device != board->dev_id)
>> 			continue;
>> 		return board;
>> 	}
>> 	return NULL;
>> }
>> 
>> This would require adding a dummy boardinfo to some of the drivers but
>> I think it's cleaner.
>> 
>> Comments?
>
> Ick.  What ever happened to converting these drivers to use the PCI api
> correctly and not to search the PCI space for the device, but have the
> PCI core call them if the device is found?
>
> It looks like most of these drivers have already been converted to that
> style, so these checks for "do we find a device" can all be removed
> entirely now, right?  There's no way the functions would be called if
> the device wasn't found in the first place.
> 
> Or am I missing something here?

If the comedi pci drivers have the "attach_pci" callback defined, the
PCI api does correctly probe the driver. The comedi_pci_auto_config()
then passes the pci_dev directly to the driver and the search of the
PCI space for the device is not required.

If the "attach_pci" callback is not defined, the comedi_pci_auto_config()
then falls back to passing the bus/slot information to the driver and uses
the "attach" callback. In this case we could probably fast-track the search
by using pci_get_slot() instead of doing the for_each_pci_dev() loop.

I think the problem is the COMEDI_DEVCONFIG ioctl. The userspace
utility 'comedi_config' uses that ioctl to link a device node to a
comedi driver. That utility allows passing the bus/slot information
but it's not required. This means we have to search the PCI space
for the pci_dev that matches the driver.

Not sure what to do here...

Regards,
Hartley

