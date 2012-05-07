Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab2EGNJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 09:09:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47931 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056Ab2EGNJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 09:09:09 -0400
Date: Mon, 7 May 2012 15:09:06 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Przemo Firszt <przemo@firszt.eu>
Cc: pinglinux@gmail.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linuxwacom-devel@lists.sourceforge.net
Subject: Re: [PATCH] HID: wacom: Add LED selector control for Wacom Intuos4
 WL
In-Reply-To: <1336395218-6865-1-git-send-email-przemo@firszt.eu>
Message-ID: <alpine.LNX.2.00.1205071508280.26736@pobox.suse.cz>
References: <1336395218-6865-1-git-send-email-przemo@firszt.eu>
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
> echo 1 > /sys/class/bluetooth/hci0:1/(dev no here)/wacom_led/status_led0_select
> 
> The status_led0_select range is 0 to 3. The brightness of the LED selector can
> be controlled as well, but this patch uses a fixed value (0x0F) and the
> selector is also permanently switched on. The naming of the attribute
> (wacom_led/status_led0_select) is the same is in USB driver for Intuos4 Wl.
> 
> Signed-off-by: Przemo Firszt <przemo@firszt.eu>
> ---
>  drivers/hid/hid-wacom.c |   93 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 93 insertions(+)
> 
> diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
> index a66e1aa..c5c6ec6 100644
> --- a/drivers/hid/hid-wacom.c
> +++ b/drivers/hid/hid-wacom.c
> @@ -31,6 +31,8 @@
>  
>  #define PAD_DEVICE_ID	0x0F
>  
> +#define WAC_CMD_LED_CONTROL     0x20
> +
>  struct wacom_data {
>  	__u16 tool;
>  	__u16 butstate;
> @@ -44,6 +46,7 @@ struct wacom_data {
>  	__u8 ps_connected;
>  	struct power_supply battery;
>  	struct power_supply ac;
> +	__u8 led_selector;
>  };
>  
>  /*percent of battery capacity for Graphire
> @@ -64,6 +67,88 @@ static enum power_supply_property wacom_ac_props[] = {
>  	POWER_SUPPLY_PROP_SCOPE,
>  };
>  
> +static void wacom_led_control(struct hid_device *hdev)
> +{
> +	struct wacom_data *wdata = hid_get_drvdata(hdev);
> +	unsigned char *buf;
> +		__u8 led = 0;
> +
> +	buf = kzalloc(9, GFP_KERNEL);
> +	if (buf) {
> +		led =  wdata->led_selector | 0x4;
> +
> +		buf[0] = WAC_CMD_LED_CONTROL;
> +		buf[1] = led;
> +		buf[2] = 0x0F;
> +		hdev->hid_output_raw_report(hdev, buf, 9, HID_FEATURE_REPORT);
> +
> +		kfree(buf);
> +	}
> +
> +	return;
> +}
> +
> +static ssize_t wacom_led0_select_store(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
> +	struct wacom_data *wdata = hid_get_drvdata(hdev);
> +	int new_led;
> +
> +	if (sscanf(buf, "%1d", &new_led) != 1)
> +		return -EINVAL;
> +
> +	wdata->led_selector = new_led & 0x03;
> +
> +	wacom_led_control(hdev);
> +	return strnlen(buf, PAGE_SIZE);
> +}
> +
> +static ssize_t wacom_led0_select_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
> +	struct wacom_data *wdata = hid_get_drvdata(hdev);
> +
> +	return snprintf(buf, 2, "%d\n", wdata->led_selector);
> +}
> +
> +static DEVICE_ATTR(status_led0_select, S_IWUSR | S_IRUSR,
> +		    wacom_led0_select_show, wacom_led0_select_store);
> +
> +static struct attribute *intuos4_led_attrs[] = {
> +	&dev_attr_status_led0_select.attr,
> +	NULL
> +};
> +
> +static struct attribute_group intuos4_led_attr_group = {
> +	.name = "wacom_led",
> +	.attrs = intuos4_led_attrs,
> +};
> +
> +static int wacom_initialize_leds(struct hid_device *hdev)
> +{
> +	struct wacom_data *wdata = hid_get_drvdata(hdev);
> +	int ret;
> +
> +	wdata->led_selector = 0;
> +	ret = sysfs_create_group(&hdev->dev.kobj, &intuos4_led_attr_group);
> +
> +	if (ret) {
> +		dev_err(&hdev->dev,
> +			"cannot create sysfs group err: %d\n", ret);
> +		return ret;
> +	}
> +	wacom_led_control(hdev);
> +
> +	return 0;
> +}
> +
> +static void wacom_destroy_leds(struct hid_device *hdev)
> +{
> +	sysfs_remove_group(&hdev->dev.kobj, &intuos4_led_attr_group);
> +}
> +
>  static int wacom_battery_get_property(struct power_supply *psy,
>  				enum power_supply_property psp,
>  				union power_supply_propval *val)
> @@ -602,6 +687,12 @@ static int wacom_probe(struct hid_device *hdev,
>  		sprintf(hdev->name, "%s", "Wacom Intuos4 WL");
>  		wdata->features = 0;
>  		wacom_set_features(hdev);
> +		ret = wacom_initialize_leds(hdev);
> +		if (ret) {
> +			hid_warn(hdev,
> +				 "can't create led attribute, err: %d\n", ret);
> +			goto destroy_leds;
> +		}
>  		break;
>  	}
>  
> @@ -644,6 +735,8 @@ err_ac:
>  err_battery:
>  	device_remove_file(&hdev->dev, &dev_attr_speed);
>  	hid_hw_stop(hdev);
> +destroy_leds:
> +	wacom_destroy_leds(hdev);
>  err_free:
>  	kfree(wdata);
>  	return ret;

Przemo,

is there a particular reason for not using LEDS_CLASS for this, please?

-- 
Jiri Kosina
SUSE Labs
