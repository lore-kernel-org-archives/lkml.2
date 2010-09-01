Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab0IAKEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 06:04:25 -0400
Received: from fox.seas.upenn.edu ([158.130.68.12]:52210 "EHLO
	fox.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab0IAKEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 06:04:23 -0400
Message-ID: <4C7E2516.1020400@seas.upenn.edu>
Date: Wed, 01 Sep 2010 06:04:06 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: Rafi Rubin <rafi@seas.upenn.edu>
CC: dmitry.torokhov@gmail.com, jkosina@suse.cz, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, micki@n-trig.com, rydberg@euromail.se,
        chatty@enac.fr
Subject: Re: [PATCH] identify firmware version
References: <20100901020634.GD23585@core.coreip.homeip.net> <1283334517-15121-1-git-send-email-rafi@seas.upenn.edu>
In-Reply-To: <1283334517-15121-1-git-send-email-rafi@seas.upenn.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-09-01_07:2010-09-01,2010-09-01,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1009010024
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to be clear, this is basically the same as the previous patch 3/4.  I just 
pulled the storage of the value.  Even if later someone wants a sysfs node, we 
can just poll the device on read.

Thanks Henrik for pointing out that it would be nice to dump the version during 
init.

Rafi

On 09/01/10 05:48, Rafi Rubin wrote:
> This adds firmware version polling to the end of probe and reports the
> version both in the raw form and proccessed to match the formatting used
> by ntrig in windows.
>
> Signed-off-by: Rafi Rubin<rafi@seas.upenn.edu>
> ---
>   drivers/hid/hid-ntrig.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++
>   1 files changed, 52 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
> index 43e95de..c91ad4a 100644
> --- a/drivers/hid/hid-ntrig.c
> +++ b/drivers/hid/hid-ntrig.c
> @@ -90,6 +90,26 @@ struct ntrig_data {
>   };
>
>
> +/*
> + * This function converts the 4 byte raw firmware code into
> + * a string containing 5 comma separated numbers.
> + */
> +static int ntrig_version_string(unsigned char *raw, char *buf)
> +{
> +	__u8 a =  (raw[1]&  0b00001110)>>  1;
> +	__u8 b =  (raw[0]&  0b00111100)>>  2;
> +	__u8 c = ((raw[0]&  0b00000011)<<  3) | ((raw[3]&  0b11100000)>>  5);
> +	__u8 d = ((raw[3]&  0b00000111)<<  3) | ((raw[2]&  0b11100000)>>  5);
> +	__u8 e =   raw[2]&  0b00000111;
> +
> +	/*
> +	 * As yet unmapped bits:
> +	 * 0b11000000 0b11110001 0b00011000 0b00011000
> +	 */
> +
> +	return sprintf(buf, "%u.%u.%u.%u.%u", a, b, c, d, e);
> +}
> +
>   static ssize_t show_phys_width(struct device *dev,
>   			       struct device_attribute *attr,
>   			       char *buf)
> @@ -776,6 +796,9 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
>   	struct hid_input *hidinput;
>   	struct input_dev *input;
>   	struct hid_report *report;
> +	unsigned char *data;
> +	struct usb_device *usb_dev = hid_to_usb_dev(hdev);
> +	char *buf;
>
>   	if (id->driver_data)
>   		hdev->quirks |= HID_QUIRK_MULTI_INPUT;
> @@ -848,10 +871,39 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
>   	if (report)
>   		usbhid_submit_report(hdev, report, USB_DIR_OUT);
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
>   	ret = sysfs_create_group(&hdev->dev.kobj,
>   			&ntrig_attribute_group);
>
>   	return 0;
> +err_free_data:
> +	kfree(data);
>   err_free:
>   	kfree(nd);
>   	return ret;
