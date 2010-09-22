Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab0IVJ6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 05:58:55 -0400
Received: from daytona.panasas.com ([67.152.220.89]:51864 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751511Ab0IVJ6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 05:58:54 -0400
Message-ID: <4C99D358.2080201@panasas.com>
Date: Wed, 22 Sep 2010 11:58:48 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Vasiliy Kulikov <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
        linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@suse.de>,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH 04/14] memstick: core: fix device_register() error handling
References: <1284900889-24369-1-git-send-email-segooon@gmail.com> <20100921152031.30365b3f.akpm@linux-foundation.org> <20100921224947.GA20183@kroah.com>
In-Reply-To: <20100921224947.GA20183@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Sep 2010 09:58:52.0225 (UTC) FILETIME=[C2C26B10:01CB5A3C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2010 12:49 AM, Greg KH wrote:
> On Tue, Sep 21, 2010 at 03:20:31PM -0700, Andrew Morton wrote:
>> On Sun, 19 Sep 2010 16:54:49 +0400
>> Vasiliy Kulikov <segooon@gmail.com> wrote:
>>
>>> If device_register() fails then call put_device().
>>> See comment to device_register.
>>>
>>> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
>>> ---
>>>  compile tested.
>>>
>>>  drivers/memstick/core/memstick.c |    1 +
>>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
>>> index c00fe82..4303b7e 100644
>>> --- a/drivers/memstick/core/memstick.c
>>> +++ b/drivers/memstick/core/memstick.c
>>> @@ -465,6 +465,7 @@ static void memstick_check(struct work_struct *work)
>>>  		if (!host->card) {
>>>  			host->card = card;
>>>  			if (device_register(&card->dev)) {
>>> +				put_device(&card->dev);
>>>  				kfree(host->card);
>>>  				host->card = NULL;
>>>  			}
>>
>> A failed device_register() takes a bogus ref on the not-registered
>> device?  It's no surprise that people are getting this wrong.  
>>
>> The principle of least surprise says: fix device_register()!
> 
> One might think that, but it's a bit more difficult.
> 
> How does device_register know it should destroy the device if it fails?
> 
> Here's how it works:
>  - device_register is just a wrapper around device_initialize() and
>    device_add()
>      - device_initialize() can't do anything wrong, so it's safe, BUT,
>        at this point in time, the reference for the device is
>        incremented, so any caller must now drop the reference and
>        properly free stuff.
>      - device_add() does a lot.
> 
> Hm, I guess, because we "know" in device_register() that we must drop
> something if device_add() fails, then I guess it's not being consistant
> with it's own calls...
> 
> So, something as simple as this?
> 
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index d1b2c9a..4ba8599 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1084,14 +1084,16 @@ name_error:
>   * have a clearly defined need to use and refcount the device
>   * before it is added to the hierarchy.
>   *
> - * NOTE: _Never_ directly free @dev after calling this function, even
> - * if it returned an error! Always use put_device() to give up the
> - * reference initialized in this function instead.
>   */
>  int device_register(struct device *dev)
>  {
> +	int retval;
> +
>  	device_initialize(dev);
> -	return device_add(dev);
> +	retval = device_add(dev);
> +	if (retval)
> +		put_device(dev);

This is all theoretically sound. But it will crash my device driver
and a dozen more like mine.

Because the passed *dev is an embedded structure inside a bigger
driver-specific structure. (Hence the call to device_register).

The kref inside the *dev is used to also govern the lifetime of
the outer struct. With a registered release and the use of a
container_of.

Now up until now, and was fine before the set_name changes.
If device_register failed the build-up function would just
deallocate the outer struct together with the inner device.
If you call put_device(dev) here then the release function
will be called. Which is a double free. And also the release
function is coded to expect a fully setup device, though
calling device_unregister, and all the other resources contained
in the outer struct.

So in short it would work but not with current code, and not
with out a major restructuring.

What about the patch James sent to just free the name string
and be done with it?

> +	return retval;
>  }
>  
>  /**
>      	
> 
> 
> Kay, what am I missing here, why can't we just do this?  Hm, the
> side-affect might be that if device_register() fails, NO ONE had better
> touch that device again, as it might have just been freed from the
> system.  I wonder if that will cause problems...
> 

Exactly. Lets please let us recap the scope here. device_register
is specifically for Embedded devices where the life time rules are
"delicate" to say the least. All we have is the name string memory
leak. Can we fix that and not force a major Kernel re-write.

> thanks,
> 
> greg k-h

Thanks
Boaz
