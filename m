Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab2LJWgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 17:36:15 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:39272 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006Ab2LJWgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 17:36:14 -0500
Message-ID: <50C66406.9090606@metafoo.de>
Date: Mon, 10 Dec 2012 23:36:54 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121027 Icedove/3.0.11
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>
Subject: Re: [PATCH 3/3 v2] iio: add rtc-driver for HID sensors of type time
References: <50C5DFCC.60203@ahsoftware.de> <1355151119-2489-1-git-send-email-holler@ahsoftware.de> <50C61675.2000407@metafoo.de> <50C6603E.5070909@ahsoftware.de>
In-Reply-To: <50C6603E.5070909@ahsoftware.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 11:20 PM, Alexander Holler wrote:
> [...]
>>> +    init_completion(&time_state->comp_last_time);
>>
>> This needs to be INIT_COMPLETION. init_completion must be called exactly
>> once on a completion, which should be from inside probe() in this case.
> 
> Ah, so I've misread http://lwn.net/Articles/23993/ . I've read it as
> init_completion() is usable multiple times (I had the impression
> INIT_COMPLETION got replaced by init_completion().
> 

Well, I've been exaggerating a bit, you can call it multiple times, but you
need to make sure that the completion is not in use at the same time, since
init_completion will completely reinitialize the struct and if it is in use at
the same time you'll get undefined behavior. So it is a good rule of thumb to
just use it once in probe(). INIT_COMPLETION on the other hand will just clear
the done flag, so you know that between your call to INIT_COMPLETION and when
wait_for_completion returns successfully your event has occurred at least once.

>>> +    /* wait for all values (event) */
>>> +   
>>> wait_for_completion_interruptible_timeout(&time_state->comp_last_time,
>>> +                            HZ*6);
>>
>> You should check the return value in case either a timeout happens or the
>> sleep is interrupted.
> 
> Yes, I already wanted to do it, but it seems I've forgotten it.
> 
>>> +    struct hid_time_state *time_state =
>>> +        kzalloc(sizeof(struct hid_time_state), GFP_KERNEL);
>>
>> You could use devm_kzalloc here. By doing so you don't have to take
>> care of
>> freeing it again since it will be auto-freed once the device is removed.
> 
> Thanks. I already searched such and wondered why such didn't exist. Just
> to clarify, if I use devm_kzalloc, I don't have to free time_state here
> 
>>> +error_free_drvdata:
>>> +    platform_set_drvdata(pdev, NULL);
>>
>> Setting the platform data to NULL should not be necessary. Some
>> drivers do
>> this but it's kind of the result of cargo-cult-coding.
>>
>>> +    kfree(time_state);
>>> +error_ret:
>>> +    return ret;
>>> +}
>>> +
>>> +static int __devinit hid_time_remove(struct platform_device *pdev)
>>> +{
>>> +    struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
>>> +    struct hid_time_state *time_state = platform_get_drvdata(pdev);
>>> +
>>> +    if (!IS_ERR(time_state->rtc))
>>> +        rtc_device_unregister(time_state->rtc);
>>> +    sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
>>> +    platform_set_drvdata(pdev, NULL);
>>
> 
> and here?
> 

yes.

