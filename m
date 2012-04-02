Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab2DBQiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 12:38:20 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58565 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab2DBQiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 12:38:18 -0400
Message-ID: <4F79D5F6.3010101@suse.cz>
Date: Mon, 02 Apr 2012 18:38:14 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120331 Thunderbird/13.0a2
MIME-Version: 1.0
To: Simon Wood <simon@mungewell.org>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, Michael Bauer <michael@m-bauer.org>,
        Michal Maly <madcatxster@gmail.com>
Subject: Re: [PATCH 2/2] HID: hid-lg4ff: Add support for G27 leds
References: <a4e40aa5c43be934d83240849aa25f3b.squirrel@mungewell.org> <1333378444-3117-1-git-send-email-simon@mungewell.org> <1333378444-3117-2-git-send-email-simon@mungewell.org>
In-Reply-To: <1333378444-3117-2-git-send-email-simon@mungewell.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2012 04:54 PM, Simon Wood wrote:
> This patch adds supports for controlling the LED 'tachometer' on
> the G27 wheel, via the LED subsystem.
> 
> The 5 LEDs are arranged from right (1=grn, 2=grn, 3=yel, 4=yel, 5=red)
> and 'mirrored' to the left (10 LEDs in total).
> 
> Signed-off-by: Simon Wood <simon@mungewell.org>
> ---
>  drivers/hid/hid-lg4ff.c |  159 ++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 158 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
> index c3146e0..afd13ee 100644
> --- a/drivers/hid/hid-lg4ff.c
> +++ b/drivers/hid/hid-lg4ff.c
> @@ -55,7 +55,8 @@ struct lg4ff_device_entry {
>  	__u16 range;
>  	__u16 min_range;
>  	__u16 max_range;
> -	__u8  leds;
> +	__u8  led_state;
> +	struct led_classdev *led[5];
>  	struct list_head list;
>  	void (*set_range)(struct hid_device *hid, u16 range);
>  };
> @@ -335,6 +336,92 @@ static ssize_t lg4ff_range_store(struct device *dev, struct device_attribute *at
>  	return count;
>  }
>  
> +static void lg4ff_set_leds(struct hid_device *hid, __u8 leds)
> +{
> +	struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
> +	struct hid_report *report = list_entry(report_list->next, struct hid_report, list);
> +
> +	report->field[0]->value[0] = 0xf8;
> +	report->field[0]->value[1] = 0x12;
> +	report->field[0]->value[2] = leds;
> +	report->field[0]->value[3] = 0x00;
> +	report->field[0]->value[4] = 0x00;
> +	report->field[0]->value[5] = 0x00;
> +	report->field[0]->value[6] = 0x00;
> +	usbhid_submit_report(hid, report, USB_DIR_OUT);
> +}
> +
> +static void lg4ff_led_set_brightness(struct led_classdev *led_cdev,
> +			enum led_brightness value)
> +{
> +	struct device *dev;
> +	struct hid_device *hid;
> +	struct lg4ff_device_entry *uninitialized_var(entry);
> +	int i, state = 0;
> +	struct lg_drv_data* drv_data;
> +	dev = led_cdev->dev->parent;
> +	hid = container_of(dev, struct hid_device, dev);
> +	drv_data = (struct lg_drv_data *)hid_get_drvdata(hid);
...
> +static enum led_brightness lg4ff_led_get_brightness(struct led_classdev *led_cdev)
> +{
> +	struct device *dev;
> +	struct hid_device *hid;
> +	struct lg4ff_device_entry *uninitialized_var(entry);
> +	int i, value = 0;
> +	struct lg_drv_data* drv_data;
> +	dev = led_cdev->dev->parent;
> +	hid = container_of(dev, struct hid_device, dev);
> +	drv_data = (struct lg_drv_data *)hid_get_drvdata(hid);

What a mess. Do you need all the uninitialized_var's, casts here and there?

Also this would be readable if you did all the stuff directly as an
initializer for all the local variables.

And make sure to check the patch by scripts/checkpatch.pl.

> +	if (!drv_data) {
> +		hid_err(hid, "Device data not found.");
> +		return LED_OFF;
> +	}
> +
> +	entry = (struct lg4ff_device_entry *)drv_data->device_props; 
> +
> +	if (!entry) {
> +		hid_err(hid, "Device properties not found.");
> +		return LED_OFF;
> +	}
> +
> +	for (i = 0; i < 5; i++)
> +		if (led_cdev == entry->led[i]) {
> +			value = (entry->led_state >> i) & 1;
> +			break;
> +		}
> +
> +	return value ? LED_FULL : LED_OFF;
> +}

thanks,
-- 
js
suse labs

