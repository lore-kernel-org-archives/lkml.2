Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab0IFTsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 15:48:51 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44922 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab0IFTso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 15:48:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=heVZIUjJi6Y9cWPLl//AtORVi8nohoJvVFRjirXgqugBwoyfId6iQ5vhdT9Hq4slkC
         Rw78WJoZlgosTTl9wSdIXSOuepTxORkIZRQyG6oeA4lK8J8UTgbg6RstRDhTI08GGkqz
         4Z93nnroEMTHLJfiE1pZXci2Zv3jKa89kld9k=
Date: Mon, 6 Sep 2010 12:48:38 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Rafi Rubin <rafi@seas.upenn.edu>
Cc: jkosina@suse.cz, linux-input@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, micki@n-trig.com, rydberg@euromail.se,
        chatty@enac.fr
Subject: Re: [PATCH] identify firmware version
Message-ID: <20100906194838.GB31384@core.coreip.homeip.net>
References: <4C7EB3A3.7050402@gmail.com>
 <1283791362-27780-1-git-send-email-rafi@seas.upenn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283791362-27780-1-git-send-email-rafi@seas.upenn.edu>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafi,

On Mon, Sep 06, 2010 at 12:42:42PM -0400, Rafi Rubin wrote:
> This adds firmware version polling to the end of probe and reports the
> version both in the raw form and proccessed to match the formatting used
> by N-Trig.
> 
> Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
> ---
>  drivers/hid/hid-ntrig.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 56 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
> index 43e95de..3472b3b 100644
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
> +	__u8 a =  (raw[1] & 0x0e) >> 1;
> +	__u8 b =  (raw[0] & 0x3c) >> 2;
> +	__u8 c = ((raw[0] & 0x03) << 3) | ((raw[3] & 0xe0) >> 5);
> +	__u8 d = ((raw[3] & 0x07) << 3) | ((raw[2] & 0xe0) >> 5);
> +	__u8 e =   raw[2] & 0x07;
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
> @@ -848,10 +871,43 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
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

Why do you allocate this from heap? Surely we can spare 20 bytes on
stack (you aren't doing DMA into it).

I'd also split all this code into ntrig_report_version() to simplifu
error handling here.

> +
> +		ret = ntrig_version_string(&data[2], buf);
> +
> +		dev_info(&hdev->dev,
> +			 "Firmware version: %s (%02x%02x %02x%02x)\n",
> +			 buf, data[2], data[3], data[4], data[5]);
> +
> +		kfree(buff);
> +	}
> +
>  	ret = sysfs_create_group(&hdev->dev.kobj,
>  			&ntrig_attribute_group);
>  
> +	kfree(data);
> +
>  	return 0;
> +err_free_data:
> +	kfree(data);
>  err_free:
>  	kfree(nd);
>  	return ret;
> -- 
> 1.7.1
> 

-- 
Dmitry
