Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab1JSNqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 09:46:05 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:60605 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab1JSNqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 09:46:02 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E9ED49B.1070005@cam.ac.uk>
Date: Wed, 19 Oct 2011 14:46:03 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, linus.ml.walleij@gmail.com,
        zdevai@gmail.com, linux@arm.linux.org.uk, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com, gregkh@suse.de
Subject: Re: [PATCH 3/6] IIO:CORE add global list of registered IIO devices.
References: <1318951776-19393-1-git-send-email-jic23@cam.ac.uk> <1318951776-19393-4-git-send-email-jic23@cam.ac.uk> <4E9DC496.3010909@metafoo.de> <4E9DE2AB.3090208@cam.ac.uk>
In-Reply-To: <4E9DE2AB.3090208@cam.ac.uk>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/11 21:33, Jonathan Cameron wrote:
> On 10/18/11 19:25, Lars-Peter Clausen wrote:
>> On 10/18/2011 05:29 PM, Jonathan Cameron wrote:
>>> Needed for inkernel interfaces.
>>>
>>
>> The bus_type structure keeps a list of all devices registered on that bus, so
>> you should be able to use bus_for_each_dev and bus_find_device for iterating
>> over the iio devices.
> I hadn't realised that but don't think it will work anyway. There are several
> other things than iio_dev based devices that sit on our bus unfortunately.
> None are in these initial merges but they will turn up later.
> The most common are iio_triggers but there are also a few weird ones such
> as the event generator for the dummy driver and the sysfstrig control device.  
> We could play some games to allow these to be identified, but it's going
> to be a mess. Probably easier to just maintain a second list as we are doing
> here.  Interesting suggestion though. Thanks and feel free to point out if there
> is a simple way around the identification issue.
Actually looking into it this morning - this is trivial to do.
We can just check that the device_type is set appropriately before doing anything
else.

Thanks Lars-Peter your suggestion is should clean things up nicely.

New version coming up.
>>
>>> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
>>> ---
>>>  drivers/iio/iio.c       |    9 +++++++++
>>>  include/linux/iio/iio.h |    1 +
>>>  2 files changed, 10 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/iio/iio.c b/drivers/iio/iio.c
>>> index 9e6acc1..246a093 100644
>>> --- a/drivers/iio/iio.c
>>> +++ b/drivers/iio/iio.c
>>> @@ -15,6 +15,9 @@
>>>  #include <linux/iio/iio.h>
>>>  #include <linux/iio/sysfs.h>
>>>  
>>> +static DEFINE_MUTEX(iio_device_list_lock);
>>> +static LIST_HEAD(iio_device_list);
>>> +
>>>  static DEFINE_IDA(iio_ida);
>>>  
>>>  static struct bus_type iio_bus_type = {
>>> @@ -91,6 +94,9 @@ static void iio_dev_release(struct device *device)
>>>  {
>>>  	struct iio_dev *indio_dev = container_of(device, struct iio_dev, dev);
>>>  	iio_device_unregister_sysfs(indio_dev);
>>> +	mutex_lock(&iio_device_list_lock);
>>> +	list_del(&indio_dev->dev_list_entry);
>>> +	mutex_unlock(&iio_device_list_lock);
>>>  }
>>>  
>>>  static struct device_type iio_dev_type = {
>>> @@ -559,6 +565,9 @@ int iio_device_register(struct iio_dev *indio_dev)
>>>  	if (ret)
>>>  		goto error_free_sysfs;
>>>  
>>> +	mutex_lock(&iio_device_list_lock);
>>> +	list_add(&indio_dev->dev_list_entry, &iio_device_list);
>>> +	mutex_unlock(&iio_device_list_lock);
>>>  	return 0;
>>>  
>>>  error_free_sysfs:
>>> diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
>>> index beedc5c..f14e7dc 100644
>>> --- a/include/linux/iio/iio.h
>>> +++ b/include/linux/iio/iio.h
>>> @@ -192,6 +192,7 @@ struct iio_info {
>>>   * @info:		[DRIVER] callbacks and constant info from driver
>>>   * @groups:		[INTERN] attribute groups
>>>   * @groupcounter:	[INTERN] index of next attribute group
>>> + * @dev_list_entry:	[INTERN] entry in global list of iio devices
>>>   **/
>>>  struct iio_dev {
>>>  	int				id;
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

