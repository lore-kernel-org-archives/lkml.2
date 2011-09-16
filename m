Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683Ab1IPCgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 22:36:13 -0400
Received: from netrider.rowland.org ([192.131.102.5]:49439 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751604Ab1IPCgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 22:36:07 -0400
Date: Thu, 15 Sep 2011 22:36:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Sameer Nanda <snanda@chromium.org>
cc: gregkh@suse.de, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Vincent Palatin <vpalatin@chromium.org>, <olofj@chromium.org>
Subject: Re: RFC: Enable wakeup for intermediate USB bridge devices
In-Reply-To: <CANMivWbGTS_Xyj4MtgrYTWTkCbVKP_Uf-i-_hNYFx+YAPaNxjQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1109152230000.13140-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Sep 2011, Sameer Nanda wrote:

> This is a follow-up from the patch I sent earlier enabling wakeup by
> default in the ehci-pci driver.  That thread is here:
> http://marc.info/?l=linux-usb&m=131595571619689&w=2
> 
> The current wake policy is to enable wake by default for a small set
> of devices that the users expect (like keyboards, power buttons and
> maybe LAN interfaces).  An example check of this can be seen in
> usbhid_start where wakeup is enabled only if the interface subclass is
> USB_INTERFACE_SUBCLASS_BOOT and protocol is
> USB_INTERFACE_PROTOCOL_KEYBOARD.
> 
> However, this doesn't quite work out of the box today since the USB
> host controllers that these devices connect to do not enable wakeup by
> default.
> 
> The proposal is to enable wakeup by default on the intermediate bridge
> devices such as ehci-pci and ohci-hcd.  This allows wake from USB
> keyboard to work by default.  For non-keyboard devices, the user will
> still need to explicitly enable them as a wakesources so there is no
> change in the device wakeup policy from what is in place currently for
> those devices.
> 
> Below is an example patch that enables wakeup for the ehci-pci bridge
> device.  I can spin up a similar patch for the ohci-hcd also,
> if there is interest in moving this forward.
> 
> =============
> 
> If the PORTWAK register is implemented and at least one of the physical
> ports is enabled for wakeup, enable wakeup for the ehci-pci device.
> 
> Signed-off-by: Sameer Nanda <snanda@chromium.org>
> ---
>  drivers/usb/host/ehci-pci.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
> index 1102ce6..ce6f784 100644
> --- a/drivers/usb/host/ehci-pci.c
> +++ b/drivers/usb/host/ehci-pci.c
> @@ -285,6 +285,16 @@ static int ehci_pci_setup(struct usb_hcd *hcd)
>                       dev_warn(&pdev->dev, "Enabling legacy PCI PM\n");
>                       device_set_wakeup_capable(&pdev->dev, 1);
>               }
> +       } else {
> +               u16     port_wake;
> +
> +               pci_read_config_word(pdev, 0x62, &port_wake);
> +
> +               /* If PORTWAK register is implemented and at least one USB
> +                * port is enabled for wakeup, enable wakeup.
> +                */
> +               if (port_wake & 0x0001 && port_wake & 0xfffe)
> +                       device_set_wakeup_enable(&pdev->dev, 1);
>       }
> 
>  #ifdef CONFIG_USB_SUSPEND

This is not the right way to do what you want.  Assuming the change to
the kernel's default wakeup-enable policy is accepted, the patch below
will enable remote wakeup for _all_ host controllers that support it.

At the same time, the patch will disable remote wakeup by default for
root hubs.  I think this is unlikely to cause any problems; people
probably don't want their sleeping laptops to wake up when a USB device
is plugged in or unplugged.  And besides, this is what we should have
been doing all along, according to the current policy.

Note: I haven't tested this patch.  You ought to check and make sure it 
behaves the way it's supposed to.

Alan Stern


Index: usb-3.1/drivers/usb/core/hcd.c
===================================================================
--- usb-3.1.orig/drivers/usb/core/hcd.c
+++ usb-3.1/drivers/usb/core/hcd.c
@@ -2429,7 +2429,7 @@ int usb_add_hcd(struct usb_hcd *hcd,
 	 * but drivers can override it in reset() if needed, along with
 	 * recording the overall controller's system wakeup capability.
 	 */
-	device_init_wakeup(&rhdev->dev, 1);
+	device_set_wakeup_capable(&rhdev->dev, 1);
 
 	/* HCD_FLAG_RH_RUNNING doesn't matter until the root hub is
 	 * registered.  But since the controller can die at any time,
@@ -2478,6 +2478,13 @@ int usb_add_hcd(struct usb_hcd *hcd,
 	}
 	if (hcd->uses_new_polling && HCD_POLL_RH(hcd))
 		usb_hcd_poll_rh_status(hcd);
+
+	/*
+	 * Host controllers don't generate their own wakeup requests;
+	 * they only forward requests from the root hub.  Therefore
+	 * controllers should always be enabled for remote wakeup.
+	 */
+	device_wakeup_enable(hcd->self.controller);
 	return retval;
 
 error_create_attr_group:

