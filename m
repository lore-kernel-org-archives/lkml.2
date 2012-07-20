Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab2GTQdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 12:33:40 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:17150 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab2GTQdh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 12:33:37 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-127.messagelabs.com!1342802006!9167915!28
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Date: Fri, 20 Jul 2012 11:33:27 -0500
Subject: RE: [PATCH 15/90] staging: comedi: adv_pci1723: move
 comedi_pci_enable() into the attach
Thread-Topic: [PATCH 15/90] staging: comedi: adv_pci1723: move
 comedi_pci_enable() into the attach
Thread-Index: Ac1mByTE73cmmPXsSbi+qGN3b8iHKgAjCNIw
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206AABE0E10@AUSP01VMBX24.collaborationhost.net>
References: <201207181830.48668.hartleys@visionengravers.com>
 <5007D568.2050401@mev.co.uk>
 <ADE657CA350FB648AAC2C43247A983F00206AA916472@AUSP01VMBX24.collaborationhost.net>
 <20120719231723.GA23010@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F00206AA9165BC@AUSP01VMBX24.collaborationhost.net>
 <20120719233506.GA12858@kroah.com>
In-Reply-To: <20120719233506.GA12858@kroah.com>
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

On Thursday, July 19, 2012 4:35 PM, gregkh wrote:
> On Thu, Jul 19, 2012 at 06:31:23PM -0500, H Hartley Sweeten wrote:
>> If the comedi pci drivers have the "attach_pci" callback defined, the
>> PCI api does correctly probe the driver. The comedi_pci_auto_config()
>> then passes the pci_dev directly to the driver and the search of the
>> PCI space for the device is not required.
>> 
>> If the "attach_pci" callback is not defined, the comedi_pci_auto_config()
>> then falls back to passing the bus/slot information to the driver and uses
>> the "attach" callback. In this case we could probably fast-track the search
>> by using pci_get_slot() instead of doing the for_each_pci_dev() loop.
>> 
>> I think the problem is the COMEDI_DEVCONFIG ioctl. The userspace
>> utility 'comedi_config' uses that ioctl to link a device node to a
>> comedi driver. That utility allows passing the bus/slot information
>> but it's not required. This means we have to search the PCI space
>> for the pci_dev that matches the driver.
>
> The ioctl shouldn't be needed anymore for PCI or USB devices, as the
> kernel handles the matching of the driver to the device.  Even if it
> didn't, there are other more "standard" ways that you can bind devices
> to drivers (through sysfs.)
>
> So, I'd really recommend ripping all of this logic out for PCI drivers
> as odds are, it's not used, and probably doesn't really work.

Ian,

I think we could rip the PCI search stuff out of the comedi pci drivers
but I would like your opinion first.

1) Implement the "attach_pci" callback in all the pci drivers.
2) Change the "attach" callback to just return -EPERM, -EINVAL, or
    whatever seems appropriate. This has the most minimal effect
    on the comedi core. We could also just remove the "attach" from
    the pci drivers that have the "attach_pci" callback but the core
    would need some changes to account for this.

The COMEDI_DEVCONFIG ioctl, which is only used by the comedi_config
utility, would then fail on all the pci drivers but that should not be an
issue because the auto config stuff would still work correctly when the
module is loaded. You would lose the ability to specify the devnode
that the module is bound to but I think the sysfs "bind" and "unbind"
files are meant to handle that.

I think there are a couple pci drivers that would still need the old "attach"
in order to load firmware using comedi_config. We can address those
later and possibly figure out a more "standard" way to load the firmware.

What do you think?

Regards,
Hartley

