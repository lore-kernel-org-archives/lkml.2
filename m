Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab0IAUMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 16:12:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36855 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab0IAUMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 16:12:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=e9W35JsO7gFZkCFpkHg5WIGqvVkBt7vxkBDNFq90zcIrADQHsbw0exHtyAYffbt/dx
         gYRvHHXk7WSSsUhLJfb9l1vk3Mg/qQhT+r2Vn0R8lKo/47ZUdQhYMuP+fDLoE3TTER0f
         0ZuAG1/q+ES+LCFvpeYilZ15iCPZYHADSC7yA=
Message-ID: <4C7EB3A3.7050402@gmail.com>
Date: Wed, 01 Sep 2010 22:12:19 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Rafi Rubin <rafi@seas.upenn.edu>
CC: dmitry.torokhov@gmail.com, jkosina@suse.cz, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, micki@n-trig.com, rydberg@euromail.se,
        chatty@enac.fr
Subject: Re: [PATCH] identify firmware version
References: <20100901020634.GD23585@core.coreip.homeip.net> <1283334517-15121-1-git-send-email-rafi@seas.upenn.edu>
In-Reply-To: <1283334517-15121-1-git-send-email-rafi@seas.upenn.edu>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2010 11:48 AM, Rafi Rubin wrote:
> --- a/drivers/hid/hid-ntrig.c
> +++ b/drivers/hid/hid-ntrig.c
> @@ -90,6 +90,26 @@ struct ntrig_data {
>  };
>  
>  
> +/*
> + * This function converts the 4 byte raw firmware code into
> + * a string containing 5 comma separated numbers.
> + */
> +static int ntrig_version_string(unsigned char *raw, char *buf)
> +{
> +	__u8 a =  (raw[1] & 0b00001110) >> 1;
> +	__u8 b =  (raw[0] & 0b00111100) >> 2;
> +	__u8 c = ((raw[0] & 0b00000011) << 3) | ((raw[3] & 0b11100000) >> 5);
> +	__u8 d = ((raw[3] & 0b00000111) << 3) | ((raw[2] & 0b11100000) >> 5);
> +	__u8 e =   raw[2] & 0b00000111;

This won't compile with gcc 3.4 which we still support. Maybe time to
kill the support?

...
> @@ -848,10 +871,39 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
>  	if (report)
>  		usbhid_submit_report(hdev, report, USB_DIR_OUT);
>  
> +	data = kmalloc(8, GFP_KERNEL);
> +	if (!data) {
> +		ret = -ENOMEM;
> +		goto err_free;
> +	}
> +
> +	ret = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
> +			      USB_REQ_CLEAR_FEATURE,
> +			      USB_TYPE_CLASS | USB_RECIP_INTERFACE |
> +			      USB_DIR_IN,
> +			      0x30c, 1, data, 8,
> +			      USB_CTRL_SET_TIMEOUT);
> +
> +	if (ret == 8) {
> +		buf = kmalloc(20, GFP_KERNEL);
> +		if (!buf) {
> +			ret = -ENOMEM;
> +			goto err_free_data;
> +		}
> +
> +		ret = ntrig_version_string(&data[2], buf);
> +
> +		dev_info(&hdev->dev,
> +			 "Firmware version: %s (%02x%02x %02x%02x)\n",
> +			 buf, data[2], data[3], data[4], data[5]);
> +	}
> +
>  	ret = sysfs_create_group(&hdev->dev.kobj,
>  			&ntrig_attribute_group);
>  
>  	return 0;

Two leaks here.

> +err_free_data:
> +	kfree(data);
>  err_free:
>  	kfree(nd);
>  	return ret;


-- 
js
