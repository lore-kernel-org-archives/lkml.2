Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab1F1WrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:47:13 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48643 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab1F1WrG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:47:06 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.136.221]
In-Reply-To: <20110627222121.GD20865@ponder.secretlab.ca>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
 <1308640714-17961-8-git-send-email-ohad@wizery.com> <20110627222121.GD20865@ponder.secretlab.ca>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 29 Jun 2011 01:46:44 +0300
Message-ID: <BANLkTikt08CDJiKNxGF2mKmOhyxHfv21_g@mail.gmail.com>
Subject: Re: [RFC 7/8] drivers: introduce rpmsg, a remote-processor messaging bus
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>, Arnd Bergmann <arnd@arndb.de>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Tue, Jun 28, 2011 at 1:21 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> Nice patch.  I'm quite thrilled to see this implemented.  Some
> comments below, but otherwise I think it looks pretty good.

Thanks !

>> +source "drivers/virtio/Kconfig"
>
> What happens when kvm and rpmsg both get enabled on the same kernel.

Sounds to me that eventually we'll have to source virtio's Kconfig in
drivers/Kconfig, and remove all the other locations it is sourced at
(currently it is directly sourced by several arch Kconfigs when
VIRTUALIZATION is selected).

>> +     if (strncmp(id->name, rpdev->id.name, RPMSG_NAME_SIZE))
>> +             return 0;
>> +
>> +     return 1;
>> +}
>
> or simply: 'return strncmp(id->name, rpdev->id.name, RPMSG_NAME_SIZE) == 0;'
>
> :-)

that works too ;)

>> +     spin_lock(&vrp->endpoints_lock);
>
> Is a spin_lock the right choice for endpoints, or should it be a
> mutex (do the endpoints operations need to be atomic)?

Today it can be a mutex: it protects idr operations invoked either by
users (creating new endpoints, definitely not requiring atomicity) or
by platform code indicating that a new message has arrived (today it's
omap's mailbox driver, which calls from a process context).

I can change that, and if someone requires atomic operations later on,
move to spinlocks again.

But it probably won't matter too much as there's no contention on that
lock today (notifications coming from omap's mailbox are serialized,
and users creating new endpoints show up very infrequently).

> At put_device time, it is conceivable that the dev pointer is no
> longer valid.  You'll need to get do the to_rpmsg_channel() before
> putting the dev.

sure.

>> +static void rpmsg_upref_sleepers(struct virtproc_info *vrp)
>> +{
>> +     /* support multiple concurrent senders */
>> +     spin_lock(&vrp->tx_lock);
>> +
>> +     /* are we the first sleeping context waiting for tx buffers ? */
>> +     if (!vrp->sleepers++)
>
> Maybe use a kref?

I can change it to an atomic variable, but I don't think kref's memory
barriers are needed here: we already have memory barriers induced by
the spinlock.

>> +static int rpmsg_remove_device(struct device *dev, void *data)
>> +{
>> +     struct rpmsg_channel *rpdev = to_rpmsg_channel(dev);
>> +
>> +     device_unregister(dev);
>> +
>> +     kfree(rpdev);
>
> put_device() I think.

Don't think so, we get the device handle from device_for_each_child
here, which doesn't call get_device (unlike device_find_child).

>> +static int __init init(void)
>
> Even for static functions, it's a really good idea to prefix all
> function names and file scoped symbol with a common prefix like
> "rpmsg_".  Doing so avoids even the outside chance of a namespace
> conflict.

Sure thing.

>> +     ret = bus_register(&rpmsg_bus);
>> +     if (ret) {
>> +             pr_err("failed to register rpmsg bus: %d\n", ret);
>> +             return ret;
>> +     }
>> +
>> +     return register_virtio_driver(&virtio_ipc_driver);
>
> And if register_virtio_driver fails?

I'll handle that, thanks.

>> +struct rpmsg_device_id {
>> +     char name[RPMSG_NAME_SIZE];
>> +     kernel_ulong_t driver_data      /* Data private to the driver */
>> +                     __attribute__((aligned(sizeof(kernel_ulong_t))));
>> +};
>
> Should this be co-located with vio_device_id?

Sure, can't hurt (I assume you meant virtio_device_id here).

> It makes it easier to dereference in kernel code if you do:
>
> #ifdef __KERNEL__
>        void *data;
> #else
>        kernel_ulong_t data;
> #endif

Sure thing.

Thanks!
Ohad.
