Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab2LLJva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 04:51:30 -0500
Received: from smtp-out-245.synserver.de ([212.40.185.245]:1105 "EHLO
	smtp-out-245.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab2LLJv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 04:51:28 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 16253
Message-ID: <50C8539C.1070509@metafoo.de>
Date: Wed, 12 Dec 2012 10:51:24 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4 v3] rtc: add rtc-driver for HID sensors of type time
References: <50C73AFC.1050904@jic23.retrosnub.co.uk> <1355250106-3114-1-git-send-email-holler@ahsoftware.de> <1355250106-3114-4-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1355250106-3114-4-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 07:21 PM, Alexander Holler wrote:
> This driver makes the time from HID sensors (hubs) which are offering
> such available like any other RTC does.
> 
> Currently the time can only be read. Setting the time must be done
> through sending a report, which currently isn't supported by
> hid-sensor-hub. (I've planned to submit patches.)
> 
> It is necessary that all values like year, month etc, are send as
> 8bit values (1 byte each) and all of them in 1 report. Also the
> spec HUTRR39b doesn't define the range of the year field, we
> tread it as 0 - 99 because that's what most RTCs I know about are
> offering.
> 
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>

Looks good, but as I wrote during the last review the __devinits need to go.
A few other suggerstions online

> ---
>  drivers/rtc/Kconfig               |   16 ++
>  drivers/rtc/Makefile              |    1 +
>  drivers/rtc/rtc-hid-sensor-time.c |  284 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 301 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/rtc/rtc-hid-sensor-time.c
> 
> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> index 19c03ab..7c7b33e 100644
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -1144,4 +1144,20 @@ config RTC_DRV_SNVS
>  	   This driver can also be built as a module, if so, the module
>  	   will be called "rtc-snvs".
>  
> +comment "HID Sensor RTC drivers"
> +
> +config RTC_DRV_HID_SENSOR_TIME
> +	tristate "HID Sensor Time"
> +	depends on USB_HID
> +	select IIO
> +	select HID_SENSOR_HUB
> +	select HID_SENSOR_IIO_COMMON
> +	help
> +	  Say yes here to build support for the HID Sensors of type Time.
> +	  This drivers makes such sensors available as RTCs.
> +
> +          If this driver is compiled as a module, it will be named
> +          rtc-hid-sensor-time.

The help text should be indented using one tab followed by two spaces

> +
> +
>  endif # RTC_CLASS
[...]
> diff --git a/drivers/rtc/rtc-hid-sensor-time.c b/drivers/rtc/rtc-hid-sensor-time.c
> new file mode 100644
> index 0000000..42b7ba1
> --- /dev/null
> +++ b/drivers/rtc/rtc-hid-sensor-time.c
> @@ -0,0 +1,284 @@
[...]
> +
> +/* Channel names for verbose error messages */
> +static const char *hid_time_channel_names[TIME_RTC_CHANNEL_MAX] = {

const char * const

> +	"year", "month", "day", "hour", "minute", "second",
> +};
> +
> +/* Callback handler to send event after all samples are received and captured */
> +static int hid_time_proc_event(struct hid_sensor_hub_device *hsdev,
> +				unsigned usage_id, void *priv)
> +{
> +	unsigned long flags;
> +	struct hid_time_state *time_state = platform_get_drvdata(priv);
> +
> +	spin_lock_irqsave(&time_state->lock_last_time, flags);
> +	time_state->last_time = time_state->time_buf;
> +	spin_unlock_irqrestore(&time_state->lock_last_time, flags);
> +	complete(&time_state->comp_last_time);
> +	return 0;
> +}
> +
> +static int hid_time_capture_sample(struct hid_sensor_hub_device *hsdev,
> +				unsigned usage_id, size_t raw_len,
> +				char *raw_data, void *priv)
> +{
> +	struct hid_time_state *time_state = platform_get_drvdata(priv);
> +	struct rtc_time *time_buf = &time_state->time_buf;
> +
> +	switch (usage_id) {
> +	case HID_USAGE_SENSOR_TIME_YEAR:
> +		time_buf->tm_year = *(u8 *)raw_data;
> +		if (time_buf->tm_year < 70)
> +			/* assume we are in 1970...2069 */
> +			time_buf->tm_year += 100;
> +		break;
> +	case HID_USAGE_SENSOR_TIME_MONTH:
> +		time_buf->tm_mon = --*(u8 *)raw_data;

What's up with the double minus?

> +		break;
> +	case HID_USAGE_SENSOR_TIME_DAY:
> +		time_buf->tm_mday = *(u8 *)raw_data;
> +		break;
> +	case HID_USAGE_SENSOR_TIME_HOUR:
> +		time_buf->tm_hour = *(u8 *)raw_data;
> +		break;
> +	case HID_USAGE_SENSOR_TIME_MINUTE:
> +		time_buf->tm_min = *(u8 *)raw_data;
> +		break;
> +	case HID_USAGE_SENSOR_TIME_SECOND:
> +		time_buf->tm_sec = *(u8 *)raw_data;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +/* small helper, haven't found any other way */
> +static const char *attrib_name(u32 attrib_id)
> +{
> +	unsigned i = 0;
> +	static const char unknown[] = "unknown";
> +
> +	for (; i < TIME_RTC_CHANNEL_MAX; ++i) {

I would put the i = 0 in the for header.

> +		if (hid_time_addresses[i] == attrib_id)
> +			return hid_time_channel_names[i];
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

Same here

> +		ret = sensor_hub_input_get_attribute_info(hsdev,
> +				HID_INPUT_REPORT, usage_id,
> +				hid_time_addresses[i], &time_state->info[i]);
> +		if (ret < 0)
> +			return ret;
> +	}
> +	/* Check the (needed) attributes for sanity */
> +	ret = time_state->info[0].report_id; /* use ret as temp. */

As I said last time, report_id instead of ret may be a better name for the
variable

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
[...]
> +
> +static int __devinit hid_time_remove(struct platform_device *pdev)
> +{
> +	struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
> +	struct hid_time_state *time_state = platform_get_drvdata(pdev);
> +
> +	if (!IS_ERR(time_state->rtc))

This will never be false, so you can just run unregister unconditionally

> +		rtc_device_unregister(time_state->rtc);
> +	sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
> +
> +	return 0;
> +}

