Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab2HIQOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 12:14:04 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37044 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab2HIQOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 12:14:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120809142406.GC14429@xanatos>
References: <1344504711-10916-1-git-send-email-kengyu@canonical.com> <20120809142406.GC14429@xanatos>
From: Keng-Yu Lin <kengyu@canonical.com>
Date: Fri, 10 Aug 2012 00:13:19 +0800
X-Google-Sender-Auth: MDWJYmXO7DWryEdx5clNweGiHnA
Message-ID: <CADXHx7ZbWPb1qLQcdquE9QTkGhOwR0ka1gX2m+o_Y68c9jqtog@mail.gmail.com>
Subject: Re: [PATCH] Intel xhci: Only switch the switchable ports
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 10:24 PM, Sarah Sharp
<sarah.a.sharp@linux.intel.com> wrote:
> On Thu, Aug 09, 2012 at 05:31:51PM +0800, Keng-Yu Lin wrote:
>> With a previous patch to enable the EHCI/XHCI port switching, it switches
>> all the available ports.
>>
>> The assumption is not correct because the BIOS may expect some ports
>> not switchable by the OS.
>
> Why would the BIOS expect some ports to not be switchable?  I know that
> we internally at Intel had discussed some theoretical reasons why it
> might not be good to switch some ports, but when I presented the
> original patch with this same code in it to Linux USB mailing list, both
> Alan and Greg said, "Why not unconditionally switch ports?"  I had no
> good examples at the time.
>
> Is this causing issues with some particular BIOS?
>

Yes, this is causing the internal webcam missing on the USB bus as I
observed on some HM70-based laptops.

The internal webcam is attached to one port that is controlled by the
xhci host.
But the other ports with the outer plugs work well after booting. I
cannot test the USB port of the internal webcam easily (without
tearing down the laptop :-/).

I also tried some similar HM77-based models. HM77 has no this issue.
This could be some chipset mystery I am not aware now.

Some bisecting led to your original patch.

>> There are two more registers that contains the information of the switchable
>> and non-switchable ports.
>>
>> This patch adds the checking code for the two register so that only the
>> switchable ports are altered.
>>
>> Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
>> ---
>>  drivers/usb/host/pci-quirks.c |   27 +++++++++++++++++++++++----
>>  1 file changed, 23 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
>> index 833b3c6..89f62f2 100644
>> --- a/drivers/usb/host/pci-quirks.c
>> +++ b/drivers/usb/host/pci-quirks.c
>> @@ -75,7 +75,9 @@
>>  #define      NB_PIF0_PWRDOWN_1       0x01100013
>>
>>  #define USB_INTEL_XUSB2PR      0xD0
>> +#define USB_INTEL_USB2PRM      0xD4
>>  #define USB_INTEL_USB3_PSSEN   0xD8
>> +#define USB_INTEL_USB3PRM      0xDC
>>
>>  static struct amd_chipset_info {
>>       struct pci_dev  *nb_dev;
>> @@ -772,10 +774,18 @@ void usb_enable_xhci_ports(struct pci_dev *xhci_pdev)
>>               return;
>>       }
>>
>> -     ports_available = 0xffffffff;
>> +     /* Read USB3PRM, the USB 3.0 Port Routing Mask Register
>> +      * Indicate the ports that can be changed from OS.
>> +      */
>> +     pci_read_config_dword(xhci_pdev, USB_INTEL_USB3PRM,
>> +                     &ports_available);
>> +
>> +     dev_dbg(&xhci_pdev->dev, "Configurable ports to enable SuperSpeed: 0x%x\n",
>> +                     ports_available);
>> +
>>       /* Write USB3_PSSEN, the USB 3.0 Port SuperSpeed Enable
>> -      * Register, to turn on SuperSpeed terminations for all
>> -      * available ports.
>> +      * Register, to turn on SuperSpeed terminations for the
>> +      * switchable ports.
>>        */
>>       pci_write_config_dword(xhci_pdev, USB_INTEL_USB3_PSSEN,
>>                       cpu_to_le32(ports_available));
>> @@ -785,7 +795,16 @@ void usb_enable_xhci_ports(struct pci_dev *xhci_pdev)
>>       dev_dbg(&xhci_pdev->dev, "USB 3.0 ports that are now enabled "
>>                       "under xHCI: 0x%x\n", ports_available);
>>
>> -     ports_available = 0xffffffff;
>> +     /* Read XUSB2PRM, xHCI USB 2.0 Port Routing Mask Register
>> +      * Indicate the port to be controlled by the EHCI host.
>
> Your code is correct, but your comment is wrong.  XUSB2PRM is the USB
> 2.0 ports that should be controlled by the xHCI host.
>

Thanks for the explanation.

>> +      */
>> +
>> +     pci_read_config_dword(xhci_pdev, USB_INTEL_USB2PRM,
>> +                     &ports_available);
>> +
>> +     dev_dbg(&xhci_pdev->dev, "Configurable ports to hand over the ECHI host:
>> +                     0x%x\n", ports_available);
>
> Again, this should be "Configurable USB 2.0 ports to hand over to xHCI:"
> Also, don't split strings, it makes it hard to grep for them later.
>

Thanks. I will re-sent a patch with the correct comment.

>> +
>>       /* Write XUSB2PR, the xHC USB 2.0 Port Routing Register, to
>>        * switch the USB 2.0 power and data lines over to the xHCI
>>        * host.
>
> Sarah Sharp

-kengyu
