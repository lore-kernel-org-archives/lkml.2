Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886Ab2LJRF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 12:05:59 -0500
Received: from smtp-out-245.synserver.de ([212.40.185.245]:1034 "EHLO
	smtp-out-237.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751691Ab2LJRF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 12:05:57 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 26869
Message-ID: <50C61675.2000407@metafoo.de>
Date: Mon, 10 Dec 2012 18:05:57 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>
Subject: Re: [PATCH 3/3 v2] iio: add rtc-driver for HID sensors of type time
References: <50C5DFCC.60203@ahsoftware.de> <1355151119-2489-1-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1355151119-2489-1-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 03:51 PM, Alexander Holler wrote:
> This driver makes the time from HID sensors (hubs) which are offering
> such available like any other RTC does.
> 
> Currently the time can only be read. Setting the time must be done
> through sending a report, which currently isn't supported by
> hid-sensor-hub.
> 
> It is necessary that all values like year, month etc, are send as
> 8bit values (1 byte each) and all of them in 1 report. Also the
> spec HUTRR39b doesn't define the range of the year field, we
> tread it as 0 - 99 because that's what most RTCs I know about are
> offering.
> 
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>

Looks pretty good now. But there are still some IIO remnants which should be
removed as well. Also the driver should move to drivers/rtc/ since, well,
it's a rtc driver not a IIO driver.

> diff --git a/drivers/iio/time/hid-sensor-time.c b/drivers/iio/time/hid-sensor-time.c
> new file mode 100644
> index 0000000..556bac9
> --- /dev/null
> +++ b/drivers/iio/time/hid-sensor-time.c
> @@ -0,0 +1,346 @@
[...]
> +
> +/* Channel definitions */
> +static const struct iio_chan_spec hid_time_channels[TIME_RTC_CHANNEL_MAX] = {
> +	{
> +		.info_mask = IIO_CHAN_INFO_RAW,
> +		.scan_index = CHANNEL_SCAN_INDEX_YEAR,
> +		.extend_name = "year",
> +	}, {
> +		.info_mask = IIO_CHAN_INFO_RAW,
> +		.scan_index = CHANNEL_SCAN_INDEX_MONTH,
> +		.extend_name = "month",
> +	}, {
> +		.info_mask = IIO_CHAN_INFO_RAW,
> +		.scan_index = CHANNEL_SCAN_INDEX_DAY,
> +		.extend_name = "day",
> +	}, {
> +		.info_mask = IIO_CHAN_INFO_RAW,
> +		.scan_index = CHANNEL_SCAN_INDEX_HOUR,
> +		.extend_name = "hour",
> +	}, {
> +		.info_mask = IIO_CHAN_INFO_RAW,
> +		.scan_index = CHANNEL_SCAN_INDEX_MINUTE,
> +		.extend_name = "minute",
> +	}, {
> +		.info_mask = IIO_CHAN_INFO_RAW,
> +		.scan_index = CHANNEL_SCAN_INDEX_SECOND,
> +		.extend_name = "second",
> +	}
> +};

The channel spec is semi unused. You use it to lookup the scan index and the
name, but that could easily be implemented without the channel spec.
Especially considering that the scan index lookup is only ever done for
channel 0, which will always return CHANNEL_SCAN_INDEX_YEAR.

> +
> +static int hid_time_read_raw(struct hid_time_state *time_state,
> +			      struct iio_chan_spec const *chan,
> +			      int *val, int *val2,
> +			      long mask)
> +{
> +	int report_id;
> +	u32 address;
> +
> +	*val = 0;
> +	*val2 = 0;
> +	if (mask)
> +		return -EINVAL;
> +	report_id = time_state->info[chan->scan_index].report_id;
> +	address = hid_time_addresses[chan->scan_index];
> +	if (report_id >= 0) {
> +		*val = sensor_hub_input_attr_get_raw_value(
> +			time_state->common_attributes.hsdev,
> +			HID_USAGE_SENSOR_TIME, address, report_id);

Just directly call sensor_hub_input_attr_get_raw_value in hid_rtc_read_time
instead of wrapping it here.

> +		return IIO_VAL_INT;
> +	}
> +	*val = 0;
> +	return -EINVAL;
> +}
> +

[...]

Are the entries in info ordered in the same way as the addresses in
hid_time_addresses? If yes you could just use a lookup-table like

static const char * const hid_time_attrib_names[] = {
	"second",
	...
};

and just use 'i' to look them up.

> +static const char *attrib_name(u32 attrib_id)
> +{
> +	unsigned i = 0;
> +	static const char unknown[] = "unknown";
> +
> +	for (; i < TIME_RTC_CHANNEL_MAX; ++i) {
> +		if (hid_time_addresses[i] == attrib_id)
> +			return hid_time_channels[i].extend_name;
> +	}
> +	return unknown; /* should never happen */
> +}
> +
> +static int hid_time_parse_report(struct platform_device *pdev,
> +				struct hid_sensor_hub_device *hsdev,
> +				unsigned usage_id,
> +				struct hid_time_state *time_state)
> +{
> +	int ret, i = 0;
> +
> +	for (; i < TIME_RTC_CHANNEL_MAX; ++i) {

I'd put the i = 0 in the for header.

> +		ret = sensor_hub_input_get_attribute_info(hsdev,
> +				HID_INPUT_REPORT, usage_id,
> +				hid_time_addresses[i], &time_state->info[i]);
> +		if (ret < 0)
> +			return ret;
> +	}
> +	/* Check the (needed) attributes for sanity */
> +	ret = time_state->info[0].report_id; /* use ret as temp. */

maybe name it report_id instead of ret

> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "bad report ID!\n");
> +		return -EINVAL;
> +	}
> +	for (i = 0; i < TIME_RTC_CHANNEL_MAX; ++i) {
> +		if (time_state->info[i].report_id != ret) {
> +			dev_err(&pdev->dev,
> +				"not all needed attributes inside the same report!\n");
> +			return -EINVAL;
> +		}
[...]
> +	}
> +
> +	return 0;
> +}
> +
> +static int hid_rtc_read_time(struct device *dev,
> +	struct rtc_time *tm)
> +{
> +	int val;
> +	unsigned long flags;
> +	struct hid_time_state *time_state =
> +		platform_get_drvdata(to_platform_device(dev));
> +
> +	init_completion(&time_state->comp_last_time);

This needs to be INIT_COMPLETION. init_completion must be called exactly
once on a completion, which should be from inside probe() in this case.

> +	/* start a read */
> +	if (hid_time_read_raw(time_state,
> +			&hid_time_channels[0], &val, &val, 0) == -EINVAL) {
> +		dev_err(dev, "unable to read time!\n");
> +		return -EIO;
> +	}
> +	/* wait for all values (event) */
> +	wait_for_completion_interruptible_timeout(&time_state->comp_last_time,
> +							HZ*6);

You should check the return value in case either a timeout happens or the
sleep is interrupted.

> +	spin_lock_irqsave(&time_state->lock_last_time, flags);
> +	*tm = time_state->last_time;
> +	spin_unlock_irqrestore(&time_state->lock_last_time, flags);
> +
> +	return 0;
> +}
> +
> +static const struct rtc_class_ops rtc_ops = {
> +	.read_time = hid_rtc_read_time,
> +};
> +
> +static int __devinit hid_time_probe(struct platform_device *pdev)

