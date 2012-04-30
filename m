Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab2D3Sva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 14:51:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53462 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2D3Sv2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 14:51:28 -0400
MIME-Version: 1.0
In-Reply-To: <20120430183023.GA5585@polaris.bitmath.org>
References: <1335175627-2270-1-git-send-email-rydberg@euromail.se>
	<1335175627-2270-6-git-send-email-rydberg@euromail.se>
	<CAN+gG=EWHi18kb1q2xQg8mfS9o6BHVLVdU+KYUcWdM4L3gJybA@mail.gmail.com>
	<20120430183023.GA5585@polaris.bitmath.org>
Date: Mon, 30 Apr 2012 20:51:28 +0200
Message-ID: <CAN+gG=Ekz8HMBP0ZOSts5ek9x38FW7v177K-p-kVBvCCkh6kOA@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] hid-multitouch: Switch to device groups
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Tissoires <Benjamin_Tissoires@logitech.com>,
        Stephane Chatty <chatty@enac.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 20:30, Henrik Rydberg <rydberg@euromail.se> wrote:
>> I remarked a small regression in this patch: the detection of the
>> serial protocol is not handled anymore. I was indeed relying on the
>> fact that the parameter "id" in mt_probe was null to know that the
>> device was not already in the list of known devices.
>
> I see. Will this suffice?

Yes, but I'd rather do the test against either id->product or
id->driver_data as we may use HID_ANY_ID for vendors specific
handling. For instance, I had the confirmation from EETI (eGalax) that
they will always use the same protocol for their usb products, thus
the same quirks could be handled by HID_DEVICE(BUS_USB,
HID_GROUP_MULTITOUCH, USB_VENDOR_ID_DWAV, HID_ANY_ID).

Thanks,
Benjamin

>
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 125c1e7..507981e 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -673,8 +673,8 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
>        if (ret)
>                goto fail;
>
> -       if (!id && td->touches_by_report == 1) {
> -               /* the device has been sent by hid-generic */
> +       /* unknown serial devices need special quirks */
> +       if ((!id || id->product == HID_ANY_ID) && td->touches_by_report == 1) {
>                mtclass = &td->mtclass;
>                mtclass->quirks |= MT_QUIRK_ALWAYS_VALID;
>                mtclass->quirks &= ~MT_QUIRK_NOT_SEEN_MEANS_UP;
>
> Cheers,
> Henrik
