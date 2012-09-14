Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241Ab2INIYC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 04:24:02 -0400
Received: from ppsw-43.csi.cam.ac.uk ([131.111.8.143]:56360 "EHLO
	ppsw-43.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757519Ab2INIX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 04:23:56 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <5052E9A3.9030200@kernel.org>
Date: Fri, 14 Sep 2012 09:24:03 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: Jonathan Cameron <jic23@jic23.retrosnub.co.uk>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] iio: inkern: add error case in iio_channel_get()
References: <A874F61F95741C4A9BA573A70FE3998F41EF45EB@DQHE02.ent.ti.com> <504DAFF7.1070902@jic23.retrosnub.co.uk> <A874F61F95741C4A9BA573A70FE3998F41EF4C19@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF4C19@DQHE02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/09/12 01:59, Kim, Milo wrote:
>> On 10/09/12 09:02, Kim, Milo wrote:
>>>    The datasheet name is defined in the IIO driver.
>>>    On the other hand, the adc_channel_label is configured in
>>>    the platform machine side.
>>>    If the datasheet name is not matched with any adc_channel_label,
>>>    the iio_channel_get() should be returned as error for preventing
>>>    using invalid IIO channel data.
>>>
>>>    Moreover, this patch detects NULL pointer dereference problem at
>> early time.
>>>    In general, the IIO driver just accesses to any member of the
>> iio_chan_spec
>>>    in own xxx_read_raw() function.
>>>    If the iio_chan_spec is invalid pointer, NULL dereference problem
>> may occur
>>>    such like 'iio_chan_spec->channel' or 'iio_chan_spec->type'.
>>>    If the iio_channel_get() gets failed in the IIO consumer,
>>>    then no read_raw() operation proceeds.
>
>> I guess this is marginally cleaner, but either way it is up to the
>> calling driver to check whether the call succeeded.
>
> IMO, it would be better if iio_channel_get() gets failed
> when the consumer tries to get the channel rather than when using it.
>
> The channel spec is retrieved when the channel is requested, - iio_channel_get()
> So it's reasonable if error returns in case of invalid channel spcec.
>
> And I just found similar handling in iio_channel_get_all().
> But my patch needs releasing the memory as Lars-Peter noted.
Fine, I'm convinced.  Certainly less weird doing it your way ;)
Please do fix up the get all case as well.
>
> Thanks !
>
> Best Regards,
> Milo
>
>>>
>>> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
>>> ---
>>>    drivers/iio/inkern.c |    6 +++++-
>>>    1 file changed, 5 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
>>> index 1faa240..a5caf6b 100644
>>> --- a/drivers/iio/inkern.c
>>> +++ b/drivers/iio/inkern.c
>>> @@ -136,11 +136,15 @@ struct iio_channel *iio_channel_get(const char
>> *name, const char *channel_name)
>>>
>>>    	channel->indio_dev = c->indio_dev;
>>>
>>> -	if (c->map->adc_channel_label)
>>> +	if (c->map->adc_channel_label) {
>>>    		channel->channel =
>>>    			iio_chan_spec_from_name(channel->indio_dev,
>>>    						c->map->adc_channel_label);
>>>
>>> +		if (channel->channel == NULL)
>>> +			return ERR_PTR(-ENODEV);
>>> +	}
>>> +
>>>    	return channel;
>>>    }
>>>    EXPORT_SYMBOL_GPL(iio_channel_get);
>>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

