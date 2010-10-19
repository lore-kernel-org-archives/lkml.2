Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492Ab0JSLd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:33:29 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57385 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758474Ab0JSLd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:33:26 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6140"; a="58478821"
Message-ID: <217d07c2bcc41c06a975cbe7b2465d64.squirrel@www.codeaurora.org>
In-Reply-To: <Pine.LNX.4.44L0.1010181444170.28752-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1010181444170.28752-100000@netrider.rowland.org>
Date: Tue, 19 Oct 2010 04:35:27 -0700 (PDT)
Subject: Re: [RFC/PATCH v2 3/3] usb: Adding SuperSpeed support to dummy_hcd
From: tlinder@codeaurora.org
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Tatyana Brokhman" <tlinder@codeaurora.org>, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        "David Brownell" <dbrownell@users.sourceforge.net>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 18 Oct 2010, Tatyana Brokhman wrote:
>
>> USB 3.0 hub includes 2 hubs - HS and SS ones.
>> Thus, when dummy_hcd enabled it will register 2 root hubs (SS and HS).
>
> All of your new kerneldoc comments are invalid.  The patch cannot be
> accepted until you fix them.

I'll go over them once more.

>
>> @@ -750,16 +865,24 @@ static DEVICE_ATTR (function, S_IRUGO,
>> show_function, NULL);
>>  int
>>  usb_gadget_register_driver (struct usb_gadget_driver *driver)
>>  {
>> -	struct dummy	*dum = the_controller;
>> +	struct dummy	*dum;
>>  	int		retval, i;
>> +	enum usb_device_speed	speed = USB_SPEED_UNKNOWN;
>> +
>> +	if (!driver->bind || !driver->setup
>> +			|| driver->speed == USB_SPEED_UNKNOWN)
>> +		return -EINVAL;
>> +
>> +	speed = driver->speed;
>
> What do you need "speed" for?  Can't you use driver->speed?

removed.

>
>> +static int dummy_ss_udc_probe(struct platform_device *pdev)
>> +{
>> +	struct dummy	*dum = the_ss_controller;
>> +	int		rc;
>> +
>> +	dum->gadget.name = gadget_name;
>> +	dum->gadget.ops = &dummy_ops;
>> +	dum->gadget.is_dualspeed = 1;
>
> Is this setting appropriate?  The "is_dualspeed" field indicates that
> the gadget runs at both full speed and high speed.  But that's not what
> you want -- you want to indicate that the gadget runs at SuperSpeed.

If a device operates in SuperSpeed it supports high and full speeds as
well. If we don't set this flag we will fail for example in ep_matches().
We didn't want to add another flag for is_superspeed. Reusing this flag
suited our current purposes well and doesn't contradict it's meaning.

>
>> @@ -1384,6 +1559,9 @@ static void dummy_timer (unsigned long _dum)
>>  	case USB_SPEED_HIGH:
>>  		total = 512/*bytes*/ * 13/*packets*/ * 8/*uframes*/;
>>  		break;
>> +	case USB_SPEED_SUPER:
>> +		total = 1024/*bytes*/ * 13/*packets*/ * 8/*uframes*/;
>> +		break;
>
> I don't know what the transfer parameters for SuperSpeed are, but I do
> know that these are wrong.  With over 60000 bytes per uframe there is
> certainly room for more than thirteen 1024-byte packets.

We'll rethink this.

>> +/**
>> + * dummy_address_device() - Assign an address for the connected
>> + * device
>> + * @param hcd - host controller of the device
>> + * @param udev - device to address
>> + *
>> + * @return int - 0 on success, or an error code (refer to
>> + *	   errno-base.h for details)
>> + *
>> + * Issue an Address Device command (which will issue a
>> + * SetAddress request to the device). We should be protected by
>> + * the usb_address0_mutex in khubd's hub_port_init, so we should
>> + * only issue and wait on one address command at the same time.
>> + *
>> + * This function is used only for SS hcd drivers.
>> + */
>> +static int dummy_address_device(struct usb_hcd *hcd, struct usb_device
>> *udev)
>> +{
>> +	udev->devnum = 3;
>> +	return usb_control_msg(udev, (PIPE_CONTROL << 30),
>> +		USB_REQ_SET_ADDRESS, 0, udev->devnum, 0,
>> +		NULL, 0, USB_CTRL_SET_TIMEOUT);
>> +}
>
> This looks very suspicious.  Why have this function if it's only going
> to do the same thing that usbcore would do if it weren't present?

Upon new device connection the host addresses the device from
hub_set_address() that if the address_device cb was provided for the hcd -
calls it. This function begins with a verification that either this cb was
supplied or the usbcore already addresses the device (meaning udev->devnum
> 1).
usbcore addresses the device in choose_address() that is called from
hub_port_connect_change but only if it's not a SuperSpeed hcd:
if (!(hcd->driver->flags & HCD_USB3)) {
	/* set the address */
        choose_address(udev);
        ...
}
Since our hcd is SuperSpeed, choose_address() isn't called and
udev->devnum remains 0.
Due to the above in order for this implementation to work properly we have
to provide the address_device cb for a SuperSpeed hcd.
Perhaps this was already fixed but I'm not familiar with such patch. I
would be happy to pick it up if you could refer me to it.

> Also, the address_device routine should not change udev->devnum.  The
> code that does this in the xhci driver is being removed, because it
> causes bugs.

A better solution might be to call choose_address() for SuperSpeed hcd as
well. If that sounds good to everyone I can make the change.

> Alan Stern
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


