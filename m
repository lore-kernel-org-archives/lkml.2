Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab1CJDMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 22:12:14 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:60474 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751324Ab1CJDML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 22:12:11 -0500
Message-ID: <4D7841D0.5000407@metafoo.de>
Date: Thu, 10 Mar 2011 04:13:20 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Bill Gatliff <bgat@billgatliff.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PWM v6 1/3] PWM: Implement a generic PWM framework
References: <1299385050-13674-1-git-send-email-bgat@billgatliff.com>	<1299385050-13674-2-git-send-email-bgat@billgatliff.com>	<4D7326B0.6050706@metafoo.de> <AANLkTinWwiyWkZ3vj6fpy7oe-PR6M+aVWoqh--+95Sgq@mail.gmail.com>
In-Reply-To: <AANLkTinWwiyWkZ3vj6fpy7oe-PR6M+aVWoqh--+95Sgq@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2011 06:05 PM, Bill Gatliff wrote:
> On Sun, Mar 6, 2011 at 12:16 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> 
>>
>>> +     if (IS_ERR(p->dev)) {
>>> +             ret = PTR_ERR(p->dev);
>>> +             goto err_device_create;
>>> +     }
>> I think it would be better to embedd the device struct directly into the
>> pwm_device struct. You could also remove the data field of the pwm_device
>> struct and use dev_{get,set}_drvdata for pwm_{get,set}_drvdata.
> 
> In theory I agree with you, but it would take away my ability to do
> things like device_create_vargs() and thereby make my code a bit more
> complicated and error prone.  Do you think the advantages outweigh the
> disadvantages?
> 

The advantages are less memory fragmentation, less cache misses and slightly
smaller generated code, but in practice this won't probably be noticeable since
there wont be vast amounts of PWM devices.
I prefer it because I think it is the nicer model.

But aside from that I've been looking into reference counting, locking and
possible races with the current framework.
So and as I see it there are two major problems:

The first problem is, that if there is no indirect refcounting on the module
which implements a device driver. For example if the parent is NULL or in a
different module, it is possible to unload the module while the driver is still
in use.
This could be fixed for example by adding a owner field to the pwm_device_ops
struct and get a reference to the owner when requesting a device.
Another option would simply be to declare it API misuse if there is not parent
or the parent has not the same owner.

The second problem is a bit serious. There is a chance of use after free.
There could still be opened sysfs files when pwm_device_unregister is called.
And thus it is possible that the opened file is read after
pwm_device_unregister has been called and the pwm_device struct might already
be freed thus causing access to already freed memory.
To fix this I suggest to move the allocation of the pwm_device to
pwm_device_register and pass in the ops instead of the device itself. Maybe the
struct could even be made opaque to the outside word in this process.
The struct would be freed from the devices 'release' callback, which is only
called after the last reference to the device has been dropped.

Related to this problem is what happens when pwm_device_unregister is called
while the device is requested. The function returns -EBUSY, but non of your
drivers currently check the return value and free the pwm_device struct anyway.
So there is going to be a use after free too.

Also the reference count of the pwm device is increased in pwm_request (by
class_find_device), but that reference is never released. A device_put should
be added to pwm_release().

- Lars
