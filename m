Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab2EJKJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 06:09:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42523 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755144Ab2EJKJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 06:09:53 -0400
Date: Thu, 10 May 2012 12:09:45 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Przemo Firszt <przemo@firszt.eu>
Cc: pinglinux@gmail.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linuxwacom-devel@lists.sourceforge.net
Subject: Re: [PATCH] HID: wacom: Add LED selector control for Wacom Intuos4
 WL
In-Reply-To: <1336419611-10372-1-git-send-email-przemo@firszt.eu>
Message-ID: <alpine.LNX.2.00.1205101205430.31253@pobox.suse.cz>
References: <1336419611-10372-1-git-send-email-przemo@firszt.eu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2012, Przemo Firszt wrote:

> Add sysfs attribute to control LED selector on Wacom Intuos4. There are 4
> different LEDs on the tablet and they can be turned on by something like:
> 
> echo 50 > /sys/class/leds/(device # here)\:selector\:1/brightness
> 
> Only one can be lit at a time. The brightness range is 0 to 127. This patch
> also contains short ABI description.
> 
> Signed-off-by: Przemo Firszt <przemo@firszt.eu>
[ ... snip ... ]
> @@ -44,6 +47,8 @@ struct wacom_data {
>  	__u8 ps_connected;
>  	struct power_supply battery;
>  	struct power_supply ac;
> +	__u8 led_selector;
> +	struct led_classdev *leds[3];

Here you define the leds[] array to have 3 members.

>  /*percent of battery capacity for Graphire
> @@ -64,6 +69,117 @@ static enum power_supply_property wacom_ac_props[] = {
>  	POWER_SUPPLY_PROP_SCOPE,
>  };
>  
> +static void wacom_leds_set_brightness(struct led_classdev *led_dev,
> +						enum led_brightness value)
> +{
> +	struct device *dev = led_dev->dev->parent;
> +	struct hid_device *hdev;
> +	struct wacom_data *wdata;
> +	unsigned char *buf;
> +	__u8 led = 0;
> +	int i;
> +
> +	hdev = container_of(dev, struct hid_device, dev);
> +	wdata = hid_get_drvdata(hdev);
> +	for (i = 0; i < 4; ++i) {

And here you are going off-by-one.

> +		if (wdata->leds[i] == led_dev)
> +			wdata->led_selector = i;
> +	}
> +
> +	led = wdata->led_selector | 0x04;
> +	buf = kzalloc(9, GFP_KERNEL);
> +	if (buf) {
> +		buf[0] = WAC_CMD_LED_CONTROL;
> +		buf[1] = led;
> +		buf[2] = value;
> +		hdev->hid_output_raw_report(hdev, buf, 9, HID_FEATURE_REPORT);
> +		kfree(buf);
> +	}
> +
> +	return;
> +}
> +
> +static enum led_brightness wacom_leds_get_brightness(struct led_classdev *led_dev)
> +{
> +	struct wacom_data *wdata;
> +	struct device *dev = led_dev->dev->parent;
> +	int value = 0;
> +	int i;
> +
> +	wdata = hid_get_drvdata(container_of(dev, struct hid_device, dev));
> +
> +	for (i = 0; i < 4; ++i) {

And here as well.

Otherwise the patch looks fine, and once you fix this, I will apply it. 
Thanks,

-- 
Jiri Kosina
SUSE Labs
