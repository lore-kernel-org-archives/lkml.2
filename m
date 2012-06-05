Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab2FEPRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:17:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53723 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab2FEPRN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:17:13 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1206051034350.1542-100000@iolanthe.rowland.org>
References: <1338886747-28088-1-git-send-email-ming.lei@canonical.com>
	<Pine.LNX.4.44L0.1206051034350.1542-100000@iolanthe.rowland.org>
Date: Tue, 5 Jun 2012 23:17:09 +0800
Message-ID: <CACVXFVMdidqhFE1AhenUi8VXbYhac492YdxsvPmVqcwmo=TrcA@mail.gmail.com>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove
From: Ming Lei <ming.lei@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 5, 2012 at 10:47 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>
> Avoid running probe, that's fine.  But avoiding remove can lead to
> problems, because the subsystem and the driver will no longer agree on
> who should manage the device.

After device_shutdown() has been called, the whole system will enter power down
or reset later, so it doesn't matter if who should manage the device.

Also once shutdown callback is called for the device, looks its other callbacks
should not touch the device any more.

>
>> --- a/drivers/base/core.c
>> +++ b/drivers/base/core.c
>> @@ -49,6 +49,9 @@ static struct kobject *dev_kobj;
>>  struct kobject *sysfs_dev_char_kobj;
>>  struct kobject *sysfs_dev_block_kobj;
>>
>> +struct srcu_struct driver_srcu;
>> +int device_shutdown_started;
>> +
>>  #ifdef CONFIG_BLOCK
>>  static inline int device_is_not_partition(struct device *dev)
>>  {
>> @@ -1803,6 +1806,9 @@ void device_shutdown(void)
>>  {
>>       struct device *dev;
>>
>> +     ACCESS_ONCE(device_shutdown_started) = 1;
>
> This does not need to be ACCESS_ONCE.  ACCESS_ONCE is needed only in
> situations where the compiler might insert multiple reads or writes.

I have talked with Paul about the ACCESS_ONCE, and Paul thought it is needed
to prevent the compiler from doing byte-at-a-time stores.

Maybe Paul has a detailed explanation about it.

>
>> +     synchronize_srcu(&driver_srcu);
>> +
>>       spin_lock(&devices_kset->list_lock);
>>       /*
>>        * Walk the devices list backward, shutting down each in turn.
>> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
>> index 1b1cbb5..5587037 100644
>> --- a/drivers/base/dd.c
>> +++ b/drivers/base/dd.c
>> @@ -250,8 +250,13 @@ static DECLARE_WAIT_QUEUE_HEAD(probe_waitqueue);
>>  static int really_probe(struct device *dev, struct device_driver *drv)
>>  {
>>       int ret = 0;
>> +     int idx;
>>
>> +     idx = srcu_read_lock(&driver_srcu);
>>       atomic_inc(&probe_count);
>> +     if (ACCESS_ONCE(device_shutdown_started))
>
> This doesn't need to be ACCESS_ONCE either.  If it would make you feel

Because the global variable of device_shutdown_started is not changed inside
the function, the compiler may put the above line after the line of
'dev->driver = drv',
so introduce the ACCESS_ONCE to avoid the compiler optimization.

> better, you could write
>
>        if (rcu_dereference(&device_shutdown_started))

The usage of SRCU refers to the part 'Cleaning Up Safely' of the SRCU
paper 'Sleepable RCU'[1].  Also the patch doesn't call rcu_assign_pointer,
so rcu_dereference isn't needed.

[1], http://lwn.net/Articles/202847/

>
>> +             goto done;
>
> You need to set ret to something other than 0, because the probe has
> not succeeded.  For example, set it to -ESHUTDOWN.

Looks reasonable.

>
>> +
>>       pr_debug("bus: '%s': %s: probing driver %s with device %s\n",
>>                drv->bus->name, __func__, drv->name, dev_name(dev));
>>       WARN_ON(!list_empty(&dev->devres_head));
>> @@ -305,6 +310,7 @@ probe_failed:
>>  done:
>>       atomic_dec(&probe_count);
>>       wake_up(&probe_waitqueue);
>> +     srcu_read_unlock(&driver_srcu, idx);
>>       return ret;
>>  }
>>
>> @@ -467,6 +473,12 @@ EXPORT_SYMBOL_GPL(driver_attach);
>>  static void __device_release_driver(struct device *dev)
>>  {
>>       struct device_driver *drv;
>> +     int idx;
>> +
>> +     idx = srcu_read_lock(&driver_srcu);
>> +
>> +     if (ACCESS_ONCE(device_shutdown_started))
>> +             goto exit;
>
> As mentioned above, this is not good.  I don't know... maybe it won't
> ever cause any difficulties.

Looks same with above.

Thanks,
--
Ming Lei