__devinit is going away, it shouldn't be used anymore in new drivers.

> +{
> +	int ret = 0;
> +	struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
> +	struct hid_time_state *time_state =
> +		kzalloc(sizeof(struct hid_time_state), GFP_KERNEL);

You could use devm_kzalloc here. By doing so you don't have to take care of
freeing it again since it will be auto-freed once the device is removed.

> +
> +	if (time_state == NULL) {
> +		ret = -ENOMEM;
> +		goto error_ret;
> +	}
> +
> +	platform_set_drvdata(pdev, time_state);
> +
> +	time_state->common_attributes.hsdev = hsdev;
> +	time_state->common_attributes.pdev = pdev;
> +
> +	ret = hid_sensor_parse_common_attributes(hsdev,
> +				HID_USAGE_SENSOR_TIME,
> +				&time_state->common_attributes);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to setup common attributes!\n");
> +		goto error_free_drvdata;
> +	}
> +
> +	ret = hid_time_parse_report(pdev, hsdev, /*channels,*/

remove the commented out code

> +				HID_USAGE_SENSOR_TIME, time_state);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to setup attributes!\n");
> +		goto error_free_drvdata;
> +	}
> +
> +	time_state->callbacks.send_event = hid_time_proc_event;
> +	time_state->callbacks.capture_sample = hid_time_capture_sample;
> +	time_state->callbacks.pdev = pdev;
> +	ret = sensor_hub_register_callback(hsdev, HID_USAGE_SENSOR_TIME,
> +					&time_state->callbacks);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "register callback failed!\n");
> +		goto error_free_drvdata;
> +	}
> +
> +	time_state->rtc = rtc_device_register("hid-sensor-time",
> +				&pdev->dev, &rtc_ops, THIS_MODULE);

Since the driver does not do much if the rtc device could not be registered
I think it should be ok to fail probe in case registering the rtc device fails.

> +
> +	if (IS_ERR(time_state->rtc)) {
> +		ret = PTR_ERR(time_state->rtc);
> +		dev_err(&pdev->dev, "rtc device register failed!\n");
> +		goto error_free_drvdata;
> +	}
> +
> +	return ret;
> +
> +error_free_drvdata:
> +	platform_set_drvdata(pdev, NULL);

Setting the platform data to NULL should not be necessary. Some drivers do
this but it's kind of the result of cargo-cult-coding.

> +	kfree(time_state);
> +error_ret:
> +	return ret;
> +}
> +
> +static int __devinit hid_time_remove(struct platform_device *pdev)
> +{
> +	struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
> +	struct hid_time_state *time_state = platform_get_drvdata(pdev);
> +
> +	if (!IS_ERR(time_state->rtc))
> +		rtc_device_unregister(time_state->rtc);
> +	sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
> +	platform_set_drvdata(pdev, NULL);

Same here.

> +	kfree(time_state);
> +
> +	return 0;
> +}
> +
[...]
