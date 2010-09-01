Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab0IAM1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 08:27:47 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:56999 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753041Ab0IAM1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 08:27:43 -0400
Message-ID: <4C7E46AB.10001@euromail.se>
Date: Wed, 01 Sep 2010 14:27:23 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100820 Thunderbird/3.1.2
MIME-Version: 1.0
To: Rafi Rubin <rafi@seas.upenn.edu>
CC: dmitry.torokhov@gmail.com, jkosina@suse.cz, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, micki@n-trig.com, chatty@enac.fr
Subject: Re: [PATCH] identify firmware version
References: <20100901020634.GD23585@core.coreip.homeip.net> <1283334517-15121-1-git-send-email-rafi@seas.upenn.edu>
In-Reply-To: <1283334517-15121-1-git-send-email-rafi@seas.upenn.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OqmPY-0005Rx-5G.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1OqmPY-0005Rx-5G 2a9efa85e019a71a7fb6997e13f421d7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2010 11:48 AM, Rafi Rubin wrote:

> This adds firmware version polling to the end of probe and reports the
> version both in the raw form and proccessed to match the formatting used
> by ntrig in windows.
> 
> Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
> ---
>  drivers/hid/hid-ntrig.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 52 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
> index 43e95de..c91ad4a 100644
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


const on the input variable would help seeing which argument is which.

> +{
> +	__u8 a =  (raw[1] & 0b00001110) >> 1;
> +	__u8 b =  (raw[0] & 0b00111100) >> 2;
> +	__u8 c = ((raw[0] & 0b00000011) << 3) | ((raw[3] & 0b11100000) >> 5);
> +	__u8 d = ((raw[3] & 0b00000111) << 3) | ((raw[2] & 0b11100000) >> 5);
> +	__u8 e =   raw[2] & 0b00000111;
> +
> +	/*
> +	 * As yet unmapped bits:
> +	 * 0b11000000 0b11110001 0b00011000 0b00011000
> +	 */
> +
> +	return sprintf(buf, "%u.%u.%u.%u.%u", a, b, c, d, e);
> +}
> +
>  static ssize_t show_phys_width(struct device *dev,
>  			       struct device_attribute *attr,
>  			       char *buf)
> @@ -776,6 +796,9 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
>  	struct hid_input *hidinput;
>  	struct input_dev *input;
>  	struct hid_report *report;
> +	unsigned char *data;
> +	struct usb_device *usb_dev = hid_to_usb_dev(hdev);
> +	char *buf;
>  
>  	if (id->driver_data)
>  		hdev->quirks |= HID_QUIRK_MULTI_INPUT;
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


Freeing buf? Since the firmware name is very much a property of the device, why
not add it to the ntrig_data struct.

> +	}
> +
>  	ret = sysfs_create_group(&hdev->dev.kobj,
>  			&ntrig_attribute_group);
>  
>  	return 0;
> +err_free_data:
> +	kfree(data);
>  err_free:
>  	kfree(nd);
>  	return ret;


Henrik

