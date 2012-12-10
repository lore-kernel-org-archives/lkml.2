Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab2LJWVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 17:21:38 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:39610 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab2LJWVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 17:21:36 -0500
Message-ID: <50C6603E.5070909@ahsoftware.de>
Date: Mon, 10 Dec 2012 23:20:46 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>
Subject: Re: [PATCH 3/3 v2] iio: add rtc-driver for HID sensors of type time
References: <50C5DFCC.60203@ahsoftware.de> <1355151119-2489-1-git-send-email-holler@ahsoftware.de> <50C61675.2000407@metafoo.de>
In-Reply-To: <50C61675.2000407@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.12.2012 18:05, schrieb Lars-Peter Clausen:
> On 12/10/2012 03:51 PM, Alexander Holler wrote:

> The channel spec is semi unused. You use it to lookup the scan index and the
> name, but that could easily be implemented without the channel spec.
> Especially considering that the scan index lookup is only ever done for
> channel 0, which will always return CHANNEL_SCAN_INDEX_YEAR.

Thats what I had in mind for v3.

> Are the entries in info ordered in the same way as the addresses in
> hid_time_addresses? If yes you could just use a lookup-table like
>
> static const char * const hid_time_attrib_names[] = {
> 	"second",
> 	...
> };
>
> and just use 'i' to look them up.

Again, what I had in mind for v3. It would have been better I wouldn't 
have used one of the existing drivers as template and afterwards 
removing tons of stuff. ;)

>> +	init_completion(&time_state->comp_last_time);
>
> This needs to be INIT_COMPLETION. init_completion must be called exactly
> once on a completion, which should be from inside probe() in this case.

Ah, so I've misread http://lwn.net/Articles/23993/ . I've read it as 
init_completion() is usable multiple times (I had the impression 
INIT_COMPLETION got replaced by init_completion().

>> +	/* wait for all values (event) */
>> +	wait_for_completion_interruptible_timeout(&time_state->comp_last_time,
>> +							HZ*6);
>
> You should check the return value in case either a timeout happens or the
> sleep is interrupted.

Yes, I already wanted to do it, but it seems I've forgotten it.

>> +	struct hid_time_state *time_state =
>> +		kzalloc(sizeof(struct hid_time_state), GFP_KERNEL);
>
> You could use devm_kzalloc here. By doing so you don't have to take care of
> freeing it again since it will be auto-freed once the device is removed.

Thanks. I already searched such and wondered why such didn't exist. Just 
to clarify, if I use devm_kzalloc, I don't have to free time_state here

>> +error_free_drvdata:
>> +	platform_set_drvdata(pdev, NULL);
>
> Setting the platform data to NULL should not be necessary. Some drivers do
> this but it's kind of the result of cargo-cult-coding.
>
>> +	kfree(time_state);
>> +error_ret:
>> +	return ret;
>> +}
>> +
>> +static int __devinit hid_time_remove(struct platform_device *pdev)
>> +{
>> +	struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
>> +	struct hid_time_state *time_state = platform_get_drvdata(pdev);
>> +
>> +	if (!IS_ERR(time_state->rtc))
>> +		rtc_device_unregister(time_state->rtc);
>> +	sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
>> +	platform_set_drvdata(pdev, NULL);
>

and here?

> Same here.
>
>> +	kfree(time_state);
>> +
>> +	return 0;
>> +}
>> +
> [...]

Regards,

Alexander
