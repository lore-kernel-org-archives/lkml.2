Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882Ab2I1Nmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:42:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55959 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148Ab2I1Nmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:42:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120928084626.GB7916@n2100.arm.linux.org.uk>
References: <1348793563-19186-1-git-send-email-ming.lei@canonical.com>
	<CAK7N6vqS9PW85hgcA7EVzCk-TQo_ru4OcC5i0Rw-b2hvb4YoXg@mail.gmail.com>
	<20120928084626.GB7916@n2100.arm.linux.org.uk>
Date: Fri, 28 Sep 2012 21:42:40 +0800
Message-ID: <CACVXFVOOVvf4xOABnv1FqPOMH6_XwFcH-ZTfBDojQrZJyypT+A@mail.gmail.com>
Subject: Re: [PATCH] driver core: fix possible missing of device probe
From: Ming Lei <ming.lei@canonical.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: anish singh <anish198519851985@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 4:46 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
>
> Actually, this description is rubbish.  It's not about the SMP barriers,
> or read/write device/driver lists, or about two CPUs (my test setup only
> has one CPU.)

Could you point out in detail what is wrong with my description?

Looks the description has been posted for about 12 days...

>
> It's about threads, and the relative timing of those threads through

I do not mention threads case in one CPU because the context in
which device_add runs will always see the driver added into
bus's driver list after applying the patch in this situation. And it
is obvious under UP case.

But in SMP case, it is not so obvious like UP, driver_register and
device_add will be run in two individual CPU,  so memory barrier
plays a role in making device_add see the new added driver in
the situation described in the commit log, and avoid the problem.

> the driver model code.  All in all, what with the error path issue, and
> now the blatently wrong description, I'm not gaining much confidence in
> Ming Lei.
>
> The below is actually what's happening, according to my analysis - and
> you'll notice that the device list has absolutely nothing to do with it:

I don't think your analysis is complete for the two reasons:

      - the problem isn't only triggered by deferred probe, and can be triggered
        by device_add too
      - your analysis doesn't cover SMP case

In fact, it is just a race between driver_register and device_add or
bus_probe_device, and should be nothing to do with deferred probe.

See my posted description again:

          Inside bus_add_driver(), one device might be added into
          the bus or probed which is triggered by deferred probe
          just after completing of driver_attach() and before
          'klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers)',
          so the device won't be probed by this driver.

>
> Thread 0                        Thread 1                        Thread 2
> driver_attach()
>  bus_for_each_dev()
>   __driver_attach(, devA)
>    driver_probe_device(, devA)
>     really_probe(devA, )
>      driver_deferred_probe_add(devA)
>                                 driver_attach()
>                                  bus_for_each_dev()
>                                   __driver_attach(, devA)
>                                    driver_probe_device(, devB)
>                                     really_probe(devB, )
>                                      driver_bound(devB)
>                                       driver_deferred_probe_trigger()
>                                                                 deferred_probe_work_func()
>                                                                  bus_probe_device(devA)
>                                                                   device_attach(devA)
>                                                                    bus_for_each_drv()
>                                                                     __device_attach(, devA)
>                                                                      *fails to find driver*
>                                                                      *devA dropped from
>                                                                       deferred probe list*
> klist_add_tail(klist_drivers)

Didn't my description cover the description above? ( bus_probe_device is
called between driver_attach and klist_add_tail)

Also it is only one of the two situations addressed by the patch.

>
> The reason this fix works is because the order in thread 0 means that
> when thread 2 comes to re-probe the device, it does find the driver,

You mean the driver_attach on same driver can happen at the same time?
If so, it is simply wrong.

> and if the resources that the driver needs are still not found (and it
> again returns -EPROBE_DEFER) the device will be placed back on the
> deferred probe list.

Thanks,
--
Ming Lei
