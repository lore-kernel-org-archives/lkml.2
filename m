Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab1EaRlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 13:41:19 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48539 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757920Ab1EaRlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 13:41:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=yDrtNFMKEeeGL7/Xr9HYD7PS7A4mv2cdvCBiB8QT9f2+z+6PqZD5jVy+PjnnMSweNL
         oBLVPkeE7xSnHUOQWN5FDrrJdekdUXQSE5oB5XyoCbbV8RGNe/FJI/D1KM78wtP1Nyas
         utku7TUMv1zjs/u4rWnL0kbvDLt5rXQrDqGH4=
Message-ID: <4DE5283A.9070202@gmail.com>
Date: Tue, 31 May 2011 19:41:14 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: "Xu, Andiry" <Andiry.Xu@amd.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] usb: Do not attempt to reset the device while it
 is disabled
References: <1306749406-21124-1-git-send-email-m.b.lankhorst@gmail.com> <2DEEA3AB13739D45A22ADDB5086AEA0B016C1261@sshaexmb1.amd.com> <4DE4F166.8020207@gmail.com> <20110531171446.GB6776@xanatos>
In-Reply-To: <20110531171446.GB6776@xanatos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sarah,

Op 31-05-11 19:14, Sarah Sharp schreef:
> On Tue, May 31, 2011 at 03:47:18PM +0200, Maarten Lankhorst wrote:
>> Hey Andiry,
>>
>> Op 31-05-11 02:34, Xu, Andiry schreef:
>>>> -----Original Message-----
>>>> From:linux-usb-owner@vger.kernel.org  [mailto:linux-usb-
>>>> owner@vger.kernel.org] On Behalf Of Maarten Lankhorst
>>>> Sent: Monday, May 30, 2011 5:57 PM
>>>> To:linux-usb@vger.kernel.org
>>>> Cc: Sarah Sharp;linux-kernel@vger.kernel.org; Maarten Lankhorst
>>>> Subject: [PATCH] [RFC] usb: Broaden range of vendor codes for xhci
>>>>
>>>> My asrock P67 chipset sends code 192 on device reset. Allowing>= 192
>>>> to be treated as success fixes it, and allows me to use my USB3 port.
>>>>
>>> TRB completion code 192-223 is defined as Vendor defined error. Your
>>> host
>>> controller returns a error - don't know what causes the error since it's
>>> vendor defined.
>> Ahh, making it the same as COMP_EBADSLT/COMP_CTX_STATE I get this:
>> [72677.470421] xhci_hcd 0000:04:00.0: Can't reset device (slot ID 1)
>> in enabled/disabled state
> Yes, because that's what those error codes mean.  But your host
> controller did not return that error code, it returned a vendor-specific
> error code.
>
>> Should reset_device even be called when in that state? The comments
>> above claim:
>> /* The Reset Device command can't fail, according to the 0.95/0.96 spec,
>>  * unless we tried to reset a slot ID that wasn't enabled,
>>  * or the device wasn't in the addressed or configured state.
>>  */
> The code shouldn't happen, but we cover the error condition in case
> there is a future bug in the USB core, or a buggy host controller.  But
> that's really beside the point.  Your host returned a different error
> code, and there's no telling what that means without vendor specific
> documentation.  Can you send me the lspci for the host?
>
>> Ignoring the error seems to make it work fine. It seems to me that
>> device reset shouldn't even be attempted since it hasn't been
>> brought up yet. The reset that fails is the one that happens on the
>> original hub_port_init when it calls hub_port_reset which calls
>> xhci_discover_or_reset_device. The failure I'm getting seems to be a
>> vendor specific variant of "you're trying to reset the device while
>> it wasn't enabled".
> Yes, the USB core resets a device during the standard enumeration
> process.  The host controller is supposed to be able to handle that
> case.  Why it returns a vendor specific error is something that company
> needs to answer.
>
> Can you send me the full dmesg with CONFIG_USB_XHCI_HCD_DEBUGGING turned
> on?  I'd like to see the full debug log for this and see if the host or
> driver is falling over in an earlier spot.
I'm on linux 2.6.39, relevant dmesg spits out this:

xhci_hcd 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
xhci_hcd 0000:04:00.0: setting latency timer to 64
xhci_hcd 0000:04:00.0: xHCI Host Controller
xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 3
xhci_hcd 0000:04:00.0: irq 17, io mem 0xfa100000
xhci_hcd 0000:04:00.0: Failed to enable MSI-X
xhci_hcd 0000:04:00.0: irq 47 for MSI/MSI-X
xHCI xhci_add_endpoint called for root hub
xHCI xhci_check_bandwidth called for root hub
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
xhci_hcd 0000:04:00.0: xHCI Host Controller
xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 4
xHCI xhci_add_endpoint called for root hub
xHCI xhci_check_bandwidth called for root hub
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
xhci_hcd 0000:04:00.0: Unknown completion code 192 for reset device command.
usb 3-1: Cannot reset HCD device state
xhci_hcd 0000:04:00.0: Unknown completion code 192 for reset device command.
usb 3-1: Cannot reset HCD device state
xhci_hcd 0000:04:00.0: Unknown completion code 192 for reset device command.
usb 3-1: Cannot reset HCD device state
xhci_hcd 0000:04:00.0: Unknown completion code 192 for reset device command.
usb 3-1: Cannot reset HCD device state
xhci_hcd 0000:04:00.0: Unknown completion code 192 for reset device command.
usb 3-1: Cannot reset HCD device state
hub 3-0:1.0: Cannot enable port 1.  Maybe the USB cable is bad?
>> Signed-off-by: Maarten Lankhorst<m.b.lankhorst@gmail.com>
>>
>> ---
>> index 81b976e..9a869b2 100644
>> --- a/drivers/usb/host/xhci.c
>> +++ b/drivers/usb/host/xhci.c
>> @@ -2307,6 +2307,10 @@ int xhci_discover_or_reset_device(struct usb_hcd *hcd, struct usb_device *udev)
>>  			return -EINVAL;
>>  	}
>>
>> +	if (GET_SLOT_STATE(xhci_get_slot_ctx(xhci, virt_dev->out_ctx)->dev_state) == 0&&
>> +	    (xhci_get_ep_ctx(xhci, virt_dev->out_ctx, 0)->ep_info&  EP_STATE_MASK) == EP_STATE_DISABLED)
>> +		return 0;
>> +
> Why are you looking at the endpoint state?  The control endpoint state
> has nothing to do with the outcome of the Reset Device command.  The
> host controller is only allowed to reject the command if the device slot
> is not in the addressed or configured state (according to the 0.96 spec,
> I assume this host isn't a 1.0 host).  So the control endpoint state
> should have nothing to do with whether the command succeeds.
>
> I'm also confused as to why this code works.  The control endpoint is
> never disabled until the USB core deallocates a device.  Once the xHCI
> driver allocates a slot and issues an Address Device command, the
> control endpoint's output context should move from the disabled state to
> the running state.  But if this conditional actually ran, then either
> the host controller didn't update the output context for the control
> endpoint, the Address Device command failed, or something very strange
> is going on.
>
> Full dmesg with the xHCI driver debug will help me figure this out.
> What kernel are you running?
I think it happens because hub_port_reset is called in hub_port_init since
commit 07194ab7be63a972096309ab0ea747df455c6a20, so I'd say that is
what causes the reset to be called in this state?

~Maarten
