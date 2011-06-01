Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab1FATj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:39:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:5524 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456Ab1FATj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:39:27 -0400
X-ExtLoop1: 1
Date: Wed, 1 Jun 2011 12:39:25 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: "Xu, Andiry" <Andiry.Xu@amd.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] usb: Do not attempt to reset the device while it
 is disabled
Message-ID: <20110601193925.GC6230@xanatos>
References: <1306749406-21124-1-git-send-email-m.b.lankhorst@gmail.com>
 <2DEEA3AB13739D45A22ADDB5086AEA0B016C1261@sshaexmb1.amd.com>
 <4DE4F166.8020207@gmail.com>
 <20110531171446.GB6776@xanatos>
 <4DE5283A.9070202@gmail.com>
 <20110531181848.GA6911@xanatos>
 <4DE53C74.2080700@gmail.com>
 <20110531223502.GA8550@xanatos>
 <4DE5804C.2050609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE5804C.2050609@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 01:57:00AM +0200, Maarten Lankhorst wrote:
> Op 01-06-11 00:35, Sarah Sharp schreef:
> > On Tue, May 31, 2011 at 09:07:32PM +0200, Maarten Lankhorst wrote:
> >> Op 31-05-11 20:18, Sarah Sharp schreef:
> >>> On Tue, May 31, 2011 at 07:41:14PM +0200, Maarten Lankhorst wrote:
> >> My xhci controller is this one:
> >> 04:00.0 USB Controller: Device 1b6f:7023 (rev 01) (prog-if 30 [XHCI])
> >> Subsystem: ASRock Incorporation Device 7023
> > Ok, the PCI SIGG says that vendor ID is assigned to Etron.  Congrats,
> > that's the first xHCI host controller I've seen from that company. :)
> Hooray.
> > Ok, so the xHCI driver does successfully get a slot from the host
> > controller.
> >
> >> [  545.664041] xhci_hcd 0000:04:00.0: Allocating ring at ffff8801c7d7ccc0
> >> [  545.664044] xhci_hcd 0000:04:00.0: Allocating priv segment structure at ffff8801e2e26c40
> >> [  545.664047] xhci_hcd 0000:04:00.0: // Allocating segment at ffff8800bac3f800 (virtual) 0xbac3f800 (DMA)
> >> [  545.664053] xhci_hcd 0000:04:00.0: Linking segment 0xbac3f800 to segment 0xbac3f800 (DMA)
> >> [  545.664056] xhci_hcd 0000:04:00.0: Wrote link toggle flag to segment ffff8801e2e26c40 (virtual), 0xbac3f800 (DMA)
> >> [  545.664059] xhci_hcd 0000:04:00.0: Set slot id 1 dcbaa entry ffff8800bac3e008 to 0xbac21000
> >> [  545.664070] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0420, 32'h2f1, 4'hf);
> > But I don't see an Address Device command complete here.  The command
> > submission probably caused that memory write, but there really should be
> > more debugging here.  I'll have to look through the hub initialization
> > and see if there is any error path that would make it skip setting the
> > device address.
> >
> > Have you tried on Linux 3.0-rc1?
> Same problem with 3.0rc1 it seems. Just look at hub_port_init, that appears to be where it's going wrong:
> 
> First it calls:
>         retval = hub_port_reset(hub, port1, udev, delay);
> 
> Which does the device reset..
> 
> Then lower in that function:
>                 if (udev->wusb == 0) {
>                         for (j = 0; j < SET_ADDRESS_TRIES; ++j) {
>                                 retval = hub_set_address(udev, devnum);
>                                 if (retval >= 0)
>                                         break;
>                                 msleep(200);
>                         }
> 
> It seems to me that is why I get the reset call failing BEFORE the address is set. However I'm unsure what
> would be a proper fix for it would be.

I think your second patch was on the right track.  It's true that the
xHCI driver shouldn't be issuing a Reset Device command before the
Address Device command completes.  The NEC host controller just handles
it as the xHCI specification requires, by giving back a completion code
that means the slot is in the enabled/disabled state:

[  127.025732] xhci_hcd 0000:03:00.0: Set slot id 1 dcbaa entry ffff880033853008 to 0x3387c000
[  127.025771] xhci_hcd 0000:03:00.0: set port reset, actual port 1 status  = 0x791
[  127.080956] xhci_hcd 0000:03:00.0: Port Status Change Event for port 2
[  127.085207] xhci_hcd 0000:03:00.0: get port status, actual port 1 status  = 0x200e03
[  127.085237] xhci_hcd 0000:03:00.0: Get port status returned 0x100503
[  127.145059] xhci_hcd 0000:03:00.0: Resetting device with slot ID 1
[  127.145090] xhci_hcd 0000:03:00.0: // Ding dong!
[  127.145112] xhci_hcd 0000:03:00.0: Command completion. Event ring dequeue ptr: 33854010 00000000 13000000 01008401
[  127.145122] xhci_hcd 0000:03:00.0: Completed reset device command.
[  127.145163] xhci_hcd 0000:03:00.0: Can't reset device (slot ID 1) in enabled/disabled state
[  127.145172] xhci_hcd 0000:03:00.0: Not freeing device rings.

The rings don't get freed, which is fine because there are no rings to
free anyway in that case.  It's just the Etron host uses a vendor
specific error condition, and the xHCI driver doesn't know what to make
of it.  I'm not inclined to assume that particular error code always means
the same thing, so let's not add handling for that code to
xhci_discover_or_reset_device().

I think the correct solution is for the xHCI driver does need to check
the output context's slot state before issuing a Reset Device command.
Can you respin your second patch to only check the slot's dev_state
field, and not the state of the control endpoint?

Also, please add a #define in xhci.h for the enabled/disabled state
instead of hard-coding it to zero.  I know that xhci-dbg.c's
xhci_get_slot_state() uses hard-coded states, but it shouldn't.  Feel
free to update it in a separate patch if you have the time.

One last thing: please run your patch through checkpatch.pl, as your
last one violated kernel coding style WRT to line length and spaces
around operators like & and &&.  See Documentation/CodingStyle.

Sarah Sharp
