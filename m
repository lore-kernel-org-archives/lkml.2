Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934219Ab1IORDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 13:03:35 -0400
Received: from smtp-out.google.com ([216.239.44.51]:48465 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab1IORDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 13:03:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:from:date:
	x-google-sender-auth:message-id:subject:to:cc:content-type:x-system-of-record;
	b=aTcvLATbyZl3OhcRWSCzyxAubU70ixOKAuZfyrsI7LtdqlN4kkopst7OkaSx3fr63
	D5PtNlBILCc54gVOYglEg==
MIME-Version: 1.0
From: Sameer Nanda <snanda@chromium.org>
Date: Thu, 15 Sep 2011 10:03:11 -0700
X-Google-Sender-Auth: RmW6NO-pDx5bbuZo5ZaMsCVpxfE
Message-ID: <CANMivWbGTS_Xyj4MtgrYTWTkCbVKP_Uf-i-_hNYFx+YAPaNxjQ@mail.gmail.com>
Subject: RFC: Enable wakeup for intermediate USB bridge devices
To: stern@rowland.harvard.edu, gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sameer Nanda <snanda@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>, olofj@chromium.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a follow-up from the patch I sent earlier enabling wakeup by
default in the ehci-pci driver.  That thread is here:
http://marc.info/?l=linux-usb&m=131595571619689&w=2

The current wake policy is to enable wake by default for a small set
of devices that the users expect (like keyboards, power buttons and
maybe LAN interfaces).  An example check of this can be seen in
usbhid_start where wakeup is enabled only if the interface subclass is
USB_INTERFACE_SUBCLASS_BOOT and protocol is
USB_INTERFACE_PROTOCOL_KEYBOARD.

However, this doesn't quite work out of the box today since the USB
host controllers that these devices connect to do not enable wakeup by
default.

The proposal is to enable wakeup by default on the intermediate bridge
devices such as ehci-pci and ohci-hcd.  This allows wake from USB
keyboard to work by default.  For non-keyboard devices, the user will
still need to explicitly enable them as a wakesources so there is no
change in the device wakeup policy from what is in place currently for
those devices.

Below is an example patch that enables wakeup for the ehci-pci bridge
device.  I can spin up a similar patch for the ohci-hcd also,
if there is interest in moving this forward.

=============

If the PORTWAK register is implemented and at least one of the physical
ports is enabled for wakeup, enable wakeup for the ehci-pci device.

Signed-off-by: Sameer Nanda <snanda@chromium.org>
---
 drivers/usb/host/ehci-pci.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index 1102ce6..ce6f784 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -285,6 +285,16 @@ static int ehci_pci_setup(struct usb_hcd *hcd)
                      dev_warn(&pdev->dev, "Enabling legacy PCI PM\n");
                      device_set_wakeup_capable(&pdev->dev, 1);
              }
+       } else {
+               u16     port_wake;
+
+               pci_read_config_word(pdev, 0x62, &port_wake);
+
+               /* If PORTWAK register is implemented and at least one USB
+                * port is enabled for wakeup, enable wakeup.
+                */
+               if (port_wake & 0x0001 && port_wake & 0xfffe)
+                       device_set_wakeup_enable(&pdev->dev, 1);
      }

 #ifdef CONFIG_USB_SUSPEND
