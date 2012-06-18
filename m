Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab2FRBxD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 21:53:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45591 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab2FRBxB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 21:53:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120615220343.GA8928@kroah.com>
References: <1339391600-17815-1-git-send-email-ming.lei@canonical.com>
	<20120615220343.GA8928@kroah.com>
Date: Mon, 18 Jun 2012 09:52:57 +0800
Message-ID: <CACVXFVO6h6wiHdTwVcjQLNtncO+ezVX3RJZPVenHEmhHjErRhg@mail.gmail.com>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove(v2)
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 6:03 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Jun 11, 2012 at 01:13:20PM +0800, Ming Lei wrote:
>> Firstly, .shutdown callback may touch a uninitialized hardware
>> if dev->driver is set and .probe is not completed.
>>
>> Secondly, device_shutdown() may dereference a null pointer to cause
>> oops when dev->driver is cleared after it is checked in
>> device_shutdown().
>>
>> So just try to hold device lock and its parent lock(if it has) to
>> fix the races.
>>
>> Cc: Alan Stern <stern@rowland.harvard.edu>
>> Cc: stable@vger.kernel.org
>
> Why stable?  Are there known systems that crash right now without this
> change?  I don't think we ever heard back from the original poster about
> this issue as to what exactly was going wrong.

I marked the patch as stable because it is really a fix on race between
shutdown and probe/remove, and the race can really happen in practice
as discussed in the thread. Once it happened, it will cause a big problem
on production machines.

>
>
>> Signed-off-by: Ming Lei <ming.lei@canonical.com>
>> ---
>> v2:
>>       - take Alan's suggestion to use device_trylock to avoid
>>       hanging during shutdown by buggy device or driver
>>       - hold parent reference counter
>>
>>  drivers/base/core.c |   32 ++++++++++++++++++++++++++++++++
>>  1 file changed, 32 insertions(+)
>>
>> diff --git a/drivers/base/core.c b/drivers/base/core.c
>> index 346be8b..f2fc989 100644
>> --- a/drivers/base/core.c
>> +++ b/drivers/base/core.c
>> @@ -1796,6 +1796,16 @@ out:
>>  }
>>  EXPORT_SYMBOL_GPL(device_move);
>>
>> +static int __try_lock(struct device *dev)
>> +{
>> +     int i = 0;
>> +
>> +     while (!device_trylock(dev) && i++ < 100)
>> +             msleep(10);
>> +
>> +     return i < 100;
>> +}
>
> That's a totally arbritary time, why does this work and other times do
> not?  And what is this returning, if the lock was grabbed successfully?

 It is a timeout time and is 1sec now. If the lock can't be held in 1sec, the
 function will return 0, otherwise it will return 1 and indicates that the lock
 has been held successfully.

Considered device lock is often held during probe and release in most
of situations, 1sec should be a sane value because it may be abnormal
if one driver's probe or release lasts for more than 1sec.

Also taking trylock is to prevent buggy drivers from hanging system during
shutdown. If the timeout is too large, it may prolong shutdown time in
the situation.

I will appreciate it very much if you can suggest a better timeout value.

> What's with the __ naming?

No special meaning, if is not allowed, I can remove the '__'.

>
> I really don't like this at all.
>
>
>> +
>>  /**
>>   * device_shutdown - call ->shutdown() on each device to shutdown.
>>   */
>> @@ -1810,8 +1820,11 @@ void device_shutdown(void)
>>        * devices offline, even as the system is shutting down.
>>        */
>>       while (!list_empty(&devices_kset->list)) {
>> +             int nonlocked;
>> +
>>               dev = list_entry(devices_kset->list.prev, struct device,
>>                               kobj.entry);
>> +             get_device(dev->parent);
>
> Why grab the parent reference?

If it is not grabbed,  device_del may happen after the line below

         spin_unlock(&devices_kset->list_lock);

so use-after-free may be triggered because the parent's lock
is to be locked/unlocked in this patch.

>
>>               get_device(dev);
>>               /*
>>                * Make sure the device is off the kset list, in the
>> @@ -1820,6 +1833,18 @@ void device_shutdown(void)
>>               list_del_init(&dev->kobj.entry);
>>               spin_unlock(&devices_kset->list_lock);
>>
>> +             /* hold lock to avoid race with .probe/.release */
>> +             if (dev->parent && !__try_lock(dev->parent))
>> +                     nonlocked = 2;
>> +             else if (!__try_lock(dev))
>> +                     nonlocked = 1;
>> +             else
>> +                     nonlocked = 0;
>
> Ick ick ick.  Why can't we just grab the lock to try to only call these
> callbacks one at a time?  What is causing the big problem here that I am
> missing?

As discussed before in the thread, trylock is introduced to prevent buggy
drivers from hanging system during shutdown.

>
>> +
>> +             if (nonlocked)
>> +                     dev_err(dev, "can't hold %slock for shutdown\n",
>> +                                     nonlocked == 1 ? "" : "parent ");
>
> What can anyone do with this message?  I sure wouldn't know what to do
> with it, do you?  If so, what?

I think the above message is very useful to troubleshoot the buggy device
drivers which hold device lock for ever.


Thanks,
--
Ming Lei
